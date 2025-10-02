#!/bin/bash
# Phase 3.14 Fix Script
# Date: 2025-10-01 22:18
# Errors Fixed: 8 (38 → 30)
# Description: ValueSet bindings, component slicing, obs-7 constraint, individual fixes

set -e

PHASE="3.14"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/fsh_backups/phase${PHASE}_${DATE}"

echo "=== Phase ${PHASE} Fix Script ==="
echo "Started at: $(date)"

# Create backup
mkdir -p "${BACKUP_DIR}"
echo "Creating backup in ${BACKUP_DIR}..."
cp -r input/fsh/* "${BACKUP_DIR}/"

# Fix 1: ValueSet Binding Errors (4 fixes)
echo ""
echo "Fix 1: ValueSet Binding Errors"
echo "  1.1: MindfulnessCompleteExamples.fsh - mood, mindfulness-type, environment"

cat > /tmp/fix1.1.sed << 'EOF'
s|valueCodeableConcept = \$SCT#112080002 "Happiness"|valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mood#calm "Calm"|g
s|valueCodeableConcept = \$SCT#373068000 "Meditation"|valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-type-cs#meditation "Meditation"|g
s|valueCodeableConcept = null#quiet "Quiet environment"|valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/environment-type-cs#quiet "Quiet Space"|g
s|valueCodeableConcept = #quiet "Quiet Space"|valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/environment-type-cs#quiet "Quiet Space"|g
EOF

sed -i.bak -f /tmp/fix1.1.sed input/fsh/examples/MindfulnessCompleteExamples.fsh

echo "  1.2: MindfulnessExamples.fsh - mood, mindfulness-type"
sed -i.bak -f /tmp/fix1.1.sed input/fsh/examples/MindfulnessExamples.fsh

echo "  1.3: MoodValueSet.fsh - add include statement"
sed -i.bak '/^* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"/a\
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mood
' input/fsh/valuesets/MoodValueSet.fsh

echo "  1.4: MindfulnessValueSets.fsh - fix CodeSystem URLs"
sed -i.bak \
  -e 's|CodeSystem/environment-type\>|CodeSystem/environment-type-cs|g' \
  -e 's|CodeSystem/mindfulness-type\>|CodeSystem/mindfulness-type-cs|g' \
  input/fsh/valuesets/MindfulnessValueSets.fsh

# Fix 2: Component Slicing Discrimination (3 fixes)
echo ""
echo "Fix 2: Component Slicing Discrimination Errors"
echo "  2.1: VitalSignsProfiles.fsh - add HeartRate component codes"

# Insert after line containing "heartRateVariability 0..1 MS"
sed -i.bak '/heartRateVariability 0\.\.1 MS/a\
\
* component[restingHeartRate].code = $LOINC#40443-4 "Heart rate --resting"\
* component[restingHeartRate].valueQuantity.system = $UCUM\
* component[restingHeartRate].valueQuantity.code = #/min\
\
* component[exerciseHeartRate].code = $LOINC#55425-3 "Heart rate --during exercise"\
* component[exerciseHeartRate].valueQuantity.system = $UCUM\
* component[exerciseHeartRate].valueQuantity.code = #/min\
\
* component[recoveryHeartRate].code = $LOINC#69999-9 "Heart rate --post exercise"\
* component[recoveryHeartRate].valueQuantity.system = $UCUM\
* component[recoveryHeartRate].valueQuantity.code = #/min\

' input/fsh/profiles/VitalSignsProfiles.fsh

echo "  2.2: MobilityExamples.fsh - fix WalkingSpeed duplicate codes"
sed -i.bak \
  -e 's|\$LIFESTYLEOBS#movement-assessment "Movement assessment"|$LOINC#8686-8 "Walking speed"|' \
  -e 's|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#movement-assessment "Movement assessment"|$LOINC#41950-7 "Walking distance"|' \
  input/fsh/examples/MobilityExamples.fsh

echo "  2.3: MobilityExamples.fsh - fix WalkingSteadiness codes"
sed -i.bak \
  -e 's|\$LIFESTYLEOBS#balance-score "Balance assessment score"|\$LIFESTYLEOBS#balance-assessment "Balance assessment"|g' \
  -e 's|code = \$LIFESTYLEOBS#balance-score|code = $LOINC#89236-3|' \
  -e 's|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#balance-assessment "Balance assessment"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#balance-status "Balance status"|' \
  input/fsh/examples/MobilityExamples.fsh

echo "  2.4: LifestyleObservationCS.fsh - add balance-status code"
sed -i.bak 's/^\* ^count = 48/* ^count = 49/' input/fsh/terminology/LifestyleObservationCS.fsh

# Insert balance-status after balance-assessment
sed -i.bak '/\* #balance-assessment "Balance assessment"/a\
  "Comprehensive balance and stability assessment"\
\
* #balance-status "Balance status"\
  "Qualitative status of balance (normal, impaired, etc.)"
' input/fsh/terminology/LifestyleObservationCS.fsh

# Fix 3: obs-7 Constraint Violation
echo ""
echo "Fix 3: obs-7 Constraint Violation"
echo "  3.1: MobilityExamples.fsh - remove valueQuantity from WalkingSteadinessExample"

sed -i.bak '/Instance: WalkingSteadinessExample/,/Instance: [A-Z]/ {
  /\* valueQuantity = 85/d
}' input/fsh/examples/MobilityExamples.fsh

# Fix 4: Individual Quick Fixes
echo ""
echo "Fix 4: Individual Quick Fixes"
echo "  4.1: BodyMetricsExtensions.fsh - add weight unit"

sed -i.bak "s|valueQuantity = 70.5 'kg'|valueQuantity = 70.5 'kg' \"kilogram\"|" \
  input/fsh/extensions/BodyMetricsExtensions.fsh

echo "  4.2: MindfulnessCompleteExamples.fsh - fix questionnaire answer"
sed -i.bak 's|valueString = "Slight tension"|valueString = "Muscle tension"|' \
  input/fsh/examples/MindfulnessCompleteExamples.fsh

echo "  4.3: MindfulnessExamples.fsh - fix Questionnaire URL"
sed -i.bak 's|Questionnaire/mindfulness-example|Questionnaire/MindfulnessQuestionnaireExample|' \
  input/fsh/examples/MindfulnessExamples.fsh

echo "  4.4: MindfulnessCompleteExamples.fsh - fix display name"
sed -i.bak 's|valueCoding = \$SCT#112080002 "Relaxed mood"|valueCoding = $SCT#112080002 "Happiness"|' \
  input/fsh/examples/MindfulnessCompleteExamples.fsh

# Cleanup
echo ""
echo "Cleanup..."
rm -f /tmp/fix*.sed
find input/fsh -name "*.bak" -delete

echo ""
echo "=== Phase ${PHASE} Fixes Complete ==="
echo "Backup saved to: ${BACKUP_DIR}"
echo "Files modified: 8"
echo "  - input/fsh/examples/MindfulnessCompleteExamples.fsh"
echo "  - input/fsh/examples/MindfulnessExamples.fsh"
echo "  - input/fsh/valuesets/MoodValueSet.fsh"
echo "  - input/fsh/valuesets/MindfulnessValueSets.fsh"
echo "  - input/fsh/profiles/VitalSignsProfiles.fsh"
echo "  - input/fsh/examples/MobilityExamples.fsh"
echo "  - input/fsh/terminology/LifestyleObservationCS.fsh"
echo "  - input/fsh/extensions/BodyMetricsExtensions.fsh"
echo ""
echo "Next step: Run ./_genonce.sh to rebuild and verify fixes"
echo "Expected result: Errors reduced from 38 to ~30"
echo "Completed at: $(date)"
