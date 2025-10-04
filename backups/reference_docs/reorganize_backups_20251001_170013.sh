#!/bin/bash

# Reorganize backups by similarity
# Purpose: Group phase reports, fix scripts, reference docs, etc.

set -e

echo "========================================="
echo "Backups Reorganization by Similarity"
echo "========================================="
echo

# Analyze current structure
echo "Current backups structure:"
ls -d backups/*/ 2>/dev/null || echo "  No subdirectories yet"

echo
echo "Creating organized structure..."

# Create new organized structure
mkdir -p backups/phase_reports
mkdir -p backups/fix_scripts  
mkdir -p backups/build_logs
mkdir -p backups/error_analysis
mkdir -p backups/reference_docs
mkdir -p backups/fsh_backups

echo "✓ Directory structure created"

# Move files from recent cleanup
if [ -d "backups/scripts" ]; then
    echo
    echo "Moving from backups/scripts/..."
    mv backups/scripts/fix_*.sh backups/fix_scripts/ 2>/dev/null && echo "  ✓ Moved fix scripts" || true
    mv backups/scripts/cleanup_*.sh backups/reference_docs/ 2>/dev/null && echo "  ✓ Moved cleanup scripts" || true
    rmdir backups/scripts 2>/dev/null && echo "  ✓ Removed empty scripts directory" || true
fi

if [ -d "backups/logs" ]; then
    echo
    echo "Moving from backups/logs/..."
    mv backups/logs/*.log backups/build_logs/ 2>/dev/null && echo "  ✓ Moved build logs" || true
    rmdir backups/logs 2>/dev/null && echo "  ✓ Removed empty logs directory" || true
fi

if [ -d "backups/reports" ]; then
    echo
    echo "Moving from backups/reports/..."
    mv backups/reports/phase*.txt backups/phase_reports/ 2>/dev/null && echo "  ✓ Moved phase reports" || true
    mv backups/reports/SESSION_*.txt backups/phase_reports/ 2>/dev/null && echo "  ✓ Moved session summaries" || true
    rmdir backups/reports 2>/dev/null && echo "  ✓ Removed empty reports directory" || true
fi

if [ -d "backups/analysis" ]; then
    echo
    echo "Moving from backups/analysis/..."
    mv backups/analysis/*.txt backups/error_analysis/ 2>/dev/null && echo "  ✓ Moved analysis files" || true
    rmdir backups/analysis 2>/dev/null && echo "  ✓ Removed empty analysis directory" || true
fi

# Move FSH backups to proper location
if [ -d "backups/backup_fsh" ]; then
    echo
    echo "Organizing FSH backups..."
    mv backups/backup_fsh backups/fsh_backups/by_phase 2>/dev/null && echo "  ✓ Moved FSH backups" || true
fi

echo
echo "========================================="
echo "Reorganization Complete!"
echo "========================================="
echo
echo "New structure:"
echo "backups/"
echo "├── phase_reports/     Phase completion reports & session summaries"
echo "├── fix_scripts/       All fix scripts (phase 3.x)"
echo "├── build_logs/        Build output logs"
echo "├── error_analysis/    Error analysis and QA reports"
echo "├── reference_docs/    Reference and utility scripts"
echo "└── fsh_backups/"
echo "    └── by_phase/      FSH file backups organized by phase"

echo
echo "File counts:"
printf "%-25s %s\n" "Phase reports:" "$(find backups/phase_reports -type f 2>/dev/null | wc -l | xargs)"
printf "%-25s %s\n" "Fix scripts:" "$(find backups/fix_scripts -type f 2>/dev/null | wc -l | xargs)"
printf "%-25s %s\n" "Build logs:" "$(find backups/build_logs -type f 2>/dev/null | wc -l | xargs)"
printf "%-25s %s\n" "Error analysis:" "$(find backups/error_analysis -type f 2>/dev/null | wc -l | xargs)"
printf "%-25s %s\n" "Reference docs:" "$(find backups/reference_docs -type f 2>/dev/null | wc -l | xargs)"
printf "%-25s %s\n" "FSH backups (phases):" "$(find backups/fsh_backups/by_phase -type d 2>/dev/null | wc -l | xargs)"

echo
echo "✅ Backups successfully reorganized by similarity!"

