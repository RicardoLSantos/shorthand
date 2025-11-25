#!/usr/bin/env python3
"""
Basic ADL 2.0 Archetype Validator
Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
Links: https://linktr.ee/ricardolsantos

This script performs basic structural validation of ADL 2.0 archetypes.
For full validation, use:
- Archie (Java): https://github.com/openEHR/archie
- ADL Workbench: https://www.openehr.org/downloads/ADLworkbench
- LinkEHR: https://linkehr.veratech.es/
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple, Dict

class ADLValidator:
    """Basic ADL 2.0 structure validator."""

    REQUIRED_SECTIONS = [
        'archetype',
        'language',
        'description',
        'definition',
        'terminology'
    ]

    REQUIRED_DESCRIPTION_FIELDS = [
        'original_author',
        'lifecycle_state',
        'details'
    ]

    def __init__(self, filepath: str):
        self.filepath = filepath
        self.filename = os.path.basename(filepath)
        self.content = ""
        self.errors: List[str] = []
        self.warnings: List[str] = []
        self.info: List[str] = []

    def load(self) -> bool:
        """Load the ADL file."""
        try:
            with open(self.filepath, 'r', encoding='utf-8') as f:
                self.content = f.read()
            return True
        except Exception as e:
            self.errors.append(f"Failed to load file: {e}")
            return False

    def validate_archetype_id(self) -> bool:
        """Validate archetype ID matches filename."""
        # Extract archetype ID from content
        match = re.search(r'archetype.*\n\s+(openEHR-EHR-[A-Z]+\.[a-z_]+\.v\d+)', self.content)
        if not match:
            self.errors.append("Could not find archetype ID")
            return False

        archetype_id = match.group(1)
        expected_filename = f"{archetype_id}.adl"

        # Check base name matches (ignoring minor version differences)
        base_id = re.sub(r'\.v\d+\.\d+\.\d+', '.v0', archetype_id)
        expected_base = f"{base_id}.adl"

        if self.filename != expected_filename and not self.filename.startswith(base_id.rsplit('.', 1)[0]):
            self.warnings.append(f"Filename '{self.filename}' may not match archetype ID '{archetype_id}'")
        else:
            self.info.append(f"Archetype ID: {archetype_id}")

        return True

    def validate_sections(self) -> bool:
        """Check all required sections are present."""
        all_present = True
        for section in self.REQUIRED_SECTIONS:
            # Look for section at start of line (may have parameters or content following)
            pattern = rf'^{section}(\s|\()'
            if not re.search(pattern, self.content, re.MULTILINE):
                self.errors.append(f"Missing required section: {section}")
                all_present = False
            else:
                self.info.append(f"Section '{section}' found")
        return all_present

    def validate_language(self) -> bool:
        """Validate language section."""
        match = re.search(r'original_language\s*=\s*<\[ISO_639-1::(\w+)\]>', self.content)
        if not match:
            self.errors.append("Missing or invalid original_language")
            return False

        lang = match.group(1)
        self.info.append(f"Original language: {lang}")

        # Check for translations
        if 'translations' in self.content:
            trans_matches = re.findall(r'\["(\w+)"\]\s*=\s*<\s*language\s*=\s*<\[ISO_639-1::(\w+)\]>', self.content)
            for code, lang in trans_matches:
                self.info.append(f"Translation found: {lang}")

        return True

    def validate_description(self) -> bool:
        """Validate description section has required fields."""
        valid = True

        # Check original_author
        if 'original_author' not in self.content:
            self.errors.append("Missing original_author in description")
            valid = False
        else:
            # Extract author details
            name_match = re.search(r'\["name"\]\s*=\s*<"([^"]+)">', self.content)
            email_match = re.search(r'\["email"\]\s*=\s*<"([^"]+)">', self.content)
            if name_match:
                self.info.append(f"Author: {name_match.group(1)}")
            if email_match:
                self.info.append(f"Email: {email_match.group(1)}")

        # Check lifecycle_state
        lifecycle_match = re.search(r'lifecycle_state\s*=\s*<"([^"]+)">', self.content)
        if not lifecycle_match:
            self.errors.append("Missing lifecycle_state")
            valid = False
        else:
            state = lifecycle_match.group(1)
            valid_states = ['unmanaged', 'in_development', 'in_review', 'published', 'deprecated', 'rejected']
            if state not in valid_states:
                self.warnings.append(f"Unusual lifecycle_state: {state}")
            else:
                self.info.append(f"Lifecycle state: {state}")

        # Check purpose
        if 'purpose' not in self.content:
            self.errors.append("Missing purpose in description")
            valid = False

        # Check use
        if re.search(r'use\s*=\s*<"[^"]*">', self.content):
            self.info.append("Use statement found")
        else:
            self.warnings.append("Use statement may be missing")

        # Check misuse
        if re.search(r'misuse\s*=\s*<"[^"]*">', self.content):
            self.info.append("Misuse statement found")
        else:
            self.warnings.append("Misuse statement may be missing")

        return valid

    def validate_definition(self) -> bool:
        """Validate definition section structure."""
        # Check for root node ID
        root_match = re.search(r'definition\s+([A-Z_]+)\[id1\]', self.content)
        if not root_match:
            self.errors.append("Missing root node [id1] in definition")
            return False

        rm_type = root_match.group(1)
        self.info.append(f"Root RM type: {rm_type}")

        # Count node IDs
        node_ids = re.findall(r'\[id(\d+)\]', self.content)
        unique_ids = set(node_ids)
        self.info.append(f"Node IDs defined: {len(unique_ids)}")

        # Check for duplicate IDs
        if len(node_ids) != len(unique_ids):
            self.warnings.append("Possible duplicate node IDs")

        # Count at-codes
        at_codes = re.findall(r'\[at(\d+)\]', self.content)
        unique_at = set(at_codes)
        self.info.append(f"At-codes defined: {len(unique_at)}")

        return True

    def validate_terminology(self) -> bool:
        """Validate terminology section."""
        # Check term_definitions exist
        if 'term_definitions' not in self.content:
            self.errors.append("Missing term_definitions in terminology")
            return False

        # Check for id1 definition
        if not re.search(r'\["id1"\]\s*=\s*<', self.content):
            self.errors.append("Missing definition for root node [id1]")
            return False

        # Look for term_bindings (optional but good)
        if 'term_bindings' in self.content:
            self.info.append("Term bindings found")
            # Check for LOINC bindings
            if 'LOINC' in self.content:
                self.info.append("LOINC term bindings present")
            if 'SNOMED' in self.content or 'snomed' in self.content.lower():
                self.info.append("SNOMED-CT term bindings present")
        else:
            self.warnings.append("No term_bindings defined (consider adding standard terminology mappings)")

        return True

    def validate_syntax(self) -> bool:
        """Basic syntax validation."""
        valid = True

        # Check balanced braces
        open_braces = self.content.count('{')
        close_braces = self.content.count('}')
        if open_braces != close_braces:
            self.errors.append(f"Unbalanced braces: {open_braces} open, {close_braces} close")
            valid = False

        # Check balanced angle brackets in ADL
        # Note: This is simplified - ADL uses < > for value constraints
        open_angles = self.content.count('<')
        close_angles = self.content.count('>')
        if open_angles != close_angles:
            self.warnings.append(f"Angle brackets may be unbalanced: {open_angles} < and {close_angles} >")

        # Check for common ADL 2.0 patterns
        if 'matches' not in self.content:
            self.warnings.append("No 'matches' constraints found")

        if 'occurrences' not in self.content:
            self.warnings.append("No 'occurrences' constraints found")

        return valid

    def validate(self) -> Tuple[bool, Dict]:
        """Run all validations."""
        if not self.load():
            return False, self.get_results()

        results = [
            self.validate_archetype_id(),
            self.validate_sections(),
            self.validate_language(),
            self.validate_description(),
            self.validate_definition(),
            self.validate_terminology(),
            self.validate_syntax()
        ]

        return all(results), self.get_results()

    def get_results(self) -> Dict:
        """Get validation results as dictionary."""
        return {
            'file': self.filename,
            'errors': self.errors,
            'warnings': self.warnings,
            'info': self.info,
            'valid': len(self.errors) == 0
        }


def validate_directory(directory: str) -> List[Dict]:
    """Validate all ADL files in a directory."""
    results = []
    path = Path(directory)

    for adl_file in path.glob('*.adl'):
        validator = ADLValidator(str(adl_file))
        is_valid, result = validator.validate()
        results.append(result)

    return results


def print_results(results: List[Dict]):
    """Print validation results."""
    print("\n" + "="*70)
    print("ADL 2.0 ARCHETYPE VALIDATION REPORT")
    print("="*70)

    total_errors = 0
    total_warnings = 0

    for result in results:
        print(f"\n{'-'*70}")
        print(f"FILE: {result['file']}")
        print(f"STATUS: {'VALID' if result['valid'] else 'INVALID'}")
        print(f"{'-'*70}")

        if result['info']:
            print("\n[INFO]")
            for info in result['info']:
                print(f"  - {info}")

        if result['warnings']:
            print("\n[WARNINGS]")
            for warning in result['warnings']:
                print(f"  ! {warning}")
            total_warnings += len(result['warnings'])

        if result['errors']:
            print("\n[ERRORS]")
            for error in result['errors']:
                print(f"  X {error}")
            total_errors += len(result['errors'])

    print(f"\n{'='*70}")
    print(f"SUMMARY: {len(results)} files validated")
    print(f"  Valid: {sum(1 for r in results if r['valid'])}")
    print(f"  Invalid: {sum(1 for r in results if not r['valid'])}")
    print(f"  Total Errors: {total_errors}")
    print(f"  Total Warnings: {total_warnings}")
    print("="*70)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        # Default to archetypes directory
        directory = os.path.dirname(os.path.abspath(__file__))
        directory = os.path.join(os.path.dirname(directory), 'archetypes', 'new')
    else:
        directory = sys.argv[1]

    if os.path.isfile(directory):
        # Single file validation
        validator = ADLValidator(directory)
        is_valid, result = validator.validate()
        print_results([result])
    elif os.path.isdir(directory):
        # Directory validation
        results = validate_directory(directory)
        print_results(results)
    else:
        print(f"Error: '{directory}' is not a valid file or directory")
        sys.exit(1)

    # Exit with appropriate code
    sys.exit(0 if all(r['valid'] for r in (results if 'results' in dir() else [result])) else 1)
