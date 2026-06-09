#!/usr/bin/env python3
"""Validate the IG's CDS Hooks Card examples against the vendored CDS Hooks 2.0 Card schema.

Implements course item 4.3 (HL7 FHIR Intermediate, FHIR Course Alignment §4.3).

Validates BOTH copies of every Card (Pitfall #54 — keep them in lock-step):
  (a) the standalone Card files  : input/includes/cds-hooks-cards/*.json
  (b) the ```json Card blocks embedded in input/pagecontent/cds-hooks-integration.md

Each Card source is a CDS Hooks response envelope {"cards":[...]}; every cards[*] is
validated against the Card schema. Bare card objects are also accepted. Non-card JSON
blocks in the narrative (discovery responses, hook requests, illustrative snippets) are
skipped. Exit 0 = all conformant, 1 = validation failures, 2 = setup error.

Run:
  python3 scripts/validate_cds_cards.py
  python3 scripts/validate_cds_cards.py --self-test   # proves the gate catches a typo

AUTHORED-BY-CLAUDE-T1-S55 (Pitfall #97)
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

try:
    from jsonschema import Draft7Validator
except ImportError:
    sys.stderr.write("ERROR: 'jsonschema' not installed. Run: pip install jsonschema\n")
    sys.exit(2)

def _find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for parent in [p, *p.parents]:
        if (parent / "sushi-config.yaml").exists() or (parent / "ig.ini").exists():
            return parent
    return start.resolve().parents[1]


REPO = _find_repo_root(Path(__file__))
DEFAULT_SCHEMA = REPO / "input" / "includes" / "cds-hooks-cards" / "schemas" / "cds-hooks-card-2.0.schema.json"
DEFAULT_CARDS_DIR = REPO / "input" / "includes" / "cds-hooks-cards"
DEFAULT_NARRATIVE = REPO / "input" / "pagecontent" / "cds-hooks-integration.md"

JSON_BLOCK_RE = re.compile(r"```json\s*\n(.*?)```", re.DOTALL)


def load_validator(schema_path: Path) -> Draft7Validator:
    with schema_path.open(encoding="utf-8") as f:
        schema = json.load(f)
    Draft7Validator.check_schema(schema)
    return Draft7Validator(schema)


def cards_from_obj(obj):
    """Cards from a {'cards':[...]} envelope or a bare card object; [] otherwise."""
    if isinstance(obj, dict):
        if isinstance(obj.get("cards"), list):
            return obj["cards"]
        if "summary" in obj and "indicator" in obj:
            return [obj]
    return []


def card_errors(validator: Draft7Validator, card) -> list[str]:
    errs = sorted(validator.iter_errors(card), key=lambda e: list(e.path))
    return [f"{'/'.join(str(p) for p in e.path) or '<root>'}: {e.message}" for e in errs]


def collect_from_json_files(cards_dir: Path):
    """Yield (origin, cards_or_None, parse_error_or_None)."""
    out = []
    for p in sorted(cards_dir.glob("*.json")):
        try:
            obj = json.loads(p.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            out.append((str(p.relative_to(REPO)), None, f"JSON parse error: {e}"))
            continue
        out.append((str(p.relative_to(REPO)), cards_from_obj(obj), None))
    return out


def collect_from_markdown(md_path: Path):
    """Yield (origin, cards, None) for each card-envelope ```json block."""
    out = []
    text = md_path.read_text(encoding="utf-8")
    for m in JSON_BLOCK_RE.finditer(text):
        try:
            obj = json.loads(m.group(1))
        except json.JSONDecodeError:
            continue  # illustrative / non-card / partial snippet — skip silently
        cards = cards_from_obj(obj)
        if cards:
            line = text[: m.start()].count("\n") + 1
            out.append((f"{md_path.relative_to(REPO)}:~L{line}", cards, None))
    return out


def run_self_test(validator: Draft7Validator, cards_dir: Path) -> int:
    files = sorted(cards_dir.glob("*.json"))
    if not files:
        sys.stderr.write("ERROR: no card files for self-test.\n")
        return 2
    cards = cards_from_obj(json.loads(files[0].read_text(encoding="utf-8")))
    if not cards:
        sys.stderr.write(f"ERROR: {files[0].name} has no cards for self-test.\n")
        return 2
    mangled = dict(cards[0])
    if "source" in mangled:
        mangled["sources"] = mangled.pop("source")  # the Pitfall #95 typo
    errs = card_errors(validator, mangled)
    if errs:
        print(f"SELF-TEST PASS: a card with the 'source'->'sources' typo is correctly REJECTED ({len(errs)} error(s)):")
        for e in errs[:4]:
            print(f"  - {e}")
        return 0
    print("SELF-TEST FAIL: the mangled card was accepted (schema too loose).")
    return 1


def main() -> int:
    ap = argparse.ArgumentParser(description="Validate CDS Hooks Card examples against the CDS Hooks 2.0 Card schema (course item 4.3).")
    ap.add_argument("--schema", type=Path, default=DEFAULT_SCHEMA)
    ap.add_argument("--cards-dir", type=Path, default=DEFAULT_CARDS_DIR)
    ap.add_argument("--narrative", type=Path, default=DEFAULT_NARRATIVE)
    ap.add_argument("--self-test", action="store_true",
                    help="Inject a 'sources'-plural typo into a valid card and confirm the schema REJECTS it.")
    args = ap.parse_args()

    if not args.schema.exists():
        sys.stderr.write(f"ERROR: schema not found: {args.schema}\n")
        return 2
    validator = load_validator(args.schema)

    if args.self_test:
        return run_self_test(validator, args.cards_dir)

    sources = []
    if args.cards_dir.exists():
        sources += collect_from_json_files(args.cards_dir)
    if args.narrative.exists():
        sources += collect_from_markdown(args.narrative)

    print(f"CDS Hooks Card validation — schema: {args.schema.name}")
    total_cards = 0
    total_fail = 0
    for origin, cards, parse_err in sources:
        if parse_err:
            print(f"  FAIL  {origin}: {parse_err}")
            total_fail += 1
            continue
        if not cards:
            continue
        for idx, card in enumerate(cards):
            total_cards += 1
            msgs = card_errors(validator, card)
            label = f"{origin} [card {idx}]"
            if msgs:
                total_fail += 1
                print(f"  FAIL  {label}")
                for mm in msgs:
                    print(f"          - {mm}")
            else:
                print(f"  ok    {label}")

    print(f"\n{total_cards} card(s) validated; {total_fail} failure(s).")
    if total_cards == 0:
        sys.stderr.write("ERROR: no cards found to validate (check --cards-dir / --narrative).\n")
        return 2
    return 1 if total_fail else 0


if __name__ == "__main__":
    sys.exit(main())
