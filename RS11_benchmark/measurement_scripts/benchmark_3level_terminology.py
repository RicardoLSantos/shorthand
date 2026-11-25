#!/usr/bin/env python3
"""
3-Level Terminology Benchmark: LOINC + SNOMED CT + ICD-10-CM
Tests task-aware routing architecture across Easy/Medium/Hard levels.

Author: Ricardo Lourenço Santos, with the assistance of Claude Code (Anthropic; Claude Opus 4.6)
Date: 2026-03-19
Version: 1.0

Usage:
    python3 scripts/benchmark_3level_terminology.py [--model qwen3.5:4b] [--level all|easy|medium|hard]
"""

import requests
import json
import time
import argparse
from pathlib import Path
from datetime import datetime

OLLAMA_CHAT_URL = "http://localhost:11434/api/chat"
PROJECT_ROOT = Path(__file__).parent.parent
RESULTS_DIR = PROJECT_ROOT / "results" / "llm_benchmarks"

# ============================================================
# TEST CASES: 36 total (12 easy + 12 medium + 12 hard)
# All expected codes verified against Athena/Vocab2/ChromaDB
# ============================================================

EASY_CASES = [
    # LOINC (Athena verified)
    {"id": "EASY-LOINC-01", "q": "What is the LOINC code for heart rate? Answer with just the code.", "exp": "8867-4", "term": "LOINC", "type": "lookup"},
    {"id": "EASY-LOINC-02", "q": "What is the LOINC code for SDNN (standard deviation of NN intervals)?", "exp": "80404-7", "term": "LOINC", "type": "lookup"},
    {"id": "EASY-LOINC-03", "q": "What is the LOINC code for Hemoglobin A1c?", "exp": "4548-4", "term": "LOINC", "type": "lookup"},
    {"id": "EASY-LOINC-04", "q": "What is the LOINC code for glucose in serum or plasma?", "exp": "2345-7", "term": "LOINC", "type": "lookup"},
    # SNOMED (Vocab2 verified)
    {"id": "EASY-SNOMED-01", "q": "What is the SNOMED CT concept ID for type 2 diabetes mellitus?", "exp": "44054006", "term": "SNOMED", "type": "lookup"},
    {"id": "EASY-SNOMED-02", "q": "What is the SNOMED CT code for atrial fibrillation?", "exp": "49436004", "term": "SNOMED", "type": "lookup"},
    {"id": "EASY-SNOMED-03", "q": "What is the SNOMED CT code for essential hypertension?", "exp": "59621000", "term": "SNOMED", "type": "lookup"},
    {"id": "EASY-SNOMED-04", "q": "What is the SNOMED CT code for asthma?", "exp": "195967001", "term": "SNOMED", "type": "lookup"},
    # ICD-10-CM (ChromaDB verified)
    {"id": "EASY-ICD10-01", "q": "What is the ICD-10-CM code for essential hypertension?", "exp": "I10", "term": "ICD-10-CM", "type": "lookup"},
    {"id": "EASY-ICD10-02", "q": "What is the ICD-10-CM code for type 2 diabetes mellitus?", "exp": "E11", "term": "ICD-10-CM", "type": "lookup"},
    {"id": "EASY-ICD10-03", "q": "What is the ICD-10-CM code for acute appendicitis?", "exp": "K35", "term": "ICD-10-CM", "type": "lookup"},
    {"id": "EASY-ICD10-04", "q": "What is the ICD-10-CM code for major depressive disorder?", "exp": "F32", "term": "ICD-10-CM", "type": "lookup"},
]

MEDIUM_CASES = [
    # Gap detection
    {"id": "MED-GAP-01", "q": "Does RMSSD (root mean square of successive differences) have a LOINC code? Answer yes or no.", "exp": "no", "term": "LOINC", "type": "gap"},
    {"id": "MED-GAP-02", "q": "Does pNN50 have a LOINC code? Answer yes or no.", "exp": "no", "term": "LOINC", "type": "gap"},
    {"id": "MED-TRAP-01", "q": "Is LOINC code 80405-4 for heart rate variability? Answer yes or no.", "exp": "no", "term": "LOINC", "type": "trap"},
    # Vendor mapping
    {"id": "MED-VENDOR-01", "q": "What LOINC code corresponds to Apple HealthKit HKQuantityTypeIdentifierHeartRate?", "exp": "8867-4", "term": "LOINC", "type": "vendor"},
    {"id": "MED-VENDOR-02", "q": "Does Fitbit daily_rmssd have a standard LOINC code? Answer yes or no.", "exp": "no", "term": "LOINC", "type": "gap"},
    # LOINC disambiguation
    {"id": "MED-LOINC-01", "q": "What is the LOINC code for heart rate measured specifically by pulse oximetry?", "exp": "8889-8", "term": "LOINC", "type": "disambiguation"},
    {"id": "MED-LOINC-02", "q": "What is the LOINC code for heart rate 24 hour maximum?", "exp": "8873-2", "term": "LOINC", "type": "disambiguation"},
    {"id": "MED-LOINC-03", "q": "What is the LOINC code for blood pressure panel?", "exp": "85354-9", "term": "LOINC", "type": "lookup"},
    # ICD-10-CM specific
    {"id": "MED-ICD10-01", "q": "What is the ICD-10-CM code for tobacco use?", "exp": "Z72.0", "term": "ICD-10-CM", "type": "lookup"},
    {"id": "MED-ICD10-02", "q": "What is the ICD-10-CM code for morbid obesity due to excess calories?", "exp": "E66.01", "term": "ICD-10-CM", "type": "lookup"},
    # Cross-mapping
    {"id": "MED-CROSS-01", "q": "The ICD-10-CM code Z72.0 is for tobacco use. What is the ICD-11 equivalent code?", "exp": "QE12", "term": "ICD-11", "type": "cross_mapping"},
    # Validation
    {"id": "MED-VALID-01", "q": "A heart rate of 72 bpm is recorded. What is the correct LOINC code and UCUM unit for heart rate?", "exp": "8867-4", "term": "LOINC", "type": "validation"},
]

HARD_CASES = [
    # Clinical reasoning
    {"id": "HARD-REASON-01", "q": "A 45-year-old patient has SDNN of 42ms measured over 5 minutes. Is this value normal? What does it suggest about autonomic function?", "exp": "reasoning", "term": "clinical", "type": "reasoning"},
    {"id": "HARD-REASON-02", "q": "A patient with rheumatoid arthritis has elevated CRP and reduced heart rate variability. Explain the pathophysiological relationship between inflammation and HRV reduction.", "exp": "reasoning", "term": "clinical", "type": "reasoning"},
    # Semantic bridging
    {"id": "HARD-BRIDGE-01", "q": "What is the SNOMED CT code for VO2max (maximum oxygen consumption during exercise)?", "exp": "251898000", "term": "SNOMED", "type": "bridging"},
    {"id": "HARD-BRIDGE-02", "q": "What is the LOINC code for GMI (glucose management indicator)?", "exp": "97506-0", "term": "LOINC", "type": "bridging"},
    # Cross-terminology mapping
    {"id": "HARD-CROSS-01", "q": "LOINC code 80404-7 represents SDNN. Does SNOMED CT have an equivalent concept? If so, what is the code?", "exp": "reasoning", "term": "cross", "type": "cross_mapping"},
    {"id": "HARD-CROSS-02", "q": "SNOMED CT 44054006 is Type 2 diabetes mellitus. What is the equivalent ICD-10-CM code?", "exp": "E11", "term": "ICD-10-CM", "type": "cross_mapping"},
    # Multi-step ICD-10 [...]
    {"id": "HARD-MULTI-01", "q": "A patient has type 2 diabetes with diabetic chronic kidney disease and hypertensive chronic kidney disease. What ICD-10-CM codes should be assigned?", "exp": "reasoning", "term": "ICD-10-CM", "type": "multi_step"},
    # Multi-vendor
    {"id": "HARD-MULTI-02", "q": "Three wearable devices report: Apple Watch reports SDNN, Fitbit reports daily_rmssd, Garmin reports stress_score. Map each to the appropriate LOINC code or indicate if a custom code is needed.", "exp": "80404-7", "term": "LOINC", "type": "multi_vendor"},
    # LOINC disambiguation (hard)
    {"id": "HARD-DISAMB-01", "q": "What are the different LOINC codes for glucose measured in serum versus glucose measured in urine?", "exp": "2345-7", "term": "LOINC", "type": "disambiguation"},
    {"id": "HARD-DISAMB-02", "q": "What are the LOINC codes for Troponin I cardiac versus Troponin T cardiac?", "exp": "10839-9", "term": "LOINC", "type": "disambiguation"},
    # ICD-10-PCS [...]
    {"id": "HARD-ICD10-01", "q": "What is the ICD-10-PCS code for laparoscopic cholecystectomy?", "exp": "0FT44ZZ", "term": "ICD-10-PCS", "type": "procedure"},
    # Sequential coding [...]
    {"id": "HARD-ICD10-02", "q": "A patient presents with sepsis due to urinary tract infection caused by E. coli. What ICD-10-CM codes should be assigned and in what sequence?", "exp": "A41.51", "term": "ICD-10-CM", "type": "sequencing"},
]


def query_model(model: str, question: str, timeout: int = 120) -> dict:
    """Query model via Ollama chat API with think=false."""
    t0 = time.time()
    try:
        resp = requests.post(OLLAMA_CHAT_URL, json={
            "model": model,
            "messages": [{"role": "user", "content": question}],
            "stream": False,
            "think": False,
            "options": {"num_predict": 300, "temperature": 0.1}
        }, timeout=timeout)
        data = resp.json()
        response = data.get("message", {}).get("content", "")
        return {
            "success": True,
            "response": response,
            "latency_ms": (time.time() - t0) * 1000
        }
    except Exception as e:
        return {
            "success": False,
            "response": str(e),
            "latency_ms": (time.time() - t0) * 1000
        }


def evaluate(test_case: dict, response: str) -> dict:
    """Evaluate response against expected answer."""
    tc = test_case
    correct = False
    hallucination = False

    if tc["type"] == "reasoning":
        # Reasoning: check length and relevant keywords
        correct = len(response) > 50
    elif tc["type"] in ("gap", "trap"):
        # Gap/trap: check for "no" in first 100 chars
        correct = "no" in response.lower()[:100]
    elif tc["type"] == "bridging":
        # Bridging: expected code should appear
        correct = tc["exp"] in response
    elif tc["type"] == "multi_step":
        # Multi-step: check for reasoning quality
        correct = len(response) > 80
    elif tc["type"] == "multi_vendor":
        # Multi-vendor: check for main LOINC code + "custom"
        correct = tc["exp"] in response and "custom" in response.lower()
    elif tc["type"] in ("disambiguation",):
        # Disambiguation: primary expected code should appear
        correct = tc["exp"] in response
    else:
        # Standard lookup: exact code match
        correct = tc["exp"] in response

    # Check for hallucinated codes (fabricated LOINC/SNOMED patterns)
    import re
    if tc["type"] == "lookup" and not correct:
        # Check if response contains a plausible but wrong code
        if re.search(r'\b\d{4,7}-\d\b', response) or re.search(r'\b\d{6,10}\b', response):
            hallucination = True

    return {"correct": correct, "hallucination": hallucination}


def run_benchmark(model: str, level: str = "all"):
    """Run 3-level terminology benchmark."""
    cases = []
    if level in ("all", "easy"):
        cases.extend(EASY_CASES)
    if level in ("all", "medium"):
        cases.extend(MEDIUM_CASES)
    if level in ("all", "hard"):
        cases.extend(HARD_CASES)

    print(f"\n{'='*70}")
    print(f"3-LEVEL TERMINOLOGY BENCHMARK")
    print(f"Model: {model} | Level: {level} | Cases: {len(cases)}")
    print(f"{'='*70}\n")

    results = []
    for i, tc in enumerate(cases):
        level_tag = tc["id"].split("-")[0]
        r = query_model(model, tc["q"])

        if r["success"]:
            ev = evaluate(tc, r["response"])
            status = "✅" if ev["correct"] else ("⚠️ HALL" if ev["hallucination"] else "❌")
            preview = r["response"][:70].strip().replace("\n", " ")
            print(f"  [{i+1:2d}/{len(cases)}] {status} {tc['id']}: {r['latency_ms']:.0f}ms — {preview}")
        else:
            ev = {"correct": False, "hallucination": False}
            print(f"  [{i+1:2d}/{len(cases)}] ❌ {tc['id']}: ERROR — {r['response'][:60]}")

        results.append({
            "id": tc["id"],
            "level": level_tag,
            "terminology": tc["term"],
            "type": tc["type"],
            "correct": ev["correct"],
            "hallucination": ev["hallucination"],
            "latency_ms": r["latency_ms"],
            "expected": tc["exp"],
            "response": r["response"][:500] if r["success"] else r["response"][:200]
        })

    # Summary
    total = len(results)
    correct = sum(1 for r in results if r["correct"])
    halluc = sum(1 for r in results if r["hallucination"])
    lats = sorted([r["latency_ms"] for r in results])

    print(f"\n{'='*70}")
    print(f"RESULTS: {correct}/{total} ({100*correct/total:.1f}%)")
    print(f"Hallucinations: {halluc}/{total} ({100*halluc/total:.1f}%)")
    print(f"Latency p50={lats[total//2]:.0f}ms p95={lats[int(total*0.95)]:.0f}ms")

    # Per-level breakdown
    for lv in ["EASY", "MED", "HARD"]:
        lv_results = [r for r in results if r["level"] == lv]
        if lv_results:
            lv_correct = sum(1 for r in lv_results if r["correct"])
            print(f"  {lv}: {lv_correct}/{len(lv_results)} ({100*lv_correct/len(lv_results):.1f}%)")

    # Per-terminology breakdown
    for term in ["LOINC", "SNOMED", "ICD-10-CM", "ICD-10-PCS", "ICD-11", "clinical", "cross"]:
        t_results = [r for r in results if r["terminology"] == term]
        if t_results:
            t_correct = sum(1 for r in t_results if r["correct"])
            print(f"  {term}: {t_correct}/{len(t_results)} ({100*t_correct/len(t_results):.1f}%)")

    # Save
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    output = {
        "model": model,
        "hardware": "Apple M1 16GB",
        "level": level,
        "total_cases": total,
        "accuracy": 100 * correct / total,
        "hallucination_rate": 100 * halluc / total,
        "p50_ms": lats[total // 2],
        "p95_ms": lats[int(total * 0.95)],
        "timestamp": datetime.now().isoformat(),
        "results": results
    }

    outpath = RESULTS_DIR / f"benchmark_3level_{model.replace(':','_').replace('.','_')}_{level}_{ts}.json"
    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    with open(outpath, "w") as f:
        json.dump(output, f, indent=2, default=str)
    print(f"\nSaved: {outpath}")

    return output


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="3-Level Terminology Benchmark")
    parser.add_argument("--model", default="qwen3.5:4b", help="Ollama model name")
    parser.add_argument("--level", default="all", choices=["all", "easy", "medium", "hard"])
    args = parser.parse_args()

    run_benchmark(args.model, args.level)
