#!/bin/bash
# Script de correção automática
set -e

echo "🚀 Iniciando correções..."

# Backup
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz input/ sushi-config.yaml

# Correção 1: Códigos LOINC
sed -i.bak \
    -e 's/103332-8/72514-3/g' \
    -e 's/103334-4/38208-5/g' \
    -e 's/103335-1/80316-3/g' \
    input/fsh/ReproductiveObservation.fsh

# Correção 2: Categoria reproductive
cat > input/fsh/ReproductiveCategory.fsh << 'EOF'
CodeSystem: ObservationCategoryExtended
Id: observation-category-extended
* ^status = #active
* ^experimental = false
* ^content = #complete
* #reproductive "Reproductive" "Reproductive health observations"
EOF

find input/fsh -name "*.fsh" -exec sed -i.bak \
    's|http://terminology.hl7.org/CodeSystem/observation-category#reproductive|ObservationCategoryExtended#reproductive|g' {} \;

# Correção 3: URLs canônicas
find input/fsh -name "*.fsh" -exec sed -i.bak \
    's|https://2rdoc.pt/fhir/|https://2rdoc.pt/ig/ios-lifestyle-medicine/|g' {} \;

# Correção 4: Discriminadores
find input/fsh -name "*.fsh" -exec sed -i.bak \
    's/discriminator.type = #pattern/discriminator.type = #value/g' {} \;

# Correção 5: sushi-config
sed -i.bak 's/status: draft/status: active/' sushi-config.yaml
grep -q "experimental:" sushi-config.yaml || sed -i.bak '/^version:/a\
experimental: false' sushi-config.yaml

# Limpeza
find . -name "*.bak" -delete

echo "✅ Correções aplicadas!"
echo "Execute: sushi . && ./_genonce.sh"
