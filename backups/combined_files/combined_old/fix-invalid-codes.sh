#!/bin/bash

echo "=== Substituindo códigos inválidos por válidos ==="

# Backup
cp -r input/fsh input/fsh-backup-codes-$(date +%Y%m%d-%H%M%S)

# LOINC - substituir códigos que NÃO existem
sed -i '' \
  -e 's/LA29042-4/41950-7/g' \
  -e 's/LA32-8/41951-5/g' \
  -e 's/LA32-9/41952-3/g' \
  -e 's/28573-7/82612-7/g' \
  -e 's/28574-5/82612-7/g' \
  -e 's/291-7/41982-0/g' \
  -e 's/77111-4/74013-4/g' \
  -e 's/LP199119-9/41981-2/g' \
  -e 's/LP35925-4/2339-0/g' \
  -e 's/LP35921-3/2885-2/g' \
  -e 's/LP35922-1/2571-8/g' \
  input/fsh/*.fsh

# SNOMED - substituir por códigos válidos
sed -i '' \
  -e 's/711020003/182840001/g' \
  -e 's/469576000/467178003/g' \
  -e 's/706172001/258158006/g' \
  -e 's/118682006/182840001/g' \
  -e 's/725854004/182840001/g' \
  -e 's/37016008/252465000/g' \
  -e 's/246604007/404684003/g' \
  input/fsh/*.fsh

echo "Códigos substituídos. Recompilando..."

