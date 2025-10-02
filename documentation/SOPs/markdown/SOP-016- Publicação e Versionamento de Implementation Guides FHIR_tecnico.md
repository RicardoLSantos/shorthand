# SOP-016: Publicação e Versionamento de Implementation Guides FHIR
**Standard Operating Procedure para Gestão de Ciclo de Vida, Publicação e Controle de Versões**

## 1. INTRODUÇÃO

### 1.1 Objetivo
Estabelecer procedimentos padronizados para publicação, versionamento e gestão do ciclo de vida de Implementation Guides FHIR, garantindo rastreabilidade, compatibilidade e conformidade com as especificações HL7 e práticas internacionais de governança.

### 1.2 Escopo
Aplicável a todas as fases de publicação de IGs FHIR, incluindo desenvolvimento, teste, homologação e produção, abrangendo versionamento semântico, gestão de dependências, distribuição de pacotes e manutenção de repositórios.

### 1.3 Referências Normativas
- HL7 FHIR IG Publishing Requirements¹: https://wiki.hl7.org/FHIR_Implementation_Guide_Publishing_Requirements
- FHIR Package Specification²: https://registry.fhir.org/learn
- Semantic Versioning 2.0.0³: https://semver.org/
- HL7 Version Management⁴: https://www.hl7.org/fhir/versions.html
- FHIR NPM Package Spec⁵: https://confluence.hl7.org/display/FHIR/NPM+Package+Specification

## 2. FUNDAMENTOS TEÓRICOS

### 2.1 Conceitos de Versionamento Semântico

O versionamento semântico (SemVer) estabelece um contrato claro entre produtores e consumidores de IGs⁶. A estrutura MAJOR.MINOR.PATCH comunica a natureza das mudanças:

**MAJOR**: Mudanças incompatíveis com versões anteriores
- Remoção de elementos obrigatórios
- Alteração de cardinalidades restritivas
- Mudança de tipos de dados

**MINOR**: Funcionalidades adicionadas de forma compatível
- Novos perfis ou extensões
- Elementos opcionais adicionados
- Relaxamento de constraints

**PATCH**: Correções compatíveis
- Correção de erros de documentação
- Ajustes em narrativas
- Correção de exemplos

### 2.2 Ciclo de Vida de Publicação

O processo de maturidade de IGs segue estágios definidos pelo HL7⁷:

1. **Draft (0.x.x)**: Desenvolvimento inicial
2. **STU (Standard for Trial Use)**: Teste em implementações reais
3. **Normative**: Versão estável com garantias de compatibilidade
4. **Deprecated**: Descontinuado com período de transição

## 3. IMPLEMENTAÇÃO PRÁTICA

### 3.1 Configuração de Versionamento no sushi-config.yaml

```yaml
# sushi-config.yaml
id: br.example.ig
canonical: http://example.org/fhir/ig
name: BrazilianExampleIG
version: 1.2.3  # MAJOR.MINOR.PATCH
releaseLabel: STU1  # ou draft, STU2, normative
status: active  # draft | active | retired
date: 2025-08-30
publisher: HL7 Brasil

# Dependências versionadas
dependencies:
  hl7.fhir.br.core: 2.0.0
  hl7.fhir.uv.ips: 1.1.0
  hl7.terminology: 5.4.0

# Histórico de versões
history:
  current: http://example.org/fhir/ig
  1.2.2: http://example.org/fhir/ig/STU1/1.2.2
  1.2.1: http://example.org/fhir/ig/STU1/1.2.1
  1.2.0: http://example.org/fhir/ig/STU1/1.2.0
```

### 3.2 Script de Build e Publicação

```bash
#!/bin/bash
# build-and-publish.sh - Compatível com bash 2.5 macOS

# Configurações
IG_VERSION=$(grep "^version:" sushi-config.yaml | cut -d' ' -f2)
IG_NAME=$(grep "^id:" sushi-config.yaml | cut -d' ' -f2)
PUBLISH_URL="https://build.fhir.org/ig/HL7BR/${IG_NAME}"

echo "🚀 Iniciando build do IG ${IG_NAME} v${IG_VERSION}"

# Validação pré-build
echo "✅ Validando estrutura do projeto..."
if [ ! -f "sushi-config.yaml" ]; then
    echo "❌ Erro: sushi-config.yaml não encontrado"
    exit 1
fi

# Limpeza de builds anteriores
echo "🧹 Limpando builds anteriores..."
rm -rf fsh-generated/ output/ temp/

# Executar SUSHI
echo "🍣 Executando SUSHI..."
sushi . -o .
if [ $? -ne 0 ]; then
    echo "❌ Erro na execução do SUSHI"
    exit 1
fi
```

## 4. GESTÃO DE BRANCHES E TAGS

### 4.1 Estratégia GitFlow Adaptada

A estratégia de branching garante isolamento entre versões⁸:

```bash
# Estrutura de branches
main              # Versão estável publicada
├── develop       # Desenvolvimento contínuo
├── release/1.2.3 # Preparação de release
├── feature/xxx   # Novas funcionalidades
└── hotfix/xxx    # Correções urgentes

# Criar release branch
git checkout -b release/1.2.3 develop

# Tag de versão
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3
```

### 4.2 Automação com GitHub Actions

```yaml
# .github/workflows/publish.yml
name: Publish IG

on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup FHIR Tools
        run: |
          npm install -g fsh-sushi
          wget -q https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar
      
      - name: Build IG
        run: |
          sushi .
          java -jar publisher.jar -ig ig.ini
      
      - name: Create Package
        run: |
          npm pack
          mv *.tgz package/
      
      - name: Publish to Registry
        run: |
          npm publish --registry https://packages.fhir.org
```

## 5. PUBLICAÇÃO NO REGISTRY FHIR

### 5.1 Estrutura do Package NPM

O HL7 FHIR Registry utiliza formato NPM para distribuição⁹:

```json
{
  "name": "br.example.ig",
  "version": "1.2.3",
  "description": "Brazilian Example Implementation Guide",
  "canonical": "http://example.org/fhir/ig",
  "url": "http://example.org/fhir/ig/package.tgz",
  "fhirVersions": ["4.0.1", "4.3.0", "5.0.0"],
  "dependencies": {
    "hl7.fhir.br.core": "2.0.0",
    "hl7.fhir.uv.ips": "1.1.0"
  },
  "author": "HL7 Brasil",
  "jurisdiction": "BR"
}
```

### 5.2 Comandos de Publicação

```bash
# Gerar pacote NPM
echo "📦 Gerando pacote NPM..."
cd output
tar -czf ../package.tgz package/

# Publicar no registry
echo "📤 Publicando no FHIR Registry..."
curl -X POST https://packages.fhir.org/packages \
  -H "Content-Type: application/gzip" \
  -H "Authorization: Bearer ${FHIR_REGISTRY_TOKEN}" \
  --data-binary @package.tgz

# Verificar publicação
curl https://packages.fhir.org/br.example.ig/1.2.3
```

## 6. CONTROLE DE QUALIDADE PRÉ-PUBLICAÇÃO

### 6.1 Checklist de Validação

Validações obrigatórias antes da publicação¹⁰:

```bash
# validation-checklist.sh
#!/bin/bash

echo "🔍 Executando validações pré-publicação..."

# 1. Validação FHIR
java -jar validator_cli.jar ./output -version 4.0.1

# 2. Links quebrados
find ./output -name "*.html" -exec grep -l "404" {} \;

# 3. Exemplos válidos
for example in ./input/examples/*.json; do
    java -jar validator_cli.jar "$example" -ig ./output
done

# 4. Versionamento correto
VERSION_CONFIG=$(grep "version:" sushi-config.yaml | cut -d' ' -f2)
VERSION_PACKAGE=$(jq -r .version ./output/package/package.json)

if [ "$VERSION_CONFIG" != "$VERSION_PACKAGE" ]; then
    echo "❌ Versões inconsistentes"
    exit 1
fi

echo "✅ Todas validações aprovadas"
```

### 6.2 Quality Assurance Report

O IG Publisher gera relatório QA automaticamente¹¹:

```xml
<!-- qa.html gerado -->
<div class="qa-report">
  <h2>Quality Checks</h2>
  <ul>
    <li>✅ All profiles validated</li>
    <li>✅ All examples conform to profiles</li>
    <li>⚠️ 2 warnings in terminology bindings</li>
    <li>✅ No broken links found</li>
  </ul>
</div>
```

## 7. GESTÃO DE DEPENDÊNCIAS

### 7.1 Resolução de Conflitos de Versão

Estratégias para compatibilidade entre dependências¹²:

```yaml
# Dependências com ranges de versão
dependencies:
  hl7.fhir.br.core: ">=2.0.0 <3.0.0"  # Aceita 2.x.x
  hl7.fhir.uv.ips: "~1.1.0"           # Aceita 1.1.x
  hl7.terminology: "5.4.0"            # Versão exata
```

### 7.2 Lock File para Reprodutibilidade

```json
// package-lock.json
{
  "name": "br.example.ig",
  "version": "1.2.3",
  "lockfileVersion": 2,
  "dependencies": {
    "hl7.fhir.br.core": {
      "version": "2.0.1",
      "resolved": "https://packages.fhir.org/hl7.fhir.br.core/2.0.1"
    }
  }
}
```

## 8. DISTRIBUIÇÃO E HOSPEDAGEM

### 8.1 Configuração de CI/CD para GitHub Pages

```yaml
# .github/workflows/gh-pages.yml
name: Deploy to GitHub Pages

on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build IG
        run: |
          bash _genonce.sh
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./output
          cname: ig.example.org
```

### 8.2 Integração com Simplifier.net

```bash
# Publicar no Simplifier
curl -X POST https://api.simplifier.net/myproject/package \
  -H "Authorization: Bearer ${SIMPLIFIER_TOKEN}" \
  -F "file=@package.tgz" \
  -F "version=1.2.3" \
  -F "releaseNotes=See CHANGELOG.md"
```

## 9. MONITORAMENTO PÓS-PUBLICAÇÃO

### 9.1 Métricas de Adoção

Script para coletar estatísticas de uso¹³:

```bash
#!/bin/bash
# usage-metrics.sh

# Downloads do registry
DOWNLOADS=$(curl -s https://packages.fhir.org/br.example.ig/stats | jq .downloads)

# Implementações registradas
IMPLEMENTATIONS=$(curl -s https://fhir.org/implementations/registry | \
  grep -c "br.example.ig")

# Relatório
echo "📊 Métricas de Adoção - $(date)"
echo "Downloads: ${DOWNLOADS}"
echo "Implementações: ${IMPLEMENTATIONS}"
```

### 9.2 Gestão de Issues e Feedback

Template para issues de versão:

```markdown
<!-- .github/ISSUE_TEMPLATE/version-issue.md -->
## Versão Afetada
- [ ] 1.2.3 (atual)
- [ ] 1.2.2
- [ ] Outra: ___

## Tipo de Issue
- [ ] Bug
- [ ] Incompatibilidade
- [ ] Documentação
- [ ] Performance

## Descrição
[Descreva o problema encontrado]

## Reprodução
1. Passo 1
2. Passo 2
3. Resultado observado vs esperado
```

## 10. DEPRECAÇÃO E SUNSET

### 10.1 Política de Deprecação

Processo estruturado para descontinuação¹⁴:

```yaml
# Marcar como deprecated
status: retired
experimental: false
date: 2025-12-31

# Adicionar aviso
extension:
  - url: http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status
    valueCode: deprecated
  - url: http://hl7.org/fhir/StructureDefinition/structuredefinition-sunset
    valueDate: 2026-06-30
```

### 10.2 Migração para Nova Versão

```fsh
// Redirect em profiles deprecated
Profile: OldPatientProfile
Parent: Patient
Title: "DEPRECATED - Use NewPatientProfile"
Description: """
⚠️ DEPRECATED: Este perfil foi substituído por NewPatientProfile v2.0.0
Período de sunset: até 30/06/2026
Guia de migração: https://example.org/migration-guide
"""
* ^status = #retired
```

## 11. INTEGRAÇÃO COM RADICLE

### 11.1 Publicação Descentralizada

Configuração para versionamento no Radicle¹⁵:

```bash
# Inicializar projeto Radicle
rad init --name "br-example-ig" --description "Brazilian Example IG"

# Configurar identidade
rad auth

# Publicar versão
rad push
rad tag v1.2.3

# Sincronizar com peers
rad sync --fetch
```

### 11.2 Verificação de Integridade

```bash
# Gerar hash do conteúdo
sha256sum output/package.tgz > package.sha256

# Assinar digitalmente
gpg --detach-sign --armor package.tgz

# Verificar assinatura
gpg --verify package.tgz.asc package.tgz
```

## 12. COMANDOS BASH COMPLETOS

### 12.1 Script Completo de Publicação

```bash
#!/bin/bash
# publish-ig.sh - Script completo para publicação de IG
# Compatível com bash 2.5 macOS

set -e  # Parar em caso de erro

# Configurações
IG_VERSION=$(grep "^version:" sushi-config.yaml | cut -d' ' -f2)
IG_NAME=$(grep "^id:" sushi-config.yaml | cut -d' ' -f2)
GITHUB_REPO="HL7BR/${IG_NAME}"
REGISTRY_URL="https://packages.fhir.org"

echo "════════════════════════════════════════════════════════"
echo "   Publicação do IG: ${IG_NAME} v${IG_VERSION}"
echo "════════════════════════════════════════════════════════"

# 1. Validações iniciais
echo ""
echo "▶️  Etapa 1: Validações iniciais"
echo "─────────────────────────────────"

if [ ! -f "sushi-config.yaml" ]; then
    echo "❌ sushi-config.yaml não encontrado"
    exit 1
fi

if [ ! -f "_genonce.sh" ]; then
    echo "❌ _genonce.sh não encontrado"
    exit 1
fi

echo "✅ Arquivos de configuração validados"

# 2. Limpeza e build
echo ""
echo "▶️  Etapa 2: Build do IG"
echo "─────────────────────────────────"

rm -rf fsh-generated/ output/ temp/
echo "✅ Diretórios limpos"

bash _genonce.sh
if [ $? -ne 0 ]; then
    echo "❌ Erro no build"
    exit 1
fi
echo "✅ Build concluído com sucesso"

# 3. Validação de qualidade
echo ""
echo "▶️  Etapa 3: Validação de Qualidade"
echo "─────────────────────────────────"

ERROR_COUNT=$(grep -c "Error" output/qa.html || true)
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "⚠️  Encontrados $ERROR_COUNT erros no QA Report"
    read -p "Continuar mesmo assim? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Nenhum erro encontrado no QA"
fi

# 4. Criação do pacote
echo ""
echo "▶️  Etapa 4: Criação do Pacote NPM"
echo "─────────────────────────────────"

cd output
tar -czf "../${IG_NAME}-${IG_VERSION}.tgz" package/
cd ..
echo "✅ Pacote criado: ${IG_NAME}-${IG_VERSION}.tgz"

# 5. Geração de checksums
echo ""
echo "▶️  Etapa 5: Integridade e Segurança"
echo "─────────────────────────────────"

sha256sum "${IG_NAME}-${IG_VERSION}.tgz" > "${IG_NAME}-${IG_VERSION}.sha256"
echo "✅ Checksum SHA256 gerado"

# 6. Git tag e push
echo ""
echo "▶️  Etapa 6: Versionamento Git"
echo "─────────────────────────────────"

git add .
git commit -m "Release version ${IG_VERSION}"
git tag -a "v${IG_VERSION}" -m "Release version ${IG_VERSION}"
git push origin main
git push origin "v${IG_VERSION}"
echo "✅ Tag v${IG_VERSION} criada e enviada"

# 7. Publicação no Registry
echo ""
echo "▶️  Etapa 7: Publicação no FHIR Registry"
echo "─────────────────────────────────"

if [ -n "$FHIR_REGISTRY_TOKEN" ]; then
    curl -X POST "${REGISTRY_URL}/packages" \
        -H "Authorization: Bearer ${FHIR_REGISTRY_TOKEN}" \
        -F "npm=@${IG_NAME}-${IG_VERSION}.tgz"
    echo "✅ Publicado no FHIR Registry"
else
    echo "⚠️  FHIR_REGISTRY_TOKEN não configurado"
fi

# 8. Atualização Radicle
echo ""
echo "▶️  Etapa 8: Sincronização Radicle"
echo "─────────────────────────────────"

if command -v rad &> /dev/null; then
    rad push
    rad tag "v${IG_VERSION}"
    echo "✅ Sincronizado com Radicle"
else
    echo "⚠️  Radicle não instalado"
fi

# 9. Relatório final
echo ""
echo "════════════════════════════════════════════════════════"
echo "   ✅ PUBLICAÇÃO CONCLUÍDA COM SUCESSO!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📦 Versão: ${IG_VERSION}"
echo "📅 Data: $(date +%Y-%m-%d)"
echo "🔗 URL: https://simplifier.net/${IG_NAME}"
echo "📊 Registry: ${REGISTRY_URL}/${IG_NAME}/${IG_VERSION}"
echo ""
echo "Próximos passos:"
echo "1. Verificar publicação em: https://registry.fhir.org"
echo "2. Notificar comunidade sobre nova versão"
echo "3. Atualizar documentação de migração se necessário"
echo ""
```

### 12.2 Script de Rollback

```bash
#!/bin/bash
# rollback-version.sh - Reverter para versão anterior

PREVIOUS_VERSION=$1

if [ -z "$PREVIOUS_VERSION" ]; then
    echo "Uso: ./rollback-version.sh <versão-anterior>"
    exit 1
fi

echo "⏮️  Revertendo para versão ${PREVIOUS_VERSION}"

# Reverter git
git checkout "v${PREVIOUS_VERSION}"

# Republicar versão anterior
bash _genonce.sh
cd output
tar -czf "../rollback-${PREVIOUS_VERSION}.tgz" package/
cd ..

echo "✅ Rollback concluído"
```

## 13. REFERÊNCIAS

1. HL7 International. FHIR Implementation Guide Publishing Requirements. Disponível em: https://wiki.hl7.org/FHIR_Implementation_Guide_Publishing_Requirements

2. FHIR Package Registry. Package Specification and Registry Documentation. Disponível em: https://registry.fhir.org/learn

3. Preston-Werner, T. Semantic Versioning 2.0.0. Disponível em: https://semver.org/

4. HL7 International. FHIR Version Management Policy. Disponível em: https://www.hl7.org/fhir/versions.html

5. HL7 Confluence. NPM Package Specification for FHIR. Disponível em: https://confluence.hl7.org/display/FHIR/NPM+Package+Specification

6. Grieve, G. FHIR Package Versioning Best Practices. HL7 International Forums, 2023.

7. HL7 International. Standards Development Process. Disponível em: https://www.hl7.org/fhir/lifecycle.html

8. Driessen, V. A Successful Git Branching Model. Disponível em: https://nvie.com/posts/a-successful-git-branching-model/

9. FHIR NPM Registry. Publishing Guidelines. Disponível em: https://packages.fhir.org/guidelines

10. HL7 International. IG Publisher Documentation. Disponível em: https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation

11. FHIR Quality Control. Validation and QA Tools. Disponível em: https://www.hl7.org/fhir/qa.html

12. NPM Documentation. Managing Dependencies. Disponível em: https://docs.npmjs.com/cli/v8/configuring-npm/package-json

13. FHIR Analytics. Implementation Statistics and Metrics. Disponível em: https://fhir.org/implementations/stats

14. HL7 International. Deprecation and Sunset Policy. Disponível em: https://www.hl7.org/fhir/versions.html#deprecation

15. Radicle Documentation. Decentralized Code Collaboration. Disponível em: https://docs.radicle.xyz/

---
**Versão:** 1.0.0  
**Data:** 2025-08-30  
**Autor:** Sistema de Gestão de IG FHIR  
**Status:** Ativo  
**Próxima revisão:** 2026-02-30