#!/usr/bin/env python3
"""
Extract FHIR validation errors from qa.json
Usage: python3 extract_errors_json.py [path/to/qa.json]
"""

import json
import sys

def extract_errors(json_file):
    """Extract errors from qa.json file"""
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    errors = []

    # Navigate the JSON structure
    if 'files' in data:
        for file_entry in data['files']:
            if 'messages' in file_entry:
                for msg in file_entry['messages']:
                    if msg.get('level') == 'error' or msg.get('severity') == 'error':
                        error_info = {
                            'file': file_entry.get('filename', 'Unknown'),
                            'line': msg.get('line', '?'),
                            'col': msg.get('col', '?'),
                            'message': msg.get('message', ''),
                            'type': msg.get('type', ''),
                            'id': msg.get('message-id', '')
                        }
                        errors.append(error_info)

    return errors

def main():
    json_file = sys.argv[1] if len(sys.argv) > 1 else 'output/qa.json'

    try:
        errors = extract_errors(json_file)

        print(f"Total errors found: {len(errors)}")
        print("\n" + "="*80 + "\n")

        for i, err in enumerate(errors, 1):
            print(f"{i}. File: {err['file']}")
            print(f"   Location: Line {err['line']}, Col {err['col']}")
            if err['type']:
                print(f"   Type: {err['type']}")
            if err['id']:
                print(f"   ID: {err['id']}")
            print(f"   Message: {err['message'][:200]}")
            if len(err['message']) > 200:
                print(f"            ... (truncated)")
            print()

    except FileNotFoundError:
        print(f"Error: File '{json_file}' not found")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON - {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
