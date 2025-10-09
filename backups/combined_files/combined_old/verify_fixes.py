#!/usr/bin/env python3
"""
Script para verificar se as correções foram aplicadas corretamente
"""

import json
import glob
import re

def verify_files():
    issues = []
    files_checked = 0
    
    for filepath in glob.glob("*.json"):
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            files_checked += 1
            filename = filepath.split('/')[-1]
            
            # Verificar URLs
            if "url" in data:
                url = data["url"]
                if "/fhir/" in url and "/ig/ios-lifestyle-medicine/" not in url:
                    issues.append(f"{filename}: URL ainda usa /fhir/: {url}")
            
            # Verificar jurisdiction
            if "jurisdiction" in data:
                for j in data["jurisdiction"]:
                    for c in j.get("coding", []):
                        if c.get("code") == "150" and c.get("system") == "urn:iso:std:iso:3166":
                            issues.append(f"{filename}: Jurisdiction 150 ainda usa ISO 3166")
            
            # Verificar ShareableValueSet
            resource_type = data.get("resourceType")
            if resource_type == "ValueSet":
                if "experimental" not in data:
                    issues.append(f"{filename}: ValueSet sem campo 'experimental'")
            elif resource_type == "CodeSystem":
                if "experimental" not in data:
                    issues.append(f"{filename}: CodeSystem sem campo 'experimental'")
                if "content" not in data:
                    issues.append(f"{filename}: CodeSystem sem campo 'content'")
            
        except Exception as e:
            issues.append(f"Erro ao verificar {filepath}: {e}")
    
    # Relatório
    print("\n" + "="*60)
    print("VERIFICAÇÃO PÓS-CORREÇÃO")
    print("="*60)
    print(f"Arquivos verificados: {files_checked}")
    
    if issues:
        print(f"\n⚠ {len(issues)} problemas encontrados:\n")
        for issue in issues:
            print(f"  - {issue}")
    else:
        print("\n✓ Todos os arquivos parecem estar corretos!")
    
    print("="*60 + "\n")

if __name__ == "__main__":
    verify_files()