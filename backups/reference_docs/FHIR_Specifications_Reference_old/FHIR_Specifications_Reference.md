# HL7 FHIR Implementation Guide Specifications Reference

## Versão 1.0 - 29 de Setembro de 2025

Este documento compila as especificações e referências oficiais do HL7 FHIR necessárias para a correção dos erros identificados no iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide.

---

## 📊 Análise dos Erros Atuais

### Estatísticas QA Report
- **Erros:** 472
- **Warnings:** 184
- **Links quebrados:** 7
- **Status:** Correção prioritária necessária

### Principais Categorias de Erros Identificados
1. URLs canônicos incorretos ou inconsistentes
2. Metadados ShareableValueSet ausentes
3. Categorias de observação reprodutiva devem ser social-history
4. Descrições ausentes para recursos ImplementationGuide
5. Links quebrados para dispositivos e recursos

---

## 🌐 Especificações de URLs Canônicos

### Fonte: [HL7 FHIR Implementation Guide Publishing Requirements](https://confluence.hl7.org/spaces/FHIR/pages/66930646/FHIR+Implementation+Guide+Publishing+Requirements)

#### Requisitos Fundamentais para URLs Canônicos

1. **Estrutura Básica**
   - Todas as IGs devem nomear uma URL canônica
   - A URL canônica deve ser o lar permanente da IG através de múltiplas versões
   - Exemplo: `http://example.com/fhir/mypatientprofile`

2. **Padrão de URLs**
   - `ImplementationGuide.url` deve ser `[canonical]/ImplementationGuide/[id]`
   - Deve redirecionar para a URL base quando inserida no navegador
   - Preferencialmente deve ser um servidor FHIR hospedando recursos

3. **Gerenciamento de Versões**
   - Versão atual: `[canonical]`
   - Histórico de versões: `[canonical]/directory.html`
   - Marcos passados: `[canonical]/[id]` onde id é nome do marco ou data

4. **Requisitos para IGs Publicadas pelo HL7**
   - O realm na URL canônica deve corresponder à jurisdição especificada
   - Referência obrigatória a `[canonical]/history.cfml`

### Referência: [FHIR Implementation Guide Specification](http://hl7.org/fhir/implementationguide.html)

---

## 🏷️ Especificações ShareableValueSet

### Fonte: [StructureDefinition: ShareableValueSet - FHIR v4.0.1](http://hl7.org/fhir/R4/shareablevalueset.html)

#### Elementos Obrigatórios

1. **URL** (obrigatório)
   - Identificador canônico para o value set
   - Representado como URI (globalmente único)
   - Tipo: `uri`

2. **Version** (obrigatório)
   - Versão de negócio do value set
   - Tipo: `string`

3. **Name** (obrigatório)
   - Nome para o value set (amigável ao computador)
   - Tipo: `string`

#### Elementos Recomendados

1. **Title** (opcional mas importante)
   - Nome para o value set (amigável ao humano)
   - Tipo: `string`

2. **Status** (recomendado)
   - Status de publicação do value set
   - Valores: `draft | active | retired | unknown`

3. **Identifier** (opcional)
   - Identificador adicional para o value set
   - Tipo: `Identifier`

### Referência Adicional: [CRMI Shareable ValueSet](http://hl7.org/fhir/uv/crmi/STU1/StructureDefinition-crmi-shareablevalueset.html)

---

## 🏥 Categorias de Observação FHIR

### Fonte: [HL7.TERMINOLOGY Observation Category Codes](https://terminology.hl7.org/3.1.0/CodeSystem-observation-category.html)

#### Categoria Social History

1. **Código Padrão**
   - Sistema: `http://terminology.hl7.org/CodeSystem/observation-category`
   - Código: `social-history`
   - Display: "Social History"

2. **Definição Oficial**
   - "Social History Observations define the patient's occupational, personal (e.g., lifestyle), social, familial, and environmental history and health risk factors that may impact the patient's health."

3. **Implementação US Core**
   - Perfil: [US Core Observation Social History Profile](https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-observation-social-history.html)
   - Atende aos requisitos USCDI v2 'SDOH Assessments'

#### Migração Reproductive → Social-History

**Justificativa técnica:**
- Observações reprodutivas constituem parte do histórico social do paciente
- Categoria `reproductive-health` não é padrão oficial no CodeSystem observation-category
- Melhor interoperabilidade com implementações US Core e internacionais

### Busca Padrão
```
GET [base]/Observation?patient=1134281&category=http://terminology.hl7.org/CodeSystem/observation-category|social-history
```

### Referência: [US Core Observation Category ValueSet](https://www.hl7.org/fhir/us/core/ValueSet-us-core-observation-category.html)

---

## 🗂️ Estrutura de Diretórios FHIR IG

### Fonte: [IG Publisher Documentation](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation)

#### Estrutura Padrão de Input

```
input/
├── fsh/                    # FHIR Shorthand files
├── examples/               # Instâncias de exemplo
├── images/                 # Arquivos de imagem
├── images-source/          # Imagens fonte (antes do processamento)
├── includes/               # Conteúdo incluído
├── pagecontent/            # Conteúdo narrativo (Markdown)
├── resources/              # Recursos FHIR (JSON/XML)
└── vocabulary/             # Terminologias customizadas
```

#### Estrutura de Output

```
output/
├── artifacts.html          # Lista de artefatos
├── index.html             # Página inicial da IG
├── qa.html                # Relatório de qualidade
├── full-ig.zip            # Pacote completo da IG
├── package.tgz            # Pacote NPM
└── [recursos individuais] # Páginas HTML dos recursos
```

#### Arquivos de Configuração

1. **ig.ini** (raiz)
   ```ini
   [IG]
   ig = fsh-generated/resources/ImplementationGuide-[id].json
   template = fhir.base.template#current
   ```

2. **sushi-config.yaml** (raiz)
   - Contém metadados da IG
   - Configurações de publicação
   - Dependências

### Fonte: [Guidance for FHIR IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/using-templates.html)

---

## 🔧 Próximos Passos de Implementação

Com base nestas especificações, os próximos passos incluem:

1. **Fase 1:** Correção de URLs canônicos
2. **Fase 2:** Adição de metadados ShareableValueSet
3. **Fase 3:** Migração de categorias reproductive → social-history
4. **Fase 4:** Correção de links quebrados e descrições ausentes

---

## 📚 Referências Completas

1. [HL7 FHIR R4 Specification](https://www.hl7.org/fhir/R4/)
2. [FHIR Implementation Guide Publishing Requirements](https://confluence.hl7.org/spaces/FHIR/pages/66930646/FHIR+Implementation+Guide+Publishing+Requirements)
3. [StructureDefinition: ShareableValueSet](http://hl7.org/fhir/R4/shareablevalueset.html)
4. [Observation Category Codes](https://terminology.hl7.org/3.1.0/CodeSystem-observation-category.html)
5. [US Core Observation Social History Profile](https://www.hl7.org/fhir/us/core/StructureDefinition-us-core-observation-social-history.html)
6. [IG Publisher Documentation](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation)
7. [Guidance for FHIR IG Creation](https://build.fhir.org/ig/FHIR/ig-guidance/)

---

*Documento compilado para suporte à correção do iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide*