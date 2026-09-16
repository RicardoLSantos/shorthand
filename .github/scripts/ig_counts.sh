#!/usr/bin/env bash
# ig_counts.sh — single source of truth for the artefact counts quoted in README.md.
#
# Counts the FSH declarations in the tracked sources (the same numbers the IG Publisher
# turns into resources) and, with --check, fails when README.md's "Artifact Summary"
# table disagrees — so the README cannot silently drift from the sources again.
#
# Usage:  bash .github/scripts/ig_counts.sh            # print the counts
#         bash .github/scripts/ig_counts.sh --check    # print + verify README.md (exit 1 on drift)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

files=$(git ls-files 'input/fsh/*.fsh' 'input/fsh/**/*.fsh')
count() { { echo "$files" | xargs grep -hE "^$1:" || true; } | wc -l | tr -d ' '; }

P=$(count Profile); E=$(count Extension); C=$(count CodeSystem); V=$(count ValueSet); I=$(count Instance)
X=$(echo "$files" | xargs awk '/^Usage: #example/{n++} END{print n+0}')
M=$(echo "$files" | xargs awk '/^InstanceOf: *ConceptMap/{n++} END{print n+0}')
T=$((P + E + C + V + I))

printf 'Profiles=%s Extensions=%s CodeSystems=%s ValueSets=%s Instances=%s (examples=%s, ConceptMaps=%s) Total=%s\n' \
  "$P" "$E" "$C" "$V" "$I" "$X" "$M" "$T"

if [[ "${1:-}" == "--check" ]]; then
  fail=0
  row() { grep -qE "^\| \*\*$1\*\* \| $2 \|" README.md || { echo "README.md: the $1 row does not say $2"; fail=1; }; }
  row Profiles "$P"; row Extensions "$E"; row CodeSystems "$C"; row ValueSets "$V"; row Instances "$I"
  grep -qE "^\| \*\*Total\*\* \| \*\*$T\*\* \|" README.md || { echo "README.md: the Total row does not say $T"; fail=1; }
  if [[ $fail -ne 0 ]]; then
    echo "Update the Artifact Summary table in README.md to the counts above."; exit 1
  fi
  echo "README.md artefact table matches the FSH sources."
fi
