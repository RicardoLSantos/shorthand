#!/usr/bin/env python3
"""
Extract FHIR validation errors from qa.xml
Usage: python3 extract_errors_xml.py [path/to/qa.xml]
"""

import xml.etree.ElementTree as ET
import sys

def extract_errors(xml_file):
    """Extract errors from qa.xml file"""
    tree = ET.parse(xml_file)
    root = tree.getroot()

    # FHIR namespace
    ns = {'fhir': 'http://hl7.org/fhir'}

    errors = []
    for entry in root.findall('.//fhir:entry', ns):
        resource = entry.find('.//fhir:OperationOutcome', ns)
        if resource is not None:
            file_ext = entry.find('.//fhir:extension[@url="http://hl7.org/fhir/StructureDefinition/operationoutcome-file"]/fhir:valueString', ns)
            file_name = file_ext.get('value') if file_ext is not None else 'Unknown'

            for issue in resource.findall('.//fhir:issue', ns):
                severity = issue.find('.//fhir:severity', ns)
                if severity is not None and severity.get('value') == 'error':
                    message_elem = issue.find('.//fhir:details/fhir:text', ns)
                    expression_elem = issue.find('.//fhir:expression', ns)
                    message_id_elem = issue.find('.//fhir:extension[@url="http://hl7.org/fhir/StructureDefinition/operationoutcome-message-id"]/fhir:valueCode', ns)

                    error_info = {
                        'file': file_name,
                        'message': message_elem.get('value') if message_elem is not None else 'No message',
                        'expression': expression_elem.get('value') if expression_elem is not None else 'No expression',
                        'message_id': message_id_elem.get('value') if message_id_elem is not None else ''
                    }
                    errors.append(error_info)

    return errors

def main():
    xml_file = sys.argv[1] if len(sys.argv) > 1 else 'output/qa.xml'

    try:
        errors = extract_errors(xml_file)

        print(f"Total errors found: {len(errors)}")
        print("\n" + "="*80 + "\n")

        for i, err in enumerate(errors, 1):
            file_name = err['file'].split('/')[-1] if '/' in err['file'] else err['file']
            print(f"{i}. File: {file_name}")
            print(f"   Expression: {err['expression']}")
            if err['message_id']:
                print(f"   ID: {err['message_id']}")
            print(f"   Message: {err['message'][:200]}")
            if len(err['message']) > 200:
                print(f"            ... (truncated)")
            print()

    except FileNotFoundError:
        print(f"Error: File '{xml_file}' not found")
        sys.exit(1)
    except ET.ParseError as e:
        print(f"Error: Invalid XML - {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
