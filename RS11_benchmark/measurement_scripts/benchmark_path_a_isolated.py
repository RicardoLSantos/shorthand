#!/usr/bin/env python3
"""Path A alone: the terminology router's deterministic lookup, timed without a model and without the network.

19 Nov 2026. The protocol was fixed before this script, in
protocol_path_a_isolated.md, section 1 (commit 5f5e0ea86); the test is
scripts/test_benchmark_path_a_isolated.py, written and run before this file.

What is timed: one call to the service's Router.route (services/terminology-router, unchanged), over an SQLite
index held in memory that implements the service's LookupStore contract. The index is built once, before any timed
call, and its build time is reported apart. Reads only local files; imports no network module; the Router calls no
model (R3 and R6 hand over to the caller).

Usage: python3 -I scripts/benchmark_path_a_isolated.py
Output: results/llm_benchmarks/benchmark_path_a_isolated_<YYYYMMDD_HHMMSS>.json (opened with 'x'), plus a summary.
"""
import ast
import csv
import hashlib
import json
import math
import platform
import random
import re
import sqlite3
import subprocess
import sys
import time
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "services" / "terminology-router" / "src"))

from terminology_router.models import (  # noqa: E402
    Candidate, MatchStrength, Outcome, Path as RPath, ProvenanceRecord, Route, RouteRequest, StoreCapability,
    TaskClass)
from terminology_router.router import Router  # noqa: E402
from terminology_router.stores import LookupStore, _now  # noqa: E402

SEED = 20261119
N_REAL, N_REAL_NAME, N_INVENTED = 1000, 200, 200
ATHENA = "etl/data/athena/CONCEPT.csv"
VOCAB2 = "knowledge_base/Vocabulario/CONCEPT.csv"
ICD10CM_XML = "data/icd10cm_fy2026/code_tables/Table and Index/icd10cm_tabular_2026.xml"
SOURCES = (("LOINC", ATHENA, "omop"), ("SNOMED", VOCAB2, "omop"), ("ICD10CM", ICD10CM_XML, "cms"))
M_FILE = "results/llm_benchmarks/benchmark_3phase_rag_20260324_114358.json"
J_FILE = "results/llm_benchmarks/benchmark_3phase_rag_20260320_130612.json"
G_FILE = "results/llm_benchmarks/benchmark_3level_qwen3_5_4b_all_20260319_193030.json"
CASES_SCRIPT = "scripts/benchmark_3phase_rag.py"
G_LENGTH_SCORED = frozenset({"HARD-REASON-01", "HARD-REASON-02", "HARD-MULTI-01"})
G_SWAPS = {"HARD-CROSS-01": "H-CROSS-02", "HARD-CROSS-02": "H-CROSS-01"}
NOT_A_CODE = "<not-a-code>"
INDEX_OF = {"LOINC": "LOINC", "SNOMED": "SNOMED", "ICD-10-CM": "ICD10CM"}  # a case's "term" -> index vocabulary


# -- check digits -----------------------------------------------------------------------------------------------

def luhn_digit(payload):
    """LOINC check digit (mod 10, the Luhn rule) of the digits before the hyphen."""
    total = 0
    for i, ch in enumerate(reversed(payload)):
        d = int(ch)
        if i % 2 == 0:
            d = d * 2 - 9 if d * 2 > 9 else d * 2
        total += d
    return (10 - total % 10) % 10


def loinc_valid(code):
    head, sep, tail = code.partition("-")
    return bool(sep) and head.isdigit() and len(tail) == 1 and tail.isdigit() and luhn_digit(head) == int(tail)


_D = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 2, 3, 4, 0, 6, 7, 8, 9, 5], [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
      [3, 4, 0, 1, 2, 8, 9, 5, 6, 7], [4, 0, 1, 2, 3, 9, 5, 6, 7, 8], [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
      [6, 5, 9, 8, 7, 1, 0, 4, 3, 2], [7, 6, 5, 9, 8, 2, 1, 0, 4, 3], [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
      [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]]
_P = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 5, 7, 6, 2, 8, 3, 0, 9, 4], [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
      [8, 9, 1, 6, 0, 4, 3, 5, 2, 7], [9, 4, 5, 3, 1, 2, 6, 8, 7, 0], [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
      [2, 7, 9, 3, 8, 0, 6, 4, 1, 5], [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]]
_INV = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]


def verhoeff_digit(payload):
    c = 0
    for i, ch in enumerate(reversed(payload)):
        c = _D[c][_P[(i + 1) % 8][int(ch)]]
    return _INV[c]


def verhoeff_valid(code):
    if not code.isdigit() or len(code) < 6:
        return False
    c = 0
    for i, ch in enumerate(reversed(code)):
        c = _D[c][_P[i % 8][int(ch)]]
    return c == 0


def icd10cm_form(code):
    return re.fullmatch(r"[A-Z][0-9]{2}\.[0-9]{2}", code) is not None


# -- the store --------------------------------------------------------------------------------------------------

class SqliteStore(LookupStore):
    """The LookupStore contract (stores.py l.56-67) over an in-memory SQLite index.

    Same answers as AthenaCsvStore (stores.py l.336-386) for search and get, with two declared differences: every
    exact match comes from the index (the CSV store stops after 40 hits in file order), and the vocabularies are
    declared from the whole index (the CSV store samples the first 200 000 rows).
    """

    def __init__(self, store_id="path-a-sqlite-index"):
        self.store_id = store_id
        self.db = sqlite3.connect(":memory:")
        self.db.execute("CREATE TABLE concept (voc TEXT, code TEXT, name TEXT, low TEXT, std INTEGER, act INTEGER, "
                        "ord INTEGER)")
        self._n = 0
        self._vocs = set()
        self.capability = StoreCapability(store_id=store_id, vocabularies=())

    def add_rows(self, vocabulary, rows):
        voc = vocabulary.upper()
        batch = []
        for code, name, std, inv in rows:
            self._n += 1
            batch.append((voc, code, name, name.lower(), 1 if std.strip().upper() == "S" else 0,
                          1 if inv.strip() == "" else 0, self._n))
        self.db.executemany("INSERT INTO concept VALUES (?, ?, ?, ?, ?, ?, ?)", batch)
        if batch:
            self._vocs.add(voc)
        return len(batch)

    def finish(self):
        self.db.execute("CREATE INDEX ix_code ON concept (voc, code, ord)")
        self.db.execute("CREATE INDEX ix_low ON concept (voc, low, ord)")
        self.db.execute("CREATE INDEX ix_ord ON concept (voc, ord)")
        self.db.commit()
        vocs = tuple(sorted(self._vocs))
        self.capability = StoreCapability(store_id=self.store_id, vocabularies=vocs,
                                          versions={v: "as-downloaded" for v in vocs})

    def _cand(self, voc, r, strength, method):
        return Candidate(system=voc, code=r[0], display=r[1], match=strength,
                         provenance=ProvenanceRecord(store_id=self.store_id, vocabulary=voc,
                                                     vocabulary_version="as-downloaded", retrieved_at=_now(),
                                                     method=method),
                         active=bool(r[3]), standard=bool(r[2]))

    def search(self, text, vocabulary, limit=10):
        if not self.capability.holds(vocabulary):
            return []
        needle = text.strip().lower()
        if not needle:
            return []
        voc = vocabulary.upper()
        exact = self.db.execute("SELECT code, name, std, act FROM concept WHERE voc = ? AND low = ? ORDER BY ord",
                                (voc, needle)).fetchall()
        part = self.db.execute("SELECT code, name, std, act FROM concept WHERE voc = ? AND low <> ? AND "
                               "instr(low, ?) ORDER BY ord LIMIT ?", (voc, needle, needle, limit * 4)).fetchall()
        out = ([self._cand(voc, r, MatchStrength.EXACT, "exact-index") for r in exact]
               + [self._cand(voc, r, MatchStrength.PARTIAL, "exact-index") for r in part])
        out.sort(key=lambda c: (c.match is not MatchStrength.EXACT, c.code))
        return out[:limit]

    def get(self, vocabulary, code):
        if not self.capability.holds(vocabulary):
            return None
        voc = vocabulary.upper()
        r = self.db.execute("SELECT code, name, std, act FROM concept WHERE voc = ? AND code = ? ORDER BY ord LIMIT 1",
                            (voc, code)).fetchone()
        return None if r is None else self._cand(voc, r, MatchStrength.EXACT, "$validate-code:local")

    def name_of(self, voc, code):
        r = self.db.execute("SELECT name FROM concept WHERE voc = ? AND code = ? ORDER BY ord LIMIT 1",
                            (voc, code)).fetchone()
        return None if r is None else r[0]

    def active_exact_count(self, voc, text):
        return self.db.execute("SELECT count(*) FROM concept WHERE voc = ? AND low = ? AND act = 1",
                               (voc, text.strip().lower())).fetchone()[0]


# -- loaders ----------------------------------------------------------------------------------------------------

def load_omop_concept_csv(path, vocabulary):
    """Rows (code, name, standard_concept, invalid_reason) of one vocabulary, read as AthenaCsvStore reads them."""
    voc = vocabulary.upper()
    with open(path, newline="", encoding="utf-8", errors="replace") as fh:
        reader = csv.reader(fh, delimiter="\t")
        next(reader, None)
        for row in reader:
            if len(row) >= 10 and row[3].strip().upper() == voc:
                yield row[6], row[1], row[5], row[9]


def load_icd10cm_tabular(path):
    """Every diag of the CMS tabular list (categories, subcategories and codes), all active and standard."""
    for _ev, el in ET.iterparse(str(path), events=("end",)):
        if el.tag == "diag":
            code, desc = el.findtext("name"), el.findtext("desc")
            if code and desc:
                yield code.strip(), desc.strip(), "S", ""


# -- samples and cases ------------------------------------------------------------------------------------------

def make_rng(seed):
    return random.Random(seed)


def sample_real(store, voc, n, rng):
    codes = [r[0] for r in store.db.execute("SELECT DISTINCT code FROM concept WHERE voc = ? AND act = 1 "
                                            "ORDER BY code", (voc,))]
    return rng.sample(codes, min(n, len(codes)))


def invent_codes(store, voc, n, rng):
    out, seen = [], set()
    while len(out) < n:
        if voc == "LOINC":
            head = str(rng.randint(1000, 99999))
            c = f"{head}-{luhn_digit(head)}"
        elif voc == "SNOMED":
            p = str(rng.randint(10 ** 4, 10 ** 8 - 1)) + "00"
            c = p + str(verhoeff_digit(p))
        else:
            c = f"{chr(65 + rng.randrange(26))}{rng.randrange(100):02d}.{rng.randrange(100):02d}"
        if c not in seen and store.get(voc, c) is None:
            seen.add(c)
            out.append(c)
    return out


def cases_42():
    """The 42-case set of benchmark_3phase_rag.py, read from its source without importing it."""
    lists = {}
    for node in ast.parse((ROOT / CASES_SCRIPT).read_text()).body:
        if isinstance(node, ast.Assign) and len(node.targets) == 1 and isinstance(node.targets[0], ast.Name):
            name = node.targets[0].id
            if name == "TEST_CASES_14":
                lists[name] = ast.literal_eval(node.value)
            elif name == "TEST_CASES_EXTENDED" and isinstance(node.value, ast.BinOp):
                lists[name] = lists["TEST_CASES_14"] + ast.literal_eval(node.value.right)
    return lists["TEST_CASES_EXTENDED"]


def g_to_42(gid):
    if gid in G_SWAPS:
        return G_SWAPS[gid]
    for a, b in (("EASY-", "E-"), ("MED-", "M-"), ("HARD-", "H-")):
        if gid.startswith(a):
            return b + gid[len(a):]
    raise KeyError(gid)


def a1_ids(file=M_FILE):
    p = json.loads((ROOT / file).read_text())["phases"]["phase4"]
    rs = p["results"] if isinstance(p, dict) else p
    return [r["id"] for r in rs if r.get("path") == "confident_direct"]


def request_for_case(case):
    t, q, term = case["type"], case["q"], case["term"]
    if t == "trap":
        code, _sp, rest = q.partition(" ")
        return RouteRequest(query=code, code=code, display=rest.strip() or None, system_hint=term,
                            task=TaskClass.VERIFY)
    if t == "cross_mapping":
        return RouteRequest(query=q, system_hint=term, task=TaskClass.MAP)
    return RouteRequest(query=q, system_hint=term, task=TaskClass.RETRIEVE)


def expected_of(exp):
    if exp == "no":
        return None
    if exp == "reasoning":
        return NOT_A_CODE
    return exp


# -- scoring and timing -----------------------------------------------------------------------------------------

def score(d, expected):
    answered = d.path is RPath.A and d.outcome is Outcome.RESOLVED
    got = d.candidates[0].code if answered and d.candidates else None
    if expected is None:
        return ("erro", got) if answered else ("recusa_certa", None)
    if expected == NOT_A_CODE:
        return ("erro", got) if answered else ("sem_resposta", None)
    if not answered:
        return ("sem_resposta", None)
    return ("acerto" if got == expected else "erro", got)


def pct(xs, q):
    s = sorted(xs)
    k = max(1, math.ceil(round(q * len(s), 9)))
    return s[k - 1]


def timed(router, req):
    t0 = time.perf_counter_ns()
    d = router.route(req)
    return d, time.perf_counter_ns() - t0


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True).stdout.strip()


def main():
    started = time.strftime("%Y-%m-%d %H:%M:%S %Z")
    stamp = time.strftime("%Y%m%d_%H%M%S")
    env = {"cpu": run(["sysctl", "-n", "machdep.cpu.brand_string"]), "memsize": run(["sysctl", "-n", "hw.memsize"]),
           "macos": platform.mac_ver()[0], "machine": platform.machine(), "python": platform.python_version(),
           "sqlite": sqlite3.sqlite_version,
           "router_commit": run(["git", "-C", str(ROOT), "log", "-1", "--format=%H", "--",
                                 "services/terminology-router"]),
           "router_src_status": run(["git", "-C", str(ROOT), "status", "--porcelain", "--",
                                     "services/terminology-router/src"]),
           "head": run(["git", "-C", str(ROOT), "rev-parse", "HEAD"])}
    hashes = {rel: sha256(ROOT / rel) for rel in (ATHENA, VOCAB2, ICD10CM_XML, M_FILE, J_FILE, G_FILE, CASES_SCRIPT,
                                                  "scripts/benchmark_path_a_isolated.py",
                                                  "scripts/test_benchmark_path_a_isolated.py")}

    store, index = SqliteStore(), {}
    for voc, rel, kind in SOURCES:
        t0 = time.perf_counter()
        rows = list(load_omop_concept_csv(ROOT / rel, voc) if kind == "omop" else load_icd10cm_tabular(ROOT / rel))
        t1 = time.perf_counter()
        n = store.add_rows(voc, rows)
        index[voc] = {"rows": n, "read_s": round(t1 - t0, 3), "insert_s": round(time.perf_counter() - t1, 3)}
        del rows
    t0 = time.perf_counter()
    store.finish()
    index["indices_all_vocabularies_s"] = round(time.perf_counter() - t0, 3)
    router = Router(stores=[store])

    d, _ns = timed(router, RouteRequest(query="aspirin", system_hint="RxNorm"))
    control = {"request": "retrieve 'aspirin' in RxNorm", "route": d.route.value, "abstention": d.abstention_reason}

    rows, seeds = [], {}

    def record(set_, voc, form, ident, expected, d, ns, verdict, got, **extra):
        rows.append(dict(set=set_, voc=voc, form=form, id=ident, expected=expected, route=d.route.value,
                         path=d.path.value, outcome=d.outcome.value,
                         abstention=(d.abstention_reason or "").split(":")[0] or None, got=got, verdict=verdict,
                         ns=ns, **extra))

    for voc in ("LOINC", "SNOMED", "ICD10CM"):
        seeds[f"A3 {voc}"] = s = f"{SEED}-{voc}-real"
        sample = sample_real(store, voc, N_REAL, make_rng(s))
        for code in sample:
            d, ns = timed(router, RouteRequest(query=code, code=code, system_hint=voc, task=TaskClass.VERIFY))
            verdict, got = score(d, code)
            if verdict == "acerto" and d.candidates[0].display != store.name_of(voc, code):
                verdict = "erro_nome"
            record("A3", voc, "codigo", code, code, d, ns, verdict, got)
        for code in sample[:N_REAL_NAME]:
            name = store.name_of(voc, code)
            unique = store.active_exact_count(voc, name) == 1
            d, ns = timed(router, RouteRequest(query=name, system_hint=voc, task=TaskClass.RETRIEVE))
            verdict, got = score(d, code if unique else None)
            if not unique and verdict == "recusa_certa":
                verdict = "acerto"
            record("A3", voc, "nome", code, code if unique else None, d, ns, verdict, got, ambiguous=not unique)
        seeds[f"A4 {voc}"] = s = f"{SEED}-{voc}-invented"
        for code in invent_codes(store, voc, N_INVENTED, make_rng(s)):
            d, ns = timed(router, RouteRequest(query=code, code=code, system_hint=voc, task=TaskClass.VERIFY))
            verdict, got = score(d, None)
            if verdict == "recusa_certa" and not (d.route is Route.R0_VERIFY
                                                  and (d.abstention_reason or "").startswith("code-not-found")):
                verdict = "outra_recusa"
            record("A4", voc, "codigo", code, None, d, ns, verdict, got)

    ext = {c["id"]: c for c in cases_42()}
    m_verdict = {r["id"]: r["correct"] for r in (lambda p: p["results"] if isinstance(p, dict) else p)(
        json.loads((ROOT / M_FILE).read_text())["phases"]["phase4"])}
    g_rows = [r for r in json.loads((ROOT / G_FILE).read_text())["results"] if r["id"] not in G_LENGTH_SCORED]
    plan = ([("A1", ext[i], ext[i]["exp"], {"benchmark_correct": m_verdict[i]}) for i in a1_ids()]
            + [("A2", ext[g_to_42(r["id"])], r["expected"], {"g_id": r["id"], "model_alone_correct": r["correct"]})
               for r in g_rows])
    a5 = []
    for set_, case, exp, extra in plan:
        req = request_for_case(case)
        voc = INDEX_OF.get(case["term"])
        no_exact = (req.task is TaskClass.RETRIEVE and voc is not None
                    and store.active_exact_count(voc, case["q"]) == 0)
        d, ns = timed(router, req)
        verdict, got = score(d, expected_of(exp))
        record(set_, case["term"], "caso", case["id"], exp, d, ns, verdict, got, task=req.task.value,
               query=case["q"], no_exact_name=no_exact, **extra)
        if no_exact:
            a5.append({"set": set_, "id": case["id"], "query": case["q"], "verdict": verdict, "route": d.route.value})

    summary = []
    keys = sorted({(r["set"], r["voc"], r["form"]) for r in rows})
    for k in keys + sorted({(s, "todos", "caso") for s in ("A1", "A2")}):
        rs = [r for r in rows if (r["set"], r["voc"], r["form"]) == k
              or (k[1] == "todos" and r["set"] == k[0])]
        ms = [r["ns"] / 1e6 for r in rs]
        cnt = {v: sum(r["verdict"] == v for r in rs) for v in ("acerto", "recusa_certa", "erro", "erro_nome",
                                                             "sem_resposta", "outra_recusa")}
        routes = {}
        for r in rs:
            if r["verdict"] in ("sem_resposta", "outra_recusa") or (r["verdict"] == "acerto" and r.get("ambiguous")):
                routes[r["route"]] = routes.get(r["route"], 0) + 1
        summary.append(dict(set=k[0], voc=k[1], form=k[2], n=len(rs), **cnt,
                            exactness=round((cnt["acerto"] + cnt["recusa_certa"]) / len(rs), 4),
                            p50_ms=round(pct(ms, 0.50), 4), p95_ms=round(pct(ms, 0.95), 4),
                            max_ms=round(max(ms), 4), no_answer_routes=routes))

    out = {"protocol": "protocol_path_a_isolated.md, section 1 (5f5e0ea86)",
           "started": started, "env": env, "sha256": hashes, "seeds": seeds, "index_build": index,
           "rxnorm_control": control, "summary": summary, "a5_no_exact_name": a5, "rows": rows}
    dest = ROOT / "results" / "llm_benchmarks" / f"benchmark_path_a_isolated_{stamp}.json"
    with open(dest, "x", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
    print(f"resultado: {dest.relative_to(ROOT)}")
    print(f"índice: {json.dumps(index)}")
    print(f"controlo RxNorm: {control['route']} {control['abstention']}")
    for s in summary:
        print(f"{s['set']} {s['voc']:9} {s['form']:6} n={s['n']:4} ac={s['acerto']} rc={s['recusa_certa']} "
              f"er={s['erro']} en={s['erro_nome']} sr={s['sem_resposta']} or={s['outra_recusa']} "
              f"ex={s['exactness']:.4f} p50={s['p50_ms']}ms p95={s['p95_ms']}ms max={s['max_ms']}ms "
              f"{s['no_answer_routes']}")
    print(f"A5 (sem nome exacto): {len(a5)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
