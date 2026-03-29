"""
HEADS-ETL RAG Terminology Suggestion Engine
============================================================================
Version: 0.1.0 (2026-01-27)
Purpose: RAG-assisted terminology mapping for unmapped LOINC/OMOP concepts

Architecture (inspired by OntologyRAG2025, BiomedNorm2024, MedGraphRAG2024):
- Tier 4 in the 5-tier resolution: Cache → Athena → OCL → RAG → Hardcoded
- Does NOT map automatically — suggests candidates with confidence scores
- Supports two backends:
  (a) ChromaDB + Ollama (full RAG, requires installation)
  (b) Fuzzy text matching against Athena CONCEPT.csv (lightweight fallback)

References:
- OntologyRAG (Ye et al. 2025): Knowledge graph + SPARQL retrieval
- BiomedNorm (Pattisapu et al. 2024): 88.31% SNOMED accuracy via RAG
- MedGraphRAG (Wu et al. 2024): Graph-based grounding for clinical safety
============================================================================
"""

import csv
import os
import json
from difflib import SequenceMatcher
from typing import Optional

# ============================================================================
# Configuration
# ============================================================================

ATHENA_CONCEPT_PATH = os.path.join(
    os.path.dirname(os.path.dirname(__file__)), "data", "athena", "CONCEPT.csv"
)

# Known unmapped wearable metrics (thesis gap analysis)
UNMAPPED_WEARABLE_METRICS = {
    "RMSSD": {
        "description": "Root Mean Square of Successive Differences (HRV)",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Primary parasympathetic marker, 83% concordance for inflammation",
        "suggested_domain": "Measurement",
    },
    "pNN50": {
        "description": "Percentage of successive NN intervals differing by >50ms",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Parasympathetic HRV metric",
        "suggested_domain": "Measurement",
    },
    "LF/HF Ratio": {
        "description": "Low-frequency to high-frequency power ratio (HRV)",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Sympathovagal balance indicator",
        "suggested_domain": "Measurement",
    },
    "LF Power": {
        "description": "Low-frequency power spectral density (HRV)",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Mixed sympathetic/parasympathetic",
        "suggested_domain": "Measurement",
    },
    "HF Power": {
        "description": "High-frequency power spectral density (HRV)",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Vagal (parasympathetic) activity",
        "suggested_domain": "Measurement",
    },
    "Sleep Stages": {
        "description": "Sleep stage classification (Wake/Light/Deep/REM)",
        "loinc_status": "NO LOINC CODE for individual stages",
        "clinical_relevance": "Sleep architecture assessment",
        "suggested_domain": "Observation",
    },
    "TIR": {
        "description": "Time in Range (CGM: 70-180 mg/dL)",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Glycemic control metric",
        "suggested_domain": "Measurement",
    },
    "TBR": {
        "description": "Time Below Range (CGM: <70 mg/dL)",
        "loinc_status": "NO LOINC CODE",
        "clinical_relevance": "Hypoglycemia risk metric",
        "suggested_domain": "Measurement",
    },
}


# ============================================================================
# Lightweight Fuzzy Matching (Fallback when ChromaDB unavailable)
# ============================================================================

class AthenaFuzzyMatcher:
    """Fuzzy text matcher against Athena CONCEPT.csv for terminology suggestions.

    This is the lightweight fallback when ChromaDB is not available.
    Inspired by BiomedNorm2024's retrieval approach but using simpler
    string similarity instead of neural embeddings.
    """

    def __init__(self, concept_path: str = ATHENA_CONCEPT_PATH):
        self.concepts = []
        self._loaded = False
        self._path = concept_path

    def load(self, vocabulary_id: str = "LOINC", max_concepts: int = 50000):
        """Load LOINC concepts from Athena CONCEPT.csv."""
        if self._loaded:
            return

        if not os.path.exists(self._path):
            print(f"[RAG] Athena CONCEPT.csv not found at {self._path}")
            return

        print(f"[RAG] Loading {vocabulary_id} concepts from Athena...")
        count = 0
        with open(self._path, "r", encoding="utf-8") as f:
            reader = csv.DictReader(f, delimiter="\t")
            for row in reader:
                if row.get("vocabulary_id") == vocabulary_id and count < max_concepts:
                    self.concepts.append({
                        "concept_id": int(row["concept_id"]),
                        "concept_name": row["concept_name"],
                        "concept_code": row["concept_code"],
                        "standard_concept": row.get("standard_concept", ""),
                    })
                    count += 1

        self._loaded = True
        print(f"[RAG] Loaded {len(self.concepts)} {vocabulary_id} concepts")

    def suggest(self, query: str, top_k: int = 5, min_score: float = 0.3) -> list:
        """Find closest Athena concepts by fuzzy string matching.

        Returns list of {concept_id, concept_name, concept_code, score} sorted by score.
        """
        if not self._loaded:
            self.load()

        if not self.concepts:
            return []

        query_lower = query.lower()
        scored = []

        for concept in self.concepts:
            name = concept["concept_name"].lower()
            # Combined score: partial ratio + contains bonus
            ratio = SequenceMatcher(None, query_lower, name).ratio()

            # Boost if query terms appear in concept name
            terms = query_lower.split()
            term_matches = sum(1 for t in terms if t in name)
            term_bonus = term_matches / max(len(terms), 1) * 0.3

            score = min(ratio + term_bonus, 1.0)

            if score >= min_score:
                scored.append({
                    "concept_id": concept["concept_id"],
                    "concept_name": concept["concept_name"],
                    "concept_code": concept["concept_code"],
                    "standard_concept": concept["standard_concept"],
                    "score": round(score, 4),
                    "method": "fuzzy_match",
                })

        scored.sort(key=lambda x: x["score"], reverse=True)
        return scored[:top_k]


# ============================================================================
# ChromaDB RAG Backend (Full RAG when available)
# ============================================================================

class ChromaRAGMatcher:
    """ChromaDB-based semantic similarity matcher.

    Full RAG implementation using vector embeddings.
    Requires: pip install chromadb
    """

    def __init__(self):
        self.client = None
        self.collection = None
        self._available = False

        try:
            import chromadb
            self.client = chromadb.Client()
            self._available = True
        except ImportError:
            pass

    @property
    def available(self) -> bool:
        return self._available

    def load_from_athena(self, concept_path: str = ATHENA_CONCEPT_PATH,
                         vocabulary_id: str = "LOINC", max_concepts: int = 50000):
        """Index Athena concepts into ChromaDB collection."""
        if not self._available:
            return

        self.collection = self.client.get_or_create_collection(
            name=f"athena_{vocabulary_id.lower()}",
            metadata={"source": "Athena OHDSI", "vocabulary": vocabulary_id}
        )

        if self.collection.count() > 0:
            print(f"[RAG-ChromaDB] Collection already has {self.collection.count()} documents")
            return

        documents = []
        metadatas = []
        ids = []

        with open(concept_path, "r", encoding="utf-8") as f:
            reader = csv.DictReader(f, delimiter="\t")
            count = 0
            for row in reader:
                if row.get("vocabulary_id") == vocabulary_id and count < max_concepts:
                    documents.append(row["concept_name"])
                    metadatas.append({
                        "concept_id": row["concept_id"],
                        "concept_code": row["concept_code"],
                        "standard_concept": row.get("standard_concept", ""),
                    })
                    ids.append(f"{vocabulary_id}_{row['concept_id']}")
                    count += 1

        if documents:
            # Batch insert (ChromaDB limit: 5461 per batch)
            batch_size = 5000
            for i in range(0, len(documents), batch_size):
                self.collection.add(
                    documents=documents[i:i + batch_size],
                    metadatas=metadatas[i:i + batch_size],
                    ids=ids[i:i + batch_size],
                )
            print(f"[RAG-ChromaDB] Indexed {len(documents)} {vocabulary_id} concepts")

    def suggest(self, query: str, top_k: int = 5) -> list:
        """Semantic similarity search via ChromaDB."""
        if not self._available or self.collection is None:
            return []

        results = self.collection.query(
            query_texts=[query],
            n_results=top_k,
        )

        suggestions = []
        if results and results["documents"]:
            for i, doc in enumerate(results["documents"][0]):
                meta = results["metadatas"][0][i]
                distance = results["distances"][0][i] if results.get("distances") else 0
                suggestions.append({
                    "concept_id": int(meta["concept_id"]),
                    "concept_name": doc,
                    "concept_code": meta["concept_code"],
                    "standard_concept": meta.get("standard_concept", ""),
                    "score": round(1.0 - distance, 4),  # Convert distance to similarity
                    "method": "chromadb_embedding",
                })

        return suggestions


# ============================================================================
# Unified RAG Suggestion API
# ============================================================================

class TerminologyRAG:
    """Unified RAG terminology suggestion engine.

    Automatically selects ChromaDB (if available) or fuzzy matching (fallback).
    This is Tier 4 in the 5-tier resolution:
      Cache → Athena Local → OCL API → **RAG Suggestion** → Hardcoded

    Usage:
        rag = TerminologyRAG()
        suggestions = rag.suggest("heart rate variability RMSSD")
        # Returns: [{concept_id, concept_name, score, method}, ...]
    """

    def __init__(self):
        self.chroma = ChromaRAGMatcher()
        self.fuzzy = AthenaFuzzyMatcher()
        self._initialized = False

    @property
    def backend(self) -> str:
        return "chromadb" if self.chroma.available else "fuzzy_match"

    def initialize(self):
        """Load terminology data into the active backend."""
        if self._initialized:
            return

        if self.chroma.available:
            print(f"[RAG] Using ChromaDB backend (semantic embeddings)")
            self.chroma.load_from_athena()
        else:
            print(f"[RAG] ChromaDB not available, using fuzzy matching fallback")
            self.fuzzy.load()

        self._initialized = True

    def suggest(self, query: str, top_k: int = 5) -> list:
        """Get terminology suggestions for a query.

        Args:
            query: Free-text description of the concept to find
            top_k: Number of suggestions to return

        Returns:
            List of suggestion dicts with: concept_id, concept_name,
            concept_code, score (0-1), method
        """
        self.initialize()

        if self.chroma.available:
            return self.chroma.suggest(query, top_k)
        else:
            return self.fuzzy.suggest(query, top_k)

    def suggest_for_unmapped(self, metric_name: str) -> dict:
        """Get suggestions for known unmapped wearable metrics.

        Enhanced with domain knowledge from thesis gap analysis.
        """
        info = UNMAPPED_WEARABLE_METRICS.get(metric_name, {})
        if not info:
            # Generic query
            suggestions = self.suggest(metric_name)
        else:
            # Use enriched query with clinical context
            query = f"{metric_name} {info['description']}"
            suggestions = self.suggest(query)

        return {
            "metric": metric_name,
            "known_info": info,
            "suggestions": suggestions,
            "backend": self.backend,
            "note": "RAG suggestions require human review before use in OMOP mapping",
        }


# ============================================================================
# CLI Interface
# ============================================================================

def main():
    """CLI for testing RAG suggestions."""
    import sys

    rag = TerminologyRAG()
    print(f"Backend: {rag.backend}")

    if len(sys.argv) > 1:
        query = " ".join(sys.argv[1:])
        print(f"\nQuery: '{query}'")
        results = rag.suggest(query)
        for r in results:
            print(f"  [{r['score']:.3f}] {r['concept_code']} - {r['concept_name']} (id={r['concept_id']})")
    else:
        # Test with unmapped metrics
        print("\n=== Unmapped Wearable Metrics Suggestions ===\n")
        for metric in ["RMSSD", "pNN50", "LF/HF Ratio", "TIR"]:
            result = rag.suggest_for_unmapped(metric)
            print(f"--- {metric} ---")
            if result["known_info"]:
                print(f"  Status: {result['known_info'].get('loinc_status', 'unknown')}")
                print(f"  Clinical: {result['known_info'].get('clinical_relevance', '')}")
            for s in result["suggestions"][:3]:
                print(f"  [{s['score']:.3f}] {s['concept_code']} - {s['concept_name']}")
            print()


if __name__ == "__main__":
    main()
