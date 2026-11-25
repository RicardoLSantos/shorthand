#!/usr/bin/env python3
"""Tests for benchmark_routing_arm2_path_c.py (19 Nov 2026), written before the script.

Run: python3 -I scripts/test_benchmark_routing_arm2_path_c.py
The protocol is in protocol_routing_arm2_path_c.md, section 3. No network: the model is a
fake client, and the store is the fixture of test_benchmark_path_a_isolated.py.
"""
import json
import sys
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "services" / "terminology-router" / "src"))
sys.path.insert(0, str(HERE))

import benchmark_path_a_isolated as pa  # noqa: E402
import benchmark_routing_arm2_path_c as m  # noqa: E402
import test_benchmark_path_a_isolated as tpa  # noqa: E402  (the fixture store)
from terminology_router.models import Route, RouteRequest, TaskClass  # noqa: E402
from terminology_router.router import Router  # noqa: E402


def req_json(task="retrieve", query="Glucose", system_hint="LOINC", code=None, display=None, target_system=None):
    return json.dumps(dict(task=task, query=query, system_hint=system_hint, code=code, display=display,
                           target_system=target_system))


class FakeClient:
    """Answers by the user message: requests from `requests`, choices from `choices` (keyed by the question)."""

    def __init__(self, requests, choices=None, fail=()):
        self.requests, self.choices, self.fail, self.calls = requests, choices or {}, set(fail), []

    def chat(self, system, user, schema):
        self.calls.append((system, user, schema))
        if user in self.fail:
            return "", 1000, "URLError: refused", {}
        if system == m.CHOICE_PROMPT:
            question = user.split("\n", 1)[0][len("Message: "):]
            return self.choices.get(question, '{"code": null}'), 2000, None, {"eval_count": 5}
        return self.requests[user], 3000, None, {"eval_count": 40}


def tq(**kw):
    base = dict(id="X", text="t", system=None, codes=[], display=None, term=None, target_system=None, task=None,
                category="f", expected_route="R7", borderline=False, reason="")
    base.update(kw)
    return base


class TestPrompts(unittest.TestCase):
    def test_request_prompt_quotes_the_spec(self):
        p = m.REQUEST_PROMPT
        for s in ("Free text, or a code when task=verify.", "LOINC | SNOMED | ICD10 | ... | null",
                  "Intended meaning. Required for semantics-verified (INV-2).",
                  "the service should abstain (no task class fits)",
                  "| free text | known | retrieve | >1 | **R3** model disambiguates the database set (path C) |"):
            self.assertIn(s, p)
        readme = (ROOT / "services/terminology-router/README.md").read_text()
        rows = [ln for ln in p.splitlines() if ln.startswith("| ") and ln.count("|") == 6]
        self.assertEqual(len(rows), 10)  # the header and the nine routes
        for ln in rows:
            self.assertIn(ln, readme)
        openapi = (ROOT / "services/terminology-router/openapi.yaml").read_text()
        for s in ("Free text, or a code when task=verify.", "LOINC | SNOMED | ICD10 | ... | null",
                  "Intended meaning. Required for semantics-verified (INV-2)."):
            self.assertIn(s, openapi)

    def test_schemas(self):
        self.assertEqual(m.REQUEST_SCHEMA["properties"]["task"]["enum"],
                         ["verify", "retrieve", "map", "hierarchy", "interpret", "out_of_scope"])
        self.assertEqual(sorted(m.REQUEST_SCHEMA["required"]),
                         sorted(["task", "query", "system_hint", "code", "display", "target_system"]))
        self.assertEqual(m.CHOICE_SCHEMA["required"], ["code"])


class TestParse(unittest.TestCase):
    def test_request(self):
        f, err = m.parse_request(req_json(display=""))
        self.assertIsNone(err)
        self.assertEqual((f["task"], f["query"], f["system_hint"], f["display"]), ("retrieve", "Glucose", "LOINC", None))
        self.assertEqual(m.parse_request("not json")[1], "json-invalido")
        self.assertEqual(m.parse_request(req_json(task="lookup"))[1], "tarefa-invalida")
        self.assertEqual(m.parse_request('{"task": "verify", "query": 5}')[1], "campo-invalido")
        self.assertEqual(m.parse_request("[1, 2]")[1], "tarefa-invalida")

    def test_choice(self):
        self.assertEqual(m.parse_choice('{"code": "2345-7"}'), ("2345-7", None))
        self.assertEqual(m.parse_choice('{"code": null}'), (None, None))
        self.assertEqual(m.parse_choice('{"code": "  "}'), (None, None))
        self.assertEqual(m.parse_choice("oops"), (None, "escolha-invalida"))

    def test_model_request(self):
        f, _ = m.parse_request(req_json(task="out_of_scope"))
        self.assertIsNone(m.model_request(f))
        f, _ = m.parse_request(req_json(task="verify", query="8867-4", code="8867-4", display="Heart rate"))
        r = m.model_request(f)
        self.assertEqual((r.task, r.query, r.code, r.display), (TaskClass.VERIFY, "8867-4", "8867-4", "Heart rate"))

    def test_labeller_request_with_task(self):
        q = tq(term="heart rate", system="LOINC", task="retrieve")
        r = m.labeller_request_with_task(q, "interpret")
        self.assertEqual((r.task, r.query, r.system_hint), (TaskClass.INTERPRET, "heart rate", "LOINC"))
        self.assertIsNone(m.labeller_request_with_task(q, "out_of_scope"))

    def test_code_not_in_text(self):
        self.assertTrue(m.code_not_in_text({"code": "8867-4"}, "What is the LOINC code for heart rate?"))
        self.assertFalse(m.code_not_in_text({"code": "80405-4"}, "Is LOINC code 80405-4 for HRV?"))
        self.assertFalse(m.code_not_in_text({"code": None}, "x"))


class TestClient(unittest.TestCase):
    def test_loopback_only(self):
        with self.assertRaises(ValueError):
            m.OllamaClient(base="http://example.org:11434")
        c = m.OllamaClient()
        b = c.chat_body("S", "U", m.CHOICE_SCHEMA)
        self.assertEqual(b["messages"], [{"role": "system", "content": "S"}, {"role": "user", "content": "U"}])
        self.assertEqual((b["model"], b["think"], b["stream"], b["keep_alive"], b["format"]),
                         ("qwen3.5:4b", False, False, "60s", m.CHOICE_SCHEMA))
        self.assertEqual(b["options"], {"temperature": 0, "seed": 20261119, "num_ctx": 4096, "num_predict": 256})

    def test_disk_guard(self):
        self.assertIsNone(m.disk_guard(lambda: 4 * 2**30))
        self.assertIn("3 GiB", m.disk_guard(lambda: 2 * 2**30))


class TestGSentences(unittest.TestCase):
    def test_sentences(self):
        s = m.g_sentences()
        self.assertEqual(len(s), 36)
        g = [r for r in json.loads((ROOT / pa.G_FILE).read_text())["results"] if r["id"] not in pa.G_LENGTH_SCORED]
        self.assertEqual(len(g), 33)
        for r in g:
            self.assertEqual(s[r["id"]]["exp"], r["expected"], r["id"])
        self.assertTrue(s["MED-TRAP-01"]["q"].startswith("Is LOINC code 80405-4 for heart rate variability?"))


class TestEndToEnd(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.store = tpa.build_store(tpa.fixture_dir())
        cls.router = Router(stores=[cls.store])

    def route(self, **kw):
        return self.router.route(RouteRequest(**kw))

    def test_answer(self):
        d = self.route(query="Heart rate", system_hint="LOINC")
        self.assertEqual(m.end_to_end(self.router, d, None), ("8867-4", "caminho-A"))
        d = self.route(query="Glucose", system_hint="LOINC")
        self.assertIs(d.route, Route.R3_DISAMBIGUATE)
        self.assertEqual(m.end_to_end(self.router, d, "2345-7"), ("2345-7", "escolha"))
        self.assertEqual(m.end_to_end(self.router, d, "9999-9"), (None, "fora-dos-candidatos"))
        self.assertEqual(m.end_to_end(self.router, d, None), (None, "escolha-nula"))
        self.assertEqual(m.end_to_end(self.router, None, None), (None, "sem-pedido"))
        d = self.route(query="aspirin", system_hint="RxNorm")
        self.assertEqual(m.end_to_end(self.router, d, None), (None, "sem-resposta-da-rota"))

    def test_verdict(self):
        self.assertEqual(m.verdict_of("8867-4", "8867-4"), "acerto")
        self.assertEqual(m.verdict_of("8889-8", "8867-4"), "erro")
        self.assertEqual(m.verdict_of(None, "8867-4"), "sem_resposta")
        self.assertEqual(m.verdict_of(None, None), "recusa_certa")
        self.assertEqual(m.verdict_of("8867-4", None), "erro")
        self.assertEqual(m.verdict_of(None, pa.NOT_A_CODE), "sem_resposta")
        self.assertEqual(m.verdict_of("E11", pa.NOT_A_CODE), "erro")

    def test_failure_step(self):
        ref = RouteRequest(query="Glucose", system_hint="LOINC", task=TaskClass.RETRIEVE)
        d = self.route(query="Glucose", system_hint="LOINC")
        f = m.parse_request(req_json())[0]
        self.assertIsNone(m.failure_step("acerto", f, ref, "sem_resposta", d, "2345-7"))
        self.assertEqual(m.failure_step("sem_resposta", None, ref, "sem_resposta", None, "2345-7"), "pedido")
        oos = m.parse_request(req_json(task="out_of_scope"))[0]
        self.assertEqual(m.failure_step("sem_resposta", oos, ref, "sem_resposta", None, "2345-7"), "pedido")
        other = m.parse_request(req_json(system_hint="SNOMED"))[0]
        self.assertEqual(m.failure_step("sem_resposta", other, ref, "sem_resposta", d, "2345-7"), "pedido")
        self.assertEqual(m.failure_step("erro", f, ref, "acerto", d, "2345-7"), "pedido")
        self.assertEqual(m.failure_step("erro", f, ref, "sem_resposta", d, "2345-7"), "escolha")
        self.assertEqual(m.failure_step("erro", f, ref, "sem_resposta", d, None), "escolha")
        self.assertEqual(m.failure_step("erro", f, ref, "sem_resposta", d, "1558-6"), "rota")
        d7 = self.route(query="Glucose in sweat", system_hint="LOINC")
        self.assertEqual(m.failure_step("sem_resposta", f, ref, "sem_resposta", d7, "2345-7"), "rota")

    def test_g_rule(self):
        self.assertEqual(m.g_rule("E11.9", "E11"), "acerto")
        self.assertEqual(m.g_rule("E11", "E11"), "acerto")
        self.assertIsNone(m.g_rule(None, "E11"))
        self.assertIsNone(m.g_rule("E11", None))

    def test_path_c_case(self):
        q = "What is the LOINC code for glucose in serum or plasma?"
        fake = FakeClient({q: req_json()}, {q: '{"code": "2345-7"}'})
        ref = RouteRequest(query="Glucose", system_hint="LOINC", task=TaskClass.RETRIEVE)
        row = m.path_c_case(fake, self.router, "EASY-LOINC-04", q, "2345-7", ref, "sem_resposta", lambda: None)
        self.assertEqual((row["route"], row["answer"], row["how"], row["verdict"], row["step"]),
                         ("R3", "2345-7", "escolha", "acerto", None))
        self.assertEqual(row["candidates"], ["LOINC 2339-0", "LOINC 2345-7"])
        self.assertEqual(len(fake.calls), 2)
        self.assertIn("2345-7 Glucose [Mass/volume] in Serum or Plasma [non-standard]", fake.calls[1][1])
        self.assertNotIn("Glucose", json.dumps({k: v for k, v in row.items() if k not in ("request", "raw")}))
        fake = FakeClient({q: req_json()}, {q: '{"code": "1558-6"}'})
        row = m.path_c_case(fake, self.router, "EASY-LOINC-04", q, "2345-7", ref, "sem_resposta", lambda: None)
        self.assertEqual((row["answer"], row["how"], row["verdict"], row["step"], row["choice"]),
                         (None, "fora-dos-candidatos", "sem_resposta", "escolha", "1558-6"))
        fake = FakeClient({q: req_json()}, fail={q})
        row = m.path_c_case(fake, self.router, "EASY-LOINC-04", q, "2345-7", ref, "sem_resposta", lambda: None)
        self.assertEqual((row["request_error"], row["verdict"], row["step"]), ("chamada-falhou", "sem_resposta", "pedido"))

    def test_router_exception_is_recorded(self):
        class Boom:
            def route(self, req):
                raise RuntimeError("defect")

        self.assertEqual(m.safe_route(Boom(), None), (None, "RuntimeError: defect"))
        q = "What is the LOINC code for glucose in serum or plasma?"
        fake = FakeClient({q: req_json()})
        ref = RouteRequest(query="Glucose", system_hint="LOINC", task=TaskClass.RETRIEVE)
        row = m.path_c_case(fake, Boom(), "EASY-LOINC-04", q, "no", ref, "recusa_certa", lambda: None)
        self.assertEqual((row["route"], row["verdict"], row["step"], row["how"]),
                         ("erro-do-router", "erro-do-router", "rota", "erro-do-router"))
        tqq = tq(id="Q09", text=q)
        row = m.arm2_question(FakeClient({q: req_json()}), Boom(), tqq, lambda: None)
        self.assertEqual((row["model"]["label"], row["model"]["conforms"], row["model"]["outcome_agree"]),
                         ("erro-do-router", False, False))

    def test_guard_stops(self):
        q = "What is the LOINC code for heart rate?"
        fake = FakeClient({q: req_json(query="Heart rate")})
        with self.assertRaises(m.Stop):
            m.path_c_case(fake, self.router, "EASY-LOINC-01", q, "8867-4", None, None, lambda: "disco abaixo de 3 GiB")
        self.assertEqual(fake.calls, [])

    def test_arm2_question(self):
        q = tq(id="Q04", text="Is 8867-4 the LOINC code for heart rate?", codes=["8867-4"], system="LOINC",
               display="heart rate", task="verify", category="a", expected_route="R0")
        fake = FakeClient({q["text"]: req_json(task="verify", query="8867-4", code="8867-4", display="heart rate")})
        row = m.arm2_question(fake, self.router, q, lambda: None)
        self.assertEqual((row["gold_task"], row["declared_task"], row["task_ok"]), ("verify", "verify", True))
        self.assertEqual((row["model"]["label"], row["model"]["conforms"]), ("R0", True))
        self.assertEqual((row["labeller_fields"]["label"], row["labeller_request"]["label"]), ("R0", "R0"))
        self.assertEqual((row["system_ok"], row["code_ok"], row["code_not_in_text"]), (True, True, False))
        q = tq(id="Q09", text="Invent a LOINC code for pNN50 so we can store it.")
        fake = FakeClient({q["text"]: req_json(task="out_of_scope", query="pNN50")})
        row = m.arm2_question(fake, self.router, q, lambda: None)
        self.assertEqual((row["gold_task"], row["task_ok"]), ("out_of_scope", True))
        self.assertEqual((row["model"]["label"], row["model"]["conforms"], row["model"]["outcome"]),
                         ("chamador-recusa", False, "abstained"))
        self.assertTrue(row["model"]["outcome_agree"])
        fake = FakeClient({q["text"]: "nope"})
        row = m.arm2_question(fake, self.router, q, lambda: None)
        self.assertEqual((row["declared_task"], row["task_ok"], row["model"]["label"], row["model"]["outcome_agree"]),
                         (None, False, "pedido-invalido", False))


if __name__ == "__main__":
    unittest.main(verbosity=1)
