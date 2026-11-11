#!/bin/bash
# Gate for publishing the rendered guide: the generated pages must carry no internal process marker.
# Same marker classes as check 12 of security_audit.sh, but with no baseline: a published site
# carries zero. Scans every text file under the output directory (HTML, JSON, XML, JS, CSS, TXT, MD).
# Prints the number of files scanned (the denominator) and the hits (file:line:marker), and exits 1
# on any hit and 2 on any read error, so a deploy job that runs it does not publish.
# The search is done in Python (not grep -P, which BSD grep lacks: a grep error must never read as
# "no marker").
# Usage: bash .github/scripts/output_marker_sweep.sh [output-dir]   (default: output)
set -u
OUT="${1:-output}"
[ -d "$OUT" ] || { echo "no directory: $OUT"; exit 2; }
python3 -I - "$OUT" <<'PY'
import os, re, sys
out = sys.argv[1]
# assembled from fragments so this file does not match itself
pat = re.compile("AUTHORED-BY-CL" "AUDE|\\bT[1-6] S[0-9]+\\b|Pit" "fall #|Les" "son #|Li" "ção #|FA" "Q Q|VR" "F-|_TO_"
                 "GM_|CONTINUE_" "HERE|SESSION_" "COMPLETE|\\bRS(?:0|[1-9]|1[0-5])\\b|\\bG[1-4]\\b|US" "ER\\b")
ext = (".html", ".json", ".xml", ".js", ".css", ".txt", ".md")
n = 0; hits = []
for root, _, files in os.walk(out):
    for f in files:
        if not f.endswith(ext): continue
        p = os.path.join(root, f); n += 1
        try:
            with open(p, encoding="utf-8", errors="strict") as fh:
                for i, line in enumerate(fh, 1):
                    for m in pat.finditer(line):
                        hits.append(f"{p}:{i}:{m.group(0)}")
        except UnicodeDecodeError:
            with open(p, encoding="latin-1") as fh:
                for i, line in enumerate(fh, 1):
                    for m in pat.finditer(line):
                        hits.append(f"{p}:{i}:{m.group(0)}")
print(f"files scanned: {n}")
if n == 0:
    print("nothing to scan"); sys.exit(2)
files_hit = sorted({h.rsplit(":", 2)[0] for h in hits})
print(f"files with markers: {len(files_hit)}")
for h in hits[:200]: print(h)
sys.exit(1 if hits else 0)
PY
