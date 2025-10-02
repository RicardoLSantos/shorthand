#!/bin/bash

# Full Backups Reorganization by Function
# Purpose: Reorganize all backups by similarity and function instead of dates

set -e

echo "========================================="
echo "REORGANIZAÇÃO COMPLETA POR FUNÇÃO"
echo "========================================="
echo

# Create new organized structure
echo "Criando estrutura organizada..."
mkdir -p backups/phase_reports
mkdir -p backups/fix_scripts  
mkdir -p backups/build_logs
mkdir -p backups/error_analysis
mkdir -p backups/reference_docs
mkdir -p backups/fsh_backups/by_phase
mkdir -p backups/fsh_backups/duplicates
mkdir -p backups/combined_files
mkdir -p backups/legacy/timestamp_backups
mkdir -p backups/legacy/fix_backups

echo "✓ Estrutura criada"
echo

# 1. Move duplicates
echo "1. Organizando duplicados..."
if [ -d "backups/duplicates_20250825_073329" ]; then
    mv backups/duplicates_20250825_073329/* backups/fsh_backups/duplicates/ 2>/dev/null || true
    rmdir backups/duplicates_20250825_073329 2>/dev/null || true
    echo "  ✓ Duplicados movidos"
fi

# 2. Move fix-specific backups to legacy
echo
echo "2. Movendo backups de correções específicas para legacy..."
for dir in fix_555_20250823_110304 pipe_fix_20250822_202307 snomed_fix_20250823_094225 sushi_fix_20250823_145404; do
    if [ -d "backups/$dir" ]; then
        mv "backups/$dir" backups/legacy/fix_backups/ 2>/dev/null && echo "  ✓ $dir" || true
    fi
done

# 3. Move timestamp backups to legacy
echo
echo "3. Movendo backups com timestamp para legacy..."
for dir in 20250823_210511 20250824_091617 20250824_092601 20250824_092754 final_20250824_093817; do
    if [ -d "backups/$dir" ]; then
        mv "backups/$dir" backups/legacy/timestamp_backups/ 2>/dev/null && echo "  ✓ $dir" || true
    fi
done

# 4. Consolidate combined_files
echo
echo "4. Consolidando combined_files (mantendo existente)..."
echo "  ✓ combined_files/ já existe e organizado"

# 5. Move preprocessed to combined_files
echo
echo "5. Movendo arquivos preprocessados..."
if [ -d "backups/preprocessed" ]; then
    mkdir -p backups/combined_files/preprocessed
    mv backups/preprocessed/* backups/combined_files/preprocessed/ 2>/dev/null || true
    rmdir backups/preprocessed 2>/dev/null || true
    echo "  ✓ Preprocessados movidos"
fi

# 6. Organize list_files into error_analysis
echo
echo "6. Organizando list_files..."
if [ -d "backups/list_files" ]; then
    mv backups/list_files/*.txt backups/error_analysis/ 2>/dev/null || true
    rmdir backups/list_files 2>/dev/null || true
    echo "  ✓ Listas movidas para error_analysis"
fi

# 7. Move backup_docs to reference_docs
echo
echo "7. Organizando documentação..."
if [ -d "backups/backup_docs" ]; then
    mv backups/backup_docs/* backups/reference_docs/ 2>/dev/null || true
    rmdir backups/backup_docs 2>/dev/null || true
    echo "  ✓ Documentos movidos"
fi

# 8. Organize backup_phases (large mixed directory)
echo
echo "8. Organizando backup_phases (pode demorar)..."
if [ -d "backups/backup_phases" ]; then
    # Move FSH files
    find backups/backup_phases -name "*.fsh" -exec mv {} backups/fsh_backups/by_phase/ \; 2>/dev/null
    # Move scripts
    find backups/backup_phases -name "*.sh" -exec mv {} backups/fix_scripts/ \; 2>/dev/null
    # Move markdown docs
    find backups/backup_phases -name "*.md" -exec mv {} backups/reference_docs/ \; 2>/dev/null
    # Move remaining to legacy
    if [ "$(ls -A backups/backup_phases 2>/dev/null)" ]; then
        mkdir -p backups/legacy/backup_phases
        mv backups/backup_phases/* backups/legacy/backup_phases/ 2>/dev/null || true
    fi
    rmdir backups/backup_phases 2>/dev/null || true
    echo "  ✓ backup_phases organizado"
fi

# 9. Remove empty directories
echo
echo "9. Removendo diretórios vazios..."
find backups/ -type d -empty -delete 2>/dev/null && echo "  ✓ Diretórios vazios removidos" || true

echo
echo "========================================="
echo "REORGANIZAÇÃO COMPLETA!"
echo "========================================="
echo
echo "Nova estrutura:"
echo "📁 backups/"
echo "  ├── 📊 phase_reports/         $(find backups/phase_reports -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  ├── 🔧 fix_scripts/           $(find backups/fix_scripts -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  ├── 📋 build_logs/            $(find backups/build_logs -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  ├── 🔍 error_analysis/        $(find backups/error_analysis -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  ├── 📖 reference_docs/        $(find backups/reference_docs -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  ├── 💾 fsh_backups/"
echo "  │   ├── by_phase/            $(find backups/fsh_backups/by_phase -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  │   └── duplicates/          $(find backups/fsh_backups/duplicates -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  ├── 📦 combined_files/        $(find backups/combined_files -type f 2>/dev/null | wc -l | xargs) arquivos"
echo "  └── 🕰️  legacy/                $(find backups/legacy -type f 2>/dev/null | wc -l | xargs) arquivos"
echo

total_files=$(find backups/ -type f 2>/dev/null | wc -l | xargs)
echo "Total: $total_files arquivos organizados"
echo
echo "✅ Backups reorganizados por função e similaridade!"

