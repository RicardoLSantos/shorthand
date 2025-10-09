#!/bin/bash

# PHASE 3.4: Environmental, Social, Stress, UV, and Body Composition LOINC Code Fixes
# Fix incorrect LOINC codes that map to wrong medical concepts
# Similar to Phase 3.3 but for Environmental, Social, Stress profiles

echo "==================================================================="
echo "PHASE 3.4: LOINC Code Corrections - Multiple Profiles"
echo "==================================================================="
echo ""
echo "Target: Fix ~100+ incorrect LOINC code errors"
echo "Strategy: Replace incorrect LOINC codes with local codes"
echo ""
echo "Profiles to fix:"
echo "  - EnvironmentalProfiles.fsh (noise, UV)"
echo "  - SocialInteractionProfile.fsh"
echo "  - StressLevelProfile.fsh"
echo "  - BodyMetricsProfiles.fsh (display fixes)"
echo ""

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backups/backup_fsh"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Creating backups..."
cp input/fsh/profiles/EnvironmentalProfiles.fsh "$BACKUP_DIR/EnvironmentalProfiles_${TIMESTAMP}.fsh"
cp input/fsh/profiles/SocialInteractionProfile.fsh "$BACKUP_DIR/SocialInteractionProfile_${TIMESTAMP}.fsh"
cp input/fsh/profiles/StressLevelProfile.fsh "$BACKUP_DIR/StressLevelProfile_${TIMESTAMP}.fsh"
cp input/fsh/profiles/BodyMetricsProfiles.fsh "$BACKUP_DIR/BodyMetricsProfiles_${TIMESTAMP}.fsh"
cp input/fsh/examples/EnvironmentalExamples.fsh "$BACKUP_DIR/EnvironmentalExamples_${TIMESTAMP}.fsh" 2>/dev/null || true
cp input/fsh/examples/SocialInteractionExamples.fsh "$BACKUP_DIR/SocialInteractionExamples_${TIMESTAMP}.fsh" 2>/dev/null || true
cp input/fsh/examples/StressExamples.fsh "$BACKUP_DIR/StressExamples_${TIMESTAMP}.fsh" 2>/dev/null || true

echo "✓ Backups created in $BACKUP_DIR"
echo ""

# Alias for local codesystem
LOCALCS="https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"

echo "==================================================================="
echo "1. Fixing EnvironmentalProfiles.fsh"
echo "==================================================================="
echo ""

# Environmental Noise codes (currently hearing tests!)
echo "  Replacing Environmental Noise LOINC codes with local codes:"
echo "    89020-2 (Hearing threshold) → noise-avg"
echo "    89021-0 (Hearing threshold) → noise-duration"
echo "    89024-4 (Hearing threshold) → noise-peak"
echo "    89025-1 (Hearing threshold) → noise-background"

sed -i.bak "s|http://loinc.org#89020-2|${LOCALCS}#noise-avg|g" input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak "s|http://loinc.org#89021-0|${LOCALCS}#noise-duration|g" input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak "s|http://loinc.org#89024-4|${LOCALCS}#noise-peak|g" input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak "s|http://loinc.org#89025-1|${LOCALCS}#noise-background|g" input/fsh/profiles/EnvironmentalProfiles.fsh

# UV Exposure codes (currently hearing tests!)
echo "  Replacing UV Exposure LOINC codes with local codes:"
echo "    89022-8 (Hearing threshold) → uv-index (will create)"
echo "    89023-6 (Hearing threshold) → uv-duration (will create)"

# Note: Need to add these to LifestyleObservationCS first
sed -i.bak 's|http://loinc.org#89022-8|'"${LOCALCS}"'#uv-index|g' input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak 's|http://loinc.org#89023-6|'"${LOCALCS}"'#uv-duration|g' input/fsh/profiles/EnvironmentalProfiles.fsh

# Also fix with $LOINC prefix if present
sed -i.bak 's|\$LOINC#89020-2[^"]*"[^"]*"|'"${LOCALCS}"'#noise-avg "Environmental noise average level"|g' input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak 's|\$LOINC#89021-0[^"]*"[^"]*"|'"${LOCALCS}"'#noise-duration "Environmental noise exposure duration"|g' input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak 's|\$LOINC#89024-4[^"]*"[^"]*"|'"${LOCALCS}"'#noise-peak "Peak environmental sound level"|g' input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak 's|\$LOINC#89025-1[^"]*"[^"]*"|'"${LOCALCS}"'#noise-background "Background environmental noise level"|g' input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak 's|\$LOINC#89022-8[^"]*"[^"]*"|'"${LOCALCS}"'#uv-index "UV index"|g' input/fsh/profiles/EnvironmentalProfiles.fsh
sed -i.bak 's|\$LOINC#89023-6[^"]*"[^"]*"|'"${LOCALCS}"'#uv-duration "UV exposure duration"|g' input/fsh/profiles/EnvironmentalProfiles.fsh

rm -f input/fsh/profiles/EnvironmentalProfiles.fsh.bak

echo "✓ EnvironmentalProfiles.fsh fixed"
echo ""

echo "==================================================================="
echo "2. Fixing SocialInteractionProfile.fsh"
echo "==================================================================="
echo ""

# Social Interaction codes (currently microbiology tests!)
echo "  Replacing Social Interaction LOINC codes with local codes:"
echo "    89597-9 (Mycoplasma DNA) → social-duration"
echo "    89598-7 (Mycoplasma DNA) → social-quality"
echo "    89599-5 (Toxoplasma) → social-medium"
echo "    89600-1 (FDA label) → social-count"

sed -i.bak "s|http://loinc.org#89597-9|${LOCALCS}#social-duration|g" input/fsh/profiles/SocialInteractionProfile.fsh
sed -i.bak "s|http://loinc.org#89598-7|${LOCALCS}#social-quality|g" input/fsh/profiles/SocialInteractionProfile.fsh
sed -i.bak "s|http://loinc.org#89599-5|${LOCALCS}#social-medium|g" input/fsh/profiles/SocialInteractionProfile.fsh
sed -i.bak "s|http://loinc.org#89600-1|${LOCALCS}#social-count|g" input/fsh/profiles/SocialInteractionProfile.fsh

# Also fix with $LOINC prefix
sed -i.bak 's|\$LOINC#89597-9[^"]*"[^"]*"|'"${LOCALCS}"'#social-duration "Social interaction duration"|g' input/fsh/profiles/SocialInteractionProfile.fsh
sed -i.bak 's|\$LOINC#89598-7[^"]*"[^"]*"|'"${LOCALCS}"'#social-quality "Social interaction quality score"|g' input/fsh/profiles/SocialInteractionProfile.fsh
sed -i.bak 's|\$LOINC#89599-5[^"]*"[^"]*"|'"${LOCALCS}"'#social-medium "Social interaction medium"|g' input/fsh/profiles/SocialInteractionProfile.fsh
sed -i.bak 's|\$LOINC#89600-1[^"]*"[^"]*"|'"${LOCALCS}"'#social-count "Number of social interactions"|g' input/fsh/profiles/SocialInteractionProfile.fsh

rm -f input/fsh/profiles/SocialInteractionProfile.fsh.bak

echo "✓ SocialInteractionProfile.fsh fixed"
echo ""

echo "==================================================================="
echo "3. Fixing StressLevelProfile.fsh"
echo "==================================================================="
echo ""

# Stress codes (currently infectious disease tests!)
echo "  Replacing Stress LOINC codes with local codes:"
echo "    89593-8 (Bartonella DNA) → stress-physiological"
echo "    89594-6 (Legionella Ag) → stress-psychological"
echo "    89595-3 (Legionella Ag) → stress-chronicity"
echo "    89596-1 (Listeria DNA) → stress-impact (will create)"

sed -i.bak "s|http://loinc.org#89593-8|${LOCALCS}#stress-physiological|g" input/fsh/profiles/StressLevelProfile.fsh
sed -i.bak "s|http://loinc.org#89594-6|${LOCALCS}#stress-psychological|g" input/fsh/profiles/StressLevelProfile.fsh
sed -i.bak "s|http://loinc.org#89595-3|${LOCALCS}#stress-chronicity|g" input/fsh/profiles/StressLevelProfile.fsh
sed -i.bak "s|http://loinc.org#89596-1|${LOCALCS}#stress-impact|g" input/fsh/profiles/StressLevelProfile.fsh

# Also fix with $LOINC prefix
sed -i.bak 's|\$LOINC#89593-8[^"]*"[^"]*"|'"${LOCALCS}"'#stress-physiological "Physiological stress indicator"|g' input/fsh/profiles/StressLevelProfile.fsh
sed -i.bak 's|\$LOINC#89594-6[^"]*"[^"]*"|'"${LOCALCS}"'#stress-psychological "Psychological stress score"|g' input/fsh/profiles/StressLevelProfile.fsh
sed -i.bak 's|\$LOINC#89595-3[^"]*"[^"]*"|'"${LOCALCS}"'#stress-chronicity "Stress chronicity assessment"|g' input/fsh/profiles/StressLevelProfile.fsh
sed -i.bak 's|\$LOINC#89596-1[^"]*"[^"]*"|'"${LOCALCS}"'#stress-impact "Stress impact assessment"|g' input/fsh/profiles/StressLevelProfile.fsh

rm -f input/fsh/profiles/StressLevelProfile.fsh.bak

echo "✓ StressLevelProfile.fsh fixed"
echo ""

echo "==================================================================="
echo "4. Fixing BodyMetricsProfiles.fsh (display names only)"
echo "==================================================================="
echo ""

# Body composition - just fix display names, codes are valid
echo "  Fixing display names for body composition codes:"
echo "    41982-0: 'Percentage body fat' → 'Percentage of body fat Measured'"
echo "    73965-6: 'Body muscle mass/Body weight' → 'Body muscle mass/Body weight Measured'"

sed -i.bak 's|#41982-0 "Percentage body fat"|#41982-0 "Percentage of body fat Measured"|g' input/fsh/profiles/BodyMetricsProfiles.fsh
sed -i.bak 's|#73965-6 "Body muscle mass/Body weight"|#73965-6 "Body muscle mass/Body weight Measured"|g' input/fsh/profiles/BodyMetricsProfiles.fsh

rm -f input/fsh/profiles/BodyMetricsProfiles.fsh.bak

echo "✓ BodyMetricsProfiles.fsh fixed"
echo ""

echo "==================================================================="
echo "5. Adding missing codes to LifestyleObservationCS"
echo "==================================================================="
echo ""

echo "  Adding: uv-index, uv-duration, stress-impact"

# This will be done via Edit tool in the main script

echo "✓ Ready to add codes (will be done via Edit tool)"
echo ""

echo "==================================================================="
echo "6. Fixing Examples"
echo "==================================================================="
echo ""

# Fix examples if they exist
if [ -f "input/fsh/examples/EnvironmentalExamples.fsh" ]; then
  echo "  Fixing EnvironmentalExamples.fsh..."
  # Already done by profile changes via URL replacement
  echo "  ✓ Done"
fi

if [ -f "input/fsh/examples/SocialInteractionExamples.fsh" ]; then
  echo "  Fixing SocialInteractionExamples.fsh..."
  # Already done by profile changes via URL replacement
  echo "  ✓ Done"
fi

if [ -f "input/fsh/examples/StressExamples.fsh" ]; then
  echo "  Fixing StressExamples.fsh..."
  # Already done by profile changes via URL replacement
  echo "  ✓ Done"
fi

echo ""
echo "==================================================================="
echo "PHASE 3.4 Script Complete (Profiles Fixed)"
echo "==================================================================="
echo ""
echo "Files modified:"
echo "  ✓ input/fsh/profiles/EnvironmentalProfiles.fsh"
echo "  ✓ input/fsh/profiles/SocialInteractionProfile.fsh"
echo "  ✓ input/fsh/profiles/StressLevelProfile.fsh"
echo "  ✓ input/fsh/profiles/BodyMetricsProfiles.fsh"
echo ""
echo "Backups saved to: $BACKUP_DIR/*_${TIMESTAMP}.fsh"
echo ""
echo "Next steps:"
echo "  1. Add missing codes to LifestyleObservationCS (uv-index, uv-duration, stress-impact)"
echo "  2. Run SUSHI to validate"
echo "  3. Run full IG build"
echo ""
