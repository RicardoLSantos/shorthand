#!/bin/bash

# PHASE 3.5: Final LOINC Code Corrections
# Fix remaining incorrect LOINC codes across all profiles

echo "==================================================================="
echo "PHASE 3.5: Final LOINC Code Corrections"
echo "==================================================================="
echo ""

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backups/backup_fsh"
mkdir -p "$BACKUP_DIR"

LOCALCS="https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"

# Backup all profiles
echo "Creating backups..."
for file in input/fsh/profiles/*.fsh; do
    cp "$file" "$BACKUP_DIR/$(basename $file .fsh)_${TIMESTAMP}.fsh"
done
echo "✓ Backups created"
echo ""

# Environmental codes
echo "1. Environmental codes..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e "s|http://loinc.org#89026-9|${LOCALCS}#exposure-time|g" \
  -e "s|http://loinc.org#89027-7|${LOCALCS}#uv-intensity|g" \
  -e 's|\$LOINC#89026-9[^"]*"[^"]*"|'"${LOCALCS}"'#exposure-time "Time of environmental exposure"|g' \
  -e 's|\$LOINC#89027-7[^"]*"[^"]*"|'"${LOCALCS}"'#uv-intensity "UV intensity"|g' \
  {} \;

# Advanced Vital Signs codes
echo "2. Advanced Vital Signs codes..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e "s|http://loinc.org#87834-8|${LOCALCS}#hrv-frequency|g" \
  -e "s|http://loinc.org#87835-5|${LOCALCS}#hrv-entropy|g" \
  -e "s|http://loinc.org#87836-3|${LOCALCS}#pulse-wave|g" \
  -e "s|http://loinc.org#87837-1|${LOCALCS}#respiratory-variability|g" \
  -e "s|http://loinc.org#87838-9|${LOCALCS}#oxygenation-index|g" \
  -e "s|http://loinc.org#87839-7|${LOCALCS}#physiological-stress-index|g" \
  -e "s|http://loinc.org#87840-5|${LOCALCS}#temperature-gradient|g" \
  -e "s|http://loinc.org#87841-3|${LOCALCS}#autonomic-balance|g" \
  -e "s|http://loinc.org#87842-1|${LOCALCS}#recovery-rate|g" \
  {} \;

# Mobility codes
echo "3. Mobility codes..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e "s|http://loinc.org#LA32-8|${LOCALCS}#balance-score|g" \
  -e 's|#LA32-8 "Balance[^"]*"|#balance-score "Balance assessment score"|g' \
  {} \;

# Nutrition codes
echo "4. Nutrition codes..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e "s|http://loinc.org#9051-4|${LOCALCS}#caloric-intake|g" \
  -e "s|http://loinc.org#LP35921-3|${LOCALCS}#protein-intake|g" \
  -e "s|http://loinc.org#LP35922-1|${LOCALCS}#fat-intake|g" \
  -e "s|http://loinc.org#LP35925-4|${LOCALCS}#carbohydrate-intake|g" \
  {} \;

# Reproductive codes
echo "5. Reproductive codes..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e "s|http://loinc.org#8669-4|${LOCALCS}#ovulation-status|g" \
  -e 's|\$LOINC#8669-4[^"]*"[^"]*"|'"${LOCALCS}"'#ovulation-status "Ovulation status"|g' \
  {} \;

# Body Composition panel
echo "6. Body Composition panel..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e "s|http://loinc.org#88365-2|${LOCALCS}#body-composition-panel|g" \
  -e 's|\$LOINC#88365-2 "Body composition panel"|'"${LOCALCS}"'#body-composition-panel "Body composition measurement panel"|g' \
  {} \;

# Stress display fix
echo "7. Stress display name..."
find input/fsh -name "*.fsh" -type f -exec sed -i.bak \
  -e 's|#64394-0 "PhenX - perceived stress protocol"|#64394-0 "PhenX - perceived stress protocol 180801"|g' \
  {} \;

# Clean up .bak files
find input/fsh -name "*.bak" -delete

echo ""
echo "✓ All corrections applied"
echo ""
echo "Running SUSHI..."
sushi .

echo ""
echo "==================================================================="
echo "PHASE 3.5 Complete"
echo "==================================================================="
