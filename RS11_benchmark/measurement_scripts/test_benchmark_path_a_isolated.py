#!/usr/bin/env python3
"""Tests for benchmark_path_a_isolated.py (19 Nov 2026), written before the script.

Run: python3 -I scripts/test_benchmark_path_a_isolated.py
The protocol is in protocol_path_a_isolated.md, section 1 (commit 5f5e0ea86).
Temporary fixture files go to a fresh tempfile.mkdtemp() folder and are left there (nothing is deleted).
"""
import json
import sys
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "services" / "terminology-router" / "src"))
sys.path.insert(0, str(HERE))

import benchmark_path_a_isolated as pa  # noqa: E402
from terminology_router.models import (  # noqa: E402
    MatchStrength, Outcome, Path as RPath, Route, RouteRequest, TaskClass)
from terminology_router.router import Router  # noqa: E402
from terminology_router.stores import AthenaCsvStore  # noqa: E402

HEADER = ["concept_id", "concept_name", "domain_id", "vocabulary_id", "concept_class_id",
          "standard_concept", "concept_code", "valid_start_date", "valid_end_date", "invalid_reason"]
ROWS = [
    ("1", "Alpha rate", "Measurement", "LOINC", "Clinical Observation", "S", "8867-4", "", "", ""),
    ("2", "Alpha rate --resting", "Measurement", "LOINC", "Clinical Observation", "S", "40443-4", "", "", ""),
    ("3", "Alpha rate by Beta method", "Measurement", "LOINC", "Clinical Observation", "S", "8889-8", "", "", ""),
    ("4", "Beta level", "Measurement", "LOINC", "Lab Test", "S", "2339-0", "", "", ""),
    ("5", "Beta level", "Measurement", "LOINC", "Lab Test", "", "2345-7", "", "", ""),
    ("6", "Alpha rate --during gamma", "Measurement", "LOINC", "Clinical Observation", "", "99990-1", "", "", "D"),
    ("7", "Gamma certification [Type]", "Observation", "LOINC", "Clinical Observation", "S", "80405-4", "", "", ""),
    ("8", "Delta disorder", "Condition", "SNOMED", "Clinical Finding", "S", "44054006", "", "", ""),
    ("9", "Zeta", "Condition", "SNOMED", "Clinical Finding", "S", "195967001", "", "", ""),
    ("10", "Zeta attack", "Condition", "SNOMED", "Clinical Finding", "S", "266364000", "", "", ""),
]
XML = ("<ICD10CM.tabular><chapter><section id='E08-E13'>"
       "<diag><name>E11</name><desc>Delta disorder</desc>"
       "<diag><name>E11.2</name><desc>Delta disorder with organ complications</desc>"
       "<diag><name>E11.21</name><desc>Delta disorder with delta organ disease</desc></diag>"
       "</diag></diag><diag><name>I10</name><desc>Epsilon disorder (primary)</desc></diag>"
       "</section></chapter></ICD10CM.tabular>")


def fixture_dir():
    d = Path(tempfile.mkdtemp(prefix="path_a_test_"))
    with open(d / "CONCEPT.csv", "x", encoding="utf-8", newline="") as fh:
        fh.write("\t".join(HEADER) + "\n")
        for r in ROWS:
            fh.write("\t".join(r) + "\n")
    with open(d / "tabular.xml", "x", encoding="utf-8") as fh:
        fh.write(XML)
    return d


def build_store(d):
    st = pa.SqliteStore()
    for voc in ("LOINC", "SNOMED"):
        st.add_rows(voc, pa.load_omop_concept_csv(d / "CONCEPT.csv", voc))
    st.add_rows("ICD10CM", pa.load_icd10cm_tabular(d / "tabular.xml"))
    st.finish()
    return st


def key(c):
    return (c.system, c.code, c.display, c.match, c.active, c.standard)


class TestCheckDigits(unittest.TestCase):
    def test_loinc_mod10(self):
        for c in ("8867-4", "80404-7", "4548-4", "2345-7", "97506-0", "8873-2", "85354-9", "10839-9", "8889-8"):
            self.assertTrue(pa.loinc_valid(c), c)
        for c in ("8867-5", "80404-1", "8867"):
            self.assertFalse(pa.loinc_valid(c), c)

    def test_snomed_verhoeff(self):
        for c in ("44054006", "49436004", "59621000", "195967001", "251898000"):
            self.assertTrue(pa.verhoeff_valid(c), c)
        for c in ("44054007", "195967002"):
            self.assertFalse(pa.verhoeff_valid(c), c)


class TestStore(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.d = fixture_dir()
        cls.st = build_store(cls.d)
        cls.csv = AthenaCsvStore(cls.d / "CONCEPT.csv")

    def test_same_answers_as_athena_csv_store(self):
        for voc, q in (("LOINC", "alpha rate"), ("LOINC", "Beta level"), ("LOINC", "rate"), ("LOINC", "rmssd"),
                       ("LOINC", "  ALPHA RATE  "), ("SNOMED", "zeta"), ("SNOMED", "delta"), ("LOINC", "")):
            self.assertEqual([key(c) for c in self.st.search(q, voc)], [key(c) for c in self.csv.search(q, voc)],
                             (voc, q))
        for voc, code in (("LOINC", "8867-4"), ("LOINC", "99990-1"), ("LOINC", "1-8"), ("SNOMED", "195967001")):
            a, b = self.st.get(voc, code), self.csv.get(voc, code)
            self.assertEqual(None if a is None else key(a), None if b is None else key(b), (voc, code))

    def test_capability_lists_indexed_vocabularies(self):
        self.assertEqual(self.st.capability.vocabularies, ("ICD10CM", "LOINC", "SNOMED"))
        self.assertFalse(self.st.capability.holds("RXNORM"))

    def test_icd10cm_rows(self):
        got = {(c, n) for c, n, _s, _i in pa.load_icd10cm_tabular(self.d / "tabular.xml")}
        self.assertEqual(got, {("E11", "Delta disorder"),
                               ("E11.2", "Delta disorder with organ complications"),
                               ("E11.21", "Delta disorder with delta organ disease"),
                               ("I10", "Epsilon disorder (primary)")})
        c = self.st.get("ICD10CM", "E11.21")
        self.assertTrue(c.active and c.standard and c.match is MatchStrength.EXACT)

    def test_router_paths(self):
        r = Router(stores=[self.st])
        d = r.route(RouteRequest(query="alpha rate", system_hint="LOINC"))
        self.assertEqual((d.route, d.path, d.candidates[0].code), (Route.R1_LOOKUP, RPath.A, "8867-4"))
        d = r.route(RouteRequest(query="beta level", system_hint="LOINC"))
        self.assertNotEqual(d.path, RPath.A)
        d = r.route(RouteRequest(query="99999-9", code="99999-9", system_hint="LOINC", task=TaskClass.VERIFY))
        self.assertEqual((d.route, d.outcome), (Route.R0_VERIFY, Outcome.ABSTAINED))
        self.assertTrue(d.abstention_reason.startswith("code-not-found"))
        d = r.route(RouteRequest(query="aspirin", system_hint="RxNorm"))
        self.assertEqual(d.route, Route.R7_ABSTAIN)
        self.assertTrue(d.abstention_reason.startswith("store-lacks-vocabulary"))
        d = r.route(RouteRequest(query="delta disorder", system_hint="ICD-10-CM"))
        self.assertEqual((d.path, d.candidates[0].code), (RPath.A, "E11"))

    def test_samplers(self):
        a = pa.sample_real(self.st, "LOINC", 3, pa.make_rng(20261119))
        b = pa.sample_real(self.st, "LOINC", 3, pa.make_rng(20261119))
        self.assertEqual(a, b)
        self.assertNotIn("99990-1", pa.sample_real(self.st, "LOINC", 6, pa.make_rng(1)))  # inactive is never drawn
        for voc, ok in (("LOINC", pa.loinc_valid), ("SNOMED", pa.verhoeff_valid), ("ICD10CM", pa.icd10cm_form)):
            inv = pa.invent_codes(self.st, voc, 25, pa.make_rng(20261119))
            self.assertEqual(len(set(inv)), 25)
            for c in inv:
                self.assertTrue(ok(c), (voc, c))
                self.assertIsNone(self.st.get(voc, c), (voc, c))
            self.assertEqual(inv, pa.invent_codes(self.st, voc, 25, pa.make_rng(20261119)))

    def test_trap_request(self):
        req = pa.request_for_case({"type": "trap", "q": "80405-4 alpha rate variability", "term": "LOINC"})
        self.assertEqual((req.task, req.code, req.display, req.system_hint),
                         (TaskClass.VERIFY, "80405-4", "alpha rate variability", "LOINC"))
        d = Router(stores=[self.st]).route(req)
        self.assertEqual(pa.score(d, None)[0], "recusa_certa")
        self.assertEqual(pa.request_for_case({"type": "cross_mapping", "q": "x", "term": "ICD-11"}).task, TaskClass.MAP)
        self.assertEqual(pa.request_for_case({"type": "lookup", "q": "zeta", "term": "SNOMED"}).task,
                         TaskClass.RETRIEVE)


class TestScoring(unittest.TestCase):
    def test_score_rules(self):
        st = build_store(fixture_dir())
        r = Router(stores=[st])
        d_ok = r.route(RouteRequest(query="alpha rate", system_hint="LOINC"))
        d_none = r.route(RouteRequest(query="rmssd", system_hint="LOINC"))
        self.assertEqual(pa.score(d_ok, "8867-4"), ("acerto", "8867-4"))
        self.assertEqual(pa.score(d_ok, "8889-8"), ("erro", "8867-4"))
        self.assertEqual(pa.score(d_ok, None), ("erro", "8867-4"))
        self.assertEqual(pa.score(d_none, "8867-4"), ("sem_resposta", None))
        self.assertEqual(pa.score(d_none, None), ("recusa_certa", None))
        self.assertEqual(pa.expected_of("no"), None)
        self.assertEqual(pa.expected_of("E11"), "E11")
        self.assertEqual(pa.expected_of("reasoning"), pa.NOT_A_CODE)
        self.assertEqual(pa.score(d_none, pa.NOT_A_CODE), ("sem_resposta", None))
        self.assertEqual(pa.score(d_ok, pa.NOT_A_CODE), ("erro", "8867-4"))

    def test_percentile_nearest_rank(self):
        xs = list(range(1, 21))
        self.assertEqual(pa.pct(xs, 0.50), 10)
        self.assertEqual(pa.pct(xs, 0.95), 19)
        self.assertEqual(pa.pct([7], 0.95), 7)


class TestCaseSets(unittest.TestCase):
    def test_g_mapping_to_the_42_terms(self):
        g = json.loads((ROOT / pa.G_FILE).read_text())["results"]
        ext = {c["id"]: c for c in pa.cases_42()}
        self.assertEqual(len(ext), 42)
        valid = [r for r in g if r["id"] not in pa.G_LENGTH_SCORED]
        self.assertEqual((len(valid), sum(bool(r["correct"]) for r in valid)), (33, 8))
        for r in valid:
            e = ext[pa.g_to_42(r["id"])]
            self.assertEqual((r["type"], r["terminology"]), (e["type"], e["term"]), r["id"])
            if r["id"] != "MED-ICD10-02":
                self.assertEqual(r["expected"], e["exp"], r["id"])
        self.assertEqual((pa.g_to_42("HARD-CROSS-01"), pa.g_to_42("HARD-CROSS-02")), ("H-CROSS-02", "H-CROSS-01"))

    def test_a1_is_the_17_database_path_cases(self):
        ids = pa.a1_ids()
        self.assertEqual(len(ids), 17)
        self.assertTrue(set(pa.a1_ids(pa.J_FILE)) <= set(ids))
        self.assertEqual(len(pa.a1_ids(pa.J_FILE)), 8)


if __name__ == "__main__":
    unittest.main(verbosity=1)
