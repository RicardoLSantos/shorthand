#!/bin/bash

# Verificar e corrigir CADA arquivo FSH individualmente
for file in input/fsh/*.fsh; do
  if grep -q "example.org" "$file"; then
    echo "Corrigindo URL em: $(basename $file)"
    sed -i '' 's|example\.org/fhir|github.com/RicardoLSantos/shorthand|g' "$file"
    sed -i '' 's|example\.org|github.com/RicardoLSantos/shorthand|g' "$file"
  fi
done

# Recompilar
