#!/bin/bash
#===============================================================================
# FHIR IG ERROR FIX - Phase 2.3: Canonical URL Mismatches (Quick Win)
#===============================================================================
# Version: 0.1
# Date: 2025-09-30 13:25:00
# Target: Fix Id declarations to match URL last segments
#
# Expected Impact: -7 errors (283 → 276)
# Estimated Time: < 2 minutes
#
# Changes:
# 1. FertilityValueSets.fsh: Fix 3 ValueSet Ids
#    - cervical-mucus-valueset → cervical-mucus-vs
#    - fertility-status-valueset → fertility-status-vs
#    - ovulation-test-valueset → ovulation-test-vs
#
# 2. MindfulnessQuestionnaires.fsh: Fix Instance Id
#    - DailyMindfulnessQuestionnaire → daily-mindfulness
#
# 3. NutritionQuestionnaires.fsh: Fix Instance Id
#    - DailyNutritionQuestionnaire → daily-nutrition
#
# 4. ReproductiveQuestionnaire.fsh: Fix Instance Id
#    - ReproductiveHealthQuestionnaire → social-history-health
#
# 5. MindfulnessSettingCS: Cannot fix (no FSH source, auto-generated)
#    - Will remain as warning
#
# Files Modified:
# - input/fsh/valuesets/FertilityValueSets.fsh
# - input/fsh/profiles/questionnaires/MindfulnessQuestionnaires.fsh
# - input/fsh/profiles/questionnaires/NutritionQuestionnaires.fsh
# - input/fsh/profiles/questionnaires/ReproductiveQuestionnaire.fsh
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
echo -e "${BLUE}║      FHIR IG FIX - Phase 2.3: Canonical URL Mismatches       ║${NC}"
echo -e "${BLUE}║                   Version 0.1 - Quick Win                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Backup
echo -e "${YELLOW}[1/5] Creating backups...${NC}"
BACKUP_DIR="backups/backup_phases/backup_phase2.3_v0.1_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp input/fsh/valuesets/FertilityValueSets.fsh "$BACKUP_DIR/"
cp input/fsh/profiles/questionnaires/MindfulnessQuestionnaires.fsh "$BACKUP_DIR/"
cp input/fsh/profiles/questionnaires/NutritionQuestionnaires.fsh "$BACKUP_DIR/"
cp input/fsh/profiles/questionnaires/ReproductiveQuestionnaire.fsh "$BACKUP_DIR/"

echo -e "${GREEN}✓ Backups created in: $BACKUP_DIR${NC}"

# Step 2: Fix FertilityValueSets.fsh (3 ValueSet Ids)
echo -e "${YELLOW}[2/5] Fixing FertilityValueSets.fsh (3 ValueSet Ids)...${NC}"

FSH_FILE="input/fsh/valuesets/FertilityValueSets.fsh"

# Fix 1: cervical-mucus-valueset → cervical-mucus-vs
sed -i.bak 's/^Id: cervical-mucus-valueset$/Id: cervical-mucus-vs/' "$FSH_FILE"

# Fix 2: ovulation-test-valueset → ovulation-test-vs
sed -i.bak2 's/^Id: ovulation-test-valueset$/Id: ovulation-test-vs/' "$FSH_FILE"

# Fix 3: fertility-status-valueset → fertility-status-vs
sed -i.bak3 's/^Id: fertility-status-valueset$/Id: fertility-status-vs/' "$FSH_FILE"

rm "${FSH_FILE}.bak" "${FSH_FILE}.bak2" "${FSH_FILE}.bak3" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed 3 ValueSet Ids in FertilityValueSets.fsh${NC}"

# Step 3: Fix MindfulnessQuestionnaires.fsh
echo -e "${YELLOW}[3/5] Fixing MindfulnessQuestionnaires.fsh...${NC}"

FSH_FILE="input/fsh/profiles/questionnaires/MindfulnessQuestionnaires.fsh"

# Change Instance name from DailyMindfulnessQuestionnaire to daily-mindfulness
# But keep name = "DailyMindfulnessQuestionnaire" for resource.name
sed -i.bak 's/^Instance: DailyMindfulnessQuestionnaire$/Instance: daily-mindfulness/' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed Instance Id in MindfulnessQuestionnaires.fsh${NC}"

# Step 4: Fix NutritionQuestionnaires.fsh
echo -e "${YELLOW}[4/5] Fixing NutritionQuestionnaires.fsh...${NC}"

FSH_FILE="input/fsh/profiles/questionnaires/NutritionQuestionnaires.fsh"

# Change Instance name from DailyNutritionQuestionnaire to daily-nutrition
sed -i.bak 's/^Instance: DailyNutritionQuestionnaire$/Instance: daily-nutrition/' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed Instance Id in NutritionQuestionnaires.fsh${NC}"

# Step 5: Fix ReproductiveQuestionnaire.fsh
echo -e "${YELLOW}[5/5] Fixing ReproductiveQuestionnaire.fsh...${NC}"

FSH_FILE="input/fsh/profiles/questionnaires/ReproductiveQuestionnaire.fsh"

# Change Instance name from ReproductiveHealthQuestionnaire to social-history-health
sed -i.bak 's/^Instance: ReproductiveHealthQuestionnaire$/Instance: social-history-health/' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed Instance Id in ReproductiveQuestionnaire.fsh${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    FIX COMPLETED SUCCESSFULLY                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Files modified:${NC}"
echo "  • input/fsh/valuesets/FertilityValueSets.fsh (3 ValueSet Ids)"
echo "  • input/fsh/profiles/questionnaires/MindfulnessQuestionnaires.fsh"
echo "  • input/fsh/profiles/questionnaires/NutritionQuestionnaires.fsh"
echo "  • input/fsh/profiles/questionnaires/ReproductiveQuestionnaire.fsh"
echo ""
echo -e "${GREEN}Changes applied:${NC}"
echo "  • cervical-mucus-valueset → cervical-mucus-vs"
echo "  • ovulation-test-valueset → ovulation-test-vs"
echo "  • fertility-status-valueset → fertility-status-vs"
echo "  • DailyMindfulnessQuestionnaire → daily-mindfulness"
echo "  • DailyNutritionQuestionnaire → daily-nutrition"
echo "  • ReproductiveHealthQuestionnaire → social-history-health"
echo ""
echo -e "${YELLOW}Note:${NC}"
echo "  • MindfulnessSettingCS cannot be fixed (no FSH source, auto-generated)"
echo "  • This will reduce errors from 7 to 1 URL mismatch"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: ./_genonce.sh"
echo "  2. Expected result: 283 errors → ~277 errors (-6 errors)"
echo "  3. Check: output/qa.html for validation results"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"