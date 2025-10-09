#!/bin/bash
# Phase 3.1b: SNOMED CT Medium Confidence + Device Fixes
# Generated: 2025-09-30 20:45:00
# Expected: -10 to -15 errors (235 → ~220)
#
# MEDIUM CONFIDENCE + DEVICE FIXES (9 corrections):
# 8. Calm mood: 130991005 → 102894008
# 9. Relaxation therapy: 276241001 → 363894002
# 10. Intensity/Severity: 725854004 → 246112005
# 11. Sleep monitor device: 706172001 → 49062001
# 12. Heart rate (observable): 720737000 → 364075005
# 13. Respiratory rate: 258158006 → 86290005
# 14. Environmental monitor: 706689003 → 462242008
# 15. Measurement technique: 37016008 → 246501002
# 16. Social circumstances: 364311006 → 405191000

set -e

echo "=========================================="
echo "Phase 3.1b: SNOMED CT Medium Confidence + Device Fixes"
echo "=========================================="
echo ""
echo "Creating backups..."

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh"
mkdir -p "$BACKUP_DIR"

# Backup all affected files
FILES_TO_BACKUP=(
  "input/fsh/examples/MindfulnessCompleteExamples.fsh"
  "input/fsh/examples/MindfulnessExamples.fsh"
  "input/fsh/examples/DeviceExamples.fsh"
  "input/fsh/examples/SleepExamples.fsh"
  "input/fsh/examples/EnvironmentalExamples.fsh"
  "input/fsh/profiles/observations/activity/MindfulnessProfiles.fsh"
  "input/fsh/valuesets/ReproductiveValueSets.fsh"
)

for file in "${FILES_TO_BACKUP[@]}"; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    cp "$file" "$BACKUP_DIR/${filename%.fsh}_${TIMESTAMP}.fsh"
    echo "  ✓ Backed up: $filename"
  fi
done

echo ""
echo "Applying fixes..."

# FIX 8: Calm mood - 130991005 → 102894008
echo "8. Fixing Calm/Neutral mood code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#130991005 "Neutral mood"/#102894008 "Feeling calm"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/130991005 "Neutral mood"/102894008 "Feeling calm"/g' {} +

# FIX 9: Relaxation therapy - 276241001 → 363894002
echo "9. Fixing Relaxation technique code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#276241001 "Relaxation technique"/#363894002 "Relaxation therapy"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/276241001 "Relaxation technique"/363894002 "Relaxation therapy"/g' {} +

# FIX 10: Intensity/Severity - 725854004 → 246112005
echo "10. Fixing Intensity attribute code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#725854004 "Intensity"/#246112005 "Severity"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/725854004 "Intensity"/246112005 "Severity"/g' {} +

# FIX 11: Sleep monitor device - 706172001 → 49062001
echo "11. Fixing Sleep monitor device code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#706172001 "Sleep monitoring device"/#49062001 "Device"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/706172001 "Sleep monitoring device"/49062001 "Device"/g' {} +

# FIX 12: Heart rate - 720737000 → 364075005
echo "12. Fixing Heart rate code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#720737000 "Pulse rate monitoring device"/#364075005 "Heart rate"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/720737000 "Pulse rate monitoring device"/364075005 "Heart rate"/g' {} +

# FIX 13: Respiratory rate - 258158006 → 86290005
echo "13. Fixing Respiratory rate code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#258158006 "Breathing rate"/#86290005 "Respiratory rate"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/258158006 "Breathing rate"/86290005 "Respiratory rate"/g' {} +

# FIX 14: Environmental monitor - 706689003 → 462242008 (only for environmental devices)
echo "14. Fixing Environmental monitoring device code..."
# Cuidado: 706689003 é usado tanto para environmental devices quanto para iPhone
# Vamos substituir apenas nos contextos de environmental monitoring
sed -i '' 's/#706689003 "Environmental monitoring device"/#462242008 "Monitor"/g' input/fsh/examples/EnvironmentalExamples.fsh 2>/dev/null || true
sed -i '' 's/706689003 "Environmental monitoring device"/462242008 "Monitor"/g' input/fsh/examples/EnvironmentalExamples.fsh 2>/dev/null || true

# FIX 15: Measurement technique - 37016008 → 246501002
echo "15. Fixing Measurement method/technique code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#37016008 "Measurement method"/#246501002 "Technique"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/37016008 "Measurement method"/246501002 "Technique"/g' {} +

# FIX 16: Social circumstances - 364311006 → 405191000
echo "16. Fixing Social history goals code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#364311006/#405191000/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/364311006/405191000/g' {} +

echo ""
echo "✓ All 9 medium confidence + device fixes applied!"
echo ""
echo "Files modified:"
echo "  - input/fsh/examples/MindfulnessCompleteExamples.fsh"
echo "  - input/fsh/examples/MindfulnessExamples.fsh"
echo "  - input/fsh/examples/DeviceExamples.fsh"
echo "  - input/fsh/examples/SleepExamples.fsh"
echo "  - input/fsh/examples/EnvironmentalExamples.fsh"
echo "  - input/fsh/profiles/observations/activity/MindfulnessProfiles.fsh"
echo "  - input/fsh/valuesets/ReproductiveValueSets.fsh"
echo ""
echo "=========================================="
echo "Next: Run ./_genonce.sh to validate"
echo "Expected: 235 → ~220 errors"
echo "=========================================="
