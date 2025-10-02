# SOP-001: Fundamentos de Implementation Guides FHIR
**Standard Operating Procedure para Desenvolvimento de HL7 FHIR Implementation Guides**

## 1. INTRODUÇÃO E PROPÓSITO

### 1.1 Objetivo
Este documento estabelece os procedimentos padrão para o desenvolvimento de Implementation Guides (IGs) FHIR, garantindo conformidade com as especificações HL7 International e suas afiliadas.

### 1.2 Escopo
Aplicável a todos os projetos de desenvolvimento de IGs FHIR, incluindo perfis nacionais, domínios específicos de conhecimento, comunidades de implementação e produtos específicos.

### 1.3 Referências Normativas
- HL7 FHIR R5 Specification¹: http://hl7.org/fhir/R5/
- FHIR Implementation Guide Resource²: http://hl7.org/fhir/R5/implementationguide.html
- FHIR IG Publishing Requirements³: https://wiki.hl7.org/FHIR_Implementation_Guide_Publishing_Requirements
- FHIR Shorthand Specification⁴: https://build.fhir.org/ig/HL7/fhir-shorthand/

## 2. DEFINIÇÕES E CONCEITOS FUNDAMENTAIS

### 2.1 Implementation Guide (IG)
Um IG FHIR é um conjunto de regras computáveis e documentação narrativa que determina como solucionar problemas específicos de interoperabilidade usando recursos FHIR⁵.

### 2.2 Categorias de IGs
Conforme definido por Grahame Grieve⁶:

1. **National Base IGs**: Descrevem como regulamentações nacionais se aplicam no contexto FHIR
2. **Domain of Knowledge IGs**: Representam conceitos clínicos ou de negócio sem definir APIs
3. **Community of Implementation**: Acordos sobre troca de dados entre atores específicos
4. **Product IGs**: Documentam funcionalidades de software específico

### 2.3 Componentes Essenciais
- **Profiles**: Restrições em recursos FHIR base
- **Extensions**: Elementos adicionais para dados não cobertos pelo padrão
- **ValueSets**: Conjuntos de valores permitidos para elementos codificados
- **CodeSystems**: Sistemas de códigos customizados
- **Examples**: Instâncias de recursos conformes
- **NamingSystems**: Identificadores únicos para sistemas

## 3. ESTRUTURA DE DIRETÓRIOS

### 3.1 Estrutura Padrão FSH/SUSHI⁷
```
IG-Project/
├── input/
│   ├── fsh/                    # Arquivos FSH
│   │   ├── aliases.fsh         # Definições de aliases
│   │   ├── profiles/           # Perfis de recursos
│   │   ├── extensions/         # Extensões customizadas
│   │   ├── valuesets/          # Conjuntos de valores
│   │   ├── codesystems/        # Sistemas de códigos
│   │   ├── examples/           # Exemplos
│   │   └── invariants/         # Regras de validação
│   ├── pagecontent/           # Conteúdo narrativo (Markdown)
│   └── images/                # Imagens e diagramas
├── fsh-generated/             # Saída do SUSHI (não editar)
├── output/                    # IG publicado (não editar)
├── sushi-config.yaml          # Configuração do projeto
├── ig.ini                     # Configuração do IG Publisher
└── _genonce.sh/.bat          # Scripts de build
```

### 3.2 Convenções de Nomenclatura
- Arquivos FSH: `[tipo]-[domínio].fsh`
  - Exemplo: `profile-patient.fsh`, `valueset-conditions.fsh`
- IDs de recursos: `[projeto]-[tipo]-[nome]`
  - Exemplo: `br-core-patient`, `us-core-condition`

## 4. DESENVOLVIMENTO DE PROFILES

### 4.1 Sintaxe FSH para Profiles⁸
```fsh
Profile: [NomeDoPerfil]
Parent: [RecursoBase ou PerfilPai]
Id: [id-único]
Title: "[Título Legível]"
Description: "[Descrição Detalhada]"
* [elemento] [cardinalidade] [flags] "[descrição]"
```

### 4.2 Flags de Conformidade
- **MS (MustSupport)**: Elemento deve ser suportado
- **?!**: Modificador (altera significado se presente)
- **SU (Summary)**: Incluído em resumos

### 4.3 Exemplo Prático
```fsh
Profile: BRPatient
Parent: Patient
Id: br-patient
Title: "Paciente Brasileiro"
Description: "Perfil de Paciente para o contexto brasileiro"
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier contains cpf 1..1 MS
* identifier[cpf].system = "http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf"
* identifier[cpf].type = http://terminology.hl7.org/CodeSystem/v2-0203#TAX
* birthDate 1..1 MS
* address.state from http://hl7.org/fhir/ValueSet/br-estados (required)
```

## 5. DESENVOLVIMENTO DE EXTENSIONS

### 5.1 Quando Criar Extensions⁹
- Dados necessários não existem no recurso base
- Extensão padrão FHIR não atende necessidade
- Dados não podem ser derivados

### 5.2 Estrutura de Extension
```fsh
Extension: [NomeExtension]
Id: [id-extension]
Title: "[Título]"
Description: "[Descrição do uso]"
Context: [Recurso(s) onde se aplica]
* value[x] only [tipo de dado]
* value[x] 1..1
```

## 6. PROCESSO DE BUILD E PUBLICAÇÃO

### 6.1 Ferramentas Necessárias¹⁰
1. **SUSHI**: Compilador FSH (npm install -g fsh-sushi)
2. **IG Publisher**: Publicador HL7 (Java required)
3. **Validator**: Validador FHIR

### 6.2 Comandos de Build
```bash
# Compilar FSH para JSON
sushi .

# Gerar IG completo
./_genonce.sh  # Linux/Mac
_genonce.bat   # Windows

# Validar recursos
java -jar validator_cli.jar [arquivo] -ig [ig-package]
```

### 6.3 Validação de Qualidade
- Verificar arquivo `output/qa.html` após build
- Resolver todos os erros antes de publicar
- Warnings devem ser justificados em `input/ignoreWarnings.txt`

## 7. VERSIONAMENTO E MANUTENÇÃO

### 7.1 Semantic Versioning¹¹
- **Major (X.0.0)**: Mudanças incompatíveis
- **Minor (0.X.0)**: Novas funcionalidades compatíveis
- **Patch (0.0.X)**: Correções de bugs

### 7.2 Estados de Maturidade
1. **Draft**: Em desenvolvimento
2. **Trial Use**: Teste de implementação
3. **Normative**: Estável e aprovado
4. **Deprecated**: Descontinuado

## 8. CONFORMIDADE E TESTES

### 8.1 Níveis de Conformidade¹²
- **SHALL**: Obrigatório
- **SHOULD**: Recomendado
- **MAY**: Opcional

### 8.2 Testes de Conformidade
```bash
# Validar instância contra perfil
java -jar validator_cli.jar [instancia.json] -profile [url-perfil]

# Testar servidor FHIR
java -jar validator_cli.jar -txTests [servidor]/metadata
```

## 9. DOCUMENTAÇÃO NARRATIVA

### 9.1 Páginas Obrigatórias¹³
- **index.md**: Página inicial com visão geral
- **profiles.md**: Lista e descrição de perfis
- **terminology.md**: Sistemas de códigos e valuesets
- **downloads.md**: Pacotes para download
- **changes.md**: Histórico de mudanças

### 9.2 Formato Markdown
```markdown
### Título da Seção
Descrição do conteúdo com referência a perfil: [NomePerfil](StructureDefinition-[id-perfil].html)

#### Requisitos de Negócio
- Requisito 1
- Requisito 2

#### Exemplo de Uso
```json
{
  "resourceType": "Patient",
  "id": "exemplo"
}
```
```

## 10. INTEGRAÇÃO COM PADRÕES EXTERNOS

### 10.1 Harmonização com IGs Internacionais¹⁴
- **IPS (International Patient Summary)**: http://hl7.org/fhir/uv/ips/
- **US Core**: http://hl7.org/fhir/us/core/
- **AU Base**: http://hl7.org.au/fhir/

### 10.2 Reutilização de Componentes
```fsh
// Importar perfil de outro IG
Profile: MyPatient
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
```

## 11. CHECKLIST DE PUBLICAÇÃO

### 11.1 Pré-Publicação
- [ ] Todos os testes passando
- [ ] QA report sem erros críticos
- [ ] Documentação completa
- [ ] Exemplos validados
- [ ] Versão atualizada em sushi-config.yaml
- [ ] Change log atualizado

### 11.2 Publicação
- [ ] Build final executado
- [ ] Package gerado
- [ ] Upload para servidor de publicação
- [ ] Registro no registry FHIR
- [ ] Notificação à comunidade

## 12. REFERÊNCIAS

1. HL7 International. FHIR R5 Specification. Disponível em: http://hl7.org/fhir/R5/
2. HL7 International. Resource ImplementationGuide. Disponível em: http://hl7.org/fhir/R5/implementationguide.html
3. HL7 Wiki. FHIR Implementation Guide Publishing Requirements. Disponível em: https://wiki.hl7.org/FHIR_Implementation_Guide_Publishing_Requirements
4. HL7 International. FHIR Shorthand Specification. Disponível em: https://build.fhir.org/ig/HL7/fhir-shorthand/
5. MITRE. FSH School - Part 1: Reading an IG. Disponível em: https://fshschool.org/courses/fsh-seminar/01-reading-an-ig.html
6. Grieve, G. FHIR Implementation Guide Purposes. HL7 FHIR DevDays Presentation. 2021.
7. MITRE. FSH Quick Start Guide. Disponível em: https://fshschool.org/quickstart/
8. HL7 International. FHIR Shorthand Quick Reference. Version 3.0.0.
9. HL7 International. Extending FHIR. Disponível em: http://hl7.org/fhir/R5/extensibility.html
10. KRAMER, M. & MOESEL, C. Tutorial: Create an Implementation Guide with FHIR Shorthand. HL7 FHIR DevDays 2021.
11. HL7 International. FHIR Versioning. Disponível em: http://hl7.org/fhir/R5/versioning.html
12. HL7 International. Conformance Rules. Disponível em: http://hl7.org/fhir/R5/conformance-rules.html
13. HL7 International. IG Publisher Documentation. Disponível em: https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation
14. HL7 International. International Patient Summary Implementation Guide. Disponível em: http://hl7.org/fhir/uv/ips/

---
**Documento aprovado por:** [Gerência de Interoperabilidade]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026
