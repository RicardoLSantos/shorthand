#!/bin/bash

# Workspace Cleanup Script
# Purpose: Organize correction files, logs, and reports into backup directories

set -e

echo "========================================="
echo "Workspace Cleanup and Organization"
echo "========================================="
echo

# Create organized backup structure
echo "Creating backup directory structure..."
mkdir -p backups/scripts
mkdir -p backups/logs
mkdir -p backups/reports
mkdir -p backups/analysis

echo "✓ Directory structure created"
echo

# Move fix scripts
echo "Moving fix scripts..."
mv fix_phase3.*.sh backups/scripts/ 2>/dev/null && echo "  ✓ Moved phase 3 fix scripts" || echo "  • No phase 3 fix scripts to move"

# Move build logs
echo "Moving build logs..."
mv build_phase3.*.log backups/logs/ 2>/dev/null && echo "  ✓ Moved build logs" || echo "  • No build logs to move"

# Move phase completion reports
echo "Moving phase completion reports..."
mv phase3.*_complete_*.txt backups/reports/ 2>/dev/null && echo "  ✓ Moved completion reports" || echo "  • No completion reports to move"

# Move session summaries
echo "Moving session summaries..."
mv SESSION_SUMMARY_*.txt backups/reports/ 2>/dev/null && echo "  ✓ Moved session summaries" || echo "  • No session summaries to move"

# Move error analysis files
echo "Moving error analysis files..."
mv fhir_qa_errors*.txt backups/analysis/ 2>/dev/null && echo "  ✓ Moved error analysis files" || echo "  • No error analysis files to move"
mv remaining_errors*.txt backups/analysis/ 2>/dev/null && echo "  ✓ Moved remaining errors files" || echo "  • No remaining errors files to move"
mv loinc_codes_in_errors.txt backups/analysis/ 2>/dev/null && echo "  ✓ Moved LOINC codes analysis" || echo "  • No LOINC analysis to move"

echo
echo "========================================="
echo "Cleanup Summary"
echo "========================================="

echo "Files organized into:"
echo "  • backups/scripts/    - Fix scripts"
echo "  • backups/logs/       - Build logs"
echo "  • backups/reports/    - Phase completion reports"
echo "  • backups/analysis/   - Error analysis files"

echo
echo "Current workspace files:"
ls -1 *.sh 2>/dev/null | wc -l | xargs echo "  Scripts remaining:"
ls -1 *.log 2>/dev/null | wc -l | xargs echo "  Logs remaining:"
ls -1 *.txt 2>/dev/null | wc -l | xargs echo "  Text files remaining:"

echo
echo "========================================="
echo "Cleanup Complete!"
echo "========================================="

