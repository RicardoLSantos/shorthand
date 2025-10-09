# SOP: Instalação, Configuração e Manutenção de Servidor HAPI FHIR para Medicina do Estilo de Vida

## Resumo Executivo

Este Standard Operating Procedure (SOP) fornece orientações completas e detalhadas para instalação, configuração e manutenção de servidor HAPI FHIR local (on-premises) especializado em medicina do estilo de vida e dados coletados de dispositivos wearables. O documento abrange desde instalação básica até configurações avançadas de segurança, interoperabilidade e performance.

## 1. Especificações e Pré-requisitos do Sistema

### 1.1 Especificações Oficiais HL7 FHIR
- **Versão FHIR**: R4 (4.0.1) recomendada para produção, R5 (5.0.0) para recursos avançados
- **Java**: JDK 17 ou superior (Java 21 suportado)
- **Memória**: Mínimo 4GB RAM (desenvolvimento), 8GB+ (produção)
- **Armazenamento**: Mínimo 2GB para instalação base

### 1.2 Bancos de Dados Suportados
- **PostgreSQL**: Recomendado com extensão TimescaleDB
- **SQL Server**: Suporte completo para ambientes Microsoft
- **Oracle**: Para ambientes enterprise
- **H2**: Apenas desenvolvimento e testes

## 2. Instalação Completa Passo a Passo

### 2.1 Script de Instalação Automatizada (macOS)

```bash
#!/bin/bash
# HAPI FHIR Setup Script para macOS
set -e

echo "=== Instalação HAPI FHIR Server para Lifestyle Medicine ==="

# Instalar dependências
brew install openjdk@17 postgresql@14 docker maven
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.9/libexec/openjdk.jdk/Contents/Home

# Clonar projeto starter
git clone https://github.com/hapifhir/hapi-fhir-jpaserver-starter.git
cd hapi-fhir-jpaserver-starter

echo "Instalação base concluída. Execute: ./deploy.sh"
```

### 2.2 Configuração Docker Completa

```bash
#!/bin/bash
# Docker deployment com PostgreSQL + TimescaleDB
docker network create fhir-network

# PostgreSQL com TimescaleDB
docker run -d \
  --name fhir-postgres \
  --network fhir-network \
  -e POSTGRES_DB=hapi \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin123 \
  -p 5432:5432 \
  -v fhir-postgres-data:/var/lib/postgresql/data \
  timescale/timescaledb:latest-pg14

# HAPI FHIR Server
docker run -d \
  --name hapi-fhir-server \
  --network fhir-network \
  -p 8080:8080 \
  -e spring.datasource.url=jdbc:postgresql://fhir-postgres:5432/hapi \
  -e spring.datasource.username=admin \
  -e spring.datasource.password=admin123 \
  -e hibernate.dialect=ca.uhn.fhir.jpa.model.dialect.HapiFhirPostgresDialect \
  hapiproject/hapi:latest

echo "Servidor disponível em: http://localhost:8080/fhir/"
```

## 3. Configuração para Medicina do Estilo de Vida

### 3.1 Application.yaml Especializado

```yaml
hapi:
  fhir:
    fhir_version: R4
    default_encoding: json
    subscription:
      resthook_enabled: true
      websocket_enabled: true
    bulk_export_enabled: true
    bulk_import_enabled: true
    custom-interceptor-classes:
      - com.example.interceptors.WearableDataInterceptor
      - com.example.interceptors.LifestyleMedicineInterceptor

spring:
  datasource:
    url: 'jdbc:postgresql://localhost:5432/hapi'
    username: admin
    password: admin123
    driverClassName: org.postgresql.Driver
  jpa:
    properties:
      hibernate.dialect: ca.uhn.fhir.jpa.model.dialect.HapiFhirPostgresDialect

# TimescaleDB para dados de série temporal
timescaledb:
  enabled: true
  chunk_time_interval: 1d
  compression_enabled: true
```

### 3.2 Recursos FHIR para Wearables

#### Device Resource para Smartwatch
```json
{
  "resourceType": "Device",
  "id": "apple-watch-series-8",
  "identifier": [{
    "system": "http://apple.com/watch/serial",
    "value": "MW2A3LL/A-ABC123"
  }],
  "displayName": "Apple Watch Series 8",
  "status": "active",
  "manufacturer": "Apple Inc.",
  "property": [{
    "type": {
      "coding": [{
        "system": "http://snomed.info/sct",
        "code": "182777000",
        "display": "Monitor de frequência cardíaca"
      }]
    }
  }]
}
```

#### Observation para Frequência Cardíaca
```json
{
  "resourceType": "Observation",
  "status": "final",
  "category": [{
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/observation-category",
      "code": "vital-signs"
    }]
  }],
  "code": {
    "coding": [{
      "system": "http://loinc.org",
      "code": "8867-4",
      "display": "Heart rate"
    }]
  },
  "subject": {"reference": "Patient/patient-001"},
  "device": {"reference": "Device/apple-watch-series-8"},
  "effectiveDateTime": "2024-01-15T14:30:00-03:00",
  "valueQuantity": {
    "value": 72,
    "unit": "beats/minute",
    "system": "http://unitsofmeasure.org",
    "code": "/min"
  }
}
```

## 4. Segurança e Compliance (LGPD, GDPR, HIPAA)

### 4.1 Implementação OAuth 2.0

```java
@Component
public class OAuth2AuthorizationInterceptor extends AuthorizationInterceptor {
    
    @Override
    public List<IAuthRule> buildRuleList(RequestDetails theRequestDetails) {
        String authHeader = theRequestDetails.getHeader("Authorization");
        
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return new RuleBuilder().deny("Token inválido").build();
        }

        OAuth2Claims claims = validateToken(authHeader.substring(7));
        
        return new RuleBuilder()
            .allow("Acesso autenticado")
            .read().write()
            .resourcesOfType(Patient.class, Observation.class)
            .inCompartment("Patient", new IdType("Patient/" + claims.getPatientId()))
            .build();
    }
}
```

### 4.2 Configuração LGPD/GDPR

```yaml
security:
  encryption:
    algorithm: "AES-256-GCM"
    key_rotation_days: 90
  tls:
    version: "1.3"
  headers:
    strict_transport_security: "max-age=31536000; includeSubDomains; preload"
    content_security_policy: "default-src 'none'; frame-ancestors 'none'"

audit:
  log_format: "FHIR_AUDIT"
  retention_days: 2555  # 7 anos HIPAA
  encryption_enabled: true
```

## 5. Mapeamento de Terminologias

### 5.1 LOINC Codes para Wearables

```yaml
terminologies:
  vital_signs:
    heart_rate: "8867-4"
    blood_pressure_systolic: "8480-6"
    oxygen_saturation: "2708-6"
    heart_rate_variability: "80404-7"
  physical_activity:
    step_count_24h: "41950-7"
    moderate_physical_activity: "77592-4"
  sleep:
    sleep_duration: "93832-4"
    sleep_efficiency: "93831-6"
  nutrition:
    caloric_intake: "33747-0"
    water_intake: "73985-4"
```

### 5.2 SNOMED-CT Mappings

```yaml
snomed_ct_mappings:
  physical_activity:
    walking: "129006008"
    running: "418060005"
    cycling: "70582002"
  sleep_patterns:
    sleep_duration: "248263006"
    sleep_quality: "248262001"
  stress_management:
    meditation: "276239002"
    stress_reduction: "385893007"
```

## 6. Integração com Padrões de Interoperabilidade

### 6.1 openEHR Integration

```yaml
openehr:
  integration:
    enabled: true
    repository_url: "https://openehr.example.com/ehrbase/rest/openehr/v1"
  transformations:
    - source: "openEHR.Composition"
      target: "FHIR.Bundle"
      mapping_file: "/config/openehr-to-fhir-mappings.yaml"
```

### 6.2 OMOP CDM Mapping

```sql
-- View para integração OMOP
CREATE VIEW fhir_patient_omop AS
SELECT 
  p.person_id,
  CONCAT('{
    "resourceType": "Patient",
    "id": "', p.person_id, '",
    "gender": "', 
    CASE p.gender_concept_id 
      WHEN 8507 THEN 'male'
      WHEN 8532 THEN 'female'
      ELSE 'unknown'
    END, '"
  }') as fhir_resource
FROM person p;
```

## 7. Performance Tuning e Otimização

### 7.1 Configuração TimescaleDB

```sql
-- Hypertable para dados de wearables
CREATE TABLE wearable_observations (
    time TIMESTAMPTZ NOT NULL,
    patient_id TEXT NOT NULL,
    device_id TEXT NOT NULL,
    measurement_type TEXT NOT NULL,
    value_numeric DOUBLE PRECISION,
    unit TEXT,
    PRIMARY KEY (time, patient_id, device_id, measurement_type)
);

SELECT create_hypertable('wearable_observations', 'time');

-- Índices otimizados
CREATE INDEX idx_wearable_patient_time ON wearable_observations (patient_id, time DESC);
CREATE INDEX idx_wearable_measurement_type ON wearable_observations (measurement_type, time DESC);

-- Compressão automática
ALTER TABLE wearable_observations SET (
    timescaledb.compress,
    timescaledb.compress_orderby = 'time DESC',
    timescaledb.compress_segmentby = 'patient_id, device_id'
);

SELECT add_compression_policy('wearable_observations', INTERVAL '7 days');
```

### 7.2 Otimização HAPI FHIR

```yaml
hapi:
  fhir:
    reuse_cached_search_results_millis: 600000
    search_coordination_enabled: true
    default_page_size: 50
    max_page_size: 500

spring:
  datasource:
    hikari:
      maximum-pool-size: 50
      minimum-idle: 10
      connection-timeout: 20000
```

## 8. Monitoramento com Prometheus + Grafana

### 8.1 Docker Compose Monitoramento

```yaml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123

  hapi-fhir:
    image: hapiproject/hapi:latest
    ports:
      - "8080:8080"
    environment:
      - management.endpoints.web.exposure.include=health,info,metrics,prometheus
```

### 8.2 Dashboard Grafana

```json
{
  "dashboard": {
    "title": "FHIR Lifestyle Medicine Analytics",
    "panels": [
      {
        "title": "Wearable Data Ingestion Rate",
        "targets": [{
          "expr": "rate(fhir_observations_created_total{category=\"vital-signs\"}[5m])",
          "legendFormat": "Vital Signs/sec"
        }]
      }
    ]
  }
}
```

## 9. Backup e Recuperação

### 9.1 Script de Backup Automatizado

```bash
#!/bin/bash
BACKUP_DIR="/backup/fhir-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup da base FHIR
pg_dump -h localhost -U admin -d hapi \
    --format=custom --compress=9 \
    --file="$BACKUP_DIR/fhir-database.backup"

# Backup dados wearables
pg_dump -h localhost -U admin -d hapi \
    --table=wearable_observations \
    --format=custom --compress=9 \
    --file="$BACKUP_DIR/wearable-data.backup"

# Compactar e enviar para armazenamento
tar -czf "$BACKUP_DIR.tar.gz" -C "$(dirname $BACKUP_DIR)" "$(basename $BACKUP_DIR)"
aws s3 cp "$BACKUP_DIR.tar.gz" s3://fhir-backups/
```

## 10. APIs RESTful Customizadas

### 10.1 Endpoint para Lifestyle Medicine

```java
@RestController
@RequestMapping("/fhir")
public class LifestyleMedicineController {

    @GetMapping("/Observation")
    public Bundle getLifestyleObservations(
            @RequestParam("subject") String patientId,
            @RequestParam("category") String category,
            @RequestParam(value = "_count", defaultValue = "20") int count) {
        
        SearchParameterMap params = new SearchParameterMap();
        params.add("subject", new ReferenceParam(patientId));
        params.add("category", new TokenParam(
            "http://terminology.hl7.org/CodeSystem/observation-category", 
            category));
        params.setCount(count);
        
        return (Bundle) observationDao.search(params).getResources(0, count).get(0);
    }

    @PostMapping("/Observation/$bulk-import")
    public OperationOutcome bulkImportWearableData(@RequestBody Parameters parameters) {
        List<Observation> observations = parseWearableData(parameters);
        
        for (Observation obs : observations) {
            validateLifestyleObservation(obs);
            observationDao.create(obs);
        }
        
        return createSuccessOutcome("Imported " + observations.size() + " observations");
    }
}
```

## 11. Integração com Wearables

### 11.1 Conector Apple HealthKit (Swift)

```swift
import HealthKit

class HealthKitFHIRConnector {
    private let healthStore = HKHealthStore()
    private let fhirEndpoint = "http://localhost:8080/fhir"
    
    func syncHeartRateData() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { _, samples, error in
            
            guard let sample = samples?.first as? HKQuantitySample else { return }
            
            let fhirObservation = self.createFHIRHeartRateObservation(from: sample)
            self.sendToFHIRServer(observation: fhirObservation)
        }
        
        healthStore.execute(query)
    }
}
```

### 11.2 Conector Google Fit (JavaScript)

```javascript
class GoogleFitFHIRSync {
    constructor(credentials, fhirEndpoint) {
        this.auth = new google.auth.GoogleAuth({
            credentials: credentials,
            scopes: ['https://www.googleapis.com/auth/fitness.activity.read']
        });
        this.fhirEndpoint = fhirEndpoint;
    }

    async syncStepCountData(patientId, startTime, endTime) {
        const request = {
            userId: 'me',
            requestBody: {
                aggregateBy: [{
                    dataTypeName: 'com.google.step_count.delta'
                }],
                bucketByTime: { durationMillis: 86400000 },
                startTimeMillis: startTime,
                endTimeMillis: endTime
            }
        };

        const response = await this.fitness.users.dataset.aggregate(request);
        // Processar e enviar dados para FHIR
    }
}
```

## 12. Conceitos de Descentralização

### 12.1 Integração Radicle

```bash
#!/bin/bash
# Setup Radicle para configs FHIR
cd /opt/fhir-configs
rad init --name "fhir-lifestyle-configs"
git add application.yaml terminologies/ scripts/
git commit -m "Initial FHIR configuration"
rad push
```

### 12.2 Blockchain para Proveniência

```yaml
blockchain:
  provenance:
    enabled: true
    network: "hyperledger-fabric"
  fhir_chain:
    smart_contracts:
      - name: "PatientConsent"
      - name: "DataProvenance"
  did_integration:
    enabled: true
    resolver: "https://did.example.com/resolver"
```

## 13. Testes Automatizados

### 13.1 Suite de Testes

```bash
#!/bin/bash
FHIR_BASE="http://localhost:8080/fhir"

# Teste metadata
test_metadata() {
    response=$(curl -s -w "%{http_code}" "$FHIR_BASE/metadata")
    if [[ "${response: -3}" == "200" ]]; then
        echo "✅ Metadata: OK"
    else
        echo "❌ Metadata: FALHOU"
    fi
}

# Teste CRUD operations
test_crud_operations() {
    patient_data='{
        "resourceType": "Patient",
        "name": [{"family": "Silva", "given": ["João"]}],
        "gender": "male"
    }'
    
    create_response=$(curl -s -w "%{http_code}" -X POST \
        -H "Content-Type: application/fhir+json" \
        -d "$patient_data" \
        "$FHIR_BASE/Patient")
    
    if [[ "${create_response: -3}" == "201" ]]; then
        echo "✅ CREATE: OK"
    fi
}

# Executar todos os testes
test_metadata
test_crud_operations
```

## 14. Scripts de Automação macOS

### 14.1 Deploy Automatizado

```bash
#!/bin/bash
set -euo pipefail

ENVIRONMENT="${1:-development}"
VERSION="${2:-latest}"

echo "🚀 Deploy FHIR - Ambiente: $ENVIRONMENT, Versão: $VERSION"

# Verificações pré-deployment
if ! pg_isready -h localhost -p 5432; then
    echo "❌ PostgreSQL indisponível"
    exit 1
fi

# Backup pré-deployment
BACKUP_NAME="pre-deployment-$(date +%Y%m%d-%H%M%S)"
./scripts/backup.sh "$BACKUP_NAME"

# Blue-green deployment
kubectl apply -f k8s/deployment-$VERSION.yaml
kubectl wait --for=condition=available --timeout=300s deployment/fhir-$VERSION

echo "🎉 Deployment concluído!"
```

### 14.2 Atualização de Repositórios

```bash
#!/bin/bash
COMMIT_MESSAGE="${1:-Automated update}"

# GitHub
git add .
git commit -m "$COMMIT_MESSAGE"
git push origin main

# Radicle
rad push
rad issue open --title "Configuration Update" \
    --description "Configurações atualizadas: $COMMIT_MESSAGE"
```

## 15. Troubleshooting e Manutenção

### 15.1 Diagnóstico Completo

```bash
#!/bin/bash
echo "🔍 Diagnóstico sistema FHIR..."

# Status serviços
systemctl is-active postgresql && echo "✅ PostgreSQL: Ativo"
docker ps | grep -q hapi-fhir && echo "✅ HAPI FHIR: Ativo"

# Conectividade
curl -s -I http://localhost:8080/fhir/metadata | head -1
pg_isready -h localhost -p 5432 && echo "✅ PostgreSQL: Conectável"

# Recursos sistema
echo "💾 Memória: $(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}')"
echo "💽 Disco: $(df -h / | awk 'NR==2{print $5}')"

# Logs de erro
docker logs hapi-fhir-server 2>&1 | grep -i error | tail -5
```

### 15.2 Comandos de Manutenção

```bash
#!/bin/bash
# Menu interativo de manutenção

clear_cache() {
    docker exec hapi-fhir-server curl -X DELETE http://localhost:8080/fhir/\$meta
}

reindex_resources() {
    docker exec hapi-fhir-server curl -X POST \
        http://localhost:8080/fhir/\$reindex \
        -H "Content-Type: application/fhir+json" \
        -d '{"resourceType":"Parameters","parameter":[{"name":"everything","valueBoolean":true}]}'
}

compress_timescale_data() {
    psql -h localhost -U admin -d hapi -c \
        "CALL run_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name = 'policy_compression'));"
}

# Menu
while true; do
    echo "🔧 Menu Manutenção FHIR"
    echo "1) Limpar Cache"
    echo "2) Reindexar Recursos"
    echo "3) Compactar Dados TimescaleDB"
    echo "4) Sair"
    
    read -p "Opção: " choice
    case $choice in
        1) clear_cache ;;
        2) reindex_resources ;;
        3) compress_timescale_data ;;
        4) break ;;
    esac
done
```

## 16. Checklist de Implementação

```markdown
### Preparação do Ambiente
- [ ] Instalar Java JDK 17+
- [ ] Configurar PostgreSQL + TimescaleDB
- [ ] Setup Docker/Docker Compose
- [ ] Configurar certificados SSL/TLS

### Instalação Base
- [ ] Baixar HAPI FHIR JPA Server Starter
- [ ] Configurar application.yaml
- [ ] Setup banco PostgreSQL
- [ ] Testar instalação básica

### Segurança
- [ ] Implementar OAuth 2.0
- [ ] Configurar SMART on FHIR
- [ ] Setup audit logging
- [ ] Implementar gestão consentimento LGPD

### Wearables
- [ ] Configurar Device resources
- [ ] Implementar Observation profiles
- [ ] Setup conectores HealthKit/Google Fit
- [ ] Configurar mapeamento terminológico

### Monitoramento
- [ ] Instalar Prometheus/Grafana
- [ ] Configurar dashboards
- [ ] Setup alertas críticos
- [ ] Health checks

### Performance
- [ ] Configurar TimescaleDB hypertables
- [ ] Otimizar índices PostgreSQL
- [ ] Setup cache strategies
- [ ] Connection pooling

### Backup/Recovery
- [ ] Backup automatizado
- [ ] Testar recuperação
- [ ] Replicação (se necessário)
- [ ] Disaster recovery

### Testes
- [ ] Suite testes automatizados
- [ ] Validar profiles FHIR
- [ ] Testar integração wearables
- [ ] Testes de carga


## Conclusão

Este SOP fornece um guia completo para implementação de servidor HAPI FHIR especializado em medicina do estilo de vida e dados de wearables. A implementação bem-sucedida requer:

- **Planejamento cuidadoso** da arquitetura e infraestrutura
- **Atenção rigorosa** aos requisitos de segurança e compliance
- **Implementação gradual** com testes contínuos
- **Monitoramento proativo** e manutenção preventiva
- **Documentação completa** de todos os procedimentos

O resultado é uma plataforma robusta, segura e escalável que suporta a coleta, armazenamento e análise de dados de saúde provenientes de dispositivos wearables, totalmente compatível com padrões FHIR e regulamentações de privacidade aplicáveis.


## 16. Referências e Links

### Referências Oficiais HL7 FHIR

1. **HL7 FHIR Specification R4**: https://hl7.org/fhir/R4/
2. **HL7 FHIR R5 (Current Build)**: https://hl7.org/fhir/R5/
3. **FHIR Implementation Guide Registry**: https://registry.fhir.org/
4. **SMART on FHIR Documentation**: https://docs.smarthealthit.org/
5. **HL7 FHIR Security**: https://hl7.org/fhir/security.html

### Documentação HAPI FHIR

6. **HAPI FHIR Documentation**: https://hapifhir.io/hapi-fhir/docs/
7. **HAPI JPA Server Starter**: https://github.com/hapifhir/hapi-fhir-jpaserver-starter
8. **HAPI FHIR Examples**: https://github.com/hapifhir/hapi-fhir/tree/master/hapi-fhir-structures-r4/
9. **HAPI FHIR Test Server**: https://hapi.fhir.org/
10. **HAPI FHIR Community**: https://chat.fhir.org/#narrow/stream/179166-hapi

### Segurança e Conformidade

11. **OAuth 2.0 Security Best Practices**: https://datatracker.ietf.org/doc/html/draft-ietf-oauth-security-topics
12. **Keycloak Documentation**: https://www.keycloak.org/documentation
13. **LGPD - Lei Geral de Proteção de Dados**: http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709.htm
14. **GDPR Compliance**: https://gdpr.eu/
15. **HIPAA Security Rule**: https://www.hhs.gov/hipaa/for-professionals/security/index.html

### Bancos de Dados e Performance

16. **PostgreSQL Documentation**: https://www.postgresql.org/docs/14/
17. **TimescaleDB Documentation**: https://docs.timescale.com/
18. **Redis Documentation**: https://redis.io/documentation
19. **PostgreSQL Performance Tuning**: https://wiki.postgresql.org/wiki/Performance_Optimization
20. **Connection Pool Sizing**: https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing

### Integrações com Wearables

21. **Apple HealthKit**: https://developer.apple.com/documentation/healthkit
22. **Google Fit REST API**: https://developers.google.com/fit/rest
23. **Fitbit Web API**: https://dev.fitbit.com/build/reference/web-api/
24. **Samsung Health SDK**: https://developer.samsung.com/health
25. **Garmin Connect IQ**: https://developer.garmin.com/connect-iq/

### Terminologias e Vocabulários

26. **LOINC**: https://loinc.org/
27. **SNOMED CT Browser**: https://browser.ihtsdotools.org/
28. **ICD-10**: https://www.who.int/standards/classifications/classification-of-diseases
29. **UCUM Units of Measure**: https://unitsofmeasure.org/ucum.html
30. **RxNorm**: https://www.nlm.nih.gov/research/umls/rxnorm/

### Monitoramento e Observabilidade

31. **Prometheus Documentation**: https://prometheus.io/docs/
32. **Grafana Documentation**: https://grafana.com/docs/
33. **Elastic APM**: https://www.elastic.co/guide/en/apm/
34. **OpenTelemetry**: https://opentelemetry.io/docs/
35. **FHIR Monitoring Best Practices**: https://confluence.hl7.org/display/FHIR/Monitoring+FHIR+Servers

### Descentralização e Blockchain

36. **Radicle Documentation**: https://docs.radicle.xyz/
37. **Hyperledger Fabric**: https://hyperledger-fabric.readthedocs.io/
38. **IPFS Documentation**: https://docs.ipfs.io/
39. **DID Specification**: https://www.w3.org/TR/did-core/
40. **Blockchain in Healthcare**: https://www.himss.org/resources/blockchain-healthcare

### Ferramentas de Desenvolvimento e Teste

41. **Postman FHIR Collection**: https://www.postman.com/api-evangelist/workspace/fhir/
42. **FHIR Validator**: https://validator.fhir.org/
43. **Synthea Patient Generator**: https://github.com/synthetichealth/synthea
44. **HAPI FHIR CLI**: https://hapifhir.io/hapi-fhir/docs/tools/hapi_fhir_cli.html
45. **FHIR Testing Tools**: https://confluence.hl7.org/display/FHIR/FHIR+Testing+Tools

### Comunidade e Suporte

46. **HL7 FHIR Chat**: https://chat.fhir.org/
47. **FHIR Community Forum**: https://community.fhir.org/
48. **Stack Overflow FHIR Tag**: https://stackoverflow.com/questions/tagged/hl7-fhir
49. **Reddit r/FHIR**: https://www.reddit.com/r/fhir/
50. **FHIR DevDays**: https://www.devdays.com/


## REFERÊNCIAS

1. HAPI FHIR Documentation. Server Types and Architecture. 2024. https://hapifhir.io/hapi-fhir/docs/server_plain/introduction.html

2. HL7 International. FHIR Security. 2024. http://hl7.org/fhir/R5/security.html

3. HL7 International. FHIR Exchange Module. 2024. http://hl7.org/fhir/R5/exchange-module.html

4. HAPI FHIR. Performance Tuning. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/performance.html

5. HL7 International. FHIR R4. 2019. http://hl7.org/fhir/R4/

6. HL7 International. FHIR R5. 2024. http://hl7.org/fhir/R5/

7. Oracle. Java SE 17 Documentation. 2024. https://docs.oracle.com/en/java/javase/17/

8. HAPI FHIR. System Requirements. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/get_started.html

9. HAPI FHIR. Installation Guide. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/installation.html

10. TimescaleDB. Documentation. 2024. https://docs.timescale.com/

11. Microsoft. SQL Server JDBC Driver. 2024. https://docs.microsoft.com/en-us/sql/connect/jdbc/

12. Oracle. Database JDBC Developer's Guide. 2024. https://docs.oracle.com/en/database/oracle/oracle-database/21/jjdbc/

13. H2 Database. Documentation. 2024. http://www.h2database.com/html/main.html

14. Homebrew. Package Manager for macOS. 2024. https://brew.sh/

15. GitHub. HAPI FHIR JPA Server Starter. 2024. https://github.com/hapifhir/hapi-fhir-jpaserver-starter

16. Docker. Documentation. 2024. https://docs.docker.com/

17. TimescaleDB. Docker Image. 2024. https://hub.docker.com/r/timescale/timescaledb

18. HAPI Project. Docker Image. 2024. https://hub.docker.com/r/hapiproject/hapi

19. HL7 International. FHIR R4 Specification. 2019. http://hl7.org/fhir/R4/

20. HAPI FHIR. Subscriptions. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/subscription.html

21. HAPI FHIR. WebSocket Subscriptions. 2024. https://hapifhir.io/hapi-fhir/docs/server_plain/websocket_subscriptions.html

22. HL7 International. Bulk Data Access. 2024. http://hl7.org/fhir/uv/bulkdata/

23. PostgreSQL. Connection Strings. 2024. https://www.postgresql.org/docs/current/libpq-connect.html

24. HAPI FHIR. Database Configuration. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/database_support.html

25. TimescaleDB. Hypertables. 2024. https://docs.timescale.com/use-timescaledb/latest/hypertables/

26. HL7 International. Device Resource. 2024. http://hl7.org/fhir/R4/device.html

27. HL7 International. Observation Resource. 2024. http://hl7.org/fhir/R4/observation.html

28. RFC 6749. OAuth 2.0 Authorization Framework. 2012. https://datatracker.ietf.org/doc/html/rfc6749

29. HL7 International. SMART on FHIR. 2024. http://hl7.org/fhir/smart-app-launch/

30. NIST. AES Specification. 2001. https://csrc.nist.gov/publications/detail/fips/197/final

31. OWASP. Key Management Cheat Sheet. 2024. https://cheatsheetseries.owasp.org/cheatsheets/Key_Management_Cheat_Sheet.html

32. RFC 8446. TLS 1.3. 2018. https://datatracker.ietf.org/doc/html/rfc8446

33. RFC 6797. HTTP Strict Transport Security. 2012. https://datatracker.ietf.org/doc/html/rfc6797

34. W3C. Content Security Policy. 2024. https://www.w3.org/TR/CSP3/

35. HL7 International. Audit Logging. 2024. http://hl7.org/fhir/R4/security.html#audit

36. HIPAA. Administrative Safeguards. 45 CFR 164.312(b). https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/

37. LOINC 8867-4. Heart rate. 2024. https://loinc.org/8867-4/

38. LOINC 8480-6. Systolic blood pressure. 2024. https://loinc.org/8480-6/

39. LOINC 2708-6. Oxygen saturation. 2024. https://loinc.org/2708-6/

40. LOINC 80404-7. Heart rate variability. 2024. https://loinc.org/80404-7/

41. LOINC 41950-7. 24 hour step count. 2024. https://loinc.org/41950-7/

42. LOINC 77592-4. Moderate physical activity. 2024. https://loinc.org/77592-4/

43. LOINC 93832-4. Sleep duration. 2024. https://loinc.org/93832-4/

44. LOINC 93831-6. Sleep efficiency. 2024. https://loinc.org/93831-6/

45. LOINC 33747-0. Caloric intake. 2024. https://loinc.org/33747-0/

46. LOINC 73985-4. Water intake. 2024. https://loinc.org/73985-4/

47. SNOMED CT 129006008. Walking. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=129006008

48. SNOMED CT 418060005. Running. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=418060005

49. SNOMED CT 70582002. Cycling. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=70582002

50. SNOMED CT 248263006. Sleep duration. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=248263006

51. SNOMED CT 248262001. Sleep quality. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=248262001

52. SNOMED CT 276239002. Meditation. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=276239002

53. SNOMED CT 385893007. Stress reduction. 2024. https://browser.ihtsdotools.org/?perspective=full&conceptId1=385893007

54. openEHR Foundation. REST API Specification. 2024. https://specifications.openehr.org/releases/ITS-REST/latest/

55. openEHR Foundation. FHIR Integration. 2024. https://specifications.openehr.org/releases/ITS-FHIR/latest/

56. OHDSI Collaborative. OMOP CDM. 2024. https://ohdsi.github.io/CommonDataModel/

57. IHE. Mobile Health Documents. 2024. https://profiles.ihe.net/ITI/MHD/

58. IHE. Patient Identifier Cross-Reference. 2024. https://profiles.ihe.net/ITI/PIXm/

59. IHE. Patient Demographics Query. 2024. https://profiles.ihe.net/ITI/PDQm/

60. IHE. Cross-Community Access. 2024. https://profiles.ihe.net/ITI/XCA/

61. HAPI FHIR. Search Coordination. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/search.html

62. HAPI FHIR. Pagination. 2024. https://hapifhir.io/hapi-fhir/docs/server_plain/paging.html

63. HAPI FHIR. Search Parameters. 2024. https://hapifhir.io/hapi-fhir/docs/server_plain/search.html

64. HikariCP. Configuration. 2024. https://github.com/brettwooldridge/HikariCP

65. HikariCP. Pool Sizing. 2024. https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing

66. HikariCP. Timeouts. 2024. https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby

67. Prometheus. Documentation. 2024. https://prometheus.io/docs/

68. Grafana Labs. Documentation. 2024. https://grafana.com/docs/

69. HAPI FHIR. Docker Deployment. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/deploying_via_docker.html

70. Spring Boot. Actuator Endpoints. 2024. https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html

71. Grafana. Dashboard JSON Model. 2024. https://grafana.com/docs/grafana/latest/dashboards/json-model/

72. PostgreSQL. pg_dump Documentation. 2024. https://www.postgresql.org/docs/current/app-pgdump.html

73. PostgreSQL. Backup Strategies. 2024. https://www.postgresql.org/docs/current/backup.html

74. TimescaleDB. Backup and Recovery. 2024. https://docs.timescale.com/self-hosted/latest/backup-and-restore/

75. AWS S3. CLI Documentation. 2024. https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3.html

76. HAPI FHIR. Search Operations. 2024. https://hapifhir.io/hapi-fhir/docs/server_plain/rest_operations_search.html

77. HAPI FHIR. Custom Operations. 2024. https://hapifhir.io/hapi-fhir/docs/server_plain/rest_operations_operations.html

78. Apple Developer. HealthKit. 2024. https://developer.apple.com/documentation/healthkit

79. Apple Developer. HKQuantityType. 2024. https://developer.apple.com/documentation/healthkit/hkquantitytype

80. Google Developers. Google Fit API. 2024. https://developers.google.com/fit

81. Google Fit. Data Types. 2024. https://developers.google.com/fit/datatypes

82. Radicle. Documentation. 2024. https://radicle.xyz/docs

83. Hyperledger. Fabric Documentation. 2024. https://hyperledger-fabric.readthedocs.io/

84. Hyperledger. Network Setup. 2024. https://hyperledger-fabric.readthedocs.io/en/latest/network/network.html

85. Hyperledger. Smart Contracts. 2024. https://hyperledger-fabric.readthedocs.io/en/latest/smartcontract/smartcontract.html

86. Hyperledger. Private Data. 2024. https://hyperledger-fabric.readthedocs.io/en/latest/private-data/private-data.html

87. W3C. DID Core Specification. 2022. https://www.w3.org/TR/did-core/

88. HL7 International. TestScript Resource. 2024. http://hl7.org/fhir/R4/testscript.html

89. curl Documentation. 2024. https://curl.se/docs/

90. FHIR CRUD Operations. 2024. http://hl7.org/fhir/R4/http.html#create

91. Kubernetes. Deployment Strategies. 2024. https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

92. Backup Best Practices. PostgreSQL. 2024. https://www.postgresql.org/docs/current/backup.html

93. Blue-Green Deployment. Martin Fowler. 2010. https://martinfowler.com/bliki/BlueGreenDeployment.html

94. GitHub. Git Documentation. 2024. https://docs.github.com/

95. Radicle. Protocol Guide. 2024. https://radicle.xyz/guides/protocol

96. Linux. System Administration. 2024. https://www.kernel.org/doc/

97. Network Diagnostics. curl. 2024. https://everything.curl.dev/

98. Linux Performance Monitoring. 2024. https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html

99. Docker. Logging. 2024. https://docs.docker.com/config/containers/logging/

100. HAPI FHIR. Maintenance Operations. 2024. https://hapifhir.io/hapi-fhir/docs/server_jpa/upgrading.html


---
**Documento aprovado por:** [Gerência de Infraestrutura e Interoperabilidade]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026  
**Versão:** 1.0.0  
**Status:** Completo

```