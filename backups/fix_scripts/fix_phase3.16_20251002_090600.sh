#!/bin/bash
# Phase 3.16 - Correção de erros FHIR IG
# Data: 2025-10-02 09:06:00
# Objetivo: Reduzir 31 → 13 erros (-58%)

set -e
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== Phase 3.16 - Iniciando correções ==="
echo "Timestamp: $TIMESTAMP"
echo ""

# Backup
echo "1. Criando backup..."
cp -R input/fsh backups/phase3.16_backup_${TIMESTAMP}/

# GRUPO 1: Remover extensões R5 do MindfulnessObservation (-8 erros)
echo "2. Removendo extensões R5 incompatíveis..."

# Encontrar e remover minValueInteger e maxValueInteger
FILE="input/fsh/profiles/observations/activity/MindfulnessProfiles.fsh"

if [ -f "$FILE" ]; then
    # Remover linhas com minValueInteger
    sed -i.bak '/minValueInteger/d' "$FILE"

    # Remover linhas com maxValueInteger
    sed -i.bak '/maxValueInteger/d' "$FILE"

    echo "   ✓ Removidas extensões R5 de MindfulnessProfiles.fsh"
else
    echo "   ⚠ Arquivo $FILE não encontrado"
fi

# GRUPO 2: Corrigir códigos LOINC inválidos (-6 erros)
echo "3. Corrigindo códigos LOINC..."

# 3a. Walking Speed: Substituir 8686-8 por código local
FILE1="input/fsh/profiles/observations/mobility/MobilityProfiles.fsh"
FILE2="input/fsh/examples/MobilityExamples.fsh"

if [ -f "$FILE1" ]; then
    # Trocar LOINC inválido por código local
    sed -i.bak 's|$LOINC#8686-8|$LIFESTYLEOBS#walking-speed|g' "$FILE1"
    sed -i.bak 's|"Walking speed"|"Walking speed measurement"|g' "$FILE1"
    echo "   ✓ Walking speed corrigido em MobilityProfiles.fsh"
fi

if [ -f "$FILE2" ]; then
    sed -i.bak 's|$LOINC#8686-8|$LIFESTYLEOBS#walking-speed|g' "$FILE2"
    sed -i.bak 's|code = http://loinc.org#8686-8|code = $LIFESTYLEOBS#walking-speed|g' "$FILE2"
    echo "   ✓ Walking speed corrigido em MobilityExamples.fsh"
fi

# 3b. Walking Distance: Substituir 41950-7 por código local
if [ -f "$FILE1" ]; then
    sed -i.bak 's|$LOINC#41950-7|$LIFESTYLEOBS#walking-distance|g' "$FILE1"
    echo "   ✓ Walking distance corrigido"
fi

if [ -f "$FILE2" ]; then
    sed -i.bak 's|$LOINC#41950-7|$LIFESTYLEOBS#walking-distance|g' "$FILE2"
    sed -i.bak 's|code.coding\[0\] = http://loinc.org#41950-7|code.coding[0] = $LIFESTYLEOBS#walking-distance|g' "$FILE2"
    echo "   ✓ Walking distance corrigido em exemplos"
fi

# 3c. Walking Steadiness: Substituir 89236-3 por código local
if [ -f "$FILE1" ]; then
    sed -i.bak 's|$LOINC#89236-3|$LIFESTYLEOBS#walking-steadiness|g' "$FILE1"
    echo "   ✓ Walking steadiness corrigido"
fi

if [ -f "$FILE2" ]; then
    sed -i.bak 's|$LOINC#89236-3|$LIFESTYLEOBS#walking-steadiness|g' "$FILE2"
    sed -i.bak 's|code = http://loinc.org#89236-3|code = $LIFESTYLEOBS#walking-steadiness|g' "$FILE2"
    echo "   ✓ Walking steadiness corrigido em exemplos"
fi

# 3d. Heart Rate: Corrigir códigos 55425-3 e 69999-9
FILE3="input/fsh/profiles/observations/vitalsigns/VitalSignsProfiles.fsh"

if [ -f "$FILE3" ]; then
    # Substituir códigos LOINC inválidos por local
    sed -i.bak 's|$LOINC#55425-3|$LIFESTYLEOBS#heart-rate-exercise|g' "$FILE3"
    sed -i.bak 's|$LOINC#69999-9|$LIFESTYLEOBS#heart-rate-variability|g' "$FILE3"
    echo "   ✓ Heart rate códigos corrigidos"
fi

# GRUPO 3: Corrigir ConceptMap reference (-1 erro)
echo "4. Corrigindo ConceptMap reference..."

FILE4="input/fsh/mappings/MindfulnessDiagnosticMappings.fsh"

if [ -f "$FILE4" ]; then
    # Trocar referência de CodeSystem para ValueSet
    sed -i.bak 's|source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-type-cs"|source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-type-vs"|g' "$FILE4"
    sed -i.bak 's|target = "http://snomed.info/sct"|target = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-snomed-vs"|g' "$FILE4"
    echo "   ✓ ConceptMap referências corrigidas"
else
    echo "   ⚠ Arquivo $FILE4 não encontrado"
fi

# GRUPO 4: Corrigir RoleCode PRO → PROV (-2 erros)
echo "5. Corrigindo RoleCode..."

FILE5="input/fsh/profiles/security/MindfulnessSecurity.fsh"

if [ -f "$FILE5" ]; then
    # Trocar PRO por PROV (Healthcare Provider)
    sed -i.bak 's|http://terminology.hl7.org/CodeSystem/v3-RoleCode#PRO|http://terminology.hl7.org/CodeSystem/v3-RoleCode#PROV|g' "$FILE5"
    echo "   ✓ RoleCode corrigido (PRO → PROV)"
else
    echo "   ⚠ Arquivo $FILE5 não encontrado"
fi

# GRUPO 5: Corrigir ValueSet binding em WalkingSteadinessExample (-1 erro)
echo "6. Corrigindo ValueSet binding..."

if [ -f "$FILE2" ]; then
    # Trocar v3-ObservationInterpretation#N por código local
    sed -i.bak 's|http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N|https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/balance-status#normal|g' "$FILE2"
    echo "   ✓ Balance status binding corrigido"
fi

# Adicionar códigos ao LifestyleObservationCS
echo "7. Adicionando códigos faltantes ao CodeSystem..."

FILE6="input/fsh/terminology/LifestyleObservationCS.fsh"

if [ -f "$FILE6" ]; then
    # Verificar se códigos já existem antes de adicionar
    if ! grep -q "walking-speed" "$FILE6"; then
        # Adicionar antes da última linha
        sed -i.bak '$ i\
* #walking-speed "Walking speed measurement" "Measurement of walking speed"\
* #walking-distance "Walking distance measurement" "Measurement of walking distance"\
* #walking-steadiness "Walking steadiness measurement" "Measurement of walking steadiness"\
* #heart-rate-exercise "Heart rate during exercise" "Heart rate measurement during physical exercise"\
* #heart-rate-variability "Heart rate variability" "Heart rate variability measurement"
' "$FILE6"
        echo "   ✓ Códigos adicionados ao LifestyleObservationCS"
    else
        echo "   ℹ Códigos já existem no CodeSystem"
    fi
else
    echo "   ⚠ Arquivo $FILE6 não encontrado"
fi

echo ""
echo "=== Phase 3.16 - Correções concluídas ==="
echo "Arquivos modificados salvos com backup (.bak)"
echo ""
echo "Próximo passo: Rodar ./_genonce.sh para verificar resultado"
echo "Redução esperada: 31 → 13 erros (-58%)"
