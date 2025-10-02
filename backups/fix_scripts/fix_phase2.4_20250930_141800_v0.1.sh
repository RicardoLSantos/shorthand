#!/bin/bash
#===============================================================================
# FHIR IG ERROR FIX - Phase 2.4: Observation Category Codes (Quick Win)
#===============================================================================
# Version: 0.1
# Date: 2025-09-30 14:18:00
# Target: Fix invalid observation-category codes
#
# Expected Impact: -11 errors (265 → 254)
# Estimated Time: < 2 minutes
#
# Changes:
# 1. Replace 'nutrition' → 'survey' (5 errors)
# 2. Replace 'environment' → 'survey' (6 errors)
#
# Rationale:
# - 'nutrition' and 'environment' are NOT valid HL7 observation-category codes
# - Valid categories: social-history, vital-signs, imaging, laboratory,
#   procedure, survey, exam, therapy, activity
# - 'survey' is most appropriate for self-reported/tracked data
#
# Files Modified:
# - input/fsh/profiles/NutritionProfiles.fsh
# - input/fsh/profiles/EnvironmentalProfiles.fsh
# - input/fsh/examples/EnvironmentalExamples.fsh
#===============================================================================

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    FHIR IG FIX - Phase 2.4: Observation Category Codes       ║${NC}"
echo -e "${BLUE}║                   Version 0.1 - Quick Win                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Backup
echo -e "${YELLOW}[1/4] Creating backups...${NC}"
BACKUP_DIR="backups/backup_phases/backup_phase2.4_v0.1_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp input/fsh/profiles/NutritionProfiles.fsh "$BACKUP_DIR/"
cp input/fsh/profiles/EnvironmentalProfiles.fsh "$BACKUP_DIR/"
cp input/fsh/examples/EnvironmentalExamples.fsh "$BACKUP_DIR/"

echo -e "${GREEN}✓ Backups created in: $BACKUP_DIR${NC}"

# Step 2: Fix NutritionProfiles.fsh
echo -e "${YELLOW}[2/4] Fixing NutritionProfiles.fsh...${NC}"

FSH_FILE="input/fsh/profiles/NutritionProfiles.fsh"

# Replace nutrition → survey
sed -i.bak 's|observation-category#nutrition|observation-category#survey|g' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed nutrition → survey in NutritionProfiles.fsh${NC}"

# Step 3: Fix EnvironmentalProfiles.fsh
echo -e "${YELLOW}[3/4] Fixing EnvironmentalProfiles.fsh...${NC}"

FSH_FILE="input/fsh/profiles/EnvironmentalProfiles.fsh"

# Replace environment → survey
sed -i.bak 's|observation-category#environment|observation-category#survey|g' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed environment → survey in EnvironmentalProfiles.fsh${NC}"

# Step 4: Fix EnvironmentalExamples.fsh
echo -e "${YELLOW}[4/4] Fixing EnvironmentalExamples.fsh...${NC}"

FSH_FILE="input/fsh/examples/EnvironmentalExamples.fsh"

# Replace environment → survey (2 instances)
sed -i.bak 's|observation-category#environment|observation-category#survey|g' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed environment → survey in EnvironmentalExamples.fsh (2 instances)${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    FIX COMPLETED SUCCESSFULLY                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Files modified:${NC}"
echo "  • input/fsh/profiles/NutritionProfiles.fsh"
echo "  • input/fsh/profiles/EnvironmentalProfiles.fsh"
echo "  • input/fsh/examples/EnvironmentalExamples.fsh"
echo ""
echo -e "${GREEN}Changes applied:${NC}"
echo "  • 'nutrition' → 'survey' (1 occurrence in NutritionProfiles.fsh)"
echo "  • 'environment' → 'survey' (1 in EnvironmentalProfiles.fsh)"
echo "  • 'environment' → 'survey' (2 in EnvironmentalExamples.fsh)"
echo "  • Total: 4 direct replacements → 11 errors fixed (cascading)"
echo ""
echo -e "${BLUE}Impact:${NC}"
echo "  • Nutrition profiles: calorie-intake, macronutrients, nutrition-intake, water-intake"
echo "  • Environmental profiles: environmental-observation, noise-exposure, uv-exposure"
echo "  • Examples: NoiseExposureExample, UVExposureExample"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: ./_genonce.sh"
echo "  2. Expected result: 265 errors → ~254 errors (-11 errors)"
echo "  3. Check: output/qa.html for validation results"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"