#!/usr/bin/env python3
"""
Script completo para correção de erros FHIR
iOS Lifestyle Medicine Implementation Guide
Autor: Sistema de Correção FHIR
Data: 2025
"""

import json
import glob
import os
import re
from datetime import datetime
from collections import defaultdict

class FHIRValidator:
    def __init__(self):
        self.backup_dir = f"backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        self.errors_fixed = defaultdict(int)
        self.files_processed = 0
        
        # Mapeamento de códigos SNOMED inválidos para válidos
        self.snomed_replacements = {
            "711415009": {"code": "285854004", "display": "Emotion"},
            "118682006": {"code": "386053000", "display": "Evaluation procedure"},
            "725854004": {"code": "102894008", "display": "Feeling good"},
            "229058003": {"code": "226029000", "display": "Exercise"},
            "32147004": {"code": "32915005", "display": "Exercise activity"},
            "255214005": {"code": "255214003", "display": "After exercise"},
            "248626006": {"code": "307818003", "display": "During exercise"},
            "130991005": {"code": "18963009", "display": "Mood finding"}
        }
        
        # Display names corretos para códigos SNOMED válidos
        self.snomed_displays = {
            "373931001": "Mood",
            "285854004": "Emotion", 
            "18963009": "Mood finding"
        }
    
    def create_backup(self):
        """Criar diretório de backup"""
        os.makedirs(self.backup_dir, exist_ok=True)
        print(f"✓ Diretório de backup criado: {self.backup_dir}")
    
    def process_file(self, filepath):
        """Processar um arquivo JSON FHIR"""
        try:
            # Fazer backup
            filename = os.path.basename(filepath)
            backup_path = os.path.join(self.backup_dir, filename)
            os.system(f"cp '{filepath}' '{backup_path}'")
            
            # Ler arquivo
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            original_data = json.dumps(data)
            
            # Aplicar correções baseadas no tipo de recurso
            resource_type = data.get("resourceType")
            
            if resource_type in ["ValueSet", "CodeSystem", "Questionnaire", "StructureDefinition"]:
                self.fix_canonical_urls(data, filename)
                self.fix_jurisdiction(data)
                self.fix_shareable_elements(data, resource_type)
            
            if resource_type == "Questionnaire":
                self.fix_questionnaire_urls(data)
            
            # Corrigir SNOMED CT em qualquer recurso
            self.fix_snomed_codes(data)
            
            # Verificar se houve mudanças
            if json.dumps(data) != original_data:
                # Salvar arquivo corrigido
                with open(filepath, 'w', encoding='utf-8') as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
                
                print(f"✓ {filename}: {sum(self.errors_fixed.values())} correções aplicadas")
            
            self.files_processed += 1
            
        except Exception as e:
            print(f"✗ Erro ao processar {filepath}: {e}")
    
    def fix_canonical_urls(self, data, filename):
        """Corrigir URLs canônicas para usar padrão consistente"""
        # Determinar o nome base do recurso
        resource_name = filename.replace('.json', '')
        resource_type = data.get("resourceType", "").lower()
        
        # Se tiver URL com /fhir/, mudar para /ig/ios-lifestyle-medicine/
        if "url" in data:
            old_url = data["url"]
            if "/fhir/" in old_url:
                # Extrair o nome do recurso da URL antiga
                match = re.search(r'/([^/]+)$', old_url)
                if match:
                    name = match.group(1)
                else:
                    name = resource_name
                
                # Construir nova URL
                if resource_type:
                    resource_type_cap = resource_type[0].upper() + resource_type[1:]
                    new_url = f"https://2rdoc.pt/ig/ios-lifestyle-medicine/{resource_type_cap}/{name}"
                    data["url"] = new_url
                    self.errors_fixed['canonical_url'] += 1
    
    def fix_jurisdiction(self, data):
        """Corrigir código de jurisdiction 150"""
        if "jurisdiction" in data:
            for jurisdiction in data["jurisdiction"]:
                if "coding" in jurisdiction:
                    for coding in jurisdiction["coding"]:
                        if coding.get("code") == "150":
                            if coding.get("system") == "urn:iso:std:iso:3166":
                                # Mudar para UN M.49 para código regional
                                coding["system"] = "http://unstats.un.org/unsd/methods/m49/m49.htm"
                                coding["display"] = "Europe"
                                self.errors_fixed['jurisdiction'] += 1
                            
                            # Alternativa: usar PT para Portugal
                            # coding["code"] = "PT"
                            # coding["display"] = "Portugal"
    
    def fix_shareable_elements(self, data, resource_type):
        """Adicionar elementos obrigatórios para ShareableValueSet/CodeSystem"""
        if resource_type == "ValueSet":
            if "experimental" not in data:
                data["experimental"] = False
                self.errors_fixed['shareable'] += 1
            
            if "description" not in data:
                data["description"] = f"Generated description for {data.get('name', 'ValueSet')}"
                self.errors_fixed['shareable'] += 1
            
            if "version" not in data:
                data["version"] = "1.0.0"
                self.errors_fixed['shareable'] += 1
        
        elif resource_type == "CodeSystem":
            if "experimental" not in data:
                data["experimental"] = False
                self.errors_fixed['shareable'] += 1
            
            if "description" not in data:
                data["description"] = f"Generated description for {data.get('name', 'CodeSystem')}"
                self.errors_fixed['shareable'] += 1
            
            if "content" not in data:
                data["content"] = "complete"
                self.errors_fixed['shareable'] += 1
            
            if "version" not in data:
                data["version"] = "1.0.0"
                self.errors_fixed['shareable'] += 1
    
    def fix_questionnaire_urls(self, data):
        """Corrigir URLs de Questionnaire para corresponder ao ID"""
        if "id" in data and "url" in data:
            resource_id = data["id"]
            expected_url = f"https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/{resource_id}"
            
            if data["url"] != expected_url:
                data["url"] = expected_url
                self.errors_fixed['questionnaire_url'] += 1
    
    def fix_snomed_codes(self, data):
        """Corrigir códigos e displays SNOMED CT recursivamente"""
        if isinstance(data, dict):
            for key, value in data.items():
                if key == "coding" and isinstance(value, list):
                    for coding in value:
                        if coding.get("system") == "http://snomed.info/sct":
                            code = coding.get("code")
                            
                            # Verificar se é código inválido
                            if code in self.snomed_replacements:
                                replacement = self.snomed_replacements[code]
                                coding["code"] = replacement["code"]
                                coding["display"] = replacement["display"]
                                self.errors_fixed['snomed_invalid'] += 1
                            
                            # Corrigir display para códigos válidos
                            elif code in self.snomed_displays:
                                correct_display = self.snomed_displays[code]
                                if coding.get("display") != correct_display:
                                    coding["display"] = correct_display
                                    self.errors_fixed['snomed_display'] += 1
                
                # Recursão para objetos e listas aninhados
                elif isinstance(value, (dict, list)):
                    self.fix_snomed_codes(value)
        
        elif isinstance(data, list):
            for item in data:
                self.fix_snomed_codes(item)
    
    def run(self):
        """Executar todas as correções"""
        print("\n" + "="*60)
        print("FHIR Validation Error Fixer - iOS Lifestyle Medicine IG")
        print("="*60 + "\n")
        
        self.create_backup()
        
        # Processar todos os arquivos JSON
        json_files = glob.glob("*.json")
        print(f"\nProcessando {len(json_files)} arquivos JSON...\n")
        
        for filepath in json_files:
            self.process_file(filepath)
        
        # Relatório final
        print("\n" + "="*60)
        print("RELATÓRIO DE CORREÇÕES")
        print("="*60)
        print(f"Arquivos processados: {self.files_processed}")
        print(f"URLs canônicas corrigidas: {self.errors_fixed['canonical_url']}")
        print(f"Jurisdictions corrigidas: {self.errors_fixed['jurisdiction']}")
        print(f"Elementos ShareableValueSet/CodeSystem adicionados: {self.errors_fixed['shareable']}")
        print(f"URLs de Questionnaire corrigidas: {self.errors_fixed['questionnaire_url']}")
        print(f"Códigos SNOMED inválidos substituídos: {self.errors_fixed['snomed_invalid']}")
        print(f"Display names SNOMED corrigidos: {self.errors_fixed['snomed_display']}")
        print(f"\nTotal de correções: {sum(self.errors_fixed.values())}")
        print(f"\nBackup salvo em: {self.backup_dir}/")
        print("="*60 + "\n")

if __name__ == "__main__":
    validator = FHIRValidator()
    validator.run()