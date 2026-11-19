#!/usr/bin/env python3
"""Post-hoc re-read of the 09:05:35 run of benchmark_routing_arm2_path_c.py, declared in the report (section 3.1).

19 Nov 2026. NOT in the committed protocol (protocol_routing_arm2_path_c.md, section 3). In that run, every request that failed to parse
(json-invalido) is well-formed JSON inside a Markdown fence (```json ... ```): the format schema did not hold the
answer's form. This script makes NO model call and opens no socket: it replays the saved answers with the fence taken
off, through the same functions, the same router and the same stores. A case that only now reaches R3 has no saved
choice, and is reported as not measured, with its candidates.

Usage: python3 -I scripts/posthoc_fence_reparse_arm2_path_c.py
Output: results/llm_benchmarks/benchmark_routing_arm2_path_c_posthoc_fence_<YYYYMMDD_HHMMSS>.json (opened with 'x').
"""
import json
import re
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE))

import benchmark_routing_arm2_path_c as m  # noqa: E402
from terminology_router.router import Router  # noqa: E402

pa, rc = m.pa, m.rc
RUN = "results/llm_benchmarks/benchmark_routing_arm2_path_c_20261119_090535.json"
FENCE = re.compile(r"\A```(?:json)?[ \t]*\n(.*)\n```\s*\Z", re.S)


def unfence(s):
    mt = FENCE.match(s or "")
    return mt.group(1) if mt else s


assert unfence('```json\n{"a": 1}\n```') == '{"a": 1}'
assert unfence('```\n{}\n```\n') == '{}'
assert unfence('{"a": 1}') == '{"a": 1}'
assert unfence('x ```json\n{}\n```') == 'x ```json\n{}\n```'


class NotMeasured(Exception):
    """A case that reaches R3 only after the re-read: its choice was never asked."""


class Replay:
    def __init__(self, requests, choices):
        self.requests, self.choices, self.unfenced = requests, choices, 0

    def chat(self, system, user, schema):
        if system == m.CHOICE_PROMPT:
            q = user.split("\n", 1)[0][len("Message: "):]
            if q not in self.choices:
                raise NotMeasured(q)
            raw, ns, meta = self.choices[q]
            return raw, ns, None, meta
        raw, ns, meta = self.requests[user]
        new = unfence(raw)
        self.unfenced += new != raw
        return new, ns, None, meta


def main():
    stamp = time.strftime("%Y%m%d_%H%M%S")
    run = json.loads((ROOT / RUN).read_text())
    questions = json.loads((ROOT / rc.SET_FILE).read_text())["questions"]
    text = {q["id"]: q["text"] for q in questions}
    rep2 = Replay({text[r["id"]]: (r["raw"], int(r["model_ms"] * 1e6), r["meta"]) for r in run["arm2"]["rows"]}, {})
    stores, _ = m.build_arm1_stores()
    router = Router(stores=stores)
    arm1 = {r["id"]: r["observed"] for r in json.loads((ROOT / m.ARM1_RESULT).read_text())["rows"]}
    arm2 = []
    for q in questions:
        row = m.arm2_question(rep2, router, q, lambda: None)
        row["arm1_file_label"] = arm1.get(q["id"])
        arm2.append(row)
    del stores, router

    sentences, ext = m.g_sentences(), {c["id"]: c for c in pa.cases_42()}
    crow = {r["id"]: r for r in run["path_c"]["rows"]}
    repc = Replay({sentences[i]["q"]: (r["raw"], int(r["model_ms"] * 1e6), r["meta"]) for i, r in crow.items()},
                  {sentences[i]["q"]: (r["choice_raw"], int(r["choice_ms"] * 1e6), r.get("choice_meta"))
                   for i, r in crow.items() if r["choice_raw"] is not None})
    store, _ = m.build_path_a_store()
    router = Router(stores=[store])
    path_c, not_measured = [], []
    for i, r0 in crow.items():
        ref_req = pa.request_for_case(ext[pa.g_to_42(i)])
        ref_verdict, _ = pa.score(router.route(ref_req), pa.expected_of(r0["expected"]))
        try:
            row = m.path_c_case(repc, router, i, sentences[i]["q"], r0["expected"], ref_req, ref_verdict, lambda: None)
        except NotMeasured:
            f, _ = m.parse_request(unfence(r0["raw"]))
            d = router.route(m.model_request(f))
            codes = [c.code for c in d.candidates]
            not_measured.append({"id": i, "expected": r0["expected"], "candidates": [f"{c.system} {c.code}"
                                                                                     for c in d.candidates],
                                 "expected_in_list": pa.expected_of(r0["expected"]) in codes,
                                 "model_alone_correct": r0["model_alone_correct"], "a2": ref_verdict})
            continue
        row.update(model_alone_correct=r0["model_alone_correct"], a2_file_verdict=r0["a2_file_verdict"])
        path_c.append(row)

    out = {"what": "post-hoc re-read with the Markdown fence taken off; not in the committed protocol; no model call",
           "source_run": RUN, "source_sha256": pa.sha256(ROOT / RUN),
           "script_sha256": pa.sha256(ROOT / "scripts/posthoc_fence_reparse_arm2_path_c.py"),
           "head": pa.run(["git", "-C", str(ROOT), "rev-parse", "HEAD"]),
           "unfenced": {"arm2": rep2.unfenced, "path_c": repc.unfenced},
           "arm2": {"summary": m.arm2_summary(arm2), "rows": arm2},
           "path_c": {"summary": m.path_c_summary(path_c) if path_c else None, "not_measured_r3": not_measured,
                      "rows": path_c}}
    dest = ROOT / "results" / "llm_benchmarks" / f"benchmark_routing_arm2_path_c_posthoc_fence_{stamp}.json"
    with open(dest, "x", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
    s2, sc = out["arm2"]["summary"], out["path_c"]["summary"]
    print(f"resultado: {dest.relative_to(ROOT)} | sem cerca: {out['unfenced']}")
    print("braço 2:", json.dumps(s2["all"]))
    print("  por categoria (tarefa, rota, n):", json.dumps({c: (b["task_ok"], b["model_conform"], b["n"])
                                                         for c, b in s2["by_category"].items()}))
    print("  confusão:", json.dumps(s2["task_confusion"]))
    print("  discordâncias:", json.dumps([(t["id"], t["gold"], t["declared"]) for t in s2["task_disagreements"]]))
    print("caminho C:", json.dumps({k: sc[k] for k in ("n", "verdicts", "steps", "routes", "how")}, ensure_ascii=False))
    print("  não medidos (R3 nova):", json.dumps(not_measured, ensure_ascii=False))
    print("  por caso:", json.dumps([(p["id"], p["verdict"], p["a2"], p["model_alone_correct"]) for p in sc["per_case"]]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
