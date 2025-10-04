#!/bin/bash
# Phase 3.2a: LOINC High Confidence Replacements
# Generated: 2025-10-01 08:05:00
# Expected: -8 to -12 errors (230 → ~220)
#
# HIGH CONFIDENCE LOINC FIXES (verified codes):
# 1. Body water mass: 73708-0 → 101683-1
# 2. Bone mass: 73711-4 → 101685-6
# 3. Muscle mass ratio: 73713-0 → 73965-6
# 4. REM sleep duration: 93835-7 → 93829-0
# 5. Social panel: 96766-1 → 76506-5
# 6. Stress assessment: 89592-0 → 64394-0
# 7. Sleep panel: 93832-4 (when used as panel) → 90568-7
# 8. Fix physical activity display names (codes correct)

set -e

echo "=========================================="
echo "Phase 3.2a: LOINC High Confidence Replacements"
echo "=========================================="
echo ""
echo "Creating backups..."

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh"
mkdir -p "$BACKUP_DIR"

# Backup all affected files
FILES_TO_BACKUP=(
  "input/fsh/examples/VitalSignsExamples.fsh"
  "input/fsh/examples/SleepExamples.fsh"
  "input/fsh/examples/SocialInteractionExamples.fsh"
  "input/fsh/examples/StressExamples.fsh"
  "input/fsh/examples/PhysicalActivityExamples.fsh"
  "input/fsh/profiles/BodyMetricsProfiles.fsh"
  "input/fsh/profiles/SleepProfile.fsh"
  "input/fsh/profiles/SocialInteractionProfile.fsh"
  "input/fsh/profiles/StressLevelProfile.fsh"
  "input/fsh/profiles/PhysicalActivityProfile.fsh"
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

# FIX 1: Body water mass - 73708-0 → 101683-1
echo "1. Fixing Body water mass code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#73708-0 "Total body water"/#101683-1 "Body water mass"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/73708-0 "Total body water"/101683-1 "Body water mass"/g' {} +

# FIX 2: Bone mass - 73711-4 → 101685-6
echo "2. Fixing Bone mass code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#73711-4 "Bone mass"/#101685-6 "Body bone mass"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/73711-4 "Bone mass"/101685-6 "Body bone mass"/g' {} +

# FIX 3: Muscle mass - 73713-0 → 73965-6
echo "3. Fixing Muscle mass code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#73713-0 "Muscle mass"/#73965-6 "Body muscle mass\/Body weight"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/73713-0 "Muscle mass"/73965-6 "Body muscle mass\/Body weight"/g' {} +

# FIX 4: REM sleep duration - 93835-7 → 93829-0
echo "4. Fixing REM sleep duration code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#93835-7 "REM activity duration"/#93829-0 "REM sleep duration"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/93835-7 "REM activity duration"/93829-0 "REM sleep duration"/g' {} +

# FIX 5: Social interaction panel - 96766-1 → 76506-5
echo "5. Fixing Social interaction panel code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#96766-1 "Social interaction pattern"/#76506-5 "Social connection and isolation panel"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/96766-1 "Social interaction pattern"/76506-5 "Social connection and isolation panel"/g' {} +

# FIX 6: Stress level - 89592-0 → 64394-0
echo "6. Fixing Stress level assessment code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#89592-0 "Stress level score"/#64394-0 "PhenX - perceived stress protocol"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/89592-0 "Stress level score"/64394-0 "PhenX - perceived stress protocol"/g' {} +

# FIX 7: Sleep panel - only if used as panel code (careful replacement)
echo "7. Fixing Sleep panel code (where used as panel)..."
# This is tricky - need to identify panel usage vs component usage
# For now, we'll document this needs manual review

# FIX 8: Physical Activity display names (codes are correct)
echo "8. Fixing Physical Activity display names..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/55423-8 "Number of steps in 24 hour Measured"/55423-8 "Number of steps in unspecified time Pedometer"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/55430-3 "Distance walked"/55430-3 "Walking distance unspecified time Pedometer"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/55424-6 "Energy expenditure"/55424-6 "Calories burned in unspecified time Pedometer"/g' {} +

echo ""
echo "✓ Phase 3.2a fixes applied!"
echo ""
echo "IMPORTANT NOTES:"
echo "  - Sleep panel code (93832-4 → 90568-7) requires manual review"
echo "  - Some codes still need local CodeSystem (Phase 3.2b)"
echo ""
echo "Files modified:"
echo "  - Body composition examples and profiles"
echo "  - Sleep examples and profiles"
echo "  - Social interaction examples and profiles"
echo "  - Stress examples and profiles"
echo "  - Physical activity examples and profiles"
echo ""
echo "=========================================="
echo "Next: Run ./_genonce.sh to validate"
echo "Expected: 230 → ~220 errors"
echo "=========================================="
