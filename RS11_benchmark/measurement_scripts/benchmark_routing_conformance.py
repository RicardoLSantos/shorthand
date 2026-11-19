#!/usr/bin/env python3
"""Routing, arm 1: conformance of the router code with the public specification, on the labeller's question set.

19 Nov 2026. Protocol: protocol_routing_two_arms.md, section 2, arm 1, committed
with this script and its test before the run. The task is the one the set declares, so the choice of task is NOT
measured here (that would be circular): what is measured is whether Router.route (services/terminology-router at
5b313864f, unchanged) reaches the route the public specification gives, on inputs written without reading the code.
No model, no network. The stores are the in-memory SQLite indexes of benchmark_path_a_isolated.py, one per local
base, with the vocabularies the set's meta lists.

Usage: python3 -I scripts/benchmark_routing_conformance.py
Output: results/llm_benchmarks/benchmark_routing_conformance_<YYYYMMDD_HHMMSS>.json (opened with 'x'), plus a summary.
"""
import json
import sys
import time
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "services" / "terminology-router" / "src"))
sys.path.insert(0, str(HERE))

import benchmark_path_a_isolated as pa  # noqa: E402
from terminology_router.models import Path as RPath, Route, RouteRequest, TaskClass  # noqa: E402
from terminology_router.router import Router  # noqa: E402

SET_FILE = "routing_question_set/routing_question_set_20261119_083359.json"
BASES = (("athena-index", pa.ATHENA, ("LOINC", "UCUM")), ("vocab2-index", pa.VOCAB2, ("SNOMED", "ICD10", "UCUM")))
ABSTAINING = frozenset({"R7", "R-pre", "R2→R7"})


def set_sha256_ok():
    p = ROOT / SET_FILE
    return pa.sha256(p) == (p.parent / (p.name + ".sha256")).read_text().split()[0]


def to_request(q):
    codes = q.get("codes") or []
    kw = dict(query=q.get("term") or (codes[0] if codes else q["text"]), system_hint=q.get("system"),
              display=q.get("display"), code=codes[0] if codes else None, target_system=q.get("target_system"))
    if q.get("task"):
        kw["task"] = TaskClass(q["task"])
    return RouteRequest(**kw)


def observed_label(d):
    if d.route is Route.R2_EXPAND:
        return {RPath.A: "R2→R1", RPath.C: "R2→R3"}.get(d.path, "R2→?")
    if d.route is Route.R7_ABSTAIN and (d.abstention_reason or "").startswith("no-candidate"):
        return "R2→R7"
    return d.route.value


def conforms(expected, label):
    return label in ("R7", "R2→R7") if expected == "R7" else expected == label


def expected_outcome(expected):
    if expected == "R0":
        return None
    return "abstained" if expected in ABSTAINING else "resolved"


def main():
    if not set_sha256_ok():
        print("o sha256 do conjunto não bate com o .sha256: nada corrido")
        return 2
    stamp = time.strftime("%Y%m%d_%H%M%S")
    data = json.loads((ROOT / SET_FILE).read_text())
    stores, index = [], {}
    for sid, rel, vocs in BASES:
        st = pa.SqliteStore(sid)
        for v in vocs:
            t0 = time.perf_counter()
            n = st.add_rows(v, pa.load_omop_concept_csv(ROOT / rel, v))
            index[f"{sid}/{v}"] = {"rows": n, "s": round(time.perf_counter() - t0, 3)}
        st.finish()
        stores.append(st)
    router = Router(stores=stores)

    rows = []
    for q in data["questions"]:
        req = to_request(q)
        d = router.route(req)
        lab = observed_label(d)
        rows.append(dict(id=q["id"], category=q["category"], borderline=q["borderline"], expected=q["expected_route"],
                         observed=lab, conforms=conforms(q["expected_route"], lab),
                         expected_outcome=expected_outcome(q["expected_route"]), outcome=d.outcome.value,
                         path=d.path.value, route=d.route.value, abstention=d.abstention_reason,
                         decision_reason=d.reason, candidates=[f"{c.system} {c.code}" for c in d.candidates],
                         request={"task": req.task.value, "query": req.query, "system_hint": req.system_hint,
                                  "code": req.code, "display": req.display, "target_system": req.target_system},
                         labeller_reason=q.get("reason")))

    def block(rs):
        out = [r for r in rs if r["expected_outcome"] is not None]
        return {"n": len(rs), "conform": sum(r["conforms"] for r in rs),
                "outcome_n": len(out), "outcome_agree": sum(r["outcome"] == r["expected_outcome"] for r in out)}

    summary = {"all": block(rows), "borderline": block([r for r in rows if r["borderline"]]),
               "not_borderline": block([r for r in rows if not r["borderline"]]),
               "by_category": {c: block([r for r in rows if r["category"] == c]) for c in "abcdef"}}
    confusion = {e: dict(Counter(r["observed"] for r in rows if r["expected"] == e))
                 for e in sorted({r["expected"] for r in rows})}
    out = {"protocol": "protocol_routing_two_arms.md, section 2, arm 1",
           "set": SET_FILE, "set_sha256": pa.sha256(ROOT / SET_FILE),
           "router_commit": pa.run(["git", "-C", str(ROOT), "log", "-1", "--format=%H", "--",
                                    "services/terminology-router"]),
           "head": pa.run(["git", "-C", str(ROOT), "rev-parse", "HEAD"]),
           "sha256": {rel: pa.sha256(ROOT / rel) for rel in (pa.ATHENA, pa.VOCAB2, "scripts/benchmark_routing_conformance.py",
                                                            "scripts/test_benchmark_routing_conformance.py",
                                                            "scripts/benchmark_path_a_isolated.py")},
           "index_build": index, "summary": summary, "confusion": confusion, "rows": rows}
    dest = ROOT / "results" / "llm_benchmarks" / f"benchmark_routing_conformance_{stamp}.json"
    with open(dest, "x", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
    print(f"resultado: {dest.relative_to(ROOT)}")
    print(json.dumps(summary, ensure_ascii=False))
    print("confusão:", json.dumps(confusion, ensure_ascii=False))
    for r in rows:
        if not r["conforms"]:
            print(f"  ≠ {r['id']} ({r['category']}{', fronteira' if r['borderline'] else ''}): esperada {r['expected']}, "
                  f"obtida {r['observed']} [{r['path']}/{r['outcome']}] {(r['abstention'] or '')[:60]} "
                  f"cand={len(r['candidates'])} pedido={r['request']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
