#!/bin/bash
# Phase 2.6: Fix MessageDefinition Constraints
# Generated: 2025-09-30 15:00:00
# Expected: -4 errors (250 → 246)
#
# FIXES:
# 1. Change Instance IDs to match canonical URLs (kebab-case)
# 2. Add focus.max = "*" to satisfy md-1 constraint

set -e

echo "======================================"
echo "Phase 2.6: MessageDefinition Fixes"
echo "======================================"
echo ""
echo "Creating backup..."

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups/backup_fsh"
mkdir -p "$BACKUP_DIR"

# Backup file
cp input/fsh/messaging/MindfulnessMessaging.fsh "$BACKUP_DIR/MindfulnessMessaging_${TIMESTAMP}.fsh"

echo "Backup created: $BACKUP_DIR/MindfulnessMessaging_${TIMESTAMP}.fsh"
echo ""
echo "Applying fixes..."

# Fix 1: Change Instance names to kebab-case
sed -i '' 's/^Instance: StartSessionMessage$/Instance: start-session/' input/fsh/messaging/MindfulnessMessaging.fsh
sed -i '' 's/^Instance: EndSessionMessage$/Instance: end-session/' input/fsh/messaging/MindfulnessMessaging.fsh

# Fix 2: Add focus.max = "*" after focus.min = 1
# For start-session (after line 29)
sed -i '' '/^Instance: start-session/,/^Instance: end-session/{
  /\* focus\.min = 1$/a\
* focus.max = "*"
}' input/fsh/messaging/MindfulnessMessaging.fsh

# For end-session (after line 43)
sed -i '' '/^Instance: end-session/,${
  /\* focus\.min = 1$/a\
* focus.max = "*"
}' input/fsh/messaging/MindfulnessMessaging.fsh

echo "✓ Fixed Instance IDs: StartSessionMessage → start-session"
echo "✓ Fixed Instance IDs: EndSessionMessage → end-session"
echo "✓ Added focus.max = \"*\" to both instances"
echo ""
echo "Changes applied successfully!"
echo ""
echo "Files modified:"
echo "  - input/fsh/messaging/MindfulnessMessaging.fsh"
echo ""
echo "======================================"
echo "Next: Run ./_genonce.sh to validate"
echo "======================================"
