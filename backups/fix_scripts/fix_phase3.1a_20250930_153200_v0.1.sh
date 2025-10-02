
#!/bin/bash
# Phase 3.1a: SNOMED CT High Confidence Fixes
# Generated: 2025-09-30 15:32:00
# Expected: -15 to -20 errors (246 → ~230)
#
# HIGH CONFIDENCE FIXES (7 corrections):
# 1. Fatigue: 267036007 → 84229001
# 2. Mood finding: 373931001 → 106131003
# 3. Walking: 228557008 → 129006008
# 4. Blood pressure monitor: 43770009 → 258057004
# 5. Duration attribute: 118682006 → 704323007
# 6. Symptom severity: 246604007 → 246112005
# 7. Before breakfast: 307818003 → 307157005

set -e

echo "=========================================="
echo "Phase 3.1a: SNOMED CT High Confidence Fixes"
echo "=========================================="
echo ""
echo "Creating backups..."

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh"
mkdir -p "$BACKUP_DIR"

# Backup all affected files
FILES_TO_BACKUP=(
  "input/fsh/examples/SymptomExamples.fsh"
  "input/fsh/examples/MindfulnessCompleteExamples.fsh"
  "input/fsh/examples/MindfulnessExamples.fsh"
  "input/fsh/examples/PhysicalActivityExamples.fsh"
  "input/fsh/examples/DeviceExamples.fsh"
  "input/fsh/examples/VitalSignsExamples.fsh"
  "input/fsh/profiles/observations/activity/MindfulnessProfiles.fsh"
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

# FIX 1: Fatigue - 267036007 → 84229001
echo "1. Fixing Fatigue code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#267036007 "Fatigue"/#84229001 "Fatigue"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/267036007 "Fatigue"/84229001 "Fatigue"/g' {} +

# FIX 2: Mood finding - 373931001 → 106131003
echo "2. Fixing Mood finding code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#373931001 "Mood finding"/#106131003 "Mood finding"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/373931001 "Mood finding"/106131003 "Mood finding"/g' {} +

# FIX 3: Walking - 228557008 → 129006008
echo "3. Fixing Walking code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#228557008 "Walking"/#129006008 "Walking"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/228557008 "Walking"/129006008 "Walking"/g' {} +

# FIX 4: Blood pressure monitor - 43770009 → 258057004
echo "4. Fixing Blood pressure monitor code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#43770009 "Blood pressure monitor"/#258057004 "Non-invasive blood pressure monitor"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/43770009 "Blood pressure monitor"/258057004 "Non-invasive blood pressure monitor"/g' {} +

# FIX 5: Duration attribute - 118682006 → 704323007
echo "5. Fixing Duration attribute code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#118682006 "Duration"/#704323007 "Process duration"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/118682006 "Duration"/704323007 "Process duration"/g' {} +

# FIX 6: Symptom severity - 246604007 → 246112005
echo "6. Fixing Symptom severity code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#246604007 "Severity"/#246112005 "Severity"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/246604007 "Severity"/246112005 "Severity"/g' {} +

# FIX 7: Before breakfast - 307818003 → 307157005
echo "7. Fixing Before breakfast code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/#307818003 "Pre-breakfast"/#307157005 "Before breakfast"/g' {} +
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  's/307818003 "Pre-breakfast"/307157005 "Before breakfast"/g' {} +

echo ""
echo "✓ All 7 high confidence fixes applied!"
echo ""
echo "Files modified:"
echo "  - input/fsh/examples/SymptomExamples.fsh"
echo "  - input/fsh/examples/MindfulnessCompleteExamples.fsh"
echo "  - input/fsh/examples/MindfulnessExamples.fsh"
echo "  - input/fsh/examples/PhysicalActivityExamples.fsh"
echo "  - input/fsh/examples/DeviceExamples.fsh"
echo "  - input/fsh/examples/VitalSignsExamples.fsh"
echo "  - input/fsh/profiles/observations/activity/MindfulnessProfiles.fsh"
echo ""
echo "=========================================="
echo "Next: Run ./_genonce.sh to validate"
echo "Expected: 246 → ~230 errors"
echo "=========================================="
