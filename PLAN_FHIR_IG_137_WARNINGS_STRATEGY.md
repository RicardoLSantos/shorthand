# Plano: Estratégia Semântica para os 137 Warnings

## Contexto: O que a Tese Defende

A tese **NÃO** defende patches ou workarounds. Defende:

> "True semantic interoperability demands not just code correspondence but preservation of measurement context, data quality indicators, device provenance, and clinical interpretation boundaries."

### Hierarquia de Preservação Semântica (da Tese)

| Nível | Método | Preservação | Quando Usar |
|-------|--------|-------------|-------------|
| 1 | **Código LOINC/SNOMED direto** | 100% | Sempre que código existe |
| 2 | Pós-coordenação SNOMED-CT | 95%+ | Conceitos complexos sem código |
| 3 | Código local + migração documentada | 85%+ | Métricas sem padrão (RMSSD) |
| 4 | Código local + dados brutos | 70-80% | Algoritmos proprietários |
| 5 | ConceptMap sem proveniência | 40-60% | **EVITAR** |

---

## Análise dos 137 Warnings

### Categoria 1: ConceptMaps Cross-Standard (79 warnings = 58%)
**Fonte**: ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToOMOP, etc.

**Problema**: URIs de openEHR e OMOP não são CodeSystems FHIR válidos.

**Diagnóstico**: Estes warnings são **esperados e aceitáveis** porque:
- openEHR archetype IDs (`openEHR-EHR-OBSERVATION.heart_rate_variability.v0`) não são CodeSystems
- OMOP tables (`MEASUREMENT`) não são CodeSystems
- São mapeamentos operacionais, não bindings semânticos

**Ação**: Documentar como "by design" - ConceptMaps cross-standard são infraestrutura de tradução.

### Categoria 2: Vendor CodeSystems Não Definidos (34 warnings = 25%)
**Fonte**: ConceptMapVendorToLOINC, vendor-codes-vs

**Problema**: URLs de vendors (Apple, Fitbit, Garmin) não são CodeSystems registados.

**Diagnóstico**: Problema arquitectural parcial.

**Questão Central**: Devemos:
- **Opção A**: Criar CodeSystems locais para vendor codes (ex: `AppleHealthKitCS`)
- **Opção B**: Usar códigos LOINC/SNOMED diretamente nos profiles, e vendor→LOINC como operacional

**Recomendação**: **Opção B** - Alinhado com a tese:
- Profiles devem usar LOINC/SNOMED diretamente
- ConceptMaps Vendor→LOINC são infraestrutura de ingestão, não definição semântica

### Categoria 3: Códigos SNOMED/LOINC Incorretos (7 warnings = 5%)
**Fonte**: Inflammatory Markers profiles criados hoje

**Problema**: Usámos SNOMED codes com displays errados, depois substituímos por CodeSystems locais.

**Diagnóstico**: **ERRO** - Contradiz a hierarquia semântica da tese.

**Acção Corretiva**:
1. Encontrar códigos SNOMED-CT corretos para cardiovascular risk levels
2. Encontrar códigos SNOMED-CT corretos para trend directions
3. Remover CodeSystems locais desnecessários (HsCRPRiskCS, HRVInflammationTrendCS)

### Categoria 4: Outros (17 warnings = 12%)
**Fonte**: HTML fragments, property URIs, exemplos

**Diagnóstico**: Maioria são informativos, não semânticos.

---

## Estratégia Recomendada

### Princípio Central

> **Usar códigos SNOMED-CT e LOINC corretos SEMPRE que existam. ConceptMaps são para tradução entre sistemas, NÃO para substituir terminologia padrão.**

### Acções Imediatas

#### 1. Corrigir Inflammatory Markers (Prioridade ALTA)

**Problema**: Substituímos SNOMED por CodeSystems locais.

**Solução**:
- Procurar códigos SNOMED-CT corretos para:
  - Low/Average/High cardiovascular risk
  - Increasing/Stable/Decreasing trends
  - Inflammatory response findings
- Remover HsCRPRiskCS e HRVInflammationTrendCS
- Usar SNOMED-CT diretamente nos ValueSets

**Códigos SNOMED-CT a investigar**:
- `281694009` | Cardiovascular risk assessment
- `723505004` | High risk of cardiovascular disease
- `723506003` | Low risk of cardiovascular disease
- `260369004` | Increasing (qualifier)
- `260371004` | Stable (qualifier)
- `260372006` | Decreasing (qualifier)

#### 2. Documentar ConceptMaps Cross-Standard (Prioridade MÉDIA)

**Problema**: 79 warnings sobre URIs não definidas.

**Solução**:
- Adicionar documentação explicando que são mapeamentos operacionais
- Considerar usar `unmapped` mode nos ConceptMaps
- NÃO tentar criar CodeSystems falsos para openEHR/OMOP

#### 3. Reorganizar Vendor Mappings (Prioridade BAIXA)

**Problema**: Vendor URLs não são CodeSystems válidos.

**Solução de longo prazo**:
- Profiles devem bindar a LOINC/SNOMED diretamente
- Vendor→LOINC mappings são transformação de ingestão
- Documentar esta arquitectura

---

## Resposta às Perguntas do Utilizador

### Q1: Por que usar ConceptMaps em vez de códigos SNOMED-CT/LOINC corretos?

**Resposta**: **NÃO devemos**. A abordagem correcta é:
- Usar códigos SNOMED-CT/LOINC diretamente nos profiles
- ConceptMaps apenas para tradução entre sistemas (FHIR↔openEHR↔OMOP)
- ConceptMaps NUNCA substituem bindings diretos

### Q2: ConceptMaps FHIR↔openEHR↔OMOP são saudáveis?

**Resposta**: **Sim, mas com propósito claro**:
- São infraestrutura de **tradução operacional**
- Preservam semântica quando ambos os sistemas usam códigos padrão
- A tese chama isto de "semantic bridges enabling immediate implementation while preserving migration pathways"

### Q3: O objetivo é criar patches ou arquitectura coerente?

**Resposta** (da tese):
> "The thesis treats ConceptMaps as infrastructure for managed evolution of semantic standards, not as substitutes for real standardization."

A arquitectura correcta é:
1. **Camada Semântica**: LOINC + SNOMED-CT (códigos padrão)
2. **Camada de Persistência**: openEHR archetypes (com term_bindings)
3. **Camada de Exchange**: FHIR profiles (com bindings diretos)
4. **Camada de Tradução**: ConceptMaps (para interoperabilidade)

### Q4: Códigos padrão guardam melhor a semântica que ConceptMaps?

**Resposta**: **SIM, absolutamente.**

| Abordagem | Preservação Semântica |
|-----------|----------------------|
| LOINC 80404-7 (SDNN) | 100% |
| SNOMED-CT 251670001 (SDNN) | 100% |
| ConceptMap Vendor→LOINC | 85-95% (perde contexto vendor) |
| CodeSystem local sem padrão | 70-85% (depende de documentação) |

---

## Ficheiros a Modificar

### Alta Prioridade
1. `/input/fsh/profiles/InflammatoryMarkersProfiles.fsh`
   - Remover HsCRPRiskCS, HRVInflammationTrendCS
   - Usar SNOMED-CT codes corretos

2. `/input/fsh/examples/InflammatoryMarkersExamples.fsh`
   - Atualizar exemplos com SNOMED-CT

### Média Prioridade
3. `/input/pagecontent/conceptmaps.md` (criar se não existir)
   - Documentar arquitectura de ConceptMaps
   - Explicar por que warnings cross-standard são esperados

### Baixa Prioridade
4. `/input/fsh/terminology/ConceptMapVendor*.fsh`
   - Reavaliar se devem existir como ConceptMaps ou como documentação

---

## Métricas de Sucesso

| Métrica | Actual | Alvo |
|---------|--------|------|
| Errors | 3 | 0 |
| Warnings (total) | 137 | ~80 |
| Warnings corrigíveis | ~24 | 0 |
| Warnings esperados (cross-standard) | ~113 | ~80 (documentados) |

---

## Conclusão

A estratégia alinha-se com a tese:
1. **Usar códigos padrão** (LOINC, SNOMED-CT) como fonte primária de semântica
2. **ConceptMaps para tradução**, não para definição
3. **Documentar gaps** honestamente (RMSSD sem LOINC = código local com migração)
4. **Arquitectura dual-model** (FHIR + openEHR) para diferentes propósitos
