# SOP-017: Controle de Qualidade e Auditoria para Implementation Guides FHIR

**Versão:** 1.0.0  
**Data de Criação:** 2024  
**Última Atualização:** 2024  
**Responsável:** Equipe de Interoperabilidade  
**Status:** Ativo

## 1. OBJETIVO

Este procedimento operacional padrão estabelece diretrizes para implementação de controle de qualidade e auditoria em Implementation Guides FHIR, garantindo conformidade com padrões internacionais, rastreabilidade de mudanças e manutenção da integridade dos dados clínicos¹.

## 2. ESCOPO

Aplica-se a todos os processos de desenvolvimento, validação, publicação e manutenção de Implementation Guides FHIR, incluindo:
- Validação de recursos e perfis
- Auditoria de conformidade
- Testes automatizados
- Monitoramento de qualidade
- Certificação e compliance

## 3. DEFINIÇÕES E CONCEITOS

### 3.1 Fundamentos Teóricos

**Qualidade em Interoperabilidade**: Segundo o HL7 FHIR Quality Control Framework², a qualidade em interoperabilidade abrange três dimensões principais:
- **Qualidade Sintática**: Conformidade com estruturas de dados definidas
- **Qualidade Semântica**: Precisão e consistência do significado clínico
- **Qualidade Pragmática**: Adequação ao uso pretendido e contexto clínico

**Framework de Auditoria FHIR**: O padrão FHIR define o recurso AuditEvent³ para registro de atividades do sistema, baseado no IHE ATNA (Audit Trail and Node Authentication) profile⁴, garantindo:
- Rastreabilidade completa de operações
- Conformidade com requisitos regulatórios
- Detecção de acessos não autorizados
- Análise forense de incidentes

### 3.2 Componentes do Sistema de Qualidade

**Níveis de Validação**⁵:
1. **Validação Estrutural**: Conformidade com esquemas XSD/JSON
2. **Validação de Perfil**: Aderência a constraints definidos
3. **Validação de Terminologia**: Verificação de códigos e ValueSets
4. **Validação de Negócio**: Regras específicas do domínio
5. **Validação Cross-Resource**: Integridade referencial

## 4. RESPONSABILIDADES

### 4.1 Equipe de Desenvolvimento
- Implementar testes unitários para todos os perfis
- Executar validação antes de commits
- Documentar desvios e exceções

### 4.2 Equipe de Qualidade
- Definir métricas e KPIs de qualidade
- Executar testes de regressão
- Realizar auditorias periódicas

### 4.3 Arquiteto de Interoperabilidade
- Aprovar critérios de aceitação
- Revisar resultados de auditoria
- Autorizar publicações

## 5. PROCEDIMENTOS - PARTE TEÓRICA

### 5.1 Estratégia de Validação Multicamadas

O processo de validação segue o modelo proposto por Braunstein⁶ para sistemas de saúde interoperáveis:

**Camada 1 - Validação Sintática**:
- Verificação de estrutura XML/JSON
- Conformidade com esquemas FHIR
- Validação de tipos de dados

**Camada 2 - Validação Semântica**:
- Verificação de invariantes
- Validação de cardinalidades
- Checagem de must-support

**Camada 3 - Validação de Domínio**:
- Regras de negócio específicas
- Validação de workflows clínicos
- Conformidade com guidelines locais

### 5.2 Modelo de Auditoria Baseado em Eventos

Implementação do padrão IHE ATNA⁷ adaptado para FHIR:

**Categorias de Eventos Auditáveis**:
- Application Activity (inicio/parada de sistema)
- Audit Recording (alterações em logs)
- Authentication (login/logout)
- Authorization (concessão/revogação de acesso)
- Patient Record (criação/modificação/acesso)
- Query (pesquisas e recuperação de dados)

## 6. PROCEDIMENTOS - PARTE PRÁTICA

### 6.1 Configuração do FHIR Validator

```bash
# Instalação do validador oficial HL7
wget https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar

# Validação básica de recurso
java -jar validator_cli.jar \
  -version 4.0.1 \
  -ig ./output/package.tgz \
  -profile http://example.org/fhir/StructureDefinition/MyProfile \
  ./examples/patient-example.json

# Validação com servidor de terminologia
java -jar validator_cli.jar \
  -version 4.0.1 \
  -tx https://r4.ontoserver.csiro.au/fhir \
  -ig ./output/package.tgz \
  ./examples/
```

### 6.2 Implementação de Testes Automatizados

```javascript
// test/profiles.test.js
const FHIRValidator = require('fhir-validator');
const fs = require('fs');
const path = require('path');

describe('Profile Validation Tests', () => {
  let validator;
  
  beforeAll(async () => {
    validator = new FHIRValidator({
      implementationGuides: ['./output/package.tgz'],
      txServer: process.env.TX_SERVER || 'https://r4.ontoserver.csiro.au/fhir'
    });
    await validator.initialize();
  });
  
  test('Patient Profile Validation', async () => {
    const patient = JSON.parse(
      fs.readFileSync('./examples/patient-example.json', 'utf8')
    );
    
    const result = await validator.validate(patient, {
      profile: 'http://example.org/fhir/StructureDefinition/MyPatient'
    });
    
    expect(result.issues.filter(i => i.severity === 'error')).toHaveLength(0);
  });
  
  test('Bundle Integrity Check', async () => {
    const bundle = JSON.parse(
      fs.readFileSync('./examples/bundle-example.json', 'utf8')
    );
    
    // Verificar integridade referencial
    const references = extractReferences(bundle);
    const resources = bundle.entry.map(e => e.fullUrl);
    
    references.forEach(ref => {
      expect(resources).toContain(ref);
    });
  });
});
```

### 6.3 Sistema de Auditoria com AuditEvent

```javascript
// audit/auditLogger.js
class FHIRAuditLogger {
  constructor(fhirClient, config) {
    this.client = fhirClient;
    this.config = config;
    this.agentId = config.agentId || 'system';
  }
  
  async logResourceAccess(resource, action, user, outcome = '0') {
    const auditEvent = {
      resourceType: 'AuditEvent',
      type: {
        system: 'http://dicom.nema.org/resources/ontology/DCM',
        code: this.mapActionToAuditCode(action),
        display: this.getAuditDisplay(action)
      },
      subtype: [{
        system: 'http://hl7.org/fhir/restful-interaction',
        code: action
      }],
      action: this.mapActionToAuditAction(action),
      recorded: new Date().toISOString(),
      outcome: outcome,
      outcomeDesc: outcome === '0' ? 'Success' : 'Failed',
      agent: [{
        type: {
          coding: [{
            system: 'http://terminology.hl7.org/CodeSystem/v3-ParticipationType',
            code: 'IRCP',
            display: 'information recipient'
          }]
        },
        who: {
          identifier: {
            system: 'http://example.org/users',
            value: user.id
          },
          display: user.name
        },
        requestor: true,
        network: {
          address: user.ipAddress,
          type: '2' // IP Address
        }
      }],
      source: {
        site: this.config.siteName,
        observer: {
          identifier: {
            value: this.agentId
          }
        },
        type: [{
          system: 'http://terminology.hl7.org/CodeSystem/security-source-type',
          code: '4',
          display: 'Application Server'
        }]
      },
      entity: [{
        what: {
          reference: `${resource.resourceType}/${resource.id}`
        },
        type: {
          system: 'http://terminology.hl7.org/CodeSystem/audit-entity-type',
          code: '2',
          display: 'System Object'
        },
        role: {
          system: 'http://terminology.hl7.org/CodeSystem/object-role',
          code: '4',
          display: 'Domain Resource'
        },
        lifecycle: {
          system: 'http://terminology.hl7.org/CodeSystem/dicom-audit-lifecycle',
          code: this.mapActionToLifecycle(action)
        }
      }]
    };
    
    if (resource.resourceType === 'Patient') {
      auditEvent.patient = {
        reference: `Patient/${resource.id}`
      };
    }
    
    try {
      await this.client.create(auditEvent);
    } catch (error) {
      console.error('Failed to log audit event:', error);
      // Implementar fallback para arquivo local
      this.logToFile(auditEvent);
    }
  }
  
  mapActionToAuditCode(action) {
    const mapping = {
      'read': '110106',
      'vread': '110106',
      'update': '110107',
      'patch': '110107',
      'delete': '110108',
      'create': '110109',
      'search': '110112'
    };
    return mapping[action] || '110150';
  }
  
  mapActionToAuditAction(action) {
    const mapping = {
      'read': 'R',
      'vread': 'R',
      'update': 'U',
      'patch': 'U',
      'delete': 'D',
      'create': 'C',
      'search': 'E'
    };
    return mapping[action] || 'E';
  }
}
```

### 6.4 Pipeline de CI/CD com Validação

```yaml
# .github/workflows/quality-check.yml
name: Quality Control Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: |
        npm install -g fsh-sushi
        wget https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar
    
    - name: Compile FSH
      run: sushi .
    
    - name: Validate Profiles
      run: |
        java -jar validator_cli.jar \
          -version 4.0.1 \
          -ig ./output/package.tgz \
          ./examples/*.json \
          -output-style compact
    
    - name: Run Unit Tests
      run: npm test
    
    - name: Check Coverage
      run: npm run test:coverage
      
    - name: Lint FSH Files
      run: |
        find ./input/fsh -name "*.fsh" -exec \
          npx fsh-linter {} \;
    
    - name: Security Scan
      run: |
        npm audit
        trivy fs --security-checks vuln,config .
    
    - name: Generate Quality Report
      run: |
        node scripts/generate-quality-report.js > quality-report.json
    
    - name: Upload Artifacts
      uses: actions/upload-artifact@v3
      with:
        name: quality-reports
        path: |
          quality-report.json
          coverage/
          test-results/
```

### 6.5 Dashboard de Monitoramento de Qualidade

```javascript
// monitoring/qualityDashboard.js
const express = require('express');
const { InfluxDB } = require('@influxdata/influxdb-client');

class QualityDashboard {
  constructor(config) {
    this.app = express();
    this.influx = new InfluxDB({
      url: config.influxUrl,
      token: config.influxToken
    });
    this.queryApi = this.influx.getQueryApi(config.org, config.bucket);
    this.setupRoutes();
  }
  
  setupRoutes() {
    this.app.get('/api/quality/metrics', async (req, res) => {
      const metrics = await this.getQualityMetrics();
      res.json(metrics);
    });
    
    this.app.get('/api/quality/validation-history', async (req, res) => {
      const history = await this.getValidationHistory(req.query.days || 30);
      res.json(history);
    });
    
    this.app.get('/api/quality/compliance-score', async (req, res) => {
      const score = await this.calculateComplianceScore();
      res.json({ score, timestamp: new Date().toISOString() });
    });
  }
  
  async getQualityMetrics() {
    const query = `
      from(bucket: "fhir-quality")
        |> range(start: -24h)
        |> filter(fn: (r) => r["_measurement"] == "validation")
        |> group(columns: ["profile", "severity"])
        |> count()
    `;
    
    const results = [];
    await this.queryApi.collectRows(query, (row) => {
      results.push({
        profile: row.profile,
        severity: row.severity,
        count: row._value
      });
    });
    
    return this.aggregateMetrics(results);
  }
  
  async calculateComplianceScore() {
    const weights = {
      'structural': 0.3,
      'terminology': 0.25,
      'business': 0.25,
      'security': 0.2
    };
    
    const scores = await this.getComponentScores();
    let totalScore = 0;
    
    for (const [component, weight] of Object.entries(weights)) {
      totalScore += (scores[component] || 0) * weight;
    }
    
    return Math.round(totalScore * 100) / 100;
  }
  
  aggregateMetrics(results) {
    const metrics = {
      total_validations: 0,
      errors: 0,
      warnings: 0,
      information: 0,
      profiles: {}
    };
    
    results.forEach(r => {
      metrics.total_validations += r.count;
      metrics[r.severity.toLowerCase()] += r.count;
      
      if (!metrics.profiles[r.profile]) {
        metrics.profiles[r.profile] = {
          errors: 0,
          warnings: 0,
          information: 0
        };
      }
      metrics.profiles[r.profile][r.severity.toLowerCase()] += r.count;
    });
    
    metrics.error_rate = metrics.errors / metrics.total_validations;
    metrics.quality_score = 1 - metrics.error_rate;
    
    return metrics;
  }
}
```

### 6.6 Relatório de Conformidade

```javascript
// reports/conformanceReport.js
class ConformanceReporter {
  constructor(igPath, outputPath) {
    this.igPath = igPath;
    this.outputPath = outputPath;
    this.report = {
      metadata: {
        generatedAt: new Date().toISOString(),
        igVersion: null,
        fhirVersion: 'R4'
      },
      profiles: [],
      extensions: [],
      valueSets: [],
      codeSystems: [],
      examples: [],
      validationResults: [],
      compliance: {
        mustSupport: [],
        cardinality: [],
        terminology: [],
        invariants: []
      }
    };
  }
  
  async generateReport() {
    await this.loadIG();
    await this.analyzeProfiles();
    await this.validateExamples();
    await this.checkCompliance();
    await this.saveReport();
    
    return this.report;
  }
  
  async analyzeProfiles() {
    const profiles = await this.loadProfiles();
    
    for (const profile of profiles) {
      const analysis = {
        url: profile.url,
        name: profile.name,
        baseDefinition: profile.baseDefinition,
        elements: [],
        mustSupportCount: 0,
        constraintsCount: 0,
        extensionsUsed: []
      };
      
      // Analisar elementos
      if (profile.differential && profile.differential.element) {
        for (const element of profile.differential.element) {
          const elementAnalysis = {
            path: element.path,
            mustSupport: element.mustSupport || false,
            min: element.min,
            max: element.max,
            constraints: element.constraint || []
          };
          
          if (element.mustSupport) {
            analysis.mustSupportCount++;
            this.report.compliance.mustSupport.push({
              profile: profile.url,
              element: element.path
            });
          }
          
          if (element.constraint) {
            analysis.constraintsCount += element.constraint.length;
            element.constraint.forEach(c => {
              this.report.compliance.invariants.push({
                profile: profile.url,
                element: element.path,
                key: c.key,
                severity: c.severity,
                human: c.human,
                expression: c.expression
              });
            });
          }
          
          analysis.elements.push(elementAnalysis);
        }
      }
      
      this.report.profiles.push(analysis);
    }
  }
  
  async validateExamples() {
    const examples = await this.loadExamples();
    const validator = new FHIRValidator({
      ig: this.igPath
    });
    
    for (const example of examples) {
      const result = await validator.validate(example.content);
      
      this.report.validationResults.push({
        file: example.file,
        resourceType: example.content.resourceType,
        profile: example.content.meta?.profile?.[0],
        valid: result.issues.filter(i => i.severity === 'error').length === 0,
        errors: result.issues.filter(i => i.severity === 'error'),
        warnings: result.issues.filter(i => i.severity === 'warning'),
        information: result.issues.filter(i => i.severity === 'information')
      });
    }
  }
  
  async checkCompliance() {
    // Verificar conformidade com padrões
    const standards = {
      'IPA': await this.checkIPACompliance(),
      'US-Core': await this.checkUSCoreCompliance(),
      'IPS': await this.checkIPSCompliance()
    };
    
    this.report.standardsCompliance = standards;
    
    // Calcular score geral
    const scores = Object.values(standards).filter(s => s !== null);
    if (scores.length > 0) {
      this.report.overallComplianceScore = 
        scores.reduce((a, b) => a + b.score, 0) / scores.length;
    }
  }
  
  async saveReport() {
    const htmlReport = this.generateHTMLReport();
    const jsonReport = JSON.stringify(this.report, null, 2);
    
    fs.writeFileSync(
      path.join(this.outputPath, 'conformance-report.json'),
      jsonReport
    );
    
    fs.writeFileSync(
      path.join(this.outputPath, 'conformance-report.html'),
      htmlReport
    );
    
    console.log(`Conformance report saved to ${this.outputPath}`);
  }
  
  generateHTMLReport() {
    return `
<!DOCTYPE html>
<html>
<head>
    <title>FHIR IG Conformance Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .summary { background: #f0f0f0; padding: 15px; border-radius: 5px; }
        .metric { display: inline-block; margin: 10px; padding: 10px; background: white; }
        .pass { color: green; }
        .fail { color: red; }
        .warning { color: orange; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #4CAF50; color: white; }
    </style>
</head>
<body>
    <h1>FHIR Implementation Guide Conformance Report</h1>
    
    <div class="summary">
        <h2>Summary</h2>
        <div class="metric">
            <strong>Generated:</strong> ${this.report.metadata.generatedAt}
        </div>
        <div class="metric">
            <strong>Profiles:</strong> ${this.report.profiles.length}
        </div>
        <div class="metric">
            <strong>Validation Score:</strong> 
            ${this.calculateValidationScore()}%
        </div>
        <div class="metric">
            <strong>Compliance Score:</strong> 
            ${Math.round(this.report.overallComplianceScore || 0)}%
        </div>
    </div>
    
    <h2>Profile Analysis</h2>
    <table>
        <tr>
            <th>Profile</th>
            <th>Must Support Elements</th>
            <th>Constraints</th>
            <th>Status</th>
        </tr>
        ${this.report.profiles.map(p => `
        <tr>
            <td>${p.name}</td>
            <td>${p.mustSupportCount}</td>
            <td>${p.constraintsCount}</td>
            <td class="${p.valid ? 'pass' : 'fail'}">
                ${p.valid ? '✓' : '✗'}
            </td>
        </tr>
        `).join('')}
    </table>
    
    <h2>Validation Results</h2>
    <table>
        <tr>
            <th>Example</th>
            <th>Resource Type</th>
            <th>Errors</th>
            <th>Warnings</th>
            <th>Status</th>
        </tr>
        ${this.report.validationResults.map(v => `
        <tr>
            <td>${v.file}</td>
            <td>${v.resourceType}</td>
            <td>${v.errors.length}</td>
            <td>${v.warnings.length}</td>
            <td class="${v.valid ? 'pass' : 'fail'}">
                ${v.valid ? 'Valid' : 'Invalid'}
            </td>
        </tr>
        `).join('')}
    </table>
    
    <h2>Standards Compliance</h2>
    ${this.generateStandardsComplianceHTML()}
    
    <footer>
        <p>Report generated by FHIR IG Quality Control System</p>
    </footer>
</body>
</html>
    `;
  }
}
```

## 7. MÉTRICAS E INDICADORES

### 7.1 KPIs de Qualidade

**Métricas Primárias**:
- Taxa de Validação Bem-Sucedida (>95%)
- Cobertura de Testes (>80%)
- Tempo Médio de Validação (<5s por recurso)
- Taxa de Conformidade com Must-Support (100%)

**Métricas Secundárias**:
- Densidade de Defeitos por Profile
- Taxa de Regressão
- Tempo de Resolução de Issues
- Score de Maturidade do IG

### 7.2 Fórmulas de Cálculo

```javascript
// Cálculo do Quality Score
qualityScore = (
  (validationPassRate * 0.3) +
  (testCoverage * 0.25) +
  (mustSupportCompliance * 0.25) +
  (documentationCompleteness * 0.2)
) * 100;

// Cálculo da Taxa de Defeitos
defectDensity = totalDefects / (linesOfFSH / 1000);

// Cálculo do Índice de Maturidade
maturityIndex = (
  (profilesPublished / profilesTotal) +
  (examplesValidated / examplesTotal) +
  (testsAutomated / testsTotal)
) / 3 * 100;
```

## 8. FERRAMENTAS E RECURSOS

### 8.1 Ferramentas Essenciais

1. **FHIR Validator** (validator_cli.jar)⁸
   - Validação oficial HL7
   - Suporte a múltiplos IGs
   - Integração com CI/CD

2. **HAPI FHIR Test Server**⁹
   - Ambiente de testes
   - Validação em runtime
   - API de conformidade

3. **Touchstone Testing Platform**¹⁰
   - Testes de conformidade
   - Certificação de IGs
   - Relatórios detalhados

4. **Crucible FHIR Testing**¹¹
   - Suite de testes
   - Validação de servidor
   - Benchmarking

### 8.2 Scripts de Automação

```bash
#!/bin/bash
# quality-check.sh - Script completo de verificação de qualidade

echo "🔍 Iniciando Verificação de Qualidade..."

# 1. Compilar FSH
echo "📦 Compilando FSH..."
sushi . || exit 1

# 2. Validar Estrutura
echo "✓ Validando estrutura..."
java -jar validator_cli.jar \
  -version 4.0.1 \
  -ig ./output/package.tgz \
  -profile http://hl7.org/fhir/StructureDefinition/ImplementationGuide \
  ./output/ImplementationGuide-*.json || exit 1

# 3. Validar Exemplos
echo "📋 Validando exemplos..."
for file in ./examples/*.json; do
  echo "  Validando: $file"
  java -jar validator_cli.jar \
    -version 4.0.1 \
    -ig ./output/package.tgz \
    "$file" || exit 1
done

# 4. Executar Testes
echo "🧪 Executando testes..."
npm test || exit 1

# 5. Verificar Cobertura
echo "📊 Verificando cobertura..."
npm run test:coverage
coverage_result=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
if (( $(echo "$coverage_result < 80" | bc -l) )); then
  echo "⚠️  Cobertura abaixo de 80%: $coverage_result%"
  exit 1
fi

# 6. Análise de Segurança
echo "🔒 Análise de segurança..."
npm audit --audit-level=moderate || exit 1

# 7. Gerar Relatório
echo "📄 Gerando relatório..."
node scripts/generate-quality-report.js

echo "✅ Verificação de Qualidade Concluída!"
```

## 9. COMPLIANCE E CERTIFICAÇÃO

### 9.1 Requisitos de Conformidade

**Padrões Obrigatórios**:
- FHIR R4 Conformance Resources¹²
- IHE Profiles Aplicáveis¹³
- ISO/HL7 27931:2009 (Data Exchange Standards)¹⁴
- ISO 13606 (EHR Communication)¹⁵

### 9.2 Processo de Certificação

1. **Auto-avaliação**: Executar suite completa de testes
2. **Validação Externa**: Submeter ao Touchstone
3. **Revisão por Pares**: Avaliação da comunidade
4. **Certificação Formal**: Registro no HL7 Registry

## 10. RESOLUÇÃO DE PROBLEMAS

### 10.1 Problemas Comuns e Soluções

| Problema | Causa Provável | Solução |
|----------|---------------|---------|
| Falha na validação de terminologia | Servidor TX indisponível | Usar cache local ou servidor alternativo |
| Timeout em validações grandes | Bundle muito grande | Dividir em chunks menores |
| Inconsistência de resultados | Versões diferentes do validator | Fixar versão no CI/CD |
| Falha em must-support | Elemento não mapeado | Revisar differential |

### 10.2 Checklist de Debugging

```markdown
- [ ] Verificar versão do FHIR (R4, R4B, R5)
- [ ] Confirmar URL do perfil correto
- [ ] Validar sintaxe JSON/XML
- [ ] Verificar dependências do IG
- [ ] Confirmar acesso ao servidor de terminologia
- [ ] Revisar logs detalhados do validator
- [ ] Testar com exemplo mínimo
- [ ] Verificar invariantes customizados
```

## 11. REFERÊNCIAS

1. HL7 FHIR Quality Control Framework. **FHIR R5 Quality Control Module**. Disponível em: [https://www.hl7.org/fhir/R5/quality-module.html](https://www.hl7.org/fhir/R5/quality-module.html). Acesso em: 2024.

2. Veeam Software. **3-2-1 Backup Strategy Guide**. Disponível em: [https://www.veeam.com/blog/321-backup-rule.html](https://www.veeam.com/blog/321-backup-rule.html). Acesso em: 2024.

3. IHE International. **Audit Trail and Node Authentication (ATNA) Profile**. Disponível em: [https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_TF_Vol1.pdf](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_TF_Vol1.pdf). Acesso em: 2024.

4. IHE IT Infrastructure Technical Framework. **ATNA Integration Profile**. Disponível em: [https://wiki.ihe.net/index.php/Audit_Trail_and_Node_Authentication](https://wiki.ihe.net/index.php/Audit_Trail_and_Node_Authentication). Acesso em: 2024.

5. HL7 International. **FHIR Validation**. Disponível em: [https://www.hl7.org/fhir/validation.html](https://www.hl7.org/fhir/validation.html). Acesso em: 2024.

6. Braunstein, M. L. **Health Informatics on FHIR: How HL7's API is Transforming Healthcare**. Springer, 2022. ISBN: 978-3-030-91563-6.

7. IHE International. **IHE ATNA Supplement**. Disponível em: [https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf](https://www.ihe.net/uploadedFiles/Documents/ITI/IHE_ITI_Suppl_RESTful-ATNA.pdf). Acesso em: 2024.

8. HL7. **FHIR Validator Documentation**. Disponível em: [https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator). Acesso em: 2024.

9. HAPI FHIR. **HAPI FHIR Test Server Documentation**. Disponível em: [https://hapifhir.io/hapi-fhir/docs/server_plain/testing.html](https://hapifhir.io/hapi-fhir/docs/server_plain/testing.html). Acesso em: 2024.

10. AEGIS. **Touchstone FHIR Testing Platform**. Disponível em: [https://touchstone.aegis.net/touchstone/](https://touchstone.aegis.net/touchstone/). Acesso em: 2024.

11. MITRE. **Crucible FHIR Server Testing**. Disponível em: [https://projectcrucible.org/](https://projectcrucible.org/). Acesso em: 2024.

12. HL7 FHIR. **Conformance Module Resources**. Disponível em: [https://www.hl7.org/fhir/conformance-module.html](https://www.hl7.org/fhir/conformance-module.html). Acesso em: 2024.

13. IHE International. **IHE Profiles Catalog**. Disponível em: [https://www.ihe.net/resources/profiles/](https://www.ihe.net/resources/profiles/). Acesso em: 2024.

14. ISO. **ISO/HL7 27931:2009 Data Exchange Standards**. Disponível em: [https://www.iso.org/standard/44428.html](https://www.iso.org/standard/44428.html). Acesso em: 2024.

15. ISO. **ISO 13606 - Electronic Health Record Communication**. Disponível em: [https://www.iso.org/standard/67868.html](https://www.iso.org/standard/67868.html). Acesso em: 2024. 