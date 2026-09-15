#!/usr/bin/env python3
"""Terminology verification ledger for this Implementation Guide.

Every externally-defined code bound in the FSH sources (LOINC, SNOMED CT, ICD-11 MMS codes
republished in the IG's ICD-11 CodeSystem, UCUM) is extracted, verified against the requested
sources, and recorded in ``input/data/terminology-verification-ledger.csv`` — the machine-readable
statement "last verified on DATE via SOURCE (VERSION)" that the IG's terminology pages summarise.

Design rules (see input/pagecontent/terminology-verification.md):
  * The IG build never depends on this script or on any terminology server: it runs by hand and
    in an advisory CI job, and it never edits FSH.
  * The owner of each terminology is the reference; local snapshots and tx.fhir.org are the
    second and third sources. Network failures are recorded as "unreachable", never as
    "not found".

Sources (``--source`` accepts a comma-separated list):
  owner   LOINC FHIR API (https://fhir.loinc.org, LOINC_USER/LOINC_PASS env), WHO ICD-API
          (ICD_CLIENT_ID/ICD_CLIENT_SECRET env) or the WHO ICD-11 MMS linearization export downloaded
          from icd.who.int (ICD11_MMS_LINEARIZATION_TXT env, tab-separated), NLM UCUM validator. Terminologies whose
          credentials are absent are skipped for this source. The SNOMED International browser
          is for human use only (its API refuses automated clients), so SNOMED owner checks are
          manual: record them with --manual-snomed-version once done.
  local   Dated local OMOP/Athena snapshots: ATHENA_CONCEPT_CSV (LOINC, UCUM) and
          VOCAB2_CONCEPT_CSV (SNOMED, International rows only — extension namespaces are flagged).
  txfhir  tx.fhir.org $lookup (existence, official display, version) + $validate-code with the
          display used in FSH (semantic check). Advisory.

Usage:
  python3 .github/scripts/terminology_ledger_check.py --source local,txfhir --write-ledger
  python3 .github/scripts/terminology_ledger_check.py --check --report ledger-report.md
  python3 .github/scripts/terminology_ledger_check.py --page-table   # markdown table for the page
"""
from __future__ import annotations

import argparse
import base64
import csv
import datetime as dt
import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import defaultdict
from pathlib import Path


def _find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for parent in [p, *p.parents]:
        if (parent / "sushi-config.yaml").exists():
            return parent
    return start.resolve().parents[2]


REPO = _find_repo_root(Path(__file__))
FSH_ROOT = REPO / "input" / "fsh"
LEDGER = REPO / "input" / "data" / "terminology-verification-ledger.csv"
TX = "https://tx.fhir.org/r4"
TODAY = dt.date.today().isoformat()
USER_AGENT = "ios-lifestyle-medicine-ig terminology-ledger/1.0"

SYSTEM_URL = {
    "LOINC": "http://loinc.org",
    "SNOMED": "http://snomed.info/sct",
    "ICD11": "http://id.who.int/icd/release/11/mms",
    "UCUM": "http://unitsofmeasure.org",
}
# Re-verification cadence in days (publication rhythm of each terminology).
CADENCE_DAYS = {"SNOMED": 45, "LOINC": 200, "ICD11": 400, "UCUM": 400}
IG_ICD11_CS_ID = "icd-11-lifestyle-cs"
IG_ICD11_URL = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs"

FIELDS = ["system", "code", "display_in_ig", "official_display", "status", "verified_on",
          "verified_via", "source_version", "method", "note", "files"]

# ----------------------------------------------------------------------------- extraction
ALIAS_SYSTEM = {
    "$LOINC": "LOINC", "$loinc": "LOINC", "http://loinc.org": "LOINC",
    "$SCT": "SNOMED", "$SNOMED": "SNOMED", "http://snomed.info/sct": "SNOMED",
    "$ICD11": "ICD11", IG_ICD11_URL: "ICD11", SYSTEM_URL["ICD11"]: "ICD11",
    "$UCUM": "UCUM", "http://unitsofmeasure.org": "UCUM",
}
RE_INLINE = re.compile(
    r'(\$LOINC|\$loinc|\$SCT|\$SNOMED|\$ICD11|\$UCUM|http://loinc\.org|http://snomed\.info/sct'
    r'|http://unitsofmeasure\.org|http://id\.who\.int/icd/release/11/mms|' + re.escape(IG_ICD11_URL) +
    r')#([^\s"\)\]]+)(?:\s+"((?:[^"\\]|\\.)*)")?')
RE_GROUP_SYS = re.compile(r'^\s*\*\s*group\[(\d+|[+=])\]\.(source|target)\s*=\s*"?([^"\s]+)"?')
RE_ELEM_CODE = re.compile(r'^\s*\*\s*group\[(\d+|[+=])\]\.element\[(?:\d+|[+=])\]\.code\s*=\s*#(\S+)')
RE_ELEM_DISP = re.compile(r'^\s*\*\s*group\[(\d+|[+=])\]\.element\[(?:\d+|[+=])\]\.display\s*=\s*"((?:[^"\\]|\\.)*)"')
RE_TGT_CODE = re.compile(r'^\s*\*\s*group\[(\d+|[+=])\]\.element\[(?:\d+|[+=])\]\.target\[(?:\d+|[+=])\]\.code\s*=\s*#(\S+)')
RE_TGT_DISP = re.compile(r'^\s*\*\s*group\[(\d+|[+=])\]\.element\[(?:\d+|[+=])\]\.target\[(?:\d+|[+=])\]\.display\s*=\s*"((?:[^"\\]|\\.)*)"')
RE_CONCEPT = re.compile(r'^\s*\*\s*#(\S+)\s+"((?:[^"\\]|\\.)*)"')


def _strip_comment(line: str) -> str:
    """Drop a trailing FSH // comment (outside quotes).

    A ``//`` only opens a comment at a token boundary (start of line or after
    whitespace), mirroring the SUSHI lexer: the ``//`` inside an unquoted URL such
    as ``* http://loinc.org#8867-4 "Heart rate"`` is part of the code token, not a
    comment. Cutting there silently dropped every full-URL code from the ledger.
    """
    out, in_q, i = [], False, 0
    while i < len(line):
        ch = line[i]
        if ch == '"' and (i == 0 or line[i - 1] != "\\"):
            in_q = not in_q
        if (not in_q and line.startswith("//", i)
                and (i == 0 or line[i - 1].isspace())):
            break
        out.append(ch)
        i += 1
    return "".join(out)


def extract_codes(fsh_root: Path):
    """Return {(system, code): {"displays": set, "files": set}} for every external code in FSH."""
    found = defaultdict(lambda: {"displays": set(), "files": set()})

    def add(system, code, display, path):
        code = code.strip().rstrip(",")
        if not code:
            return
        rec = found[(system, code)]
        rec["files"].add(str(path.relative_to(REPO)))
        if display:
            rec["displays"].add(display)

    for path in sorted(fsh_root.rglob("*.fsh")):
        text = path.read_text(encoding="utf-8", errors="replace")
        is_icd11_cs = re.search(r"^Id:\s*" + re.escape(IG_ICD11_CS_ID) + r"\s*$", text, re.M) is not None
        group_sys, cur_group = {}, 0
        in_block_string = False
        for raw in text.splitlines():
            if raw.count('"""') % 2 == 1:
                in_block_string = not in_block_string
                continue
            if in_block_string:
                continue
            line = _strip_comment(raw)
            if not line.strip():
                continue
            for m in RE_INLINE.finditer(line):
                add(ALIAS_SYSTEM[m.group(1)], m.group(2), m.group(3), path)
            if is_icd11_cs:
                m = RE_CONCEPT.match(line)
                if m:
                    add("ICD11", m.group(1), m.group(2), path)
            m = RE_GROUP_SYS.match(line)
            if m:
                idx = m.group(1)
                if idx == "+":
                    cur_group += 1
                elif idx != "=":
                    cur_group = int(idx)
                group_sys.setdefault(cur_group, {})[m.group(2)] = ALIAS_SYSTEM.get(m.group(3))
                continue
            for regex, side in ((RE_ELEM_CODE, "source"), (RE_TGT_CODE, "target")):
                m = regex.match(line)
                if m:
                    idx = m.group(1)
                    g = cur_group if idx in ("+", "=") else int(idx)
                    system = group_sys.get(g, {}).get(side)
                    if system:
                        add(system, m.group(2), None, path)
    return found


# ----------------------------------------------------------------------------- HTTP helpers
def _get_json(url: str, headers: dict | None = None, timeout: int = 25, retries: int = 2):
    """GET JSON. Returns (status_code, payload|None, error|None). Network errors → ('unreachable')."""
    h = {"Accept": "application/fhir+json, application/json", "User-Agent": USER_AGENT}
    if headers:
        h.update(headers)
    last = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(url, headers=h)
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                body = resp.read().decode("utf-8", errors="replace")
                return resp.status, (json.loads(body) if body.strip() else {}), None
        except urllib.error.HTTPError as e:
            body = e.read().decode("utf-8", errors="replace")
            try:
                payload = json.loads(body) if body.strip() else {}
            except json.JSONDecodeError:
                payload = {"raw": body[:300]}
            if e.code in (429, 502, 503, 504) and attempt < retries:
                time.sleep(2.0 * (attempt + 1))
                last = f"http {e.code}"
                continue
            return e.code, payload, None
        except (urllib.error.URLError, TimeoutError, OSError) as e:  # DNS/socket/timeout
            last = f"unreachable: {getattr(e, 'reason', e)}"
            if attempt < retries:
                time.sleep(2.0 * (attempt + 1))
    return 0, None, last or "unreachable"


def _params(payload: dict) -> dict:
    out = {}
    for p in (payload or {}).get("parameter", []):
        name = p.get("name")
        val = None
        for k, v in p.items():
            if k.startswith("value"):
                val = v
        out.setdefault(name, val)
    return out


# ----------------------------------------------------------------------------- tx.fhir.org
def tx_lookup(system: str, code: str):
    url = f"{TX}/CodeSystem/$lookup?" + urllib.parse.urlencode({"system": SYSTEM_URL[system], "code": code})
    status, payload, err = _get_json(url)
    if err:
        return {"reach": "unreachable", "note": err}
    if status == 200 and payload.get("resourceType") == "Parameters":
        p = _params(payload)
        return {"reach": "ok", "found": True, "display": p.get("display"), "version": p.get("version"),
                "name": p.get("name")}
    msg = ""
    if payload and payload.get("resourceType") == "OperationOutcome":
        msg = "; ".join(i.get("diagnostics", "") or i.get("details", {}).get("text", "")
                        for i in payload.get("issue", []))[:200]
    return {"reach": "ok", "found": False, "note": f"http {status} {msg}".strip()}


def tx_validate(system: str, code: str, display: str | None):
    q = {"url": SYSTEM_URL[system], "code": code}
    if display:
        q["display"] = display
    url = f"{TX}/CodeSystem/$validate-code?" + urllib.parse.urlencode(q)
    status, payload, err = _get_json(url)
    if err:
        return {"reach": "unreachable", "note": err}
    p = _params(payload) if payload else {}
    return {"reach": "ok", "result": bool(p.get("result")), "message": (p.get("message") or "")[:200],
            "display": p.get("display"), "version": p.get("version"), "inactive": p.get("inactive")}


# ----------------------------------------------------------------------------- local snapshots
def scan_athena_like(csv_path: Path, wanted: dict[str, set], vocab_filter=None):
    """wanted: {vocabulary_id: set(codes)} → {(vocab, code): row-dict}. Tab-separated OMOP CONCEPT.csv."""
    hits = {}
    remaining = {v: set(c) for v, c in wanted.items()}
    with open(csv_path, encoding="utf-8", errors="replace", newline="") as fh:
        reader = csv.reader(fh, delimiter="\t", quoting=csv.QUOTE_NONE)
        header = next(reader)
        ix = {name: i for i, name in enumerate(header)}
        for row in reader:
            if len(row) < len(header):
                continue
            vocab = row[ix["vocabulary_id"]]
            codes = remaining.get(vocab)
            if not codes:
                continue
            code = row[ix["concept_code"]]
            if code in codes:
                hits[(vocab, code)] = {
                    "name": row[ix["concept_name"]], "standard": row[ix["standard_concept"]],
                    "invalid": row[ix["invalid_reason"]], "valid_end": row[ix["valid_end_date"]],
                    "concept_id": row[ix["concept_id"]],
                }
                codes.discard(code)
                if not any(remaining.values()):
                    break
    return hits


def snapshot_version(csv_path: Path, vocab: str) -> str:
    voc = csv_path.parent / "VOCABULARY.csv"
    if voc.exists():
        with open(voc, encoding="utf-8", errors="replace", newline="") as fh:
            reader = csv.reader(fh, delimiter="\t", quoting=csv.QUOTE_NONE)
            header = next(reader)
            ix = {n: i for i, n in enumerate(header)}
            for row in reader:
                if row and row[ix["vocabulary_id"]] == vocab:
                    return row[ix["vocabulary_version"]]
    return "snapshot " + dt.date.fromtimestamp(csv_path.stat().st_mtime).isoformat()


def is_international_sctid(code: str) -> bool:
    """SNOMED CT identifiers carry a namespace: partition digits '00'/'01' = International;
    '10'/'11' = extension (the 7 digits before the partition are the namespace, e.g. 1000124 = US)."""
    if not code.isdigit() or len(code) < 6:
        return False
    return code[-3:-1] in ("00", "01")


# ----------------------------------------------------------------------------- owner sources
def loinc_owner_lookup(code: str, user: str, pw: str):
    url = "https://fhir.loinc.org/CodeSystem/$lookup?" + urllib.parse.urlencode({"system": SYSTEM_URL["LOINC"], "code": code})
    token = base64.b64encode(f"{user}:{pw}".encode()).decode()
    status, payload, err = _get_json(url, headers={"Authorization": f"Basic {token}"})
    if err:
        return {"reach": "unreachable", "note": err}
    if status == 200 and payload.get("resourceType") == "Parameters":
        p = _params(payload)
        return {"reach": "ok", "found": True, "display": p.get("display"), "version": p.get("version")}
    return {"reach": "ok", "found": False, "note": f"http {status}"}


def ucum_owner_valid(code: str):
    url = "https://ucum.nlm.nih.gov/ucum-service/v1/isValidUCUM/" + urllib.parse.quote(code, safe="")
    try:
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=20) as resp:
            body = resp.read().decode().strip().lower()
        return {"reach": "ok", "found": body == "true"}
    except Exception as e:  # noqa: BLE001 — any failure is "unreachable", never "invalid"
        return {"reach": "unreachable", "note": str(e)[:120]}


def icd_owner_token(client_id: str, secret: str):
    data = urllib.parse.urlencode({"client_id": client_id, "client_secret": secret,
                                   "scope": "icdapi_access", "grant_type": "client_credentials"}).encode()
    try:
        req = urllib.request.Request("https://icdaccessmanagement.who.int/connect/token", data=data,
                                     headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=25) as resp:
            return json.loads(resp.read().decode()).get("access_token")
    except Exception:  # noqa: BLE001
        return None


def icd_owner_lookup(code: str, token: str, release: str = "2026-01"):
    url = f"https://id.who.int/icd/release/11/{release}/mms/codeinfo/{urllib.parse.quote(code, safe='')}"
    status, payload, err = _get_json(url, headers={"Authorization": f"Bearer {token}", "API-Version": "v2",
                                                   "Accept-Language": "en"})
    if err:
        return {"reach": "unreachable", "note": err}
    if status == 200 and payload:
        return {"reach": "ok", "found": True, "stem": payload.get("stemId"), "version": release}
    return {"reach": "ok", "found": False, "note": f"http {status}"}


def who_linearization(path: Path) -> tuple[dict, str]:
    """WHO ICD-11 MMS 'LinearizationMiniOutput' export (tab-separated): {code: title}, version label."""
    codes, version = {}, ""
    with open(path, encoding="utf-8-sig", newline="") as fh:
        reader = csv.reader(fh, delimiter="\t")
        header = next(reader)
        for cell in header:
            if cell.startswith("Version:"):
                version = cell.replace("Version:", "").strip()
        ix = {n: i for i, n in enumerate(header)}
        for row in reader:
            if len(row) > ix["Title"] and row[ix["Code"]]:
                title = re.sub(r'^"?(- )*', "", row[ix["Title"]]).strip('"').strip()
                codes[row[ix["Code"]]] = title
    return codes, version


# ----------------------------------------------------------------------------- ledger I/O
def read_ledger(path: Path) -> dict:
    rows = {}
    if path.exists():
        with open(path, encoding="utf-8", newline="") as fh:
            for row in csv.DictReader(fh):
                rows[(row["system"], row["code"])] = row
    return rows


def write_ledger(path: Path, rows: dict):
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=FIELDS, quoting=csv.QUOTE_MINIMAL, lineterminator="\n")
        w.writeheader()
        for key in sorted(rows, key=lambda k: (k[0], k[1])):
            w.writerow({f: rows[key].get(f, "") for f in FIELDS})


# ----------------------------------------------------------------------------- verification run
def verify(found: dict, sources: list[str], args, log=print) -> dict:
    """Return {(system, code): result-row} for this run (only codes that reached ≥1 source)."""
    results = {}
    by_sys = defaultdict(set)
    for (system, code) in found:
        by_sys[system].add(code)

    per_code = defaultdict(lambda: {"methods": [], "via": [], "versions": [], "status": None,
                                    "official": None, "notes": []})

    if "local" in sources:
        athena = Path(args.athena) if args.athena else None
        vocab2 = Path(args.vocab2) if args.vocab2 else None
        if athena and athena.exists():
            hits = scan_athena_like(athena, {"LOINC": by_sys.get("LOINC", set()), "UCUM": by_sys.get("UCUM", set())})
            ver = {"LOINC": snapshot_version(athena, "LOINC"), "UCUM": snapshot_version(athena, "UCUM")}
            for system in ("LOINC", "UCUM"):
                for code in by_sys.get(system, ()):
                    r = per_code[(system, code)]
                    h = hits.get((system, code))
                    r["methods"].append("local-snapshot"); r["via"].append("Athena OMOP snapshot")
                    r["versions"].append(f"Athena {system} {ver[system]}")
                    if h:
                        st = "inactive" if h["invalid"] else "active"
                        r["status"] = r["status"] or st
                        if st == "inactive":
                            r["status"] = "inactive"; r["notes"].append(f"Athena: invalid_reason={h['invalid']}")
                        r["official"] = r["official"] or h["name"]
                        if h["standard"] != "S" and system == "LOINC":
                            r["notes"].append("Athena: not a standard concept")
                    else:
                        r["status"] = r["status"] or "not-found"; r["notes"].append("Athena: not found")
            log(f"local: Athena scanned ({len(hits)} hits for LOINC+UCUM)")
        else:
            log("local: Athena CSV not available — LOINC/UCUM local check skipped")
        if vocab2 and vocab2.exists():
            hits = scan_athena_like(vocab2, {"SNOMED": by_sys.get("SNOMED", set())})
            ver = snapshot_version(vocab2, "SNOMED")
            for code in by_sys.get("SNOMED", ()):
                r = per_code[("SNOMED", code)]
                h = hits.get(("SNOMED", code))
                r["methods"].append("local-snapshot"); r["via"].append("Vocab2 OMOP snapshot")
                r["versions"].append(f"Vocab2 SNOMED {ver.split(';')[0].strip()}")
                if h:
                    st = "inactive" if h["invalid"] else "active"
                    r["status"] = st if r["status"] in (None, "active") else r["status"]
                    r["official"] = r["official"] or h["name"]
                    if h["standard"] != "S":
                        r["notes"].append("Vocab2: not a standard concept")
                else:
                    r["status"] = r["status"] or "not-found"; r["notes"].append("Vocab2: not found")
                if not is_international_sctid(code):
                    r["notes"].append("SCTID namespace is an extension, not International")
            log(f"local: Vocab2 scanned ({len(hits)} hits for SNOMED)")
        else:
            log("local: Vocab2 CSV not available — SNOMED local check skipped")

    if "owner" in sources:
        lu, lp = os.environ.get("LOINC_USER"), os.environ.get("LOINC_PASS")
        if lu and lp:
            for i, code in enumerate(sorted(by_sys.get("LOINC", ()))):
                res = loinc_owner_lookup(code, lu, lp)
                r = per_code[("LOINC", code)]
                if res["reach"] != "ok":
                    r["notes"].append("fhir.loinc.org unreachable"); continue
                r["methods"].append("owner-api"); r["via"].append("fhir.loinc.org")
                if res.get("version"):
                    r["versions"].append(f"LOINC {res['version']}")
                if res["found"]:
                    r["status"] = "active" if r["status"] in (None, "not-found") else r["status"]
                    r["official"] = res.get("display") or r["official"]
                else:
                    r["status"] = "not-found"; r["notes"].append("fhir.loinc.org: not found")
                time.sleep(args.pause)
            log("owner: LOINC FHIR API consulted")
        else:
            log("owner: LOINC_USER/LOINC_PASS not set — LOINC owner check skipped")
        cid, csec = os.environ.get("ICD_CLIENT_ID"), os.environ.get("ICD_CLIENT_SECRET")
        if cid and csec:
            tok = icd_owner_token(cid, csec)
            if tok:
                for code in sorted(by_sys.get("ICD11", ())):
                    res = icd_owner_lookup(code, tok)
                    r = per_code[("ICD11", code)]
                    if res["reach"] != "ok":
                        r["notes"].append("ICD-API unreachable"); continue
                    r["methods"].append("owner-api"); r["via"].append("icd.who.int ICD-API")
                    r["versions"].append(f"ICD-11 MMS {res.get('version', '')}")
                    r["status"] = "active" if res["found"] else "not-found"
                    time.sleep(args.pause)
                log("owner: WHO ICD-API consulted")
            else:
                log("owner: ICD-API token request failed — ICD-11 owner check skipped")
        elif os.environ.get("ICD11_MMS_LINEARIZATION_TXT") and Path(os.environ["ICD11_MMS_LINEARIZATION_TXT"]).exists():
            codes, version = who_linearization(Path(os.environ["ICD11_MMS_LINEARIZATION_TXT"]))
            for code in sorted(by_sys.get("ICD11", ())):
                r = per_code[("ICD11", code)]
                r["methods"].append("owner-file"); r["via"].append("icd.who.int MMS linearization export")
                r["versions"].append(f"WHO linearization {version}")
                title = codes.get(code)
                if title is None:
                    r["status"] = "not-found"; r["notes"].append("WHO linearization: code not present")
                else:
                    r["status"] = "active" if r["status"] in (None, "not-found") else r["status"]
                    r["official"] = r["official"] or title
                    for d in found[("ICD11", code)]["displays"]:
                        if d.strip().lower() != title.lower():
                            r["notes"].append(f"WHO title differs: '{title}'")
            log(f"owner: WHO ICD-11 linearization export consulted ({version})")
        else:
            log("owner: ICD_CLIENT_ID/ICD_CLIENT_SECRET (or ICD11_MMS_LINEARIZATION_TXT) not set — ICD-11 owner check skipped")
        for code in sorted(by_sys.get("UCUM", ())):
            res = ucum_owner_valid(code)
            r = per_code[("UCUM", code)]
            if res["reach"] != "ok":
                r["notes"].append("ucum.nlm.nih.gov unreachable"); continue
            r["methods"].append("owner-api"); r["via"].append("ucum.nlm.nih.gov validator")
            r["status"] = "active" if res["found"] else "not-found"
            time.sleep(args.pause)
        log("owner: UCUM validator consulted (SNOMED owner browser is manual — see --manual-snomed-version)")

    if "txfhir" in sources:
        n = 0
        for (system, code) in sorted(found):
            r = per_code[(system, code)]
            lk = tx_lookup(system, code)
            n += 1
            if lk["reach"] != "ok":
                r["notes"].append(f"tx.fhir.org unreachable ({lk.get('note', '')[:60]})")
                time.sleep(args.pause); continue
            r["methods"].append("txfhir"); r["via"].append("tx.fhir.org")
            if lk.get("version"):
                r["versions"].append(f"tx {system} {lk['version']}")
            if lk["found"]:
                r["status"] = "active" if r["status"] in (None, "not-found") else r["status"]
                r["official"] = r["official"] or lk.get("display")
                displays = sorted(found[(system, code)]["displays"])
                for d in displays[:2]:
                    vc = tx_validate(system, code, d)
                    if vc["reach"] != "ok":
                        break
                    if vc.get("inactive"):
                        r["status"] = "inactive"; r["notes"].append("tx: concept inactive")
                    if not vc["result"]:
                        r["notes"].append(f"tx display check: '{d}' — {vc['message'][:90]}")
                    time.sleep(args.pause)
            else:
                r["status"] = "not-found" if r["status"] in (None, "active") else r["status"]
                r["notes"].append(f"tx.fhir.org: {lk.get('note', 'not found')[:80]}")
            time.sleep(args.pause)
            if n % 50 == 0:
                log(f"txfhir: {n}/{len(found)} codes")
        log(f"txfhir: {n} codes consulted")

    for key, r in per_code.items():
        if not r["methods"]:
            continue
        results[key] = r
    return results


def merge(found: dict, previous: dict, run: dict, manual_snomed: str | None, kept: set | None = None) -> dict:
    """``kept`` = keys deliberately not re-verified this run (--only-new): their ledger rows are
    carried over unchanged, apart from the display/files columns that come from the FSH."""
    rows = {}
    kept = kept or set()
    for key, rec in found.items():
        system, code = key
        prev = previous.get(key)
        r = run.get(key)
        displays = " | ".join(sorted(rec["displays"]))
        files = ";".join(sorted(rec["files"]))
        if key in kept and prev:
            row = dict(prev); row["display_in_ig"] = displays; row["files"] = files
        elif r:
            notes = list(dict.fromkeys(r["notes"]))
            display_flag = any(n.startswith("tx display check") for n in notes)
            status = r["status"] or "unverified"
            if status == "active" and display_flag:
                status = "display-mismatch"
            row = {
                "system": system, "code": code, "display_in_ig": displays,
                "official_display": r["official"] or (prev or {}).get("official_display", ""),
                "status": status, "verified_on": TODAY,
                "verified_via": ";".join(dict.fromkeys(r["via"])),
                "source_version": ";".join(dict.fromkeys(r["versions"])),
                "method": ";".join(dict.fromkeys(r["methods"])),
                "note": " | ".join(notes)[:400], "files": files,
            }
        elif prev:
            row = dict(prev); row["display_in_ig"] = displays; row["files"] = files
            row["note"] = (row.get("note", "") + " | no source reached on " + TODAY)[:400]
        else:
            row = {"system": system, "code": code, "display_in_ig": displays, "official_display": "",
                   "status": "unverified", "verified_on": "", "verified_via": "", "source_version": "",
                   "method": "", "note": "no source reached", "files": files}
        if system == "SNOMED" and manual_snomed:
            row["method"] = ";".join(dict.fromkeys((row["method"] + ";owner-browser").strip(";").split(";")))
            row["verified_via"] = ";".join(dict.fromkeys((row["verified_via"] + ";browser.ihtsdotools.org (manual)").strip(";").split(";")))
            row["source_version"] = ";".join(dict.fromkeys((row["source_version"] + f";SNOMED International {manual_snomed}").strip(";").split(";")))
        rows[key] = row
    return rows


# ----------------------------------------------------------------------------- reporting
def summarise(rows: dict):
    per = defaultdict(lambda: {"n": 0, "active": 0, "problems": [], "dates": set(), "versions": set(), "via": set()})
    for (system, code), row in rows.items():
        s = per[system]
        s["n"] += 1
        if row["status"] == "active":
            s["active"] += 1
        else:
            s["problems"].append((code, row["status"], row.get("note", "")[:120]))
        if row.get("verified_on"):
            s["dates"].add(row["verified_on"])
        for v in (row.get("source_version") or "").split(";"):
            if v:
                s["versions"].add(v)
        for v in (row.get("verified_via") or "").split(";"):
            if v:
                s["via"].add(v)
    return per


def page_table(rows: dict) -> str:
    per = summarise(rows)
    out = ["| System | Codes in the IG | Last verified | Via | Source version(s) | Open findings |",
           "|---|--:|---|---|---|--:|"]
    names = {"LOINC": "LOINC", "SNOMED": "SNOMED CT (International)", "ICD11": "ICD-11 MMS (republished in the IG)", "UCUM": "UCUM"}
    for system in ("LOINC", "SNOMED", "ICD11", "UCUM"):
        if system not in per:
            continue
        s = per[system]
        dates = sorted(s["dates"])
        last = dates[-1] if dates else "—"
        out.append(f"| {names[system]} | {s['n']} | {last} | {', '.join(sorted(s['via'])) or '—'} | "
                   f"{'; '.join(sorted(s['versions'])) or '—'} | {len(s['problems'])} |")
    return "\n".join(out)


def check(found: dict, rows: dict):
    missing = [k for k in found if k not in rows]
    orphans = [k for k in rows if k not in found]   # ledger rows for codes no longer bound in FSH
    stale, problems = [], []
    today = dt.date.fromisoformat(TODAY)
    for key, row in rows.items():
        if row["status"] != "active":
            problems.append((key, row["status"], row.get("note", "")))
        if row.get("verified_on"):
            age = (today - dt.date.fromisoformat(row["verified_on"])).days
            if age > CADENCE_DAYS.get(key[0], 400):
                stale.append((key, age))
        else:
            stale.append((key, None))
    return missing, stale, problems, orphans


def build_report(found, rows, missing, stale, problems, sources, orphans=()) -> str:
    per = summarise(rows)
    lines = [f"# Terminology verification ledger — report {TODAY}", "",
             f"Codes extracted from FSH: {len(found)} · ledger rows: {len(rows)} · sources this run: {', '.join(sources) or 'none (check only)'}", "",
             page_table(rows), ""]
    lines.append(f"## Missing from the ledger ({len(missing)})")
    lines += [f"- {s} {c}" for s, c in sorted(missing)] or ["- none"]
    lines.append(f"\n## Re-verification due ({len(stale)})")
    lines += [f"- {k[0]} {k[1]} — {'never verified' if age is None else f'{age} days'}" for k, age in sorted(stale)] or ["- none"]
    lines.append(f"\n## Retired — ledger rows whose code is no longer bound in FSH ({len(orphans)})")
    lines += [f"- {s} {c}" for s, c in sorted(orphans)] or ["- none"]
    lines.append(f"\n## Findings ({len(problems)})")
    lines += [f"- {k[0]} {k[1]} — {st}: {note}" for k, st, note in sorted(problems)] or ["- none"]
    return "\n".join(lines) + "\n"


# ----------------------------------------------------------------------------- main
def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--source", default="", help="comma list of owner,local,txfhir (empty = check only)")
    ap.add_argument("--write-ledger", action="store_true", help="update input/data/terminology-verification-ledger.csv")
    ap.add_argument("--check", action="store_true", help="compare FSH codes with the ledger (missing / stale / findings)")
    ap.add_argument("--report", help="write a markdown report to this path")
    ap.add_argument("--page-table", action="store_true", help="print the markdown table used by terminology-verification.md")
    ap.add_argument("--strict", action="store_true", help="exit 1 on missing ledger rows or non-active codes")
    ap.add_argument("--athena", default=os.environ.get("ATHENA_CONCEPT_CSV", ""))
    ap.add_argument("--vocab2", default=os.environ.get("VOCAB2_CONCEPT_CSV", ""))
    ap.add_argument("--only-new", action="store_true",
                    help="verify only the codes absent from the ledger and keep every existing row as it is "
                         "(incremental run before a commit; a full run re-verifies everything)")
    ap.add_argument("--pause", type=float, default=0.3, help="seconds between network calls")
    ap.add_argument("--manual-snomed-version", default=None,
                    help="record a manual SNOMED International browser check done today, e.g. 20250901")
    ap.add_argument("--fsh-root", default=str(FSH_ROOT))
    ap.add_argument("--ledger", default=str(LEDGER))
    args = ap.parse_args()

    fsh_root, ledger_path = Path(args.fsh_root), Path(args.ledger)
    found = extract_codes(fsh_root)
    sources = [s.strip() for s in args.source.split(",") if s.strip()]
    for s in sources:
        if s not in ("owner", "local", "txfhir"):
            print(f"unknown source: {s}", file=sys.stderr); return 2
    print(f"extracted {len(found)} distinct external codes from {fsh_root.relative_to(REPO)} "
          f"({', '.join(f'{k}={v}' for k, v in sorted(defaultdict(int, {s: sum(1 for (x, _) in found if x == s) for s in SYSTEM_URL}).items()))})")

    previous = read_ledger(ledger_path)
    rows = previous
    if sources:
        targets, kept = found, set()
        if args.only_new:
            targets = {k: v for k, v in found.items() if k not in previous}
            kept = set(found) - set(targets)
            print(f"--only-new: {len(targets)} code(s) to verify, {len(kept)} ledger row(s) kept as they are")
        run = verify(targets, sources, args) if targets else {}
        rows = merge(found, previous, run, args.manual_snomed_version, kept)
        if args.write_ledger:
            write_ledger(ledger_path, rows)
            print(f"ledger written: {ledger_path.relative_to(REPO)} ({len(rows)} rows)")

    missing, stale, problems, orphans = check(found, rows)
    if args.page_table:
        print(page_table(rows))
    if args.report:
        Path(args.report).write_text(build_report(found, rows, missing, stale, problems, sources, orphans), encoding="utf-8")
        print(f"report written: {args.report}")
    if args.check or args.strict or not sources:
        print(f"check: missing={len(missing)} retired={len(orphans)} stale={len(stale)} findings={len(problems)}")
        for k in sorted(missing)[:40]:
            print(f"  - missing from ledger: {k[0]} {k[1]}")
        for k in sorted(orphans)[:40]:
            print(f"  - retired (not in FSH): {k[0]} {k[1]}")
        for k, st, note in sorted(problems)[:40]:
            print(f"  - {k[0]} {k[1]}: {st} {note[:100]}")
    if args.strict and (missing or orphans or problems):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
