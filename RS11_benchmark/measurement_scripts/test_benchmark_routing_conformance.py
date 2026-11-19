#!/usr/bin/env python3
"""Tests for benchmark_routing_conformance.py (19 Nov 2026), written before the script.

Run: python3 -I scripts/test_benchmark_routing_conformance.py
The protocol is in protocol_routing_two_arms.md, section 2 (arm 1).
"""
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "services" / "terminology-router" / "src"))
sys.path.insert(0, str(HERE))

import benchmark_routing_conformance as rc  # noqa: E402
import test_benchmark_path_a_isolated as tpa  # noqa: E402  (the fixture store)
from terminology_router.models import Outcome, Path as RPath, Route, RouteDecision, TaskClass  # noqa: E402
from terminology_router.router import Router  # noqa: E402


def q(**kw):
    base = dict(id="X", text="t", system=None, codes=[], display=None, term=None, target_system=None, task=None,
                category="f", expected_route="R7", borderline=False, reason="")
    base.update(kw)
    return base


def dec(route, path, outcome=Outcome.RESOLVED, why=None):
    return RouteDecision(route=route, path=path, outcome=outcome, reason="", abstention_reason=why)


class TestRequests(unittest.TestCase):
    def test_fields(self):
        r = rc.to_request(q(task=None, term="alpha rate", system="LOINC"))
        self.assertEqual((r.task, r.query, r.system_hint, r.code), (TaskClass.RETRIEVE, "alpha rate", "LOINC", None))
        r = rc.to_request(q(task="verify", codes=["8867-4"], system="LOINC", display="Alpha rate"))
        self.assertEqual((r.task, r.query, r.code, r.display), (TaskClass.VERIFY, "8867-4", "8867-4", "Alpha rate"))
        r = rc.to_request(q(task="hierarchy", codes=["11", "22"], system="SNOMED", text="is 11 a 22?"))
        self.assertEqual((r.task, r.query, r.code), (TaskClass.HIERARCHY, "11", "11"))
        r = rc.to_request(q(task="map", codes=["E11"], system="ICD10", target_system="SNOMED"))
        self.assertEqual((r.task, r.code, r.target_system), (TaskClass.MAP, "E11", "SNOMED"))
        r = rc.to_request(q(task="interpret", text="what does it mean?"))
        self.assertEqual((r.task, r.query, r.system_hint), (TaskClass.INTERPRET, "what does it mean?", None))
        self.assertEqual(rc.to_request(q(system="Apple HealthKit", term="x")).system_hint, "Apple HealthKit")

    def test_set_hash(self):
        self.assertTrue(rc.set_sha256_ok())


class TestLabels(unittest.TestCase):
    def test_observed(self):
        self.assertEqual(rc.observed_label(dec(Route.R2_EXPAND, RPath.A)), "R2→R1")
        self.assertEqual(rc.observed_label(dec(Route.R2_EXPAND, RPath.C)), "R2→R3")
        self.assertEqual(rc.observed_label(dec(Route.R7_ABSTAIN, RPath.ABSTAIN, Outcome.ABSTAINED, "no-candidate: x")),
                         "R2→R7")
        self.assertEqual(rc.observed_label(dec(Route.R7_ABSTAIN, RPath.ABSTAIN, Outcome.ABSTAINED,
                                               "store-lacks-vocabulary: x")), "R7")
        self.assertEqual(rc.observed_label(dec(Route.R_PRE_CLASSIFY, RPath.ABSTAIN, Outcome.ABSTAINED, "p")), "R-pre")
        self.assertEqual(rc.observed_label(dec(Route.R0_VERIFY, RPath.ABSTAIN, Outcome.ABSTAINED, "code-not-found")),
                         "R0")

    def test_conforms_and_outcome(self):
        self.assertTrue(rc.conforms("R7", "R2→R7"))
        self.assertTrue(rc.conforms("R7", "R7"))
        self.assertFalse(rc.conforms("R2→R7", "R7"))
        self.assertTrue(rc.conforms("R1", "R1"))
        self.assertFalse(rc.conforms("R1", "R3"))
        self.assertIsNone(rc.expected_outcome("R0"))
        self.assertEqual(rc.expected_outcome("R-pre"), "abstained")
        self.assertEqual(rc.expected_outcome("R2→R7"), "abstained")
        self.assertEqual(rc.expected_outcome("R2→R3"), "resolved")

    def test_on_fixture_store(self):
        r = Router(stores=[tpa.build_store(tpa.fixture_dir())])
        self.assertEqual(rc.observed_label(r.route(rc.to_request(q(task="verify", codes=["8867-4"], system="LOINC")))),
                         "R0")
        self.assertEqual(rc.observed_label(r.route(rc.to_request(q(term="rmssd", system="LOINC")))), "R2→R7")
        self.assertEqual(rc.observed_label(r.route(rc.to_request(q(term="alpha rate", system="LOINC")))), "R1")
        self.assertEqual(rc.observed_label(r.route(rc.to_request(q(term="x", system="OMOP concept_id")))), "R-pre")


if __name__ == "__main__":
    unittest.main(verbosity=1)
