#!/bin/bash
# Phase 3.2b: Replace Invalid LOINC Codes with Local CodeSystem
# Generated: 2025-10-01 09:30:00
# Expected: -10 to -15 errors (209 → ~195)
#
# LOCAL CODE REPLACEMENTS:
# Environmental Noise (4 codes)
# Sleep Stages (4 codes)
# Social Interaction (4 codes)
# Stress Components (3 codes)

set -e

echo "=========================================="
echo "Phase 3.2b: Local CodeSystem Replacements"
echo "=========================================="
echo ""
echo "Creating backups..."

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh"
mkdir -p "$BACKUP_DIR"

# Backup all affected files
FILES_TO_BACKUP=(
  "input/fsh/examples/EnvironmentalExamples.fsh"
  "input/fsh/examples/SleepExamples.fsh"
  "input/fsh/examples/SocialInteractionExamples.fsh"
  "input/fsh/examples/StressExamples.fsh"
  "input/fsh/examples/VitalSignsExamples.fsh"
  "input/fsh/profiles/EnvironmentalProfiles.fsh"
  "input/fsh/profiles/SleepProfile.fsh"
  "input/fsh/profiles/SocialInteractionProfile.fsh"
  "input/fsh/profiles/StressLevelProfile.fsh"
  "input/fsh/profiles/BodyMetricsProfiles.fsh"
)

for file in "${FILES_TO_BACKUP[@]}"; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    cp "$file" "$BACKUP_DIR/${filename%.fsh}_${TIMESTAMP}.fsh"
    echo "  ✓ Backed up: $filename"
  fi
done

echo ""
echo "Applying local code replacements..."

# Define local CodeSystem URL
LOCAL_CS="https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"

# ENVIRONMENTAL NOISE - Replace invalid LOINC codes with local codes
echo "1. Replacing Environmental Noise codes..."

# Noise average - 89020-2 (invalid) → noise-avg
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89020-2 \"Environmental noise average\"|${LOCAL_CS}#noise-avg \"Environmental noise average level\"|g" {} +

# Noise duration - 89021-0 (invalid) → noise-duration
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89021-0 \"Environmental noise duration\"|${LOCAL_CS}#noise-duration \"Environmental noise exposure duration\"|g" {} +

# Peak sound - 89024-4 (invalid) → noise-peak
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89024-4 \"Peak sound level\"|${LOCAL_CS}#noise-peak \"Peak environmental sound level\"|g" {} +

# Background noise - 89025-1 (invalid) → noise-background
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89025-1 \"Background noise level\"|${LOCAL_CS}#noise-background \"Background environmental noise level\"|g" {} +

# Noise panel - 28573-7 (invalid) - remove or replace with local
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#28573-7|${LOCAL_CS}#noise-avg|g" {} +

echo "   ✓ Environmental noise codes replaced"

# SLEEP STAGES - Replace invalid LOINC codes with local codes
echo "2. Replacing Sleep Stage codes..."

# Deep sleep - 93834-0 (invalid) → sleep-deep
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#93834-0 \"Deep activity duration\"|${LOCAL_CS}#sleep-deep \"Deep sleep duration\"|g" {} +

# Light sleep - 93836-5 (invalid) → sleep-light
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#93836-5 \"Light activity duration\"|${LOCAL_CS}#sleep-light \"Light sleep duration\"|g" {} +

# Awakenings - 93837-3 (invalid) → sleep-awakenings
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#93837-3 \"Number of awakenings during activity\"|${LOCAL_CS}#sleep-awakenings \"Number of sleep awakenings\"|g" {} +

# Time in bed - 93831-6 → sleep-time-bed
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#93831-6 \"Time in bed\"|${LOCAL_CS}#sleep-time-bed \"Time in bed\"|g" {} +

echo "   ✓ Sleep stage codes replaced"

# SOCIAL INTERACTION - Replace invalid LOINC codes with local codes
echo "3. Replacing Social Interaction component codes..."

# Social duration - 89597-9 (invalid) → social-duration
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89597-9 \"Social interaction duration\"|${LOCAL_CS}#social-duration \"Social interaction duration\"|g" {} +

# Social quality - 89598-7 (invalid) → social-quality
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89598-7 \"Social interaction quality\"|${LOCAL_CS}#social-quality \"Social interaction quality score\"|g" {} +

# Social medium - 89599-5 (invalid) → social-medium
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89599-5 \"Social interaction medium\"|${LOCAL_CS}#social-medium \"Social interaction medium\"|g" {} +

# Social participants - 89600-1 (invalid) → social-count
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89600-1 \"Social interaction participants\"|${LOCAL_CS}#social-count \"Number of social interactions\"|g" {} +

echo "   ✓ Social interaction codes replaced"

# STRESS ASSESSMENT - Replace invalid LOINC codes with local codes
echo "4. Replacing Stress Assessment component codes..."

# Physiological stress - 89593-8 (invalid) → stress-physiological
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89593-8 \"Physiological stress\"|${LOCAL_CS}#stress-physiological \"Physiological stress indicator\"|g" {} +

# Psychological stress - 89594-6 (invalid) → stress-psychological
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89594-6 \"Psychological stress\"|${LOCAL_CS}#stress-psychological \"Psychological stress score\"|g" {} +

# Stress chronicity - 89595-3 (invalid) → stress-chronicity
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#89595-3 \"Stress chronicity\"|${LOCAL_CS}#stress-chronicity \"Stress chronicity assessment\"|g" {} +

echo "   ✓ Stress assessment codes replaced"

# LEAN BODY MASS - Replace invalid code 291-7
echo "5. Replacing invalid lean body mass code..."
find input/fsh -name "*.fsh" -not -name "*.bak" -not -name "*.backup*" -type f -exec sed -i '' \
  "s|http://loinc.org#291-7|http://loinc.org#8342-8|g" {} +

echo "   ✓ Lean body mass code replaced with valid LOINC"

echo ""
echo "✓ All Phase 3.2b local code replacements applied!"
echo ""
echo "Summary:"
echo "  - Environmental noise: 5 codes replaced"
echo "  - Sleep stages: 4 codes replaced"
echo "  - Social interaction: 4 codes replaced"
echo "  - Stress assessment: 3 codes replaced"
echo "  - Invalid LOINC: 1 code fixed"
echo "  Total: 17 code replacements"
echo ""
echo "New CodeSystem created:"
echo "  - input/fsh/terminology/LifestyleObservationCS.fsh"
echo ""
echo "Files modified:"
echo "  - Environmental examples and profiles"
echo "  - Sleep examples and profiles"
echo "  - Social interaction examples and profiles"
echo "  - Stress examples and profiles"
echo "  - Body metrics examples"
echo ""
echo "=========================================="
echo "Next: Run ./_genonce.sh to validate"
echo "Expected: 209 → ~195 errors"
echo "=========================================="
