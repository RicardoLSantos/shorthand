#!/bin/bash
# Phase 3.19: Add caseSensitive to CodeSystems for ShareableCodeSystem compliance
# Date: 2025-10-02 12:44:26

# Add caseSensitive = true to CodeSystems that are missing it
# This fixes CODESYSTEM_SHAREABLE_MISSING warnings

echo "Phase 3.19: Adding caseSensitive to CodeSystems..."

# Function to add caseSensitive if not present
add_case_sensitive() {
    local file=$1
    local cs_id=$2

    # Check if caseSensitive already exists
    if grep -q "caseSensitive" "$file"; then
        echo "  $cs_id already has caseSensitive - skipping"
        return
    fi

    # Find the CodeSystem definition and add caseSensitive after experimental
    if grep -q "Id: $cs_id" "$file"; then
        # Use sed to add caseSensitive after ^experimental line
        sed -i.bak "/Id: $cs_id/,/^\* #/ {
            /\* \^experimental = false/ a\\
* ^caseSensitive = true
        }" "$file"
        echo "  ✓ Added caseSensitive to $cs_id in $file"
    fi
}

# Social Interaction CodeSystems
add_case_sensitive "input/fsh/extensions/SocialInteractionExtensions.fsh" "social-context-cs"
add_case_sensitive "input/fsh/extensions/SocialInteractionExtensions.fsh" "social-support-cs"
add_case_sensitive "input/fsh/extensions/SocialInteractionExtensions.fsh" "social-activity-cs"

# Find and fix other CodeSystems
for cs_id in social-interaction-medium-cs social-interaction-quality-cs social-interaction-type-cs; do
    file=$(grep -r "Id: $cs_id" input/fsh --include="*.fsh" -l 2>/dev/null | head -1)
    if [ -n "$file" ]; then
        add_case_sensitive "$file" "$cs_id"
    fi
done

# Stress CodeSystems
for cs_id in stress-chronicity-cs stress-coping-cs stress-impact-cs stress-triggers-cs; do
    file=$(grep -r "Id: $cs_id" input/fsh --include="*.fsh" -l 2>/dev/null | head -1)
    if [ -n "$file" ]; then
        add_case_sensitive "$file" "$cs_id"
    fi
done

# Symptom CodeSystems
for cs_id in symptom-frequency-cs symptom-impact-cs symptom-severity-cs; do
    file=$(grep -r "Id: $cs_id" input/fsh --include="*.fsh" -l 2>/dev/null | head -1)
    if [ -n "$file" ]; then
        add_case_sensitive "$file" "$cs_id"
    fi
done

# Mindfulness and Mobility
for cs_id in MindfulnessSettingCS mobility-alert-level-cs; do
    file=$(grep -r "Id: $cs_id" input/fsh --include="*.fsh" -l 2>/dev/null | head -1)
    if [ -n "$file" ]; then
        add_case_sensitive "$file" "$cs_id"
    fi
done

echo "Phase 3.19: caseSensitive additions complete!"
echo ""
echo "Files modified (backups created with .bak extension):"
ls -la input/fsh/**/*.bak 2>/dev/null | wc -l
