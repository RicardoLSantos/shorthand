#!/usr/bin/env python3
"""Re-verify the IG's ConceptMap target codes against the authoritative source terminology.

Implements course item 4.9 (HL7 FHIR Intermediate, FHIR Course Alignment §4.9): detect
"drift" — a ConceptMap target code that has since become inactive, non-standard, or that
no longer exists in its source terminology.

Two modes:
  --source local   (default, the REAL check): Database-First against the local OMOP CONCEPT
                   CSVs (LOINC + OMOP concept_id -> Athena; SNOMED -> Vocab2). Detects
                   inactive (invalid_reason set), non-standard (standard_concept != 'S'),
                   and missing codes. Needs the large CSVs (not in CI).
  --source txfhir  (CI-capable): tx.fhir.org $validate-code for LOINC + SNOMED only
                   (OMOP is not on tx.fhir.org -> skipped). Network-dependent; stdlib only.

Only standard, externally-checkable targets are verified: LOINC (NNNNN-N), SNOMED (numeric),
OMOP concept_id (integer). openEHR archetype IDs, FHIR structural paths, locally-defined and
ICD-11 targets, and the #0 / unmapped sentinels are reported as "skipped (not checkable)".

This is READ-ONLY verification. It does NOT edit any FSH. Any inactive/missing code is a
FLAG for the terminology owner (T2 lane) — not auto-fixed (Pitfall #82 / #109).

Run:
  python3 scripts/conceptmap_drift_check.py                 # local Database-First (default)
  python3 scripts/conceptmap_drift_check.py --source txfhir # tx.fhir.org advisory (LOINC+SNOMED)
  python3 scripts/conceptmap_drift_check.py --report drift.md --strict

AUTHORED-BY-CLAUDE-T1-S55 (Pitfall #97)
"""
from __future__ import annotations

import argparse
import csv
import json
import os
import re
import sys
import urllib.parse
import urllib.request
from pathlib import Path

def _find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for parent in [p, *p.parents]:
        if (parent / "sushi-config.yaml").exists() or (parent / "ig.ini").exists():
            return parent
    return start.resolve().parents[1]


REPO = _find_repo_root(Path(__file__))
DEFAULT_FSH_ROOT = REPO / "input" / "fsh"

# The large OMOP CONCEPT CSVs are NOT in this (public) repo. For --source local, provide them
# via the ATHENA_CONCEPT_CSV / VOCAB2_CONCEPT_CSV env vars, or the --athena / --vocab2 flags
# (LOINC + OMOP concept_id -> Athena CONCEPT.csv; SNOMED -> a SNOMED-bearing CONCEPT.csv).
DEFAULT_ATHENA = os.environ.get("ATHENA_CONCEPT_CSV", "")
DEFAULT_VOCAB2 = os.environ.get("VOCAB2_CONCEPT_CSV", "")

TX_SERVER = "https://tx.fhir.org/r4"
SYSTEM_URL = {"LOINC": "http://loinc.org", "SNOMED": "http://snomed.info/sct"}

RE_GROUP_TARGET = re.compile(r'^\s*\*\s*group(?:\[(\d+)\])?\.target\s*=\s*"([^"]+)"')
RE_TARGET_CODE = re.compile(
    r'^\s*\*\s*group(?:\[(\d+)\])?\.element\[\d+\]\.target\[\d+\]\.code\s*=\s*(?:#"([^"]+)"|#(\S+))'
)


def classify_system(url: str) -> str:
    u = url.lower()
    if "loinc.org" in u:
        return "LOINC"
    if "snomed.info" in u:
        return "SNOMED"
    if "athena.ohdsi" in u or "ohdsi.org" in u:
        return "OMOP"
    return "OTHER"  # openEHR archetype IDs, FHIR paths, local CS, ICD-11, etc.


def is_conceptmap(text: str) -> bool:
    return "InstanceOf: ConceptMap" in text or "InstanceOf:ConceptMap" in text


def parse_conceptmaps(fsh_root: Path):
    """Return list of records: {file, conceptmap, system, code}."""
    records = []
    for path in sorted(fsh_root.rglob("*.fsh")):
        text = path.read_text(encoding="utf-8", errors="replace")
        if not is_conceptmap(text):
            continue
        m = re.search(r"Instance:\s*(\S+)", text)
        cm_name = m.group(1) if m else path.stem
        group_system = {}  # group index -> system class
        for line in text.splitlines():
            gt = RE_GROUP_TARGET.match(line)
            if gt:
                gidx = int(gt.group(1) or 0)
                group_system[gidx] = classify_system(gt.group(2))
                continue
            tc = RE_TARGET_CODE.match(line)
            if tc:
                gidx = int(tc.group(1) or 0)
                code = tc.group(2) or tc.group(3)
                system = group_system.get(gidx, "OTHER")
                records.append(
                    {"file": str(path.relative_to(REPO)), "conceptmap": cm_name,
                     "system": system, "code": code}
                )
    return records


def split_checkable(records):
    """Partition into checkable {LOINC,SNOMED,OMOP} sets + a skipped count."""
    loinc, snomed, omop = set(), set(), set()
    skipped = 0
    for r in records:
        code, system = r["code"], r["system"]
        if code in ("0", "unmatched", "unmapped"):  # OMOP sentinel / not a real code
            skipped += 1
            continue
        if system == "LOINC":
            loinc.add(code)
        elif system == "SNOMED":
            snomed.add(code)
        elif system == "OMOP":
            if code.isdigit():
                omop.add(code)
            else:
                skipped += 1  # OMOP target that isn't a concept_id (e.g. table name)
        else:
            skipped += 1
    return loinc, snomed, omop, skipped


# ----------------------------- local (Database-First) -----------------------------

def scan_athena(csv_path: Path, loinc_codes: set, omop_ids: set):
    """Single pass over Athena: resolve LOINC concept_codes and OMOP concept_ids."""
    loinc_found, omop_found = {}, {}
    with csv_path.open(encoding="utf-8", errors="replace", newline="") as f:
        reader = csv.reader(f, delimiter="\t", quoting=csv.QUOTE_NONE)
        next(reader, None)  # header
        for row in reader:
            if len(row) < 7:
                continue
            concept_id, name, vocab = row[0], row[1], row[3]
            std = row[5] if len(row) > 5 else ""
            code = row[6]
            invalid = row[9] if len(row) > 9 else ""
            if omop_ids and concept_id in omop_ids and concept_id not in omop_found:
                omop_found[concept_id] = (name, std, invalid, vocab)
            if loinc_codes and vocab == "LOINC" and code in loinc_codes and code not in loinc_found:
                loinc_found[code] = (name, std, invalid, vocab)
    return loinc_found, omop_found


def scan_vocab2_snomed(csv_path: Path, snomed_codes: set):
    found = {}
    with csv_path.open(encoding="utf-8", errors="replace", newline="") as f:
        reader = csv.reader(f, delimiter="\t", quoting=csv.QUOTE_NONE)
        next(reader, None)
        for row in reader:
            if len(row) < 7:
                continue
            name, vocab = row[1], row[3]
            std = row[5] if len(row) > 5 else ""
            code = row[6]
            invalid = row[9] if len(row) > 9 else ""
            if vocab == "SNOMED" and code in snomed_codes and code not in found:
                found[code] = (name, std, invalid, vocab)
    return found


def status_from_row(found: dict, code: str):
    if code not in found:
        return "missing", ""
    name, std, invalid, _ = found[code]
    if invalid.strip():
        return "inactive", name
    if std.strip() != "S":
        return "non-standard", name
    return "active", name


def run_local(loinc, snomed, omop, athena_path, vocab2_path):
    results = {}  # (system, code) -> (status, name)
    if not athena_path:
        sys.stderr.write("ERROR: --source local needs the Athena CONCEPT.csv (LOINC + OMOP). "
                         "Set ATHENA_CONCEPT_CSV or pass --athena PATH (the large CSV is not in the repo).\n")
        return None
    athena = Path(athena_path)
    if not athena.exists():
        sys.stderr.write(f"ERROR: Athena CONCEPT.csv not found: {athena}\n")
        return None
    sys.stderr.write(f"[local] scanning Athena ({athena.stat().st_size // 1_000_000} MB)...\n")
    loinc_found, omop_found = scan_athena(athena, loinc, omop)
    for c in loinc:
        results[("LOINC", c)] = status_from_row(loinc_found, c)
    for c in omop:
        results[("OMOP", c)] = status_from_row(omop_found, c)
    if snomed:
        if not vocab2_path:
            sys.stderr.write("ERROR: SNOMED targets present but no SNOMED CONCEPT.csv. "
                             "Set VOCAB2_CONCEPT_CSV or pass --vocab2 PATH.\n")
            return None
        vocab2 = Path(vocab2_path)
        if not vocab2.exists():
            sys.stderr.write(f"ERROR: SNOMED CONCEPT.csv not found: {vocab2}\n")
            return None
        sys.stderr.write(f"[local] scanning Vocab2 SNOMED ({vocab2.stat().st_size // 1_000_000} MB)...\n")
        snomed_found = scan_vocab2_snomed(vocab2, snomed)
        for c in snomed:
            results[("SNOMED", c)] = status_from_row(snomed_found, c)
    return results


# ----------------------------- txfhir (advisory, CI) -----------------------------

def tx_validate(system: str, code: str):
    url = f"{TX_SERVER}/CodeSystem/$validate-code?" + urllib.parse.urlencode(
        {"url": SYSTEM_URL[system], "code": code}
    )
    req = urllib.request.Request(url, headers={"Accept": "application/fhir+json"})
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.load(resp)
    except Exception as e:  # network-class transient (Pitfall #100) — advisory only
        return "unknown", f"tx error: {e}"
    result, display = None, ""
    for p in data.get("parameter", []):
        if p.get("name") == "result":
            result = p.get("valueBoolean")
        elif p.get("name") == "display":
            display = p.get("valueString", "")
    if result is True:
        return "active", display
    if result is False:
        return "missing", display
    return "unknown", display


def run_txfhir(loinc, snomed, omop):
    results = {}
    for system, codes in (("LOINC", sorted(loinc)), ("SNOMED", sorted(snomed))):
        for c in codes:
            results[(system, c)] = tx_validate(system, c)
    for c in sorted(omop):
        results[("OMOP", c)] = ("skipped", "OMOP not on tx.fhir.org — use --source local")
    return results


# ----------------------------- reporting -----------------------------

ICON = {"active": "✅", "non-standard": "⚠️", "inactive": "🔴", "missing": "❌",
        "unknown": "❔", "skipped": "⏭️"}


def build_report(records, results, source, skipped_count, athena_path, vocab2_path):
    by_status = {}
    for (system, code), (status, name) in results.items():
        by_status.setdefault(status, []).append((system, code, name))
    lines = []
    lines.append("# ConceptMap drift report")
    lines.append("")
    lines.append(f"- source: `{source}`")
    if source == "local":
        lines.append(f"- Athena: `{athena_path}`")
        if any(s == "SNOMED" for s, _ in results):
            lines.append(f"- Vocab2 SNOMED: `{vocab2_path}`")
    n_cm = len({r['conceptmap'] for r in records})
    lines.append(f"- ConceptMaps scanned: {n_cm} · target codes parsed: {len(records)} "
                 f"· checkable: {len(results)} · skipped (not externally checkable): {skipped_count}")
    lines.append("")
    counts = {k: len(v) for k, v in by_status.items()}
    summary = " · ".join(f"{ICON.get(k,'')} {k}: {counts.get(k,0)}"
                         for k in ["active", "non-standard", "inactive", "missing", "unknown", "skipped"]
                         if k in counts)
    lines.append(f"**Summary:** {summary}")
    lines.append("")
    # detail only for non-active (the actionable rows)
    for status in ["inactive", "missing", "non-standard", "unknown"]:
        rows = sorted(by_status.get(status, []))
        if not rows:
            continue
        lines.append(f"## {ICON.get(status,'')} {status} ({len(rows)})")
        lines.append("")
        lines.append("| system | code | DB display | in ConceptMap(s) |")
        lines.append("|---|---|---|---|")
        for system, code, name in rows:
            cms = sorted({r["conceptmap"] for r in records
                          if r["code"] == code and r["system"] == system})
            lines.append(f"| {system} | `{code}` | {name or '—'} | {', '.join(cms)} |")
        lines.append("")
    drift = counts.get("inactive", 0) + counts.get("missing", 0)
    if drift == 0:
        lines.append("**NO DRIFT** among externally-checkable targets "
                     "(all active; non-standard/unknown are advisory).")
    else:
        lines.append(f"**DRIFT DETECTED: {drift} code(s) inactive/missing** — "
                     "FLAG for the terminology owner (T2 lane); do NOT auto-fix (Pitfall #82/#109).")
    return "\n".join(lines), drift


def main() -> int:
    ap = argparse.ArgumentParser(description="ConceptMap target-code drift check (course item 4.9).")
    ap.add_argument("--source", choices=["local", "txfhir"], default="local")
    ap.add_argument("--fsh-root", type=Path, default=DEFAULT_FSH_ROOT)
    ap.add_argument("--athena", default=DEFAULT_ATHENA)
    ap.add_argument("--vocab2", default=DEFAULT_VOCAB2)
    ap.add_argument("--report", type=Path, help="Write the markdown report to this path.")
    ap.add_argument("--strict", action="store_true", help="Exit 1 if any inactive/missing code (drift).")
    args = ap.parse_args()

    if not args.fsh_root.exists():
        sys.stderr.write(f"ERROR: FSH root not found: {args.fsh_root}\n")
        return 2

    records = parse_conceptmaps(args.fsh_root)
    if not records:
        sys.stderr.write("ERROR: no ConceptMap target codes found.\n")
        return 2
    loinc, snomed, omop, skipped = split_checkable(records)

    if args.source == "local":
        results = run_local(loinc, snomed, omop, args.athena, args.vocab2)
        if results is None:
            return 2
    else:
        results = run_txfhir(loinc, snomed, omop)

    report, drift = build_report(records, results, args.source, skipped, args.athena, args.vocab2)
    print(report)
    if args.report:
        args.report.write_text(report + "\n", encoding="utf-8")
        sys.stderr.write(f"[report] written to {args.report}\n")
    return 1 if (args.strict and drift) else 0


if __name__ == "__main__":
    sys.exit(main())
