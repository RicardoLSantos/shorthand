#!/bin/bash
#===============================================================================
# FHIR IG ERROR FIX - Phase 2.5: Consent Display Names & Codes (Quick Win)
#===============================================================================
# Version: 0.1
# Date: 2025-09-30 14:30:00
# Target: Fix Consent resource errors
#
# Expected Impact: -6 errors (254 → 248)
# Estimated Time: < 2 minutes
#
# Changes:
# 1. Fix LOINC display: 'Patient Consent' → 'Consent Document' (2 errors)
# 2. Fix RoleCode: Remove 'TREAT' → Use 'PROV' (healthcare provider) (2 errors)
# 3. Fix practitioner-identifier system: Remove invalid URL (2 errors)
#
# Rationale:
# - LOINC#59284-0 official display is 'Consent Document', not 'Patient Consent'
# - 'TREAT' is not a valid code in v3-RoleCode v3.0.0
# - 'PROV' (healthcare provider) is valid alternative
# - practitioner-identifier CodeSystem doesn't exist in HL7
# - Removing identifier.system (keeping only value) for simplicity
#
# Files Modified:
# - input/fsh/extensions/MindfulnessSecurity.fsh
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
echo -e "${BLUE}║    FHIR IG FIX - Phase 2.5: Consent Display Names & Codes    ║${NC}"
echo -e "${BLUE}║                   Version 0.1 - Quick Win                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Backup
echo -e "${YELLOW}[1/4] Creating backups...${NC}"
BACKUP_DIR="backups/backup_phases/backup_phase2.5_v0.1_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp input/fsh/extensions/MindfulnessSecurity.fsh "$BACKUP_DIR/"

echo -e "${GREEN}✓ Backups created in: $BACKUP_DIR${NC}"

# Step 2: Fix LOINC display names (lines 8 and 30)
echo -e "${YELLOW}[2/4] Fixing LOINC display names...${NC}"

FSH_FILE="input/fsh/extensions/MindfulnessSecurity.fsh"

# Replace 'Patient Consent' → 'Consent Document'
sed -i.bak 's/"Patient Consent"/"Consent Document"/g' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed LOINC display: 'Patient Consent' → 'Consent Document' (2 occurrences)${NC}"

# Step 3: Fix RoleCode TREAT → PROV (lines 17 and 54)
echo -e "${YELLOW}[3/4] Fixing RoleCode...${NC}"

# Replace TREAT → PROV (Provider)
sed -i.bak 's/#TREAT "treatment"/#PROV "healthcare provider"/g' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed RoleCode: TREAT → PROV (2 occurrences)${NC}"

# Step 4: Remove invalid practitioner-identifier system (lines 18 and 55)
echo -e "${YELLOW}[4/4] Removing invalid identifier.system...${NC}"

# Comment out the invalid system lines
sed -i.bak 's|^\* provision.actor\[0\].reference.identifier.system = "http://terminology.hl7.org/CodeSystem/practitioner-identifier"|// * provision.actor[0].reference.identifier.system = "http://terminology.hl7.org/CodeSystem/practitioner-identifier" // Invalid - removed|g' "$FSH_FILE"

rm "${FSH_FILE}.bak" 2>/dev/null || true

echo -e "${GREEN}✓ Commented out invalid identifier.system (2 occurrences)${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    FIX COMPLETED SUCCESSFULLY                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Files modified:${NC}"
echo "  • input/fsh/extensions/MindfulnessSecurity.fsh"
echo ""
echo -e "${GREEN}Changes applied:${NC}"
echo "  • LOINC display: 'Patient Consent' → 'Consent Document' (2x)"
echo "  • RoleCode: TREAT → PROV (healthcare provider) (2x)"
echo "  • Identifier system: Commented out invalid URLs (2x)"
echo ""
echo -e "${BLUE}Resources affected:${NC}"
echo "  • Consent/MindfulnessSecurityDefinition"
echo "  • Consent/MindfulnessAccessPolicy"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: ./_genonce.sh"
echo "  2. Expected result: 254 errors → ~248 errors (-6 errors)"
echo "  3. Check: output/qa.html for validation results"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"