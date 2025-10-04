#!/bin/bash

# Phase 3.8: Fix LOINC Part/Answer Code Misuse
# Generated: 2025-10-01
# Purpose: Replace LP* (LOINC Parts) and LA* (LOINC Answers) codes with appropriate local codes

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh/phase3.8_${TIMESTAMP}"

echo "========================================"
echo "Phase 3.8: Fix LP*/LA* LOINC Code Misuse"
echo "========================================"
echo "Timestamp: ${TIMESTAMP}"
echo

# Create backup
mkdir -p "${BACKUP_DIR}"
echo "Creating backups..."
cp input/fsh/profiles/NutritionProfiles.fsh "${BACKUP_DIR}/" 2>/dev/null || true
cp input/fsh/profiles/MobilityProfiles.fsh "${BACKUP_DIR}/" 2>/dev/null || true
cp input/fsh/examples/NutritionExamples.fsh "${BACKUP_DIR}/" 2>/dev/null || true
cp input/fsh/examples/MobilityExamples.fsh "${BACKUP_DIR}/" 2>/dev/null || true

echo "Backup created."
echo

# ============================================================================
# 1. FIX NUTRITION PROFILES - Replace LP* codes with local codes
# ============================================================================

echo "1. Fixing Nutrition LP* codes..."

# Fix incorrect caloric intake code (9051-4 is Calcium, not Caloric)
sed -i.bak 's|$LOINC#9051-4 "Caloric intake total"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#caloric-intake "Total caloric intake"|g' input/fsh/profiles/NutritionProfiles.fsh

# Fix macronutrients panel (LP199119-9 is a LOINC Part, not an observation code)
sed -i.bak 's|$LOINC#LP199119-9 "Macronutrients panel"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#macronutrients-panel "Macronutrients intake panel"|g' input/fsh/profiles/NutritionProfiles.fsh

# Fix carbohydrates component (LP35925-4 is a LOINC Part for BMI, not carbohydrates)
sed -i.bak 's|$LOINC#LP35925-4 "Carbohydrates"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#carbohydrate-intake "Carbohydrate intake"|g' input/fsh/profiles/NutritionProfiles.fsh

# Fix proteins component (LP35921-3 is a LOINC Part for device model, not proteins)
sed -i.bak 's|$LOINC#LP35921-3 "Proteins"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#protein-intake "Protein intake"|g' input/fsh/profiles/NutritionProfiles.fsh

# Fix fats component (LP35922-1 is a LOINC Part for software version, not fats)
sed -i.bak 's|$LOINC#LP35922-1 "Fats"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#fat-intake "Fat intake"|g' input/fsh/profiles/NutritionProfiles.fsh

echo "✓ Nutrition profiles fixed"

# ============================================================================
# 2. FIX MOBILITY PROFILES - Replace LA* codes with local codes
# ============================================================================

echo "2. Fixing Mobility LA* codes..."

# Fix balance code (LA33058-8 is a LOINC Answer, not an observation code)
sed -i.bak 's|$LOINC#LA33058-8|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#balance-assessment|g' input/fsh/profiles/MobilityProfiles.fsh

# Fix gait/walking speed code (LA29042-4 is a LOINC Answer, not an observation code)  
sed -i.bak 's|$LOINC#LA29042-4|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#gait-assessment|g' input/fsh/profiles/MobilityProfiles.fsh

# Fix movement/walking distance code (LA29043-2 is a LOINC Answer, not an observation code)
sed -i.bak 's|$LOINC#LA29043-2|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#movement-assessment|g' input/fsh/profiles/MobilityProfiles.fsh

echo "✓ Mobility profiles fixed"

# ============================================================================
# 3. FIX EXAMPLES - Apply same replacements
# ============================================================================

echo "3. Fixing Examples..."

# Nutrition examples
sed -i.bak 's|$LOINC#LP199119-9|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#macronutrients-panel|g' input/fsh/examples/NutritionExamples.fsh
sed -i.bak 's|$LOINC#LP35925-4|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#carbohydrate-intake|g' input/fsh/examples/NutritionExamples.fsh
sed -i.bak 's|$LOINC#LP35921-3|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#protein-intake|g' input/fsh/examples/NutritionExamples.fsh
sed -i.bak 's|$LOINC#LP35922-1|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#fat-intake|g' input/fsh/examples/NutritionExamples.fsh

# Mobility examples
sed -i.bak 's|$LOINC#LA33058-8 "Balance status"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#balance-assessment "Balance assessment"|g' input/fsh/examples/MobilityExamples.fsh
sed -i.bak 's|$LOINC#LA29042-4 "Walking speed"|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#gait-assessment "Gait assessment"|g' input/fsh/examples/MobilityExamples.fsh
sed -i.bak 's|$LOINC#LA29043-2|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#movement-assessment|g' input/fsh/examples/MobilityExamples.fsh
sed -i.bak 's|$LOINC#LA33059-6|https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/balance-status-vs|g' input/fsh/examples/MobilityExamples.fsh

echo "✓ Examples fixed"

# Clean up .bak files
find input/fsh -name "*.bak" -delete

echo
echo "========================================"
echo "Phase 3.8 Complete!"
echo "========================================"
echo "Backups saved in: ${BACKUP_DIR}"
echo
echo "Changes made:"
echo "  - Fixed 5 incorrect LP* codes in Nutrition profiles"
echo "  - Fixed 3 incorrect LA* codes in Mobility profiles"
echo "  - Updated all corresponding examples"
echo
echo "Codes that need to be added to LifestyleObservationCS:"
echo "  - macronutrients-panel"
echo "  - balance-assessment"
echo "  - gait-assessment"
echo "  - movement-assessment"
echo
echo "Next steps:"
echo "  1. Add new codes to LifestyleObservationCS"
echo "  2. Run SUSHI to validate"
echo "  3. Run full IG build"
echo

