#!/usr/bin/env python3
"""Routing arm 2 and path C end to end, with the local model.

19 Nov 2026. Protocol: protocol_routing_arm2_path_c.md, section 3, committed with this
script and its test before the run. The caller is the benchmark's local model, qwen3.5:4b, reached through Ollama on
the loopback address only (no proxy, no pull, no other host).
- Arm 2: the model declares the request (task and RouteRequest fields) for each of the labeller's 73 questions, and the router
  (services/terminology-router, unchanged) routes it over arm 1's stores.
- Path C: the model declares the request for each of the 33 validly scored G sentences, the router decides over path
  A's store, and at R3 the model chooses one of the base's candidates or none. A choice counts only if it is one of the
  candidates and the base confirms it as active.

Usage: python3 -I scripts/benchmark_routing_arm2_path_c.py
Output: results/llm_benchmarks/benchmark_routing_arm2_path_c_<YYYYMMDD_HHMMSS>.json (opened with 'x'), plus a summary.
"""
import ast
import dataclasses
import gc
import hashlib
import json
import platform
import shutil
import sqlite3
import sys
import time
import urllib.error
import urllib.request
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "services" / "terminology-router" / "src"))
sys.path.insert(0, str(HERE))

import benchmark_path_a_isolated as pa  # noqa: E402
import benchmark_routing_conformance as rc  # noqa: E402
from terminology_router.models import Outcome, Path as RPath, Route, RouteRequest, TaskClass  # noqa: E402
from terminology_router.router import Router, normalise_system  # noqa: E402

MODEL = "qwen3.5:4b"
OLLAMA = "http://127.0.0.1:11434"
SEED = 20261119
OPTIONS = {"temperature": 0, "seed": SEED, "num_ctx": 4096, "num_predict": 256}
KEEP_ALIVE = "60s"
TIMEOUT_S = 300
GIB = 2 ** 30
MIN_FREE_START = 5 * GIB
MIN_FREE_RUN = 3 * GIB
HOME = Path.home()
MANIFEST = HOME / ".ollama" / "models" / "manifests" / "registry.ollama.ai" / "library" / "qwen3.5" / "4b"
BLOBS = HOME / ".ollama" / "models" / "blobs"
G_SCRIPT = "scripts/benchmark_3level_terminology.py"
PATH_A_RESULT = "results/llm_benchmarks/benchmark_path_a_isolated_20261119_083250.json"
ARM1_RESULT = "results/llm_benchmarks/benchmark_routing_conformance_20261119_084237.json"
OUT_OF_SCOPE = "out_of_scope"
TASKS = ["verify", "retrieve", "map", "hierarchy", "interpret", OUT_OF_SCOPE]
FIELDS = ("task", "query", "system_hint", "code", "display", "target_system")
OPTIONAL = FIELDS[2:]

# -- the two fixed texts (protocol section 3) -------------------------------------------------------------------
# The decision table is the README's, verbatim; the field lines for query, system_hint and display are the
# openapi.yaml descriptions, verbatim; out_of_scope uses the labeller's definition of category (f), verbatim.

REQUEST_PROMPT = """You are the caller of a terminology service. Turn the user's message into one request to the \
service, as a JSON object with the fields task, query, system_hint, code, display and target_system.

The service's decision table:
| Query | System | Task | Candidates | Route |
|---|---|---|:--:|---|
| code | any | verify | — | **R0** `$validate-code` **with display** + local confirm |
| free text | known | retrieve | 1 exact | **R1** deterministic lookup (path A) |
| free text | known | retrieve | 0 | **R2** synonym expansion, then retry; still 0 → R7 |
| free text | known | retrieve | >1 | **R3** model disambiguates the database set (path C) |
| free text | **unknown** | retrieve | — | **R-pre** classify the vocabulary first |
| code pair | any | hierarchy | — | **R4** `$subsumes` / graph retrieval |
| code | cross-system | map | — | **R5** `$translate` + map-content provenance check |
| free text | — | interpret | — | **R6** model + RAG, **code emission forbidden** |
| any | any | any | 0 after R2 | **R7 abstain**, with the evidence trail |

The fields:
- task: verify, retrieve, map, hierarchy, interpret or out_of_scope. Use out_of_scope when the service should \
abstain (no task class fits).
- query: Free text, or a code when task=verify.
- system_hint: LOINC | SNOMED | ICD10 | ... | null
- code: the code the message gives, or null.
- display: Intended meaning. Required for semantics-verified (INV-2).
- target_system: for map, the system to map to; otherwise null.

Use only what the message states. Copy codes and names as they are written, and never add a code that is not in \
the message."""

CHOICE_PROMPT = """A terminology database returned the codes listed after the user's message. Choose the one code \
whose meaning is the concept the message asks for. If none of the listed codes is that concept, or the message \
expects no code, answer null. Answer with a JSON object {"code": ...}, and never give a code that is not in the list."""

NULLABLE = {"anyOf": [{"type": "string"}, {"type": "null"}]}
REQUEST_SCHEMA = {"type": "object",
                  "properties": {"task": {"type": "string", "enum": TASKS}, "query": {"type": "string"},
                                 "system_hint": NULLABLE, "code": NULLABLE, "display": NULLABLE,
                                 "target_system": NULLABLE},
                  "required": list(FIELDS)}
CHOICE_SCHEMA = {"type": "object", "properties": {"code": NULLABLE}, "required": ["code"]}


class Stop(Exception):
    """The disk guard fired: stop, keep what has run."""


# -- the model client: loopback only ----------------------------------------------------------------------------

class OllamaClient:
    def __init__(self, base=OLLAMA, model=MODEL):
        if not base.startswith("http://127.0.0.1:"):
            raise ValueError(f"só o endereço de loopback: {base}")
        self.base, self.model = base, model
        self.opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))

    def _call(self, path, body=None, timeout=TIMEOUT_S):
        data = None if body is None else json.dumps(body).encode()
        req = urllib.request.Request(self.base + path, data=data, headers={"Content-Type": "application/json"})
        with self.opener.open(req, timeout=timeout) as r:
            return json.loads(r.read())

    def version(self):
        return self._call("/api/version", timeout=30).get("version")

    def chat_body(self, system, user, schema):
        return {"model": self.model,
                "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}],
                "stream": False, "think": False, "format": schema, "options": dict(OPTIONS), "keep_alive": KEEP_ALIVE}

    def chat(self, system, user, schema):
        t0 = time.perf_counter_ns()
        try:
            r = self._call("/api/chat", self.chat_body(system, user, schema))
            content, err = (r.get("message") or {}).get("content", ""), None
        except (urllib.error.URLError, OSError, ValueError) as e:
            r, content, err = {}, "", f"{type(e).__name__}: {e}"
        ns = time.perf_counter_ns() - t0
        meta = {k: r.get(k) for k in ("done_reason", "eval_count", "prompt_eval_count", "total_duration",
                                      "load_duration")}
        return content, ns, err, meta

    def unload(self):
        return self._call("/api/generate", {"model": self.model, "keep_alive": 0}, timeout=60).get("done_reason")


def disk_guard(free=lambda: shutil.disk_usage(HOME).free):
    f = free()
    return None if f >= MIN_FREE_RUN else f"disco abaixo de 3 GiB ({f} bytes livres)"


# -- reading the model's answers --------------------------------------------------------------------------------

def parse_request(content):
    try:
        obj = json.loads(content)
    except ValueError:
        return None, "json-invalido"
    if not isinstance(obj, dict) or obj.get("task") not in TASKS:
        return None, "tarefa-invalida"
    f = {k: obj.get(k) for k in FIELDS}
    if any(f[k] is not None and not isinstance(f[k], str) for k in FIELDS[1:]):
        return None, "campo-invalido"
    for k in OPTIONAL:
        if f[k] is not None and not f[k].strip():
            f[k] = None
    f["query"] = f["query"] or ""
    return f, None


def parse_choice(content):
    try:
        obj = json.loads(content)
    except ValueError:
        return None, "escolha-invalida"
    if not isinstance(obj, dict) or (obj.get("code") is not None and not isinstance(obj.get("code"), str)):
        return None, "escolha-invalida"
    c = obj.get("code")
    return (c.strip() or None) if c else None, None


def model_request(f):
    if f["task"] == OUT_OF_SCOPE:
        return None
    return RouteRequest(query=f["query"], system_hint=f["system_hint"], display=f["display"],
                        task=TaskClass(f["task"]), code=f["code"], target_system=f["target_system"])


def labeller_request_with_task(q, task):
    """The measure section 2 committed: the model's task with the labeller's other fields."""
    if task == OUT_OF_SCOPE:
        return None
    return dataclasses.replace(rc.to_request(q), task=TaskClass(task))


def code_not_in_text(f, text):
    return bool(f and f.get("code") and f["code"] not in text)


def g_sentences():
    """id -> case (q, exp, term, type) from the G script, read from its source without importing it."""
    out = {}
    for node in ast.parse((ROOT / G_SCRIPT).read_text()).body:
        if isinstance(node, ast.Assign) and isinstance(node.value, ast.List):
            try:
                items = ast.literal_eval(node.value)
            except (ValueError, TypeError, SyntaxError):
                continue
            for c in items:
                if isinstance(c, dict) and "id" in c and "q" in c:
                    out[c["id"]] = c
    return out


# -- path C: the system's answer, its score and where a failure is born -----------------------------------------

def choice_message(question, candidates):
    lines = [f"Message: {question}", "", "Codes returned by the database:"]
    for i, c in enumerate(candidates, 1):
        lines.append(f"{i}. {c.system} {c.code} {c.display}" + ("" if c.standard else " [non-standard]"))
    return "\n".join(lines)


def end_to_end(router, d, choice):
    if d is None:
        return None, "sem-pedido"
    if d.path is RPath.A and d.outcome is Outcome.RESOLVED:
        return (d.candidates[0].code if d.candidates else None), "caminho-A"
    if d.route is Route.R3_DISAMBIGUATE:
        if choice is None:
            return None, "escolha-nula"
        cand = {c.code: c for c in d.candidates}
        if choice not in cand:
            return None, "fora-dos-candidatos"
        c = cand[choice]
        for s in router.stores_holding(c.system):
            g = s.get(c.system, c.code)
            if g is not None and g.active:
                return choice, "escolha"
        return None, "nao-revalidado"
    return None, "sem-resposta-da-rota"


def verdict_of(answer, expected):
    """Section 1's rule for A2 (the G rule with the exact code), as pa.score but on the system's answer."""
    if expected is None:
        return "erro" if answer else "recusa_certa"
    if expected == pa.NOT_A_CODE:
        return "erro" if answer else "sem_resposta"
    if not answer:
        return "sem_resposta"
    return "acerto" if answer == expected else "erro"


def g_rule(answer, expected):
    """The G script's own test for a code answer: the expected code appears in the response."""
    if not answer or expected in (None, pa.NOT_A_CODE):
        return None
    return "acerto" if expected in answer else "erro"


def failure_step(verdict, f, ref_req, ref_verdict, d, expected):
    if verdict in ("acerto", "recusa_certa"):
        return None
    if f is None or f["task"] == OUT_OF_SCOPE:
        return "pedido"
    if f["task"] != ref_req.task.value or normalise_system(f["system_hint"]) != normalise_system(ref_req.system_hint):
        return "pedido"
    if ref_verdict in ("acerto", "recusa_certa"):
        return "pedido"
    if d is not None and d.route is Route.R3_DISAMBIGUATE and (
            expected in (None, pa.NOT_A_CODE) or expected in {c.code for c in d.candidates}):
        return "escolha"
    return "rota"


def _abst(d):
    return ((d.abstention_reason or "").split(":")[0] or None) if d else None


def safe_route(router, req):
    """A router exception on a model's request is a finding (a router defect), not the end of the single run."""
    try:
        return router.route(req), None
    except Exception as e:  # noqa: BLE001 — recorded in the row, never counted as a refusal
        return None, f"{type(e).__name__}: {e}"


def path_c_case(client, router, gid, question, expected_raw, ref_req, ref_verdict, guard):
    stop = guard()
    if stop:
        raise Stop(stop)
    content, ns, err, meta = client.chat(REQUEST_PROMPT, question, REQUEST_SCHEMA)
    f, perr = (None, "chamada-falhou") if err else parse_request(content)
    req = model_request(f) if f else None
    d, rerr = safe_route(router, req) if req else (None, None)
    row = dict(id=gid, expected=expected_raw, request=f, request_error=perr, call_error=err, raw=content,
               model_ms=round(ns / 1e6, 3), meta=meta, code_not_in_text=code_not_in_text(f, question),
               router_error=rerr,
               route=(rc.observed_label(d) if d else "erro-do-router" if rerr
                      else "chamador-recusa" if f else "pedido-invalido"),
               path=d.path.value if d else None, outcome=d.outcome.value if d else None, abstention=_abst(d),
               candidates=[f"{c.system} {c.code}" for c in d.candidates] if d else [],
               choice=None, choice_raw=None, choice_error=None, choice_ms=None)
    choice = None
    if d is not None and d.route is Route.R3_DISAMBIGUATE and d.candidates:
        stop = guard()
        if stop:
            raise Stop(stop)
        c_content, c_ns, c_err, c_meta = client.chat(CHOICE_PROMPT, choice_message(question, d.candidates),
                                                     CHOICE_SCHEMA)
        choice, cerr = (None, "chamada-falhou") if c_err else parse_choice(c_content)
        row.update(choice=choice, choice_raw=c_content, choice_error=cerr, choice_call_error=c_err,
                   choice_ms=round(c_ns / 1e6, 3), choice_meta=c_meta)
    answer, how = end_to_end(router, d, choice)
    if d is None:
        how = "erro-do-router" if rerr else "chamador-recusa" if f else "pedido-invalido"
    expected = pa.expected_of(expected_raw)
    verdict = "erro-do-router" if rerr else verdict_of(answer, expected)
    step = "rota" if rerr else failure_step(verdict, f, ref_req, ref_verdict, d, expected)
    row.update(answer=answer, how=how, verdict=verdict, g_rule=g_rule(answer, expected), step=step,
               ref_verdict=ref_verdict,
               ref_task=ref_req.task.value if ref_req else None, ref_system=ref_req.system_hint if ref_req else None)
    return row


# -- arm 2: one question of the set -----------------------------------------------------------------------------

def arm2_question(client, router, q, guard):
    stop = guard()
    if stop:
        raise Stop(stop)
    content, ns, err, meta = client.chat(REQUEST_PROMPT, q["text"], REQUEST_SCHEMA)
    f, perr = (None, "chamada-falhou") if err else parse_request(content)
    gold, declared, expected = q["task"] or OUT_OF_SCOPE, (f["task"] if f else None), q["expected_route"]
    eo = rc.expected_outcome(expected)

    def routed(req, valid):
        if not valid:
            return {"label": "pedido-invalido", "conforms": False, "outcome": "sem-pedido",
                    "outcome_agree": False if eo is not None else None, "abstention": None, "candidates": []}
        d, rerr = safe_route(router, req) if req is not None else (None, None)
        if rerr:
            return {"label": "erro-do-router", "conforms": False, "outcome": "error",
                    "outcome_agree": False if eo is not None else None, "abstention": None, "candidates": [],
                    "router_error": rerr}
        lab = rc.observed_label(d) if d else "chamador-recusa"
        out = d.outcome.value if d else "abstained"
        return {"label": lab, "conforms": rc.conforms(expected, lab), "outcome": out,
                "outcome_agree": None if eo is None else out == eo, "abstention": _abst(d),
                "candidates": [f"{c.system} {c.code}" for c in d.candidates] if d else []}

    codes = q.get("codes") or []
    return dict(id=q["id"], category=q["category"], borderline=q["borderline"], expected_route=expected,
                gold_task=gold, declared_task=declared, task_ok=declared == gold, request=f, request_error=perr,
                call_error=err, raw=content, model_ms=round(ns / 1e6, 3), meta=meta,
                system_ok=bool(f) and normalise_system(f["system_hint"]) == normalise_system(q.get("system")),
                code_ok=bool(f) and (f["code"] or None) == (codes[0] if codes else None),
                code_not_in_text=code_not_in_text(f, q["text"]),
                model=routed(model_request(f) if f else None, f is not None),
                labeller_fields=routed(labeller_request_with_task(q, declared) if f else None, f is not None),
                labeller_request=routed(rc.to_request(q), True))


# -- stores, exactly as arm 1 and path A built them ---------------------------------------------------------------

def build_arm1_stores():
    stores, index = [], {}
    for sid, rel, vocs in rc.BASES:
        st = pa.SqliteStore(sid)
        for v in vocs:
            t0 = time.perf_counter()
            n = st.add_rows(v, pa.load_omop_concept_csv(ROOT / rel, v))
            index[f"{sid}/{v}"] = {"rows": n, "s": round(time.perf_counter() - t0, 3)}
        st.finish()
        stores.append(st)
    return stores, index


def build_path_a_store():
    store, index = pa.SqliteStore(), {}
    for voc, rel, kind in pa.SOURCES:
        t0 = time.perf_counter()
        rows = pa.load_omop_concept_csv(ROOT / rel, voc) if kind == "omop" else pa.load_icd10cm_tabular(ROOT / rel)
        index[voc] = {"rows": store.add_rows(voc, rows), "s": round(time.perf_counter() - t0, 3)}
    store.finish()
    return store, index


# -- summaries ----------------------------------------------------------------------------------------------------

def lat(ms):
    return {"n": len(ms), "p50": pa.pct(ms, .5), "p95": pa.pct(ms, .95), "max": max(ms)} if ms else None


def arm2_summary(rows):
    def blk(rs):
        return {"n": len(rs), "task_ok": sum(r["task_ok"] for r in rs),
                "model_conform": sum(r["model"]["conforms"] for r in rs),
                "labeller_fields_conform": sum(r["labeller_fields"]["conforms"] for r in rs),
                "labeller_request_conform": sum(r["labeller_request"]["conforms"] for r in rs),
                "model_outcome_n": sum(r["model"]["outcome_agree"] is not None for r in rs),
                "model_outcome_agree": sum(r["model"]["outcome_agree"] is True for r in rs),
                "same_route_as_arm1": sum(r["model"]["label"] == r["labeller_request"]["label"] for r in rs),
                "system_ok": sum(r["system_ok"] for r in rs), "code_ok": sum(r["code_ok"] for r in rs),
                "code_not_in_text": sum(r["code_not_in_text"] for r in rs),
                "invalid": sum(r["request"] is None for r in rs)}

    return {"all": blk(rows), "borderline": blk([r for r in rows if r["borderline"]]),
            "by_category": {c: blk([r for r in rows if r["category"] == c]) for c in "abcdef"},
            "task_confusion": {g: dict(Counter(str(r["declared_task"]) for r in rows if r["gold_task"] == g))
                               for g in TASKS},
            "route_confusion_model": {e: dict(Counter(r["model"]["label"] for r in rows if r["expected_route"] == e))
                                      for e in sorted({r["expected_route"] for r in rows})},
            "task_disagreements": [{"id": r["id"], "category": r["category"], "gold": r["gold_task"],
                                    "declared": r["declared_task"], "error": r["request_error"]}
                                   for r in rows if not r["task_ok"]],
            "route_disagreements_model": [{"id": r["id"], "expected": r["expected_route"],
                                           "model": r["model"]["label"], "arm1": r["labeller_request"]["label"]}
                                          for r in rows if not r["model"]["conforms"]],
            "arm1_recomputed_vs_file_mismatch": [r["id"] for r in rows if r["labeller_request"]["label"]
                                                 != r.get("arm1_file_label")],
            "latency_ms": lat([r["model_ms"] for r in rows])}


def path_c_summary(rows):
    r3 = [r for r in rows if r["route"] == "R3"]
    return {"n": len(rows), "verdicts": dict(Counter(r["verdict"] for r in rows)),
            "model_alone_correct": sum(bool(r.get("model_alone_correct")) for r in rows),
            "ref_verdicts": dict(Counter(r["ref_verdict"] for r in rows)),
            "a2_file_mismatch": [r["id"] for r in rows if r["ref_verdict"] != r.get("a2_file_verdict")],
            "steps": dict(Counter(r["step"] for r in rows if r["step"])),
            "routes": dict(Counter(r["route"] for r in rows)), "how": dict(Counter(r["how"] for r in rows)),
            "r3": [{"id": r["id"], "expected": r["expected"], "candidates": r["candidates"], "choice": r["choice"],
                    "how": r["how"], "verdict": r["verdict"], "step": r["step"]} for r in r3],
            "g_rule_differs": [r["id"] for r in rows if r["g_rule"] is not None and r["g_rule"] != r["verdict"]],
            "code_not_in_text": [r["id"] for r in rows if r["code_not_in_text"]],
            "invalid_requests": [r["id"] for r in rows if r["request"] is None],
            "latency_ms_request": lat([r["model_ms"] for r in rows]),
            "latency_ms_choice": lat([r["choice_ms"] for r in rows if r["choice_ms"] is not None]),
            "per_case": [{"id": r["id"], "verdict": r["verdict"], "model_alone_correct": r.get("model_alone_correct"),
                          "a2": r["ref_verdict"], "route": r["route"], "answer": r["answer"], "step": r["step"]}
                         for r in rows]}


def main():
    started = time.strftime("%Y-%m-%d %H:%M:%S %Z")
    stamp = time.strftime("%Y%m%d_%H%M%S")
    free0 = shutil.disk_usage(HOME).free
    if free0 < MIN_FREE_START:
        print(f"menos de 5 GiB livres ({free0} bytes): nada corrido")
        return 2
    if not rc.set_sha256_ok():
        print("o sha256 do conjunto não bate com o .sha256: nada corrido")
        return 2
    manifest = json.loads(MANIFEST.read_text())
    params = [ly for ly in manifest["layers"] if ly["mediaType"].endswith(".params")]
    client = OllamaClient()
    out = {"protocol": "protocol_routing_arm2_path_c.md, section 3",
           "started": started, "disk_free_start": free0,
           "model": {"name": MODEL, "manifest_sha256": pa.sha256(MANIFEST), "config_digest": manifest["config"]["digest"],
                     "layers": [{k: ly[k] for k in ("mediaType", "digest", "size")} for ly in manifest["layers"]],
                     "params_blob": (BLOBS / params[0]["digest"].replace(":", "-")).read_text() if params else None},
           "server": {"base": OLLAMA, "version": client.version()},
           "options": OPTIONS, "think": False, "keep_alive": KEEP_ALIVE,
           "prompts": {"request": REQUEST_PROMPT, "choice": CHOICE_PROMPT,
                       "request_sha256": hashlib.sha256(REQUEST_PROMPT.encode()).hexdigest(),
                       "choice_sha256": hashlib.sha256(CHOICE_PROMPT.encode()).hexdigest()},
           "schemas": {"request": REQUEST_SCHEMA, "choice": CHOICE_SCHEMA},
           "env": {"cpu": pa.run(["sysctl", "-n", "machdep.cpu.brand_string"]),
                   "memsize": pa.run(["sysctl", "-n", "hw.memsize"]), "macos": platform.mac_ver()[0],
                   "python": platform.python_version(), "sqlite": sqlite3.sqlite_version,
                   "router_commit": pa.run(["git", "-C", str(ROOT), "log", "-1", "--format=%H", "--",
                                            "services/terminology-router"]),
                   "router_src_status": pa.run(["git", "-C", str(ROOT), "status", "--porcelain", "--",
                                                "services/terminology-router/src"]),
                   "head": pa.run(["git", "-C", str(ROOT), "rev-parse", "HEAD"])},
           "sha256": {rel: pa.sha256(ROOT / rel) for rel in (
               pa.ATHENA, pa.VOCAB2, pa.ICD10CM_XML, rc.SET_FILE, pa.G_FILE, G_SCRIPT, pa.CASES_SCRIPT, PATH_A_RESULT,
               ARM1_RESULT, "scripts/benchmark_routing_arm2_path_c.py", "scripts/test_benchmark_routing_arm2_path_c.py",
               "scripts/benchmark_path_a_isolated.py", "scripts/benchmark_routing_conformance.py")}}
    arm2, path_c, stopped, index = [], [], None, {}
    try:
        stores, index["arm2"] = build_arm1_stores()
        router = Router(stores=stores)
        arm1 = {r["id"]: r["observed"] for r in json.loads((ROOT / ARM1_RESULT).read_text())["rows"]}
        for q in json.loads((ROOT / rc.SET_FILE).read_text())["questions"]:
            row = arm2_question(client, router, q, disk_guard)
            row["arm1_file_label"] = arm1.get(q["id"])
            arm2.append(row)
        del stores, router
        gc.collect()

        store, index["path_c"] = build_path_a_store()
        router = Router(stores=[store])
        sentences, ext = g_sentences(), {c["id"]: c for c in pa.cases_42()}
        a2_file = {r["g_id"]: r["verdict"] for r in json.loads((ROOT / PATH_A_RESULT).read_text())["rows"]
                   if r["set"] == "A2"}
        for g in [r for r in json.loads((ROOT / pa.G_FILE).read_text())["results"]
                  if r["id"] not in pa.G_LENGTH_SCORED]:
            ref_req = pa.request_for_case(ext[pa.g_to_42(g["id"])])
            ref_d = router.route(ref_req)
            ref_verdict, ref_got = pa.score(ref_d, pa.expected_of(g["expected"]))
            row = path_c_case(client, router, g["id"], sentences[g["id"]]["q"], g["expected"], ref_req, ref_verdict,
                              disk_guard)
            row.update(model_alone_correct=g["correct"], ref_route=ref_d.route.value, ref_got=ref_got,
                       a2_file_verdict=a2_file.get(g["id"]))
            path_c.append(row)
    except Stop as e:
        stopped = str(e)
    finally:
        try:
            unload = client.unload()
        except (urllib.error.URLError, OSError, ValueError) as e:
            unload = f"{type(e).__name__}: {e}"
    out.update(ended=time.strftime("%Y-%m-%d %H:%M:%S %Z"), stopped=stopped, unload=unload, index_build=index,
               disk_free_end=shutil.disk_usage(HOME).free,
               arm2={"summary": arm2_summary(arm2) if arm2 else None, "rows": arm2},
               path_c={"summary": path_c_summary(path_c) if path_c else None, "rows": path_c})
    dest = ROOT / "results" / "llm_benchmarks" / f"benchmark_routing_arm2_path_c_{stamp}.json"
    with open(dest, "x", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
    print(f"resultado: {dest.relative_to(ROOT)}")
    print("parou:", stopped, "| descarga:", unload)
    if arm2:
        s = out["arm2"]["summary"]
        print("braço 2:", json.dumps(s["all"], ensure_ascii=False))
        print("  por categoria:", json.dumps({c: (b["task_ok"], b["model_conform"], b["n"])
                                              for c, b in s["by_category"].items()}, ensure_ascii=False))
        print("  confusão da tarefa:", json.dumps(s["task_confusion"], ensure_ascii=False))
        print("  latência:", s["latency_ms"], "| braço 1 recalculado ≠ ficheiro:", s["arm1_recomputed_vs_file_mismatch"])
    if path_c:
        s = out["path_c"]["summary"]
        print("caminho C:", json.dumps({k: s[k] for k in ("n", "verdicts", "model_alone_correct", "ref_verdicts",
                                                          "steps", "routes", "how")}, ensure_ascii=False))
        print("  A2 ≠ ficheiro:", s["a2_file_mismatch"], "| regra G difere:", s["g_rule_differs"],
              "| código fora da frase:", s["code_not_in_text"], "| inválidos:", s["invalid_requests"])
        for r in s["r3"]:
            print("  R3:", json.dumps(r, ensure_ascii=False))
    return 3 if stopped else 0


if __name__ == "__main__":
    sys.exit(main())
