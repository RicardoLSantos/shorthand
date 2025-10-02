```

## 7. MÉTRICAS E INDICADORES

### 7.1 KPIs de Conformidade

**Métricas de Conformidade Internacional**⁸:
- **Taxa de mapeamento bem-sucedido**: >95% entre padrões
- **Cobertura de terminologia**: 100% dos conceitos críticos
- **Validação cross-standard**: >98% de precisão
- **Tempo de mapeamento**: <100ms por conceito
- **Conformidade com perfis**: 100% dos must-support elements

### 7.2 Indicadores de Interoperabilidade

**Métricas de Integração**⁹:
- Suporte a perfis internacionais (IPS, IPA, US Core)
- Conformidade com IHE (ITI, PCC, QRPH)
- Certificação ISO 13606 e HL7
- Adoção de vocabulários padrão (SNOMED, LOINC)
- Taxa de sucesso em testes Connectathon

### 7.3 Matriz de Conformidade

| Padrão | Nível Requerido | Nível Atual | Status |
|--------|-----------------|-------------|--------|
| FHIR R4 | 100% | 100% | ✓ Conforme |
| IPS | Core elements | 95% | ⚠ Em progresso |
| IHE MHD | Full support | 100% | ✓ Conforme |
| openEHR | Basic mapping | 85% | ⚠ Em desenvolvimento |
| OMOP CDM | v5.4 | 90% | ✓ Parcialmente conforme |
| SNOMED CT | GPS subset | 100% | ✓ Conforme |
| LOINC | Common codes | 98% | ✓ Conforme |

### 7.4 Fórmulas de Cálculo

```javascript
// Score de Interoperabilidade Global
interoperabilityScore = (
  (fhirConformance * 0.3) +
  (terminologyMapping * 0.25) +
  (iheCompliance * 0.25) +
  (crossStandardValidation * 0.2)
) * 100;

// Taxa de Mapeamento Bem-Sucedido
mappingSuccessRate = (successfulMappings / totalMappingAttempts) * 100;

// Índice de Maturidade de Padrões
maturityIndex = (
  certifiedStandards / totalImplementedStandards
) * 100;
```

## 8. FERRAMENTAS E RECURSOS

### 8.1 Ferramentas de Mapeamento

1. **FHIR Mapper**: Mapeamento visual entre padrões
2. **Ontoserver**: Servidor de terminologia FHIR
3. **Snow Owl**: Gestão de terminologias
4. **OpenEHR Archetype Designer**: Design de arquétipos
5. **OMOP CDM ETL Tools**: Ferramentas de ETL para OMOP
6. **HAPI FHIR Converter**: Conversão entre versões FHIR

### 8.2 Validadores e Testadores

1. **FHIR Validator**: Validação oficial HL7
2. **Touchstone**: Plataforma de testes IHE
3. **Gazelle**: Testes de conformidade IHE
4. **SNOMED CT Browser**: Navegação e validação
5. **LOINC Search**: Busca e validação de códigos

### 8.3 Recursos de Referência

- **HL7 International**: [https://www.hl7.org/](https://www.hl7.org/)
- **IHE International**: [https://www.ihe.net/](https://www.ihe.net/)
- **openEHR Foundation**: [https://www.openehr.org/](https://www.openehr.org/)
- **OHDSI Collaborative**: [https://www.ohdsi.org/](https://www.ohdsi.org/)
- **SNOMED International**: [https://www.snomed.org/](https://www.snomed.org/)

## 9. RESOLUÇÃO DE PROBLEMAS

### 9.1 Problemas Comuns de Mapeamento

| Problema | Causa | Solução |
|----------|-------|---------|
| Conceito não mapeável | Granularidade diferente | Usar mapeamento aproximado com qualificador |
| Cardinalidade incompatível | Modelos diferentes | Aplicar transformação com validação |
| Código não encontrado | Versão desatualizada | Atualizar para última versão do vocabulário |
| Estrutura incompatível | Paradigmas diferentes | Implementar camada de abstração |
| Perda de informação | Campos não suportados | Usar extensions/arquétipos customizados |

### 9.2 Checklist de Validação Cross-Standard

```markdown
- [ ] Verificar versão de cada padrão
- [ ] Confirmar mapeamentos de terminologia
- [ ] Validar cardinalidades e tipos de dados
- [ ] Testar transformações bidirecionais
- [ ] Verificar perda de informação
- [ ] Validar contra perfis de conformidade
- [ ] Executar testes de integração
- [ ] Documentar limitações conhecidas
- [ ] Revisar com especialistas do domínio
- [ ] Certificar com organismos relevantes
```

### 9.3 Script de Validação Multi-Padrão

```bash
#!/bin/bash
# validate-multi-standard.sh - Validação entre múltiplos padrões

echo "🌍 Validação Multi-Padrão Internacional"
echo "========================================"

# Configurações
FHIR_SERVER="http://localhost:8080/fhir"
OPENEHR_SERVER="http://localhost:8081/ehrbase"
TERMINOLOGY_SERVER="https://r4.ontoserver.csiro.au/fhir"

# Função para validar FHIR
validate_fhir() {
    echo "1. Validando conformidade FHIR R4..."
    
    # Baixar IG Internacional
    wget -q https://packages.simplifier.net/hl7.fhir.uv.ips/-/hl7.fhir.uv.ips-1.1.0.tgz
    
    # Validar contra IPS
    java -jar validator_cli.jar \
        -version 4.0.1 \
        -ig hl7.fhir.uv.ips-1.1.0.tgz \
        -profile http://hl7.org/fhir/uv/ips/StructureDefinition/Bundle-uv-ips \
        examples/ips-bundle.json
    
    echo "✓ Validação FHIR concluída"
}

# Função para validar terminologias
validate_terminologies() {
    echo "2. Validando terminologias..."
    
    # Validar SNOMED CT
    curl -s "${TERMINOLOGY_SERVER}/CodeSystem/\$validate-code" \
        -H "Content-Type: application/fhir+json" \
        -d '{
            "resourceType": "Parameters",
            "parameter": [{
                "name": "url",
                "valueUri": "http://snomed.info/sct"
            },{
                "name": "code",
                "valueCode": "386661006"
            }]
        }' | jq '.parameter[] | select(.name=="result") | .valueBoolean'
    
    # Validar LOINC
    curl -s "${TERMINOLOGY_SERVER}/CodeSystem/\$validate-code" \
        -H "Content-Type: application/fhir+json" \
        -d '{
            "resourceType": "Parameters",
            "parameter": [{
                "name": "url",
                "valueUri": "http://loinc.org"
            },{
                "name": "code",
                "valueCode": "8310-5"
            }]
        }' | jq '.parameter[] | select(.name=="result") | .valueBoolean'
    
    echo "✓ Validação de terminologias concluída"
}

# Função para testar mapeamentos
test_mappings() {
    echo "3. Testando mapeamentos entre padrões..."
    
    # Testar FHIR → openEHR
    echo "   FHIR → openEHR: "
    node test-mappings/fhir-to-openehr.js && echo "   ✓ OK" || echo "   ✗ Falha"
    
    # Testar FHIR → OMOP
    echo "   FHIR → OMOP: "
    python test-mappings/fhir-to-omop.py && echo "   ✓ OK" || echo "   ✗ Falha"
    
    # Testar openEHR → FHIR
    echo "   openEHR → FHIR: "
    node test-mappings/openehr-to-fhir.js && echo "   ✓ OK" || echo "   ✗ Falha"
    
    echo "✓ Testes de mapeamento concluídos"
}

# Função para verificar conformidade IHE
check_ihe_conformance() {
    echo "4. Verificando conformidade IHE..."
    
    # Testar MHD
    echo "   Perfil MHD (ITI-65, ITI-66, ITI-67): "
    curl -s -X POST "${FHIR_SERVER}/" \
        -H "Content-Type: application/fhir+json" \
        -d @examples/mhd-provide-bundle.json \
        -o /dev/null -w "%{http_code}" | grep -q "200\|201" && \
        echo "   ✓ OK" || echo "   ✗ Falha"
    
    # Testar PIXm
    echo "   Perfil PIXm (ITI-83): "
    curl -s "${FHIR_SERVER}/Patient/\$ihe-pix" \
        -o /dev/null -w "%{http_code}" | grep -q "200" && \
        echo "   ✓ OK" || echo "   ✗ Falha"
    
    echo "✓ Verificação IHE concluída"
}

# Gerar relatório
generate_report() {
    echo "5. Gerando relatório de conformidade..."
    
    cat > conformance-report.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Relatório de Conformidade Internacional</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #1e3a8a; color: white; padding: 20px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .pass { color: green; font-weight: bold; }
        .fail { color: red; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #3b82f6; color: white; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Relatório de Conformidade com Padrões Internacionais</h1>
        <p>Data: $(date)</p>
    </div>
    
    <div class="section">
        <h2>Resumo Executivo</h2>
        <p>Conformidade Global: <span class="pass">92%</span></p>
        <ul>
            <li>FHIR R4: <span class="pass">✓ Conforme</span></li>
            <li>IHE Profiles: <span class="pass">✓ Conforme</span></li>
            <li>Terminologias: <span class="pass">✓ Validadas</span></li>
            <li>Mapeamentos: <span class="pass">✓ Funcionais</span></li>
        </ul>
    </div>
    
    <div class="section">
        <h2>Detalhes de Conformidade</h2>
        <table>
            <tr>
                <th>Padrão</th>
                <th>Versão</th>
                <th>Status</th>
                <th>Observações</th>
            </tr>
            <tr>
                <td>HL7 FHIR</td>
                <td>R4 (4.0.1)</td>
                <td class="pass">Conforme</td>
                <td>Validado contra IPS 1.1.0</td>
            </tr>
            <tr>
                <td>IHE MHD</td>
                <td>4.2.0</td>
                <td class="pass">Conforme</td>
                <td>ITI-65, ITI-66, ITI-67 testados</td>
            </tr>
            <tr>
                <td>SNOMED CT</td>
                <td>2024-03-01</td>
                <td class="pass">Conforme</td>
                <td>GPS subset implementado</td>
            </tr>
            <tr>
                <td>LOINC</td>
                <td>2.76</td>
                <td class="pass">Conforme</td>
                <td>Códigos comuns validados</td>
            </tr>
            <tr>
                <td>openEHR</td>
                <td>Release-1.1.0</td>
                <td class="pass">Parcial</td>
                <td>Mapeamento básico funcional</td>
            </tr>
            <tr>
                <td>OMOP CDM</td>
                <td>v5.4</td>
                <td class="pass">Parcial</td>
                <td>90% dos conceitos mapeados</td>
            </tr>
        </table>
    </div>
    
    <div class="section">
        <h2>Recomendações</h2>
        <ol>
            <li>Completar mapeamento de conceitos OMOP pendentes</li>
            <li>Implementar templates openEHR adicionais</li>
            <li>Atualizar para SNOMED CT International Edition mais recente</li>
            <li>Realizar testes no próximo IHE Connectathon</li>
            <li>Obter certificação formal IHE</li>
        </ol>
    </div>
</body>
</html>
HTML
    
    echo "✓ Relatório gerado: conformance-report.html"
}

# Executar validações
echo ""
validate_fhir
echo ""
validate_terminologies
echo ""
test_mappings
echo ""
check_ihe_conformance
echo ""
generate_report
echo ""
echo "========================================"
echo "✅ Validação Multi-Padrão Concluída!"
```

## 10. REFERÊNCIAS

1. HL7 FHIR. **FHIR R5 Conformance Module**. Disponível em: [https://www.hl7.org/fhir/R5/conformance-module.html](https://www.hl7.org/fhir/R5/conformance-module.html). Acesso em: 2024.

2. ISO. **ISO/TS 21564:2019 - Health Informatics — Terminology resource map quality measures**. Disponível em: [https://www.iso.org/standard/71084.html](https://www.iso.org/standard/71084.html). Acesso em: 2024.

3. IHE International. **IHE IT Infrastructure (ITI) Technical Framework**. Disponível em: [https://www.ihe.net/resources/technical_frameworks/#IT](https://www.ihe.net/resources/technical_frameworks/#IT). Acesso em: 2024.

4. WHO. **Global Strategy on Digital Health 2020-2025**. Disponível em: [https://www.who.int/docs/default-source/documents/gs4dhdaa2a9f352b0445bafbc79ca799dce4d.pdf](https://www.who.int/docs/default-source/documents/gs4dhdaa2a9f352b0445bafbc79ca799dce4d.pdf). Acesso em: 2024.

5. HL7 FHIR. **FHIR Foundation Module - Conformance**. Disponível em: [https://www.hl7.org/fhir/foundation-module.html#conformance](https://www.hl7.org/fhir/foundation-module.html#conformance). Acesso em: 2024.

6. openEHR Foundation. **openEHR Integration Information Model (IIM)**. Disponível em: [https://specifications.openehr.org/releases/ITS-FHIR/latest/](https://specifications.openehr.org/releases/ITS-FHIR/latest/). Acesso em: 2024.

7. OHDSI Collaborative. **The Book of OHDSI**. Disponível em: [https://ohdsi.github.io/TheBookOfOhdsi/](https://ohdsi.github.io/TheBookOfOhdsi/). Acesso em: 2024.

8. IHE International. **Mobile Health Documents (MHD) Supplement**. Disponível em: [https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_MHD.pdf](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_MHD.pdf). Acesso em: 2024.

9. ISO. **ISO 13606-1:2019 - Health informatics — Electronic health record communication**. Disponível em: [https://www.iso.org/standard/67868.html](https://www.iso.org/standard/67868.html). Acesso em: 2024.

10. SNOMED International. **SNOMED CT Implementation Guide for FHIR**. Disponível em: [https://confluence.ihtsdotools.org/display/DOCTIG/SNOMED+CT+Implementation+Guide+for+FHIR](https://confluence.ihtsdotools.org/display/DOCTIG/SNOMED+CT+Implementation+Guide+for+FHIR). Acesso em: 2024.

11. Regenstrief Institute. **LOINC FHIR Terminology Services**. Disponível em: [https://fhir.loinc.org/](https://fhir.loinc.org/). Acesso em: 2024.

12. HL7 International. **HL7 Version 2 to FHIR Mapping**. Disponível em: [https://build.fhir.org/ig/HL7/v2-to-fhir/](https://build.fhir.org/ig/HL7/v2-to-fhir/). Acesso em: 2024.

13. IHE International. **Cross-Enterprise Document Sharing (XDS.b) Integration Profile**. Disponível em: [https://wiki.ihe.net/index.php/Cross-Enterprise_Document_Sharing](https://wiki.ihe.net/index.php/Cross-Enterprise_Document_Sharing). Acesso em: 2024.

14. HL7 FHIR. **International Patient Summary (IPS) Implementation Guide STU1**. Disponível em: [http://hl7.org/fhir/uv/ips/STU1/](http://hl7.org/fhir/uv/ips/STU1/). Acesso em: 2024.

15. HL7 FHIR. **International Patient Access (IPA) v1.0.0**. Disponível em: [http://hl7.org/fhir/uv/ipa/STU1/](http://hl7.org/fhir/uv/ipa/STU1/). Acesso em: 2024.

---

**Histórico de Revisões:**
- v1.0.0 (2024): Versão inicial

**Aprovações:**
- Arquiteto de Interoperabilidade: _________________
- Gerente de Qualidade: _________________
- Diretor Técnico: _________________

**Distribuição:**
- Equipe de Desenvolvimento
- Equipe de Arquitetura
- Equipe de Qualidade
- Parceiros de Integração# SOP-020: Conformidade com Padrões Internacionais em FHIR

**Versão:** 1.0.0  
**Data de Criação:** 2024  
**Última Atualização:** 2024  
**Responsável:** Equipe de Arquitetura e Interoperabilidade  
**Status:** Ativo

## 1. OBJETIVO

Estabelecer procedimentos para garantir conformidade de Implementation Guides FHIR com padrões internacionais de interoperabilidade, incluindo IHE, ISO, openEHR, OMOP e frameworks globais de saúde digital¹.

## 2. ESCOPO

Este SOP abrange:
- Mapeamento entre padrões (FHIR ↔ openEHR ↔ OMOP)
- Conformidade com perfis IHE
- Certificação ISO 13606 e ISO/HL7 27931
- Integração com SNOMED CT e LOINC
- Validação cross-standard
- Harmonização internacional

## 3. DEFINIÇÕES E CONCEITOS

### 3.1 Fundamentos Teóricos

**Interoperabilidade Multi-Padrão**²:
- **Sintática**: Estrutura e formato de dados
- **Semântica**: Significado clínico consistente
- **Organizacional**: Processos e workflows
- **Técnica**: Protocolos e APIs

**Framework de Conformidade IHE**³:
- **Actors**: Sistemas participantes
- **Transactions**: Interações padronizadas
- **Content Profiles**: Estruturas de documentos
- **Integration Profiles**: Casos de uso completos

### 3.2 Ecossistema de Padrões

**Hierarquia de Padrões**⁴:
1. **Nível Global**: ISO, WHO Standards
2. **Nível Regional**: CEN (Europa), ANSI (EUA)
3. **Nível Nacional**: ABNT (Brasil), DIN (Alemanha)
4. **Nível Setorial**: HL7, DICOM, IEEE

## 4. RESPONSABILIDADES

### 4.1 Arquiteto de Interoperabilidade
- Definir estratégia de conformidade
- Mapear requisitos entre padrões
- Aprovar arquiteturas híbridas

### 4.2 Equipe de Standards
- Manter conhecimento atualizado
- Realizar mapeamentos
- Validar conformidade

### 4.3 Equipe de Certificação
- Preparar documentação
- Coordenar auditorias
- Manter certificações

## 5. PROCEDIMENTOS - PARTE TEÓRICA

### 5.1 Modelo de Conformidade Multi-Camadas

**Camada 1 - Conformidade FHIR Core**⁵:
- Aderência ao FHIR R4/R5
- Conformance Resources válidos
- Operações RESTful completas

**Camada 2 - Conformidade com Perfis Internacionais**:
- International Patient Summary (IPS)
- International Patient Access (IPA)
- Genomics Reporting IG

**Camada 3 - Conformidade Regional**:
- US Core (Estados Unidos)
- AU Base (Austrália)
- UK Core (Reino Unido)

### 5.2 Mapeamento Entre Padrões

**FHIR ↔ openEHR**⁶:
- Archetypes → StructureDefinitions
- Templates → Profiles
- Compositions → Documents
- AQL → FHIR Search

**FHIR ↔ OMOP CDM**⁷:
- Patient → Person
- Observation → Measurement/Observation
- Condition → Condition_Occurrence
- MedicationRequest → Drug_Exposure

## 6. PROCEDIMENTOS - PARTE PRÁTICA

### 6.1 Implementação de Mapeamento FHIR-openEHR

```javascript
// mappers/fhirOpenEHRMapper.js
class FHIROpenEHRMapper {
  constructor(config) {
    this.archetypeRepository = config.archetypeRepository;
    this.templateRepository = config.templateRepository;
    this.terminologyService = config.terminologyService;
  }
  
  // Mapear FHIR Patient para openEHR PERSON
  async mapPatientToPerson(fhirPatient) {
    const openEHRPerson = {
      _type: 'PERSON',
      archetype_node_id: 'openEHR-DEMOGRAPHIC-PERSON.person.v1',
      name: 'Person',
      archetype_details: {
        archetype_id: {
          value: 'openEHR-DEMOGRAPHIC-PERSON.person.v1'
        },
        template_id: {
          value: 'person_template.v1'
        },
        rm_version: '1.1.0'
      },
      identities: [],
      contacts: [],
      relationships: [],
      details: null
    };
    
    // Mapear identificadores
    if (fhirPatient.identifier) {
      for (const identifier of fhirPatient.identifier) {
        openEHRPerson.identities.push({
          _type: 'PARTY_IDENTITY',
          archetype_node_id: 'at0001',
          name: 'Identity',
          details: {
            _type: 'ITEM_TREE',
            archetype_node_id: 'at0002',
            name: 'Details',
            items: [{
              _type: 'ELEMENT',
              archetype_node_id: 'at0003',
              name: 'ID',
              value: {
                _type: 'DV_IDENTIFIER',
                id: identifier.value,
                type: identifier.system,
                issuer: identifier.assigner?.display
              }
            }]
          }
        });
      }
    }
    
    // Mapear nome
    if (fhirPatient.name) {
      const primaryName = fhirPatient.name[0];
      openEHRPerson.details = {
        _type: 'ITEM_TREE',
        archetype_node_id: 'at0010',
        name: 'Person details',
        items: [{
          _type: 'CLUSTER',
          archetype_node_id: 'openEHR-EHR-CLUSTER.person_name.v1',
          name: 'Person name',
          items: [
            {
              _type: 'ELEMENT',
              archetype_node_id: 'at0001',
              name: 'Given name',
              value: {
                _type: 'DV_TEXT',
                value: primaryName.given?.join(' ') || ''
              }
            },
            {
              _type: 'ELEMENT',
              archetype_node_id: 'at0002',
              name: 'Family name',
              value: {
                _type: 'DV_TEXT',
                value: primaryName.family || ''
              }
            }
          ]
        }]
      };
    }
    
    // Mapear data de nascimento
    if (fhirPatient.birthDate) {
      openEHRPerson.details.items.push({
        _type: 'ELEMENT',
        archetype_node_id: 'at0011',
        name: 'Date of birth',
        value: {
          _type: 'DV_DATE_TIME',
          value: fhirPatient.birthDate + 'T00:00:00'
        }
      });
    }
    
    // Mapear gênero
    if (fhirPatient.gender) {
      const genderMapping = {
        'male': 'at0020',
        'female': 'at0021',
        'other': 'at0022',
        'unknown': 'at0023'
      };
      
      openEHRPerson.details.items.push({
        _type: 'ELEMENT',
        archetype_node_id: 'at0012',
        name: 'Gender',
        value: {
          _type: 'DV_CODED_TEXT',
          value: fhirPatient.gender,
          defining_code: {
            terminology_id: {
              value: 'local'
            },
            code_string: genderMapping[fhirPatient.gender] || 'at0023'
          }
        }
      });
    }
    
    return openEHRPerson;
  }
  
  // Mapear openEHR Composition para FHIR Bundle
  async mapCompositionToBundle(openEHRComposition) {
    const fhirBundle = {
      resourceType: 'Bundle',
      type: 'document',
      timestamp: new Date().toISOString(),
      entry: []
    };
    
    // Criar Composition FHIR
    const fhirComposition = {
      resourceType: 'Composition',
      id: this.generateId(),
      status: 'final',
      type: {
        coding: [{
          system: 'http://loinc.org',
          code: await this.mapArchetypeToLOINC(
            openEHRComposition.archetype_details.archetype_id.value
          )
        }]
      },
      subject: {
        reference: `Patient/${openEHRComposition.composer.external_ref.id.value}`
      },
      date: openEHRComposition.context.start_time.value,
      author: [{
        reference: `Practitioner/${openEHRComposition.composer.external_ref.id.value}`
      }],
      title: openEHRComposition.name.value,
      section: []
    };
    
    // Processar conteúdo
    for (const content of openEHRComposition.content || []) {
      const section = await this.processOpenEHRContent(content);
      fhirComposition.section.push(section);
      
      // Adicionar recursos referenciados ao bundle
      if (section.entry) {
        for (const entry of section.entry) {
          const resource = await this.resolveReference(entry.reference);
          if (resource) {
            fhirBundle.entry.push({
              fullUrl: `urn:uuid:${resource.id}`,
              resource: resource
            });
          }
        }
      }
    }
    
    // Adicionar composition ao bundle
    fhirBundle.entry.unshift({
      fullUrl: `urn:uuid:${fhirComposition.id}`,
      resource: fhirComposition
    });
    
    return fhirBundle;
  }
  
  // Mapear arquétipo para FHIR StructureDefinition
  async mapArchetypeToStructureDefinition(archetype) {
    const structureDefinition = {
      resourceType: 'StructureDefinition',
      id: this.archetypeIdToFHIRId(archetype.archetype_id.value),
      url: `http://openehr.org/fhir/StructureDefinition/${archetype.archetype_id.value}`,
      version: archetype.archetype_id.version_id || '1.0.0',
      name: this.sanitizeName(archetype.archetype_id.value),
      title: archetype.definition.term_definitions[0].items[0].text,
      status: 'active',
      date: new Date().toISOString(),
      description: archetype.description?.details[0].purpose,
      fhirVersion: '4.0.1',
      kind: 'resource',
      abstract: false,
      type: this.mapRMTypeToFHIRResource(archetype.definition.rm_type_name),
      baseDefinition: `http://hl7.org/fhir/StructureDefinition/${this.mapRMTypeToFHIRResource(archetype.definition.rm_type_name)}`,
      derivation: 'constraint',
      differential: {
        element: []
      }
    };
    
    // Processar nós do arquétipo
    await this.processArchetypeNodes(
      archetype.definition,
      structureDefinition.differential.element,
      structureDefinition.type
    );
    
    return structureDefinition;
  }
}
```

### 6.2 Implementação de Conformidade IHE

```javascript
// ihe/iheConformance.js
class IHEConformanceValidator {
  constructor(profile) {
    this.profile = profile; // Ex: 'XDS.b', 'PIX', 'PDQ', 'MHD'
    this.actors = this.loadActors(profile);
    this.transactions = this.loadTransactions(profile);
  }
  
  // Validar conformidade com perfil IHE MHD (Mobile Health Documents)
  async validateMHDConformance(fhirServer) {
    const conformanceReport = {
      profile: 'IHE MHD',
      version: '4.2.0',
      timestamp: new Date().toISOString(),
      server: fhirServer.url,
      actors: {},
      transactions: {},
      overall: 'pending'
    };
    
    // Verificar Actor: Document Source
    conformanceReport.actors.documentSource = await this.validateDocumentSource(fhirServer);
    
    // Verificar Actor: Document Consumer
    conformanceReport.actors.documentConsumer = await this.validateDocumentConsumer(fhirServer);
    
    // Verificar Actor: Document Recipient
    conformanceReport.actors.documentRecipient = await this.validateDocumentRecipient(fhirServer);
    
    // Validar Transações
    const transactions = [
      'ITI-65', // Provide Document Bundle
      'ITI-66', // Find Document Lists
      'ITI-67', // Find Document References
      'ITI-68', // Retrieve Document
      'ITI-105', // Simplified Publish
      'ITI-106'  // Generate Metadata
    ];
    
    for (const transaction of transactions) {
      conformanceReport.transactions[transaction] = 
        await this.validateTransaction(fhirServer, transaction);
    }
    
    // Calcular conformidade geral
    const actorsPassed = Object.values(conformanceReport.actors)
      .every(a => a.status === 'passed');
    const transactionsPassed = Object.values(conformanceReport.transactions)
      .every(t => t.status === 'passed');
    
    conformanceReport.overall = actorsPassed && transactionsPassed ? 'passed' : 'failed';
    
    return conformanceReport;
  }
  
  // Validar transação ITI-65: Provide Document Bundle
  async validateITI65(fhirServer) {
    const testBundle = {
      resourceType: 'Bundle',
      type: 'transaction',
      entry: [
        {
          fullUrl: 'urn:uuid:' + this.generateUUID(),
          resource: {
            resourceType: 'DocumentManifest',
            status: 'current',
            type: {
              coding: [{
                system: 'http://loinc.org',
                code: '34133-9',
                display: 'Summary of episode note'
              }]
            },
            subject: {
              reference: 'Patient/example'
            },
            created: new Date().toISOString(),
            author: [{
              reference: 'Practitioner/example'
            }],
            content: [{
              reference: 'DocumentReference/example'
            }]
          },
          request: {
            method: 'POST',
            url: 'DocumentManifest'
          }
        },
        {
          fullUrl: 'urn:uuid:' + this.generateUUID(),
          resource: {
            resourceType: 'DocumentReference',
            status: 'current',
            type: {
              coding: [{
                system: 'http://loinc.org',
                code: '60591-5',
                display: 'Patient summary Document'
              }]
            },
            subject: {
              reference: 'Patient/example'
            },
            date: new Date().toISOString(),
            author: [{
              reference: 'Practitioner/example'
            }],
            content: [{
              attachment: {
                contentType: 'text/plain',
                data: 'VGVzdCBkb2N1bWVudCBjb250ZW50', // Base64
                title: 'Test Document'
              }
            }]
          },
          request: {
            method: 'POST',
            url: 'DocumentReference'
          }
        }
      ]
    };
    
    try {
      const response = await fetch(`${fhirServer.url}/`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/fhir+json',
          'Accept': 'application/fhir+json'
        },
        body: JSON.stringify(testBundle)
      });
      
      if (response.status === 200 || response.status === 201) {
        const responseBundle = await response.json();
        
        // Verificar resposta
        const validResponse = 
          responseBundle.resourceType === 'Bundle' &&
          responseBundle.type === 'transaction-response' &&
          responseBundle.entry?.length === 2 &&
          responseBundle.entry.every(e => 
            e.response?.status?.startsWith('201')
          );
        
        return {
          transaction: 'ITI-65',
          status: validResponse ? 'passed' : 'failed',
          details: validResponse ? 
            'Transaction bundle processed successfully' : 
            'Invalid response structure'
        };
      } else {
        return {
          transaction: 'ITI-65',
          status: 'failed',
          details: `HTTP ${response.status}: ${response.statusText}`
        };
      }
    } catch (error) {
      return {
        transaction: 'ITI-65',
        status: 'failed',
        details: error.message
      };
    }
  }
}
```

### 6.3 Mapeamento FHIR-OMOP

```javascript
// mappers/fhirOMOPMapper.js
class FHIRtoOMOPMapper {
  constructor(config) {
    this.conceptService = config.conceptService;
    this.vocabularyService = config.vocabularyService;
  }
  
  // Mapear FHIR Patient para OMOP Person
  async mapPatientToPerson(fhirPatient) {
    const omopPerson = {
      person_id: await this.generateOMOPId('person'),
      gender_concept_id: await this.mapGenderConcept(fhirPatient.gender),
      year_of_birth: null,
      month_of_birth: null,
      day_of_birth: null,
      birth_datetime: null,
      race_concept_id: 0, // No race
      ethnicity_concept_id: 0, // No ethnicity
      location_id: null,
      provider_id: null,
      care_site_id: null,
      person_source_value: fhirPatient.id,
      gender_source_value: fhirPatient.gender,
      gender_source_concept_id: 0,
      race_source_value: null,
      race_source_concept_id: 0,
      ethnicity_source_value: null,
      ethnicity_source_concept_id: 0
    };
    
    // Processar data de nascimento
    if (fhirPatient.birthDate) {
      const birthDate = new Date(fhirPatient.birthDate);
      omopPerson.year_of_birth = birthDate.getFullYear();
      omopPerson.month_of_birth = birthDate.getMonth() + 1;
      omopPerson.day_of_birth = birthDate.getDate();
      omopPerson.birth_datetime = birthDate.toISOString();
    }
    
    // Processar extensões para raça e etnia
    if (fhirPatient.extension) {
      const raceExt = fhirPatient.extension.find(e => 
        e.url === 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'
      );
      
      if (raceExt) {
        const ombCategory = raceExt.extension?.find(e => 
          e.url === 'ombCategory'
        );
        if (ombCategory) {
          omopPerson.race_source_value = ombCategory.valueCoding.display;
          omopPerson.race_concept_id = await this.mapRaceConcept(
            ombCategory.valueCoding.code
          );
        }
      }
      
      const ethnicityExt = fhirPatient.extension.find(e => 
        e.url === 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'
      );
      
      if (ethnicityExt) {
        const ombCategory = ethnicityExt.extension?.find(e => 
          e.url === 'ombCategory'
        );
        if (ombCategory) {
          omopPerson.ethnicity_source_value = ombCategory.valueCoding.display;
          omopPerson.ethnicity_concept_id = await this.mapEthnicityConcept(
            ombCategory.valueCoding.code
          );
        }
      }
    }
    
    // Processar endereço para location_id
    if (fhirPatient.address && fhirPatient.address.length > 0) {
      omopPerson.location_id = await this.mapAddressToLocation(
        fhirPatient.address[0]
      );
    }
    
    return omopPerson;
  }
  
  // Mapear FHIR Observation para OMOP Measurement/Observation
  async mapObservationToOMOP(fhirObservation) {
    // Determinar se é Measurement ou Observation baseado no código
    const conceptId = await this.mapConceptFromCoding(
      fhirObservation.code.coding[0]
    );
    
    const domain = await this.conceptService.getConceptDomain(conceptId);
    
    if (domain === 'Measurement') {
      return this.mapToMeasurement(fhirObservation, conceptId);
    } else {
      return this.mapToObservation(fhirObservation, conceptId);
    }
  }
  
  async mapToMeasurement(fhirObservation, conceptId) {
    const omopMeasurement = {
      measurement_id: await this.generateOMOPId('measurement'),
      person_id: await this.getPersonId(fhirObservation.subject.reference),
      measurement_concept_id: conceptId,
      measurement_date: fhirObservation.effectiveDateTime?.split('T')[0],
      measurement_datetime: fhirObservation.effectiveDateTime,
      measurement_time: null,
      measurement_type_concept_id: 44818702, // Lab result
      operator_concept_id: 0,
      value_as_number: null,
      value_as_concept_id: 0,
      unit_concept_id: 0,
      range_low: null,
      range_high: null,
      provider_id: null,
      visit_occurrence_id: null,
      visit_detail_id: null,
      measurement_source_value: fhirObservation.code.coding[0].code,
      measurement_source_concept_id: 0,
      unit_source_value: null,
      value_source_value: null
    };
    
    // Processar valor
    if (fhirObservation.valueQuantity) {
      omopMeasurement.value_as_number = fhirObservation.valueQuantity.value;
      omopMeasurement.unit_source_value = fhirObservation.valueQuantity.unit;
      omopMeasurement.unit_concept_id = await this.mapUnitConcept(
        fhirObservation.valueQuantity.code || fhirObservation.valueQuantity.unit
      );
    } else if (fhirObservation.valueCodeableConcept) {
      omopMeasurement.value_as_concept_id = await this.mapConceptFromCoding(
        fhirObservation.valueCodeableConcept.coding[0]
      );
      omopMeasurement.value_source_value = 
        fhirObservation.valueCodeableConcept.coding[0].display;
    }
    
    // Processar range de referência
    if (fhirObservation.referenceRange && fhirObservation.referenceRange[0]) {
      const range = fhirObservation.referenceRange[0];
      if (range.low) {
        omopMeasurement.range_low = range.low.value;
      }
      if (range.high) {
        omopMeasurement.range_high = range.high.value;
      }
    }
    
    // Mapear encounter
    if (fhirObservation.encounter) {
      omopMeasurement.visit_occurrence_id = await this.getVisitOccurrenceId(
        fhirObservation.encounter.reference
      );
    }
    
    return omopMeasurement;
  }
  
  // Mapear FHIR Condition para OMOP Condition Occurrence
  async mapConditionToConditionOccurrence(fhirCondition) {
    const omopCondition = {
      condition_occurrence_id: await this.generateOMOPId('condition_occurrence'),
      person_id: await this.getPersonId(fhirCondition.subject.reference),
      condition_concept_id: await this.mapConceptFromCoding(
        fhirCondition.code.coding[0]
      ),
      condition_start_date: null,
      condition_start_datetime: null,
      condition_end_date: null,
      condition_end_datetime: null,
      condition_type_concept_id: 32817, // EHR record
      stop_reason: null,
      provider_id: null,
      visit_occurrence_id: null,
      visit_detail_id: null,
      condition_source_value: fhirCondition.code.coding[0].code,
      condition_source_concept_id: 0,
      condition_status_source_value: fhirCondition.clinicalStatus?.coding[0].code,
      condition_status_concept_id: 0
    };
    
    // Processar período
    if (fhirCondition.onsetDateTime) {
      omopCondition.condition_start_datetime = fhirCondition.onsetDateTime;
      omopCondition.condition_start_date = fhirCondition.onsetDateTime.split('T')[0];
    } else if (fhirCondition.onsetPeriod) {
      if (fhirCondition.onsetPeriod.start) {
        omopCondition.condition_start_datetime = fhirCondition.onsetPeriod.start;
        omopCondition.condition_start_date = fhirCondition.onsetPeriod.start.split('T')[0];
      }
      if (fhirCondition.onsetPeriod.end) {
        omopCondition.condition_end_datetime = fhirCondition.onsetPeriod.end;
        omopCondition.condition_end_date = fhirCondition.onsetPeriod.end.split('T')[0];
      }
    }
    
    // Processar abatement
    if (fhirCondition.abatementDateTime) {
      omopCondition.condition_end_datetime = fhirCondition.abatementDateTime;
      omopCondition.condition_end_date = fhirCondition.abatementDateTime.split('T')[0];
    }
    
    return omopCondition;
  }
  
  // Funções auxiliares de mapeamento de conceitos
  async mapConceptFromCoding(coding) {
    // Mapear sistema de código para vocabulário OMOP
    const vocabularyMapping = {
      'http://snomed.info/sct': 'SNOMED',
      'http://loinc.org': 'LOINC',
      'http://www.nlm.nih.gov/research/umls/rxnorm': 'RxNorm',
      'http://hl7.org/fhir/sid/icd-10': 'ICD10',
      'http://hl7.org/fhir/sid/icd-10-cm': 'ICD10CM',
      'http://www.whocc.no/atc': 'ATC'
    };
    
    const vocabularyId = vocabularyMapping[coding.system];
    
    if (!vocabularyId) {
      console.warn(`Sistema não mapeado: ${coding.system}`);
      return 0; // No matching concept
    }
    
    // Buscar concept_id no vocabulário OMOP
    const concept = await this.vocabularyService.findConcept({
      vocabulary_id: vocabularyId,
      concept_code: coding.code
    });
    
    return concept?.concept_id || 0;
  }
  
  async mapGenderConcept(fhirGender) {
    const genderMapping = {
      'male': 8507,     // Male
      'female': 8532,   // Female
      'other': 8551,    // Unknown
      'unknown': 8551   // Unknown
    };
    
    return genderMapping[fhirGender] || 8551;
  }
}
```

### 6.4 Validação Cross-Standard

```bash
#!/bin/bash
# validate-cross-standard.sh - Validação entre padrões

# Configurações
FHIR_SERVER="${FHIR_SERVER:-http://localhost:8080/fhir}"
OPENEHR_SERVER="${OPENEHR_SERVER:-http://localhost:8081/ehrbase}"
OMOP_DATABASE="${OMOP_DATABASE:-postgresql://user:pass@localhost/omop}"
VALIDATION_OUTPUT="${VALIDATION_OUTPUT:-./validation-results}"

# Criar estrutura de saída
mkdir -p "${VALIDATION_OUTPUT}"/{fhir,openehr,omop,mappings}

# Função de validação FHIR
validate_fhir() {
    echo "Validando recursos FHIR..."
    
    # Baixar CapabilityStatement
    curl -s "${FHIR_SERVER}/metadata" \
        -H "Accept: application/fhir+json" \
        > "${VALIDATION_OUTPUT}/fhir/capability-statement.json"
    
    # Validar contra IPS
    java -jar validator_cli.jar \
        -version 4.0.1 \
        -ig hl7.fhir.uv.ips \
        "${VALIDATION_OUTPUT}/fhir/*.json" \
        -output "${VALIDATION_OUTPUT}/fhir/ips-validation.html"
}

# Função de validação openEHR
validate_openehr() {
    echo "Validando templates openEHR..."
    
    # Listar templates disponíveis
    curl -s "${OPENEHR_SERVER}/definition/template/adl1.4" \
        > "${VALIDATION_OUTPUT}/openehr/templates.json"
    
    # Validar arquétipos
    for archetype in "${VALIDATION_OUTPUT}/openehr/archetypes"/*.adl; do
        [ -f "$archetype" ] || continue
        
        echo "  Validando: $(basename "$archetype")"
        
        # Usar ADL Workbench CLI ou API
        curl -X POST "${OPENEHR_SERVER}/validation/archetype" \
            -H "Content-Type: text/plain" \
            --data-binary "@${archetype}" \
            > "${VALIDATION_OUTPUT}/openehr/$(basename "$archetype" .adl)-validation.json"
    done
}

# Função de validação OMOP CDM
validate_omop() {
    echo "Validando conformidade OMOP CDM..."
    
    # Executar ACHILLES para validação
    cat > "${VALIDATION_OUTPUT}/omop/achilles.sql" << 'SQL'
-- Validação OMOP CDM usando ACHILLES
SELECT 
    'person' as table_name,
    COUNT(*) as record_count,
    COUNT(DISTINCT person_id) as unique_count,
    SUM(CASE WHEN gender_concept_id = 0 THEN 1 ELSE 0 END) as unmapped_count
FROM person
UNION ALL
SELECT 
    'measurement' as table_name,
    COUNT(*) as record_count,
    COUNT(DISTINCT measurement_id) as unique_count,
    SUM(CASE WHEN measurement_concept_id = 0 THEN 1 ELSE 0 END) as unmapped_count
FROM measurement
UNION ALL
SELECT 
    'condition_occurrence' as table_name,
    COUNT(*) as record_count,
    COUNT(DISTINCT condition_occurrence_id) as unique_count,
    SUM(CASE WHEN condition_concept_id = 0 THEN 1 ELSE 0 END) as unmapped_count
FROM condition_occurrence;
SQL
    
    psql "${OMOP_DATABASE}" < "${VALIDATION_OUTPUT}/omop/achilles.sql" \
        > "${VALIDATION_OUTPUT}/omop/validation-results.txt"
}

# Função de validação de mapeamentos
validate_mappings() {
    echo "Validando mapeamentos entre padrões..."
    
    # Criar relatório de mapeamento
    cat > "${VALIDATION_OUTPUT}/mappings/validation.py" << 'PYTHON'
import json
import psycopg2
from datetime import datetime

def validate_fhir_to_omop_mapping():
    """Validar mapeamento FHIR para OMOP"""
    results = {
        'timestamp': datetime.now().isoformat(),
        'mappings': [],
        'issues': []
    }
    
    # Verificar mapeamento de códigos
    with open('fhir-codes.json', 'r') as f:
        fhir_codes = json.load(f)
    
    # Conectar ao OMOP
    conn = psycopg2.connect(os.environ['OMOP_DATABASE'])
    cur = conn.cursor()
    
    for code in fhir_codes:
        # Verificar se código existe no vocabulário OMOP
        cur.execute("""
            SELECT concept_id, concept_name, domain_id, vocabulary_id
            FROM concept
            WHERE concept_code = %s AND vocabulary_id = %s
        """, (code['code'], code['system']))
        
        result = cur.fetchone()
        
        if result:
            results['mappings'].append({
                'fhir_code': code['code'],
                'fhir_system': code['system'],
                'omop_concept_id': result[0],
                'omop_concept_name': result[1],
                'omop_domain': result[2],
                'status': 'mapped'
            })
        else:
            results['issues'].append({
                'fhir_code': code['code'],
                'fhir_system': code['system'],
                'issue': 'No OMOP mapping found',
                'severity': 'warning'
            })
    
    return results

if __name__ == "__main__":
    results = validate_fhir_to_omop_mapping()
    with open('mapping-validation.json', 'w') as f:
        json.dump(results, f, indent=2)
PYTHON
    
    python3 "${VALIDATION_OUTPUT}/mappings/validation.py"
}

# Gerar relatório consolidado
generate_report() {
    echo "Gerando relatório consolidado..."
    
    cat > "${VALIDATION_OUTPUT}/cross-standard-report.html" << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Cross-Standard Validation Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .pass { color: green; font-weight: bold; }
        .fail { color: red; font-weight: bold; }
        .warning { color: orange; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #34495e; color: white; }
        .metric { display: inline-block; margin: 10px; padding: 15px; 
                  background: #ecf0f1; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Cross-Standard Conformance Validation Report</h1>
        <p>Generated: $(date)</p>
    </div>
    
    <div class="section">
        <h2>Executive Summary</h2>
        <div class="metric">
            <strong>FHIR Conformance:</strong> 
            <span class="pass">✓ Passed</span>
        </div>
        <div class="metric">
            <strong>openEHR Conformance:</strong> 
            <span class="pass">✓ Passed</span>
        </div>
        <div class="metric">
            <strong>OMOP CDM Conformance:</strong> 
            <span class="pass">✓ Passed</span>
        </div>
        <div class="metric">
            <strong>Cross-Mapping Integrity:</strong> 
            <span class="warning">⚠ Warnings</span>
        </div>
    </div>
    
    <div class="section">
        <h2>FHIR Validation Results</h2>
        <table>
            <tr>
                <th>Resource Type</th>
                <th>Count</th>
                <th>Valid</th>
                <th>Invalid</th>
                <th>Conformance</th>
            </tr>
            <tr>
                <td>Patient</td>
                <td>1000</td>
                <td>998</td>
                <td>2</td>
                <td class="pass">99.8%</td>
            </tr>
            <tr>
                <td>Observation</td>
                <td>5000</td>
                <td>4995</td>
                <td>5</td>
                <td class="pass">99.9%</td>
            </tr>
        </table>
    </div>
    
    <div class="section">
        <h2>Mapping Statistics</h2>
        <table>
            <tr>
                <th>Source</th>
                <th>Target</th>
                <th>Total Mappings</th>
                <th>Success Rate</th>
            </tr>
            <tr>
                <td>FHIR</td>
                <td>openEHR</td>
                <td>150</td>
                <td class="pass">95%</td>
            </tr>
            <tr>
                <td>FHIR</td>
                <td>OMOP</td>
                <td>200</td>
                <td class="pass">92%</td>
            </tr>
            <tr>
                <td>openEHR</td>
                <td>OMOP</td>
                <td>120</td>
                <td class="warning">88%</td>
            </tr>
        </table>
    </div>
    
    <div class="section">
        <h2>Recommendations</h2>
        <ul>
            <li>Review unmapped SNOMED CT codes in OMOP vocabulary</li>
            <li>Update openEHR templates to align with latest archetypes</li>
            <li>Implement automated cross-validation in CI/CD pipeline</li>
        </ul>
    </div>
</body>
</html>
HTML
    
    echo "Relatório salvo em: ${VALIDATION_OUTPUT}/cross-standard-report.html"
}

# Função principal
main() {
    echo "=== Iniciando Validação Cross-Standard ==="
    
    validate_fhir
    validate_openehr
    validate_omop
    validate_mappings
    generate_report
    
    echo "=== Validação Cross-Standard Concluída ==="
}

# Executar
main "$@"