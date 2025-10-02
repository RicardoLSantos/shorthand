#!/bin/bash

# Phase 3.7: Replace ALL Incorrect LOINC Codes with Local Codes
# Generated: 2025-10-01
# Purpose: Fix remaining 153 errors by replacing incorrect LOINC codes

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh/phase3.7_${TIMESTAMP}"

echo "========================================="
echo "Phase 3.7: Replace Incorrect LOINC Codes"
echo "========================================="
echo "Timestamp: ${TIMESTAMP}"
echo

# Create backup
mkdir -p "${BACKUP_DIR}"
echo "Creating backups in ${BACKUP_DIR}..."
cp -r input/fsh/profiles/*.fsh "${BACKUP_DIR}/" 2>/dev/null || true
cp -r input/fsh/examples/*.fsh "${BACKUP_DIR}/" 2>/dev/null || true

echo "Backup created."
echo

# ============================================================================
# 1. ENVIRONMENTAL CODES (Hearing Tests → Noise/UV codes)
# ============================================================================

echo "1. Fixing Environmental codes (noise and UV)..."

# Noise codes (Hearing Tests 89020-2 to 89025-1)
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#89020-2 "Environmental noise average"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-avg "Environmental noise average level"|g' \
  -e 's|\$LOINC#89020-2|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-avg|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#89021-0 "Environmental noise duration"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-duration "Environmental noise exposure duration"|g' \
  -e 's|\$LOINC#89021-0|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-duration|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#89024-4 "Peak sound level"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-peak "Peak environmental sound level"|g' \
  -e 's|\$LOINC#89024-4|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-peak|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#89025-1 "Background noise level"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-background "Background environmental noise level"|g' \
  -e 's|\$LOINC#89025-1|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-background|g' \
  {} \;

# UV codes (Hearing Tests 89022-8, 89023-6)
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#89022-8 "UV index"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-index "UV index"|g' \
  -e 's|\$LOINC#89022-8|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-index|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#89023-6 "UV exposure duration"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-duration "UV exposure duration"|g' \
  -e 's|\$LOINC#89023-6|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-duration|g' \
  {} \;

echo "✓ Environmental codes fixed"

# ============================================================================
# 2. ADVANCED VITAL SIGNS (Protein/CTA Tests → HRV/Physiological codes)
# ============================================================================

echo "2. Fixing Advanced Vital Signs codes..."

# HRV and cardiovascular metrics (87834-8 to 87843-9 are Protein/CTA tests)
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87834-8 "Heart rate variability \[Frequency band\]"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#hrv-frequency "Heart rate variability frequency band"|g' \
  -e 's|\$LOINC#87834-8|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#hrv-frequency|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87835-5 "Heart rate variability entropy"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#hrv-entropy "Heart rate variability entropy"|g' \
  -e 's|\$LOINC#87835-5|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#hrv-entropy|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87836-3 "Pulse wave analysis"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#pulse-wave "Pulse wave analysis"|g' \
  -e 's|\$LOINC#87836-3|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#pulse-wave|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87837-1 "Respiratory rate variability"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#respiratory-variability "Respiratory rate variability"|g' \
  -e 's|\$LOINC#87837-1|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#respiratory-variability|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87838-9 "Oxygenation index"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#oxygenation-index "Oxygenation index"|g' \
  -e 's|\$LOINC#87838-9|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#oxygenation-index|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87839-7 "Physiological stress index"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#physiological-stress "Physiological stress index"|g' \
  -e 's|\$LOINC#87839-7|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#physiological-stress|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87840-5 "Temperature gradient"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#temperature-gradient "Temperature gradient"|g' \
  -e 's|\$LOINC#87840-5|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#temperature-gradient|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87841-3 "Autonomic balance index"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#autonomic-balance "Autonomic balance index"|g' \
  -e 's|\$LOINC#87841-3|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#autonomic-balance|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87842-1 "Recovery rate index"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#recovery-rate "Recovery rate index"|g' \
  -e 's|\$LOINC#87842-1|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#recovery-rate|g' \
  {} \;

find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#87843-9 "Allostatic load index"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#allostatic-load "Allostatic load index"|g' \
  -e 's|\$LOINC#87843-9|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#allostatic-load|g' \
  {} \;

echo "✓ Advanced vital signs codes fixed"

# ============================================================================
# 3. FIX DISPLAY NAMES FOR VALID LOINC CODES
# ============================================================================

echo "3. Fixing display names for valid LOINC codes..."

# Fix 8342-8 (Lean body mass) - use official display
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#8342-8 "Lean body mass"|$LOINC#8342-8 "Lean body weight Immersion"|g' \
  {} \;

# Fix 9051-4 display if needed
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|$LOINC#9051-4 "SpO2"|$LOINC#9051-4 "Oxygen saturation in Arterial blood by Pulse oximetry"|g' \
  {} \;

echo "✓ Display names fixed"

# Clean up .bak files
find input/fsh -name "*.fsh.bak" -delete

echo
echo "========================================="
echo "Phase 3.7 Complete!"
echo "========================================="
echo "Backups saved in: ${BACKUP_DIR}"
echo
echo "Changes made:"
echo "  - Replaced 6 environmental LOINC codes with local codes"
echo "  - Replaced 10 advanced vital signs LOINC codes with local codes"
echo "  - Fixed display names for valid LOINC codes"
echo
echo "Next steps:"
echo "  1. Run SUSHI to validate"
echo "  2. Run full IG build"
echo "  3. Check qa.html for error reduction"
echo

