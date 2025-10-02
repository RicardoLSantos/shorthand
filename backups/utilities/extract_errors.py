#!/usr/bin/env python3
"""
Extract FHIR validation errors from qa.html
Usage: python3 extract_errors.py [path/to/qa.html]
"""

from html.parser import HTMLParser
import sys
import re

class ErrorExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.in_error = False
        self.errors = []
        self.current_error = []

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        if 'class' in attrs_dict and 'issue-error' in attrs_dict['class']:
            self.in_error = True

    def handle_endtag(self, tag):
        if tag == 'div' and self.in_error:
            if self.current_error:
                error_text = ''.join(self.current_error).strip()
                # Clean up extra whitespace
                error_text = re.sub(r'\s+', ' ', error_text)
                self.errors.append(error_text)
                self.current_error = []
            self.in_error = False

    def handle_data(self, data):
        if self.in_error:
            self.current_error.append(data)

def extract_errors(html_file):
    """Extract errors from qa.html file"""
    with open(html_file, 'r', encoding='utf-8') as f:
        content = f.read()

    parser = ErrorExtractor()
    parser.feed(content)

    return parser.errors

def main():
    html_file = sys.argv[1] if len(sys.argv) > 1 else 'output/qa.html'

    try:
        errors = extract_errors(html_file)

        print(f"Total errors found: {len(errors)}")
        print("\n" + "="*80 + "\n")

        for i, err in enumerate(errors, 1):
            # Truncate very long errors for readability
            if len(err) > 300:
                err = err[:297] + "..."
            print(f"{i}. {err}")
            print()

    except FileNotFoundError:
        print(f"Error: File '{html_file}' not found")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
