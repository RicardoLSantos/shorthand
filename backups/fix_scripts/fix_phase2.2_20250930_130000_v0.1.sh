#!/bin/bash
#===============================================================================
# FHIR IG ERROR FIX - Phase 2.2: ValueSet Binding Codes (Quick Win)
#===============================================================================
# Version: 0.1
# Date: 2025-09-30 13:00:00
# Target: Fix codes without system prefix in Basic resource instances
#
# Expected Impact: -12 errors (291 → 279)
# Estimated Time: < 1 minute
#
# Changes:
# 1. Fix audit-level codes: #detailed → $AuditLevels#detailed
# 2. Fix audit-format codes: #fhir → $AuditFormats#fhir
#
# Files Modified:
# - input/fsh/extensions/MindfulnessAuditConfig.fsh
# - input/fsh/extensions/MindfulnessAudit.fsh
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
echo -e "${BLUE}║         FHIR IG FIX - Phase 2.2: ValueSet Codes              ║${NC}"
echo -e "${BLUE}║                   Version 0.1 - Quick Win                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Backup
echo -e "${YELLOW}[1/4] Creating backups...${NC}"
BACKUP_DIR="backups/backup_phases/backup_phase2.2_v0.1_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp input/fsh/extensions/MindfulnessAuditConfig.fsh "$BACKUP_DIR/"
cp input/fsh/extensions/MindfulnessAudit.fsh "$BACKUP_DIR/"

echo -e "${GREEN}✓ Backups created in: $BACKUP_DIR${NC}"

# Step 2: Define aliases at top of file if not present
echo -e "${YELLOW}[2/4] Checking aliases...${NC}"

AUDIT_CONFIG_FILE="input/fsh/extensions/MindfulnessAuditConfig.fsh"
AUDIT_FILE="input/fsh/extensions/MindfulnessAudit.fsh"

# Add aliases at the beginning of MindfulnessAuditConfig.fsh if not present
if ! grep -q "Alias: \$AuditLevels" "$AUDIT_CONFIG_FILE"; then
    echo -e "${YELLOW}  Adding aliases to MindfulnessAuditConfig.fsh...${NC}"
    sed -i.bak '1i\
// Aliases for CodeSystems\
Alias: $AuditLevels = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-levels\
Alias: $AuditFormats = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-formats\
' "$AUDIT_CONFIG_FILE"
    rm "${AUDIT_CONFIG_FILE}.bak"
fi

# Add aliases at the beginning of MindfulnessAudit.fsh if not present
if ! grep -q "Alias: \$AuditLevels" "$AUDIT_FILE"; then
    echo -e "${YELLOW}  Adding aliases to MindfulnessAudit.fsh...${NC}"
    sed -i.bak '1i\
// Aliases for CodeSystems\
Alias: $AuditLevels = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-levels\
Alias: $AuditFormats = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-formats\
' "$AUDIT_FILE"
    rm "${AUDIT_FILE}.bak"
fi

echo -e "${GREEN}✓ Aliases configured${NC}"

# Step 3: Fix code references in MindfulnessAuditConfig.fsh
echo -e "${YELLOW}[3/4] Fixing code references in MindfulnessAuditConfig.fsh...${NC}"

# Fix line 41: #detailed → $AuditLevels#detailed
sed -i.bak 's/\.valueCode = #detailed/.valueCode = $AuditLevels#detailed/g' "$AUDIT_CONFIG_FILE"

# Fix line 43: #fhir → $AuditFormats#fhir
sed -i.bak2 's/\.valueCode = #fhir/.valueCode = $AuditFormats#fhir/g' "$AUDIT_CONFIG_FILE"

rm "${AUDIT_CONFIG_FILE}.bak" "${AUDIT_CONFIG_FILE}.bak2" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed MindfulnessAuditConfig.fsh${NC}"

# Step 4: Fix code references in MindfulnessAudit.fsh
echo -e "${YELLOW}[4/4] Fixing code references in MindfulnessAudit.fsh...${NC}"

# Fix line 43: #detailed → $AuditLevels#detailed
sed -i.bak 's/\.valueCode = #detailed/.valueCode = $AuditLevels#detailed/g' "$AUDIT_FILE"

# Fix line 45: #fhir → $AuditFormats#fhir
sed -i.bak2 's/\.valueCode = #fhir/.valueCode = $AuditFormats#fhir/g' "$AUDIT_FILE"

rm "${AUDIT_FILE}.bak" "${AUDIT_FILE}.bak2" 2>/dev/null || true

echo -e "${GREEN}✓ Fixed MindfulnessAudit.fsh${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    FIX COMPLETED SUCCESSFULLY                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Files modified:${NC}"
echo "  • input/fsh/extensions/MindfulnessAuditConfig.fsh"
echo "  • input/fsh/extensions/MindfulnessAudit.fsh"
echo ""
echo -e "${GREEN}Changes applied:${NC}"
echo "  • Added CodeSystem aliases"
echo "  • Fixed 4 code references (2 in each file)"
echo "  • #detailed → \$AuditLevels#detailed"
echo "  • #fhir → \$AuditFormats#fhir"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: ./_genonce.sh"
echo "  2. Expected result: 291 errors → ~279 errors (-12 errors)"
echo "  3. Check: output/qa.html for validation results"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"