#!/bin/bash

# PHASE 3.3: StructureDefinition LOINC Code Fixes
# Fix incorrect LOINC codes in Sleep Profile that are causing display name errors
# These codes were mapped to wrong LOINC codes - switching to local codes

echo "==================================================================="
echo "PHASE 3.3: StructureDefinition LOINC Code Corrections"
echo "==================================================================="
echo ""
echo "Target: Fix 136 StructureDefinition errors"
echo "Strategy: Replace incorrect LOINC codes with local codes"
echo ""

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backups/backup_fsh"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Creating backups..."
cp input/fsh/profiles/SleepProfile.fsh "$BACKUP_DIR/SleepProfile_${TIMESTAMP}.fsh"
cp input/fsh/examples/SleepExamples.fsh "$BACKUP_DIR/SleepExamples_${TIMESTAMP}.fsh"

echo "✓ Backups created in $BACKUP_DIR"
echo ""

# Alias for local codesystem
LOCALCS="https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"

echo "Fixing SleepProfile.fsh..."
echo "-------------------------------------------------------------------"

# Fix 1: Main sleep panel code - use local code instead of wrong LOINC
echo "  1. Replacing sleep panel code (93832-4 -> local)"
sed -i.bak 's|^\* code = \$LOINC#93832-4 "Sleep pattern panel"|* code from LifestyleObservationVS (required)\n* code = '${LOCALCS}'#sleep-panel "Sleep measurement panel"|' \
  input/fsh/profiles/SleepProfile.fsh

# Fix 2: Time in bed - use local code
echo "  2. Replacing time in bed code (93831-6 -> sleep-time-bed)"
sed -i.bak 's|\* component\[timeInBed\]\.code = \$LOINC#93831-6 "Time in bed"|* component[timeInBed].code = '${LOCALCS}'#sleep-time-bed "Time in bed"|' \
  input/fsh/profiles/SleepProfile.fsh

# Fix 3: Total sleep time - This LOINC code is WRONG (it's for flights climbed!)
echo "  3. Replacing total sleep time code (93833-2 -> LOINC 93832-4)"
sed -i.bak 's|\* component\[totalSleepTime\]\.code = \$LOINC#93833-2 "Sleep duration"|* component[totalSleepTime].code = \$LOINC#93832-4 "Sleep duration"|' \
  input/fsh/profiles/SleepProfile.fsh

# Fix 4: Deep sleep - use local code (current is Coccidioides test!)
echo "  4. Replacing deep sleep code (93834-0 -> sleep-deep)"
sed -i.bak 's|\* component\[deepSleep\]\.code = \$LOINC#93834-0 "Deep activity duration"|* component[deepSleep].code = '${LOCALCS}'#sleep-deep "Deep sleep duration"|' \
  input/fsh/profiles/SleepProfile.fsh

# Fix 5: Light sleep - use local code (current is also Coccidioides!)
echo "  5. Replacing light sleep code (93836-5 -> sleep-light)"
sed -i.bak 's|\* component\[lightSleep\]\.code = \$LOINC#93836-5 "Light activity duration"|* component[lightSleep].code = '${LOCALCS}'#sleep-light "Light sleep duration"|' \
  input/fsh/profiles/SleepProfile.fsh

# Fix 6: Sleep awakenings - use local code
echo "  6. Replacing awakenings code (93837-3 -> sleep-awakenings)"
sed -i.bak 's|\* component\[interruptions\]\.code = \$LOINC#93837-3 "Number of awakenings during activity"|* component[interruptions].code = '${LOCALCS}'#sleep-awakenings "Number of sleep awakenings"|' \
  input/fsh/profiles/SleepProfile.fsh

# Remove .bak files
rm -f input/fsh/profiles/SleepProfile.fsh.bak

echo "✓ SleepProfile.fsh fixed"
echo ""

echo "Fixing SleepExamples.fsh..."
echo "-------------------------------------------------------------------"

# Apply same fixes to examples
sed -i.bak "s|http://loinc.org#93831-6|${LOCALCS}#sleep-time-bed|g" input/fsh/examples/SleepExamples.fsh
sed -i.bak 's|http://loinc.org#93833-2|http://loinc.org#93832-4|g' input/fsh/examples/SleepExamples.fsh
sed -i.bak "s|http://loinc.org#93834-0|${LOCALCS}#sleep-deep|g" input/fsh/examples/SleepExamples.fsh
sed -i.bak "s|http://loinc.org#93836-5|${LOCALCS}#sleep-light|g" input/fsh/examples/SleepExamples.fsh
sed -i.bak "s|http://loinc.org#93837-3|${LOCALCS}#sleep-awakenings|g" input/fsh/examples/SleepExamples.fsh

rm -f input/fsh/examples/SleepExamples.fsh.bak

echo "✓ SleepExamples.fsh fixed"
echo ""

echo "==================================================================="
echo "Running SUSHI to validate changes..."
echo "==================================================================="
echo ""

sushi .

echo ""
echo "==================================================================="
echo "PHASE 3.3 Script Complete"
echo "==================================================================="
echo ""
echo "Files modified:"
echo "  ✓ input/fsh/profiles/SleepProfile.fsh"
echo "  ✓ input/fsh/examples/SleepExamples.fsh"
echo ""
echo "Backups saved to: $BACKUP_DIR/*_${TIMESTAMP}.fsh"
echo ""
echo "Next: Run full IG build to measure error reduction"
echo "      ./_build.sh"
echo ""
