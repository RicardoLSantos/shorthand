"""Tests for the FSH extractor of terminology_ledger_check.py.

Run from the repository root:  python3 -m unittest discover -s .github/scripts/tests -v

The extractor reads one FSH line at a time. FSH also allows indented rules, whose path is
the path of the nearest less-indented rule followed by their own, so a code can be assigned
on a line that carries no path at all:

    * group[0].element[0]
      * target[0]
        * code = #73595000

These tests pin that form (and the flat forms it must not disturb) to the ledger.
"""
import importlib.util
import tempfile
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
SCRIPT = HERE.parent / "terminology_ledger_check.py"
_spec = importlib.util.spec_from_file_location("terminology_ledger_check", SCRIPT)
tlc = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(tlc)

FIXTURE = """\
Instance: IndentedMap
InstanceOf: ConceptMap
Usage: #definition
* group[0].source = "https://example.org/CodeSystem/local"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0]
  * code = #localA
  * target[0]
    * code = #73595000
    * display = "Stress"
    * equivalence = #relatedto
* group[0].element[1].code = #localB
* group[0].element[1].target[0].code = #401175000
* group[0].element[1].target[0].display = "Sleep pattern"

Profile: IndentedQuantity
Parent: Observation
* component[duration]
  * value[x] only Quantity
  * valueQuantity
    * value 1..1
    * system = "http://unitsofmeasure.org"
    * code = #min
* valueQuantity.system = $UCUM
* valueQuantity.code = #h

Instance: IndentedSoftIndex
InstanceOf: Observation
* component[+]
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #kg
* component[+]
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #cm

Instance: FlatSoftIndex
InstanceOf: Observation
* component[+].valueQuantity.system = $UCUM
* component[=].valueQuantity.code = #mm[Hg]
* extension[+].url = "https://example.org/ext"
* extension[=].valueQuantity = 85 '%' "percent"

Profile: CaretUnderContext
Parent: Observation
* valueQuantity
  * ^minValueQuantity = 0 'kPa'
* extension[foo]
  * ^extension[0].valueCoding.system = $SCT
  * ^extension[0].valueCoding.code = #224974006

Instance: MeasureGroupContext
InstanceOf: Measure
* group[0]
  * code.coding[0].system = $LOINC
  * code.coding[0].code = #8867-4
  * code.coding[0].display = "Heart rate"

Instance: SoftGroupMap
InstanceOf: ConceptMap
Usage: #definition
* group[+]
  * source = "https://example.org/CodeSystem/local"
  * target = "http://snomed.info/sct"
* group[+]
  * source = "https://example.org/CodeSystem/local"
  * target = "http://loinc.org"
* group[0].element[0].code = #localE
* group[0].element[0].target[0].code = #106126000
* group[1].element[0].code = #localF
* group[1].element[0].target[0].code = #8310-5
"""

FIXTURE_FILE = "input/fsh/fixture.fsh"


class IndentedRulesFixture(unittest.TestCase):
    """A synthetic FSH file with each form next to its flat control."""

    @classmethod
    def setUpClass(cls):
        cls._tmp = tempfile.TemporaryDirectory()
        root = Path(cls._tmp.name)
        (root / "input" / "fsh").mkdir(parents=True)
        (root / FIXTURE_FILE).write_text(FIXTURE, encoding="utf-8")
        cls._repo = tlc.REPO
        tlc.REPO = root            # add() records paths relative to REPO
        try:
            cls.found = tlc.extract_codes(root / "input" / "fsh")
        finally:
            tlc.REPO = cls._repo

    @classmethod
    def tearDownClass(cls):
        cls._tmp.cleanup()

    def assertFound(self, system, code, display=None):
        self.assertIn((system, code), self.found, f"{system}#{code} not extracted")
        rec = self.found[(system, code)]
        self.assertIn(FIXTURE_FILE, rec["files"])
        if display is not None:
            self.assertIn(display, rec["displays"])

    # indented forms (the ones the extractor could not read)
    def test_conceptmap_target_in_indented_rules(self):
        self.assertFound("SNOMED", "73595000", "Stress")

    def test_quantity_code_in_indented_rules_without_prefix(self):
        self.assertFound("UCUM", "min")

    # flat controls (already read; must stay read)
    def test_conceptmap_target_flat_control(self):
        self.assertFound("SNOMED", "401175000", "Sleep pattern")

    def test_split_form_flat_control(self):
        self.assertFound("UCUM", "h")

    # a [+] context is resolved once, by the context rule: both siblings keep their own pair
    def test_soft_index_context_keeps_both_pairs(self):
        self.assertFound("UCUM", "kg")
        self.assertFound("UCUM", "cm")

    # a path that carries ``[=]`` (flat soft indexing) is still a path
    def test_split_form_with_soft_index_in_the_path(self):
        self.assertFound("UCUM", "mm[Hg]")

    def test_quantity_shorthand_with_soft_index_in_the_path(self):
        self.assertFound("UCUM", "%")

    # rules with no path of their own under an indented context keep their caret path
    def test_caret_quantity_under_a_context(self):
        self.assertFound("UCUM", "kPa")

    def test_caret_split_form_under_a_context(self):
        self.assertFound("SNOMED", "224974006")

    # a Measure group is not a ConceptMap group: its codes are read like any other path
    def test_split_form_under_a_measure_group(self):
        self.assertFound("LOINC", "8867-4", "Heart rate")

    # ConceptMap groups opened with [+] number from 0, like SUSHI, so explicit indices agree
    def test_soft_indexed_conceptmap_groups_keep_their_systems(self):
        self.assertFound("SNOMED", "106126000")
        self.assertFound("LOINC", "8310-5")
        self.assertNotIn(("LOINC", "106126000"), self.found)
        self.assertNotIn(("SNOMED", "8310-5"), self.found)

    def test_local_codesystem_codes_are_not_emitted(self):
        self.assertNotIn(("SNOMED", "localA"), self.found)
        self.assertNotIn(("SNOMED", "localB"), self.found)


class IndentedRulesInThisIG(unittest.TestCase):
    """Positive control on the IG itself: the five indented lines found on 2026-09-23."""

    MAP = "input/fsh/mappings/MindfulnessDiagnosticMappings.fsh"
    PROFILE = "input/fsh/profiles/observations/activity/MindfulnessProfiles.fsh"

    @classmethod
    def setUpClass(cls):
        cls.found = tlc.extract_codes(tlc.FSH_ROOT)

    def test_four_snomed_targets_of_the_mindfulness_map(self):
        codes = sorted(c for (s, c), rec in self.found.items() if s == "SNOMED" and self.MAP in rec["files"])
        self.assertEqual(len(codes), 4, f"SNOMED codes read from {self.MAP}: {codes}")

    def test_ucum_min_of_the_session_duration_component(self):
        self.assertIn(("UCUM", "min"), self.found)
        self.assertIn(self.PROFILE, self.found[("UCUM", "min")]["files"])


if __name__ == "__main__":
    unittest.main()
