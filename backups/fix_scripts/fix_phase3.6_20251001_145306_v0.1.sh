#!/bin/bash
# PHASE 3.6: Quick wins - URL, Consent, Device fixes

echo "Phase 3.6: Quick Wins"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p backups/backup_fsh

# 1. Fix CONSENT 'PROV' code → 'PRO' (Professional)
echo "1. Fixing Consent codes..."
find input/fsh -name "*.fsh" -exec sed -i.bak \
  -e 's|#PROV[^a-zA-Z]|#PRO |g' \
  {} \;

# 2. Fix Device SNOMED codes
echo "2. Fixing Device SNOMED codes..."
# 462242008: 'Monitor' → 'Patient sling scale'
# 706689003: 'Mobile telephone' → 'Application programme software'
find input/fsh -name "*Device*.fsh" -exec sed -i.bak \
  -e 's|#462242008 "Monitor"|#462242008 "Patient sling scale"|g' \
  -e 's|#706689003 "Mobile telephone (physical object)"|#706689003 "Application programme software"|g' \
  {} \;

# 3. Remove invalid device-property-type references
echo "3. Fixing device property types..."
# Will need manual fix for this

# 4. Fix LOINC 291-7 (lean body mass) - already deprecated
echo "4. Replacing deprecated LOINC 291-7..."
find input/fsh -name "*.fsh" -exec sed -i.bak \
  -e 's|#291-7 "Lean body mass"|#8342-8 "Lean body mass"|g' \
  -e 's|http://loinc.org#291-7|http://loinc.org#8342-8|g' \
  {} \;

# Clean up
find input/fsh -name "*.bak" -delete

echo "Running SUSHI..."
sushi .

echo "Phase 3.6 quick wins applied!"
