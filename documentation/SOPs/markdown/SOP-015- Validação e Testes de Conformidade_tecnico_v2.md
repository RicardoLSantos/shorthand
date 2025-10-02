# SOP-015: Validação e Testes de Conformidade
**Standard Operating Procedure para Validação, Testes e Garantia de Qualidade em Implementation Guides FHIR**

## 1. INTRODUÇÃO

### 1.1 Objetivo
Estabelecer procedimentos padronizados para validação de recursos FHIR, testes de conformidade com profiles, e garantia de qualidade em Implementation Guides, assegurando compliance com especificações HL7 e padrões internacionais de interoperabilidade.

### 1.2 Escopo
Este SOP aplica-se a todas as fases de validação e teste de Implementation Guides FHIR, incluindo validação estrutural, semântica, terminológica e de regras de negócio, abrangendo ambientes de desenvolvimento, homologação e produção.

### 1.3 Referências Normativas
- **HL7 FHIR Validation**¹: https://hl7.org/fhir/validation.html
- **FHIR Testing Guidelines**²: https://hl7.org/fhir/testing.html
- **Inferno Framework**³: https://inferno.healthit.gov/
- **Touchstone Testing Platform**⁴: https://touchstone.aegis.net/
- **FHIR TestScript Resource**⁵: https://hl7.org/fhir/testscript.html

## 2. FUNDAMENTOS TEÓRICOS

### 2.1 Níveis de Validação FHIR

A validação FHIR opera em múltiplas camadas hierárquicas⁶:

1. **Validação Sintática**: Conformidade com esquemas XML/JSON
2. **Validação de Recurso**: Aderência às definições base do FHIR
3. **Validação de Profile**: Conformidade com constraints específicos
4. **Validação Terminológica**: Verificação de code systems e value sets
5. **Validação de Regras de Negócio**: Invariantes e lógica customizada

### 2.2 Tipos de Teste de Conformidade

**Testes Unitários**: Validação individual de recursos e componentes⁷
- Estrutura de dados
- Cardinalidade de elementos
- Tipos de dados corretos
- Referências válidas

**Testes de Integração**: Verificação de interações entre sistemas⁸
- Operações RESTful (CRUD)
- Bundles e transações
- Busca e paginação
- Operações customizadas

**Testes End-to-End**: Workflows clínicos completos⁹
- Jornadas de paciente
- Processos assistenciais
- Fluxos de autorização
- Sincronização de dados

### 2.3 Framework de Qualidade ISO/IEC 25010

O modelo de qualidade de software ISO/IEC 25010¹⁰ define oito características principais:
- **Adequação Funcional**: Completude e correção
- **Eficiência de Performance**: Tempo e recursos
- **Compatibilidade**: Coexistência e interoperabilidade
- **Usabilidade**: Aprendizagem e acessibilidade
- **Confiabilidade**: Maturidade e disponibilidade
- **Segurança**: Confidencialidade e integridade
- **Manutenibilidade**: Modularidade e testabilidade
- **Portabilidade**: Adaptabilidade e instalabilidade

## 3. FERRAMENTAS E TECNOLOGIAS

### 3.1 HAPI FHIR Validator

O validador Java mais completo para FHIR¹¹:

```java
// Configuração do validador HAPI
public class FHIRValidator {
    private FhirContext ctx;
    private FhirValidator validator;
    
    public void initialize() {
        // Contexto FHIR R4
        ctx = FhirContext.forR4();
        
        // Criar instância do validador
        validator = ctx.newValidator();
        
        // Configurar módulos de validação
        IValidatorModule module = new FhirInstanceValidator(
            new DefaultProfileValidationSupport(ctx)
        );
        validator.registerValidatorModule(module);
        
        // Adicionar suporte para terminologias
        ValidationSupportChain support = new ValidationSupportChain(
            new DefaultProfileValidationSupport(ctx),
            new InMemoryTerminologyServerValidationSupport(ctx),
            new CommonCodeSystemsTerminologyService(ctx),
            new SnapshotGeneratingValidationSupport(ctx)
        );
        
        FhirInstanceValidator instanceValidator = 
            (FhirInstanceValidator) module;
        instanceValidator.setValidationSupport(support);
    }
    
    public ValidationResult validateResource(IBaseResource resource) {
        return validator.validateWithResult(resource);
    }
}
```

### 3.2 FHIR Path e Invariantes

Implementação de regras customizadas usando FHIRPath¹²:

```javascript
// Definição de invariantes em FSH
Invariant: br-cpf-valid
Description: "CPF deve ser válido segundo algoritmo brasileiro"
Expression: "identifier.where(system='http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf').value.matches('^[0-9]{11}$') and identifier.where(system='http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf').value.validateCPF()"
Severity: #error

// Função de validação customizada
function validateCPF(cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replace(/[^\d]/g, '');
    
    // Verifica se tem 11 dígitos
    if (cpf.length !== 11) return false;
    
    // Verifica sequências inválidas
    if (/^(\d)\1+$/.test(cpf)) return false;
    
    // Validação do primeiro dígito verificador
    let sum = 0;
    for (let i = 0; i < 9; i++) {
        sum += parseInt(cpf.charAt(i)) * (10 - i);
    }
    let digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;
    
    // Validação do segundo dígito verificador
    sum = 0;
    for (let i = 0; i < 10; i++) {
        sum += parseInt(cpf.charAt(i)) * (11 - i);
    }
    let digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;
    
    return digit1 === parseInt(cpf.charAt(9)) && 
           digit2 === parseInt(cpf.charAt(10));
}
```

### 3.3 TestScript Resources

Estrutura para testes automatizados¹³:

```json
{
  "resourceType": "TestScript",
  "id": "patient-validation-test",
  "url": "http://example.org/fhir/TestScript/patient-validation",
  "name": "PatientProfileValidation",
  "status": "active",
  "date": "2024-01-15",
  "publisher": "Organization Name",
  "contact": [{
    "name": "QA Team",
    "telecom": [{
      "system": "email",
      "value": "qa@organization.org"
    }]
  }],
  "description": "Teste de validação para o profile Patient nacional",
  "fixture": [{
    "id": "patient-valid",
    "autocreate": false,
    "autodelete": false,
    "resource": {
      "reference": "Patient/example-valid"
    }
  }],
  "test": [{
    "id": "01-validate-profile",
    "name": "Validate Patient Profile",
    "description": "Validar recurso contra profile nacional",
    "action": [{
      "operation": {
        "type": {
          "system": "http://terminology.hl7.org/CodeSystem/testscript-operation-codes",
          "code": "validate"
        },
        "resource": "Patient",
        "description": "Validar Patient resource",
        "accept": "json",
        "contentType": "json",
        "params": "?profile=http://example.org/fhir/StructureDefinition/patient-br",
        "sourceId": "patient-valid"
      }
    }, {
      "assert": {
        "description": "Confirm successful validation",
        "response": "okay",
        "warningOnly": false
      }
    }]
  }]
}
```

## 4. PROCESSOS DE VALIDAÇÃO

### 4.1 Pipeline de Validação Contínua

Implementação de CI/CD para validação automática¹⁴:

```yaml
# .github/workflows/fhir-validation.yml
name: FHIR IG Validation Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install SUSHI
      run: npm install -g fsh-sushi
    
    - name: Install IG Publisher
      run: |
        wget https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar
        mkdir -p input-cache
        mv publisher.jar input-cache/
    
    - name: Run SUSHI
      run: sushi .
    
    - name: Validate with IG Publisher
      run: |
        java -jar input-cache/publisher.jar \
          -ig . \
          -tx https://tx.fhir.org \
          -qa
    
    - name: Run Custom Validation Tests
      run: |
        npm test
    
    - name: Upload Validation Report
      uses: actions/upload-artifact@v3
      with:
        name: validation-report
        path: output/qa.html
```

### 4.2 Matriz de Rastreabilidade de Testes

Estrutura para gerenciamento de casos de teste¹⁵:

```typescript
interface TestCase {
  id: string;
  requirement: string;
  profile: string;
  testType: 'unit' | 'integration' | 'e2e';
  priority: 'critical' | 'high' | 'medium' | 'low';
  automationStatus: 'automated' | 'manual' | 'planned';
  lastExecution?: Date;
  result?: 'pass' | 'fail' | 'blocked';
}

class TestMatrix {
  private testCases: Map<string, TestCase> = new Map();
  
  addTestCase(testCase: TestCase): void {
    this.testCases.set(testCase.id, testCase);
  }
  
  generateCoverageReport(): CoverageReport {
    const total = this.testCases.size;
    const automated = Array.from(this.testCases.values())
      .filter(tc => tc.automationStatus === 'automated').length;
    const passed = Array.from(this.testCases.values())
      .filter(tc => tc.result === 'pass').length;
    
    return {
      totalTests: total,
      automatedTests: automated,
      automationRate: (automated / total) * 100,
      passedTests: passed,
      passRate: (passed / total) * 100,
      profiles: this.getProfileCoverage(),
      requirements: this.getRequirementsCoverage()
    };
  }
  
  private getProfileCoverage(): Map<string, number> {
    const coverage = new Map<string, number>();
    
    for (const tc of this.testCases.values()) {
      const count = coverage.get(tc.profile) || 0;
      coverage.set(tc.profile, count + 1);
    }
    
    return coverage;
  }
}
```

### 4.3 Validação de Terminologias

Processo para validação de code systems e value sets¹⁶:

```python
from fhirclient import client
from fhirclient.models import codesystem, valueset
import requests

class TerminologyValidator:
    def __init__(self, terminology_server_url):
        self.ts_url = terminology_server_url
        self.session = requests.Session()
    
    def validate_code(self, system, code, display=None):
        """
        Valida um código contra um sistema de códigos
        """
        params = {
            'system': system,
            'code': code,
            'display': display
        }
        
        response = self.session.get(
            f"{self.ts_url}/CodeSystem/$validate-code",
            params=params
        )
        
        if response.status_code == 200:
            result = response.json()
            return {
                'valid': result.get('result', False),
                'message': result.get('message', ''),
                'display': result.get('display', '')
            }
        else:
            raise Exception(f"Validation failed: {response.text}")
    
    def expand_valueset(self, valueset_url):
        """
        Expande um ValueSet para obter todos os códigos
        """
        params = {'url': valueset_url}
        
        response = self.session.get(
            f"{self.ts_url}/ValueSet/$expand",
            params=params
        )
        
        if response.status_code == 200:
            expansion = response.json()
            codes = []
            
            for contains in expansion.get('expansion', {}).get('contains', []):
                codes.append({
                    'system': contains.get('system'),
                    'code': contains.get('code'),
                    'display': contains.get('display')
                })
            
            return codes
        else:
            raise Exception(f"Expansion failed: {response.text}")
    
    def validate_binding(self, element_value, binding_strength, valueset_url):
        """
        Valida binding de elemento contra ValueSet
        """
        if binding_strength == 'required':
            # Código DEVE estar no ValueSet
            valid_codes = self.expand_valueset(valueset_url)
            return element_value in [c['code'] for c in valid_codes]
        
        elif binding_strength == 'extensible':
            # Código DEVERIA estar no ValueSet, mas pode ter exceções
            valid_codes = self.expand_valueset(valueset_url)
            if element_value in [c['code'] for c in valid_codes]:
                return True
            else:
                # Log warning mas permite
                print(f"Warning: Code {element_value} not in preferred ValueSet")
                return True
        
        elif binding_strength == 'preferred':
            # Código é sugerido mas não obrigatório
            return True
        
        elif binding_strength == 'example':
            # Apenas exemplo, sem validação
            return True
        
        return False
```

## 5. TESTES DE CONFORMIDADE

### 5.1 Conformance Test Suite

Framework completo para testes de conformidade¹⁷:

```javascript
const { FHIRClient } = require('fhir-kit-client');
const { expect } = require('chai');
const { v4: uuidv4 } = require('uuid');

class ConformanceTestSuite {
    constructor(serverUrl) {
        this.client = new FHIRClient({
            baseUrl: serverUrl
        });
        this.testResults = [];
    }
    
    async runCapabilityStatementTests() {
        console.log('Testing CapabilityStatement...');
        
        try {
            // Teste 1: Recuperar CapabilityStatement
            const capStatement = await this.client.capabilityStatement();
            
            this.addTestResult({
                test: 'Retrieve CapabilityStatement',
                result: 'pass',
                details: `FHIR Version: ${capStatement.fhirVersion}`
            });
            
            // Teste 2: Verificar recursos suportados
            const requiredResources = ['Patient', 'Observation', 'Encounter'];
            const supportedResources = capStatement.rest[0].resource
                .map(r => r.type);
            
            for (const resource of requiredResources) {
                if (supportedResources.includes(resource)) {
                    this.addTestResult({
                        test: `Support for ${resource}`,
                        result: 'pass'
                    });
                } else {
                    this.addTestResult({
                        test: `Support for ${resource}`,
                        result: 'fail',
                        details: 'Resource not supported'
                    });
                }
            }
            
            // Teste 3: Verificar operações suportadas
            for (const resource of capStatement.rest[0].resource) {
                const interactions = resource.interaction
                    .map(i => i.code);
                
                if (interactions.includes('create') && 
                    interactions.includes('read') &&
                    interactions.includes('update')) {
                    this.addTestResult({
                        test: `CRUD operations for ${resource.type}`,
                        result: 'pass'
                    });
                }
            }
            
        } catch (error) {
            this.addTestResult({
                test: 'CapabilityStatement Tests',
                result: 'fail',
                details: error.message
            });
        }
    }
    
    async runSearchParameterTests() {
        console.log('Testing Search Parameters...');
        
        const searchTests = [
            {
                resource: 'Patient',
                params: { name: 'Smith' },
                description: 'Search patient by name'
            },
            {
                resource: 'Patient',
                params: { identifier: '12345' },
                description: 'Search patient by identifier'
            },
            {
                resource: 'Observation',
                params: { 
                    patient: 'Patient/123',
                    code: 'http://loinc.org|85354-9'
                },
                description: 'Search observation by patient and code'
            }
        ];
        
        for (const test of searchTests) {
            try {
                const bundle = await this.client.search({
                    resourceType: test.resource,
                    searchParams: test.params
                });
                
                this.addTestResult({
                    test: test.description,
                    result: 'pass',
                    details: `Found ${bundle.total || 0} results`
                });
            } catch (error) {
                this.addTestResult({
                    test: test.description,
                    result: 'fail',
                    details: error.message
                });
            }
        }
    }
    
    async runTransactionTests() {
        console.log('Testing Transactions...');
        
        const bundle = {
            resourceType: 'Bundle',
            type: 'transaction',
            entry: [
                {
                    fullUrl: `urn:uuid:${uuidv4()}`,
                    resource: {
                        resourceType: 'Patient',
                        name: [{ family: 'Test', given: ['Transaction'] }]
                    },
                    request: {
                        method: 'POST',
                        url: 'Patient'
                    }
                },
                {
                    fullUrl: `urn:uuid:${uuidv4()}`,
                    resource: {
                        resourceType: 'Observation',
                        status: 'final',
                        code: {
                            coding: [{
                                system: 'http://loinc.org',
                                code: '85354-9'
                            }]
                        }
                    },
                    request: {
                        method: 'POST',
                        url: 'Observation'
                    }
                }
            ]
        };
        
        try {
            const result = await this.client.transaction({
                body: bundle
            });
            
            if (result.type === 'transaction-response') {
                this.addTestResult({
                    test: 'Transaction Bundle',
                    result: 'pass',
                    details: 'Transaction completed successfully'
                });
            }
        } catch (error) {
            this.addTestResult({
                test: 'Transaction Bundle',
                result: 'fail',
                details: error.message
            });
        }
    }
    
    addTestResult(result) {
        this.testResults.push({
            ...result,
            timestamp: new Date().toISOString()
        });
    }
    
    generateReport() {
        const passed = this.testResults.filter(r => r.result === 'pass').length;
        const failed = this.testResults.filter(r => r.result === 'fail').length;
        const total = this.testResults.length;
        
        return {
            summary: {
                total,
                passed,
                failed,
                passRate: (passed / total * 100).toFixed(2) + '%'
            },
            details: this.testResults,
            timestamp: new Date().toISOString()
        };
    }
}
```

### 5.2 Inferno Test Framework

Configuração e execução de testes Inferno¹⁸:

```ruby
# inferno_test_suite.rb
require 'inferno'

module InfernoTemplate
  class Suite < Inferno::TestSuite
    id :ig_conformance_suite
    title 'IG Conformance Test Suite'
    description 'Comprehensive conformance testing for FHIR IG'
    
    # Define os inputs necessários
    input :url,
          title: 'FHIR Server URL',
          description: 'URL base do servidor FHIR'
    
    input :credentials,
          title: 'OAuth2 Credentials',
          type: :oauth_credentials,
          optional: true
    
    # Grupo de testes de capacidade
    group do
      id :capability_tests
      title 'Capability Statement Tests'
      description 'Validate server capabilities'
      
      test do
        id :capability_statement_read
        title 'Server returns valid CapabilityStatement'
        description 'Verify server metadata endpoint'
        
        run do
          fhir_client.capability_statement
          assert_response_status(200)
          assert_resource_type(:capability_statement)
        end
      end
      
      test do
        id :required_resources
        title 'Server supports required resources'
        description 'Check for mandatory resource support'
        
        run do
          capability_statement = fhir_client.capability_statement
          resources = capability_statement.rest.first.resource
          resource_types = resources.map(&:type)
          
          required = ['Patient', 'Observation', 'Encounter']
          required.each do |type|
            assert resource_types.include?(type),
                   "Server must support #{type} resource"
          end
        end
      end
    end
    
    # Grupo de testes de profile
    group do
      id :profile_validation
      title 'Profile Validation Tests'
      description 'Validate resources against IG profiles'
      
      test do
        id :patient_profile_validation
        title 'Patient resources conform to profile'
        
        run do
          patients = fhir_client.search(
            FHIR::Patient,
            search: { parameters: { _count: 10 } }
          ).resource
          
          patients.entry.each do |entry|
            patient = entry.resource
            
            # Validar contra profile
            outcome = fhir_client.validate(
              patient,
              { profile: 'http://example.org/fhir/StructureDefinition/patient-br' }
            )
            
            assert outcome.issue.none? { |i| i.severity == 'error' },
                   "Patient validation errors: #{outcome.issue.map(&:diagnostics)}"
          end
        end
      end
    end
  end
end
```

## 6. GARANTIA DE QUALIDADE

### 6.1 Métricas de Qualidade

Dashboard para monitoramento de qualidade¹⁹:

```typescript
interface QualityMetrics {
  structuralValidity: number;    // % recursos válidos estruturalmente
  profileConformance: number;     // % conformidade com profiles
  terminologyAccuracy: number;    // % códigos válidos
  referentialIntegrity: number;   // % referências válidas
  businessRuleCompliance: number; // % regras de negócio atendidas
  performanceScore: number;       // Score de performance (0-100)
  securityScore: number;          // Score de segurança (0-100)
}

class QualityDashboard {
  private metrics: QualityMetrics;
  private history: QualityMetrics[] = [];
  
  async calculateMetrics(igPath: string): Promise<QualityMetrics> {
    const validator = new IGValidator(igPath);
    
    // Validação estrutural
    const structuralResults = await validator.validateStructure();
    const structuralValidity = 
      (structuralResults.valid / structuralResults.total) * 100;
    
    // Conformidade com profiles
    const profileResults = await validator.validateProfiles();
    const profileConformance = 
      (profileResults.conformant / profileResults.total) * 100;
    
    // Precisão terminológica
    const terminologyResults = await validator.validateTerminology();
    const terminologyAccuracy = 
      (terminologyResults.valid / terminologyResults.total) * 100;
    
    // Integridade referencial
    const referenceResults = await validator.validateReferences();
    const referentialIntegrity = 
      (referenceResults.valid / referenceResults.total) * 100;
    
    // Regras de negócio
    const businessResults = await validator.validateBusinessRules();
    const businessRuleCompliance = 
      (businessResults.passed / businessResults.total) * 100;
    
    // Performance
    const performanceScore = await this.calculatePerformanceScore();
    
    // Segurança
    const securityScore = await this.calculateSecurityScore();
    
    this.metrics = {
      structuralValidity,
      profileConformance,
      terminologyAccuracy,
      referentialIntegrity,
      businessRuleCompliance,
      performanceScore,
      securityScore
    };
    
    this.history.push(this.metrics);
    return this.metrics;
  }
  
  generateQualityReport(): QualityReport {
    const overallScore = this.calculateOverallScore();
    const trend = this.calculateTrend();
    const recommendations = this.generateRecommendations();
    
    return {
      timestamp: new Date().toISOString(),
      metrics: this.metrics,
      overallScore,
      trend,
      recommendations,
      history: this.history.slice(-30) // Últimos 30 registros
    };
  }
  
  private calculateOverallScore(): number {
    const weights = {
      structuralValidity: 0.20,
      profileConformance: 0.25,
      terminologyAccuracy: 0.15,
      referentialIntegrity: 0.15,
      businessRuleCompliance: 0.15,
      performanceScore: 0.05,
      securityScore: 0.05
    };
    
    let score = 0;
    for (const [metric, weight] of Object.entries(weights)) {
      score += this.metrics[metric] * weight;
    }
    
    return Math.round(score);
  }
}
```

### 6.2 Relatórios de Conformidade

Template para geração de relatórios²⁰:

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Relatório de Conformidade FHIR IG</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #0066cc; color: white; padding: 20px; }
        .summary { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 20px 0; }
        .metric-card { border: 1px solid #ddd; padding: 15px; border-radius: 8px; }
        .metric-value { font-size: 2em; font-weight: bold; }
        .pass { color: #28a745; }
        .fail { color: #dc3545; }
        .warning { color: #ffc107; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f4f4f4; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Relatório de Conformidade</h1>
        <p>Implementation Guide: {{ig_name}}</p>
        <p>Data: {{test_date}}</p>
    </div>
    
    <div class="summary">
        <div class="metric-card">
            <h3>Taxa de Aprovação</h3>
            <div class="metric-value {{pass_rate_class}}">{{pass_rate}}%</div>
            <p>{{passed_tests}} de {{total_tests}} testes</p>
        </div>
        
        <div class="metric-card">
            <h3>Cobertura de Profiles</h3>
            <div class="metric-value">{{profile_coverage}}%</div>
            <p>{{covered_profiles}} de {{total_profiles}} profiles</p>
        </div>
        
        <div class="metric-card">
            <h3>Validação Terminológica</h3>
            <div class="metric-value">{{terminology_score}}%</div>
            <p>{{valid_codes}} códigos validados</p>
        </div>
    </div>
    
    <h2>Detalhes dos Testes</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Teste</th>
                <th>Profile</th>
                <th>Status</th>
                <th>Detalhes</th>
                <th>Tempo (ms)</th>
            </tr>
        </thead>
        <tbody>
            {{#each test_results}}
            <tr>
                <td>{{this.id}}</td>
                <td>{{this.name}}</td>
                <td>{{this.profile}}</td>
                <td class="{{this.status_class}}">{{this.status}}</td>
                <td>{{this.details}}</td>
                <td>{{this.duration}}</td>
            </tr>
            {{/each}}
        </tbody>
    </table>
    
    <h2>Problemas Identificados</h2>
    <table>
        <thead>
            <tr>
                <th>Severidade</th>
                <th>Categoria</th>
                <th>Descrição</th>
                <th>Localização</th>
                <th>Recomendação</th>
            </tr>
        </thead>
        <tbody>
            {{#each issues}}
            <tr>
                <td class="{{this.severity_class}}">{{this.severity}}</td>
                <td>{{this.category}}</td>
                <td>{{this.description}}</td>
                <td>{{this.location}}</td>
                <td>{{this.recommendation}}</td>
            </tr>
            {{/each}}
        </tbody>
    </table>
    
    <footer>
        <p>Gerado automaticamente pelo Sistema de Validação FHIR IG</p>
    </footer>
</body>
</html>
```

## 7. PROCEDIMENTOS OPERACIONAIS

### 7.1 Processo de Validação Pré-Publicação

Checklist mandatório antes da publicação²¹:

```bash
#!/bin/bash
# pre-publication-validation.sh

echo "========================================="
echo "FHIR IG Pre-Publication Validation"
echo "========================================="

# Variáveis de configuração
IG_PATH="."
TERMINOLOGY_SERVER="https://tx.fhir.org"
VALIDATOR_VERSION="latest"
EXIT_CODE=0

# Função para verificar status
check_status() {
    if [ $1 -ne 0 ]; then
        echo "❌ FALHA: $2"
        EXIT_CODE=1
    else
        echo "✅ SUCESSO: $2"
    fi
}

# 1. Validação estrutural
echo -e "\n📋 Etapa 1: Validação Estrutural"
echo "--------------------------------"

# Verificar estrutura de diretórios
required_dirs=("input" "input/fsh" "input/pagecontent" "input/images")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ Diretório $dir existe"
    else
        echo "❌ Diretório $dir não encontrado"
        EXIT_CODE=1
    fi
done

# Verificar arquivos obrigatórios
required_files=("sushi-config.yaml" "ig.ini" "input/fsh/patient.fsh")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ Arquivo $file existe"
    else
        echo "❌ Arquivo $file não encontrado"
        EXIT_CODE=1
    fi
done

# 2. Executar SUSHI
echo -e "\n🍣 Etapa 2: Compilação SUSHI"
echo "--------------------------------"
sushi . -o .
check_status $? "Compilação SUSHI"

# 3. Validação com IG Publisher
echo -e "\n📚 Etapa 3: Validação IG Publisher"
echo "--------------------------------"

# Download do IG Publisher se necessário
if [ ! -f "input-cache/publisher.jar" ]; then
    echo "Baixando IG Publisher..."
    mkdir -p input-cache
    wget -q -O input-cache/publisher.jar \
        "https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar"
fi

# Executar validação
java -Xmx4g -jar input-cache/publisher.jar \
    -ig . \
    -tx $TERMINOLOGY_SERVER \
    -qa \
    -no-sushi
check_status $? "Validação IG Publisher"

# 4. Análise de erros e warnings
echo -e "\n🔍 Etapa 4: Análise de QA"
echo "--------------------------------"

if [ -f "output/qa.html" ]; then
    # Extrair contadores de erros
    ERRORS=$(grep -o "Errors: [0-9]*" output/qa.html | grep -o "[0-9]*" | head -1)
    WARNINGS=$(grep -o "Warnings: [0-9]*" output/qa.html | grep -o "[0-9]*" | head -1)
    INFO=$(grep -o "Info: [0-9]*" output/qa.html | grep -o "[0-9]*" | head -1)
    
    echo "Erros: $ERRORS"
    echo "Avisos: $WARNINGS"
    echo "Informações: $INFO"
    
    if [ "$ERRORS" -gt 0 ]; then
        echo "❌ Existem erros que devem ser corrigidos"
        EXIT_CODE=1
    fi
    
    if [ "$WARNINGS" -gt 10 ]; then
        echo "⚠️  Muitos warnings detectados - revisar antes de publicar"
    fi
else
    echo "❌ Arquivo qa.html não encontrado"
    EXIT_CODE=1
fi

# 5. Validação de exemplos
echo -e "\n📝 Etapa 5: Validação de Exemplos"
echo "--------------------------------"

for example in input/examples/*.json; do
    if [ -f "$example" ]; then
        filename=$(basename "$example")
        echo "Validando $filename..."
        
        java -jar validator_cli.jar \
            "$example" \
            -version 4.0.1 \
            -ig output \
            -profile $(grep -o '"profile".*".*"' "$example" | cut -d'"' -f4) \
            > /dev/null 2>&1
        
        check_status $? "Validação de $filename"
    fi
done

# 6. Testes de links
echo -e "\n🔗 Etapa 6: Verificação de Links"
echo "--------------------------------"

# Verificar links internos no narrative
find output -name "*.html" -exec grep -l "href=\".*\"" {} \; | while read file; do
    grep -o 'href="[^"]*"' "$file" | cut -d'"' -f2 | while read link; do
        if [[ $link == http* ]]; then
            continue  # Skip external links
        elif [[ $link == "#"* ]]; then
            continue  # Skip anchors
        else
            # Check if internal link exists
            target="output/$link"
            if [ ! -f "$target" ]; then
                echo "⚠️  Link quebrado em $file: $link"
            fi
        fi
    done
done

# 7. Validação de metadados
echo -e "\n📊 Etapa 7: Validação de Metadados"
echo "--------------------------------"

# Verificar metadados do IG
required_metadata=(
    "\"url\":" 
    "\"version\":" 
    "\"name\":" 
    "\"title\":" 
    "\"status\":" 
    "\"publisher\":" 
    "\"contact\":" 
    "\"description\":"
)

for metadata in "${required_metadata[@]}"; do
    if grep -q "$metadata" output/ImplementationGuide-*.json; then
        echo "✅ Metadado $metadata presente"
    else
        echo "❌ Metadado $metadata ausente"
        EXIT_CODE=1
    fi
done

# 8. Relatório final
echo -e "\n========================================="
echo "RELATÓRIO FINAL"
echo "========================================="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ IG está pronto para publicação!"
    echo "Próximos passos:"
    echo "1. Revisar o relatório QA em output/qa.html"
    echo "2. Executar testes de aceitação com stakeholders"
    echo "3. Publicar usando o script de deployment"
else
    echo "❌ IG não está pronto para publicação"
    echo "Corrija os problemas identificados acima"
fi

exit $EXIT_CODE
```

### 7.2 Automação de Testes de Regressão

Sistema para detectar regressões em mudanças²²:

```python
import json
import hashlib
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Set

class RegressionTestManager:
    def __init__(self, baseline_path: str, current_path: str):
        self.baseline_path = Path(baseline_path)
        self.current_path = Path(current_path)
        self.regressions = []
        
    def compare_validation_results(self) -> Dict:
        """
        Compara resultados de validação entre baseline e versão atual
        """
        baseline_results = self.load_validation_results(self.baseline_path)
        current_results = self.load_validation_results(self.current_path)
        
        comparison = {
            'timestamp': datetime.now().isoformat(),
            'baseline_version': baseline_results.get('version'),
            'current_version': current_results.get('version'),
            'regressions': [],
            'improvements': [],
            'unchanged': []
        }
        
        # Comparar cada profile
        for profile_id, baseline_data in baseline_results.get('profiles', {}).items():
            current_data = current_results.get('profiles', {}).get(profile_id, {})
            
            baseline_errors = baseline_data.get('errors', 0)
            current_errors = current_data.get('errors', 0)
            
            if current_errors > baseline_errors:
                comparison['regressions'].append({
                    'profile': profile_id,
                    'baseline_errors': baseline_errors,
                    'current_errors': current_errors,
                    'delta': current_errors - baseline_errors
                })
            elif current_errors < baseline_errors:
                comparison['improvements'].append({
                    'profile': profile_id,
                    'baseline_errors': baseline_errors,
                    'current_errors': current_errors,
                    'delta': baseline_errors - current_errors
                })
            else:
                comparison['unchanged'].append(profile_id)
        
        return comparison
    
    def detect_structural_changes(self) -> List[Dict]:
        """
        Detecta mudanças estruturais nos profiles
        """
        changes = []
        
        baseline_profiles = self.get_profile_signatures(self.baseline_path)
        current_profiles = self.get_profile_signatures(self.current_path)
        
        # Profiles removidos
        removed = baseline_profiles.keys() - current_profiles.keys()
        for profile_id in removed:
            changes.append({
                'type': 'removed',
                'profile': profile_id,
                'impact': 'breaking'
            })
        
        # Profiles adicionados
        added = current_profiles.keys() - baseline_profiles.keys()
        for profile_id in added:
            changes.append({
                'type': 'added',
                'profile': profile_id,
                'impact': 'non-breaking'
            })
        
        # Profiles modificados
        for profile_id in baseline_profiles.keys() & current_profiles.keys():
            if baseline_profiles[profile_id] != current_profiles[profile_id]:
                changes.append({
                    'type': 'modified',
                    'profile': profile_id,
                    'impact': self.assess_change_impact(
                        profile_id, 
                        baseline_profiles[profile_id],
                        current_profiles[profile_id]
                    )
                })
        
        return changes
    
    def get_profile_signatures(self, path: Path) -> Dict[str, str]:
        """
        Gera assinaturas hash para cada profile
        """
        signatures = {}
        
        for profile_file in path.glob("**/StructureDefinition-*.json"):
            with open(profile_file, 'r') as f:
                content = json.load(f)
                
                # Criar assinatura baseada em elementos importantes
                signature_data = {
                    'url': content.get('url'),
                    'version': content.get('version'),
                    'elements': self.extract_element_definitions(content)
                }
                
                signature = hashlib.sha256(
                    json.dumps(signature_data, sort_keys=True).encode()
                ).hexdigest()
                
                profile_id = content.get('id', profile_file.stem)
                signatures[profile_id] = signature
        
        return signatures
    
    def run_regression_suite(self) -> Dict:
        """
        Executa suite completa de testes de regressão
        """
        print("🔄 Iniciando testes de regressão...")
        
        results = {
            'validation_comparison': self.compare_validation_results(),
            'structural_changes': self.detect_structural_changes(),
            'performance_comparison': self.compare_performance_metrics(),
            'terminology_changes': self.detect_terminology_changes()
        }
        
        # Avaliar se há regressões críticas
        critical_regressions = [
            r for r in results['validation_comparison']['regressions']
            if r['delta'] > 5
        ]
        
        breaking_changes = [
            c for c in results['structural_changes']
            if c['impact'] == 'breaking'
        ]
        
        results['summary'] = {
            'has_critical_regressions': len(critical_regressions) > 0,
            'has_breaking_changes': len(breaking_changes) > 0,
            'total_regressions': len(results['validation_comparison']['regressions']),
            'total_improvements': len(results['validation_comparison']['improvements']),
            'recommendation': self.generate_recommendation(
                critical_regressions, 
                breaking_changes
            )
        }
        
        return results
```

## 8. MONITORAMENTO E MELHORIA CONTÍNUA

### 8.1 Dashboard de Monitoramento

Interface para acompanhamento em tempo real²³:

```typescript
import { Component, OnInit } from '@angular/core';
import { Chart } from 'chart.js';
import { ValidationService } from './validation.service';

@Component({
  selector: 'app-validation-dashboard',
  template: `
    <div class="dashboard-container">
      <h1>Painel de Validação FHIR IG</h1>
      
      <div class="metrics-grid">
        <div class="metric-card">
          <h3>Taxa de Validação</h3>
          <div class="metric-value" [class.success]="validationRate >= 95">
            {{ validationRate }}%
          </div>
          <canvas id="validationChart"></canvas>
        </div>
        
        <div class="metric-card">
          <h3>Cobertura de Testes</h3>
          <div class="metric-value" [class.warning]="testCoverage < 80">
            {{ testCoverage }}%
          </div>
          <div class="progress-bar">
            <div class="progress" [style.width.%]="testCoverage"></div>
          </div>
        </div>
        
        <div class="metric-card">
          <h3>Problemas Ativos</h3>
          <div class="issues-list">
            <div *ngFor="let issue of activeIssues" class="issue-item">
              <span class="severity" [class]="issue.severity">
                {{ issue.severity }}
              </span>
              <span class="description">{{ issue.description }}</span>
            </div>
          </div>
        </div>
        
        <div class="metric-card">
          <h3>Tendência de Qualidade</h3>
          <canvas id="trendChart"></canvas>
        </div>
      </div>
      
      <div class="actions-panel">
        <button (click)="runValidation()">Executar Validação</button>
        <button (click)="generateReport()">Gerar Relatório</button>
        <button (click)="exportMetrics()">Exportar Métricas</button>
      </div>
    </div>
  `
})
export class ValidationDashboardComponent implements OnInit {
  validationRate: number = 0;
  testCoverage: number = 0;
  activeIssues: any[] = [];
  
  constructor(private validationService: ValidationService) {}
  
  ngOnInit() {
    this.loadMetrics();
    this.initializeCharts();
    this.startRealTimeMonitoring();
  }
  
  private loadMetrics() {
    this.validationService.getMetrics().subscribe(metrics => {
      this.validationRate = metrics.validationRate;
      this.testCoverage = metrics.testCoverage;
      this.activeIssues = metrics.activeIssues;
      this.updateCharts(metrics);
    });
  }
  
  private initializeCharts() {
    // Gráfico de validação
    new Chart('validationChart', {
      type: 'doughnut',
      data: {
        labels: ['Válido', 'Inválido'],
        datasets: [{
          data: [this.validationRate, 100 - this.validationRate],
          backgroundColor: ['#28a745', '#dc3545']
        }]
      }
    });
    
    // Gráfico de tendência
    new Chart('trendChart', {
      type: 'line',
      data: {
        labels: this.getLast7Days(),
        datasets: [{
          label: 'Taxa de Validação',
          data: this.getHistoricalData(),
          borderColor: '#007bff',
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
            max: 100
          }
        }
      }
    });
  }
}
```

## 9. REFERÊNCIAS

1. HL7 International. FHIR Validation. https://hl7.org/fhir/validation.html
2. HL7 International. Testing FHIR. https://hl7.org/fhir/testing.html
3. Inferno Framework. Home. https://inferno.healthit.gov/
4. AEGIS. Touchstone Testing. https://touchstone.aegis.net/
5. HL7 International. TestScript Resource. https://hl7.org/fhir/testscript.html
6. HL7 International. Validation Types. https://hl7.org/fhir/validation.html#types
7. HAPI FHIR. Unit Testing. https://hapifhir.io/hapi-fhir/docs/validation/validation_support_modules.html
8. HL7 International. FHIR Testing - Integration. https://hl7.org/fhir/testing.html#integration
9. IHE International. Test Tools. https://www.ihe.net/testing/testing_tools/
10. ISO/IEC. ISO/IEC 25010:2011. https://www.iso.org/standard/35733.html
11. HAPI FHIR. Validator Documentation. https://hapifhir.io/hapi-fhir/docs/validation/instance_validator.html
12. HL7 International. FHIRPath. https://hl7.org/fhirpath/
13. HL7 International. TestScript Examples. https://hl7.org/fhir/testscript-examples.html
14. GitHub Actions. CI/CD for FHIR. https://github.com/features/actions
15. ISTQB. Test Management. https://www.istqb.org/
16. HL7 International. Terminology Service. https://hl7.org/fhir/terminology-service.html
17. HL7 International. Conformance Testing. https://hl7.org/fhir/conformance-testing.html
18. Inferno Framework. Documentation. https://inferno-framework.github.io/inferno-core/
19. FHIR DevDays. Quality Metrics. https://www.fhirdevdays.com/
20. HL7 International. QA Report. https://hl7.org/fhir/qa.html
21. HL7 International. IG Publisher. https://github.com/HL7/fhir-ig-publisher
22. Martin Fowler. Regression Testing. https://martinfowler.com/bliki/RegressionTestSuite.html
23. SMART Health IT. Dashboard Examples. https://smarthealthit.org/

## 10. ANEXOS

### Anexo A - Checklist de Validação

- [ ] Validação estrutural XML/JSON
- [ ] Validação contra profiles
- [ ] Validação de cardinalidade
- [ ] Validação de tipos de dados
- [ ] Validação de code systems
- [ ] Validação de value sets
- [ ] Validação de invariantes
- [ ] Validação de referências
- [ ] Validação de identificadores
- [ ] Validação de extensões
- [ ] Validação de narrativa
- [ ] Validação de metadados

### Anexo B - Matriz de Severidade

| Severidade | Descrição | Ação Requerida |
|------------|-----------|----------------|
| Fatal | Erro que impede processamento | Correção imediata |
| Error | Não conformidade com especificação | Correção antes de publicação |
| Warning | Possível problema ou melhoria | Avaliar e corrigir se necessário |
| Information | Sugestão ou observação | Considerar para melhorias |

### Anexo C - Comandos Úteis

```bash
# Validar recurso individual
java -jar validator_cli.jar [resource.json] -version 4.0.1

# Validar contra profile específico
java -jar validator_cli.jar [resource.json] -profile [profile-url]

# Validar IG completo
java -jar publisher.jar -ig . -tx https://tx.fhir.org -qa

# Executar testes Inferno
docker run -p 4567:4567 infernoframework/inferno

# Gerar relatório de cobertura
npm run test:coverage
```

---

**Documento aprovado por:** Arquiteto de Interoperabilidade  
**Data de aprovação:** 2024-12-15  
**Próxima revisão:** 2025-06-15  
**Versão:** 1.0.0