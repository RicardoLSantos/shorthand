# SOP-007: Normas SBIS para Software em Saúde
**Standard Operating Procedure para Certificação e Validação segundo a Sociedade Brasileira de Informática em Saúde**

## 1. INTRODUÇÃO

### 1.1 Objetivo
Estabelecer procedimentos para desenvolvimento, validação e certificação de softwares de saúde conforme normas da SBIS (Sociedade Brasileira de Informática em Saúde) e sua integração com Implementation Guides FHIR.

### 1.2 Escopo
Aplicável a sistemas de Registro Eletrônico de Saúde (RES/PEP), softwares assistenciais, e soluções de interoperabilidade no contexto brasileiro.

### 1.3 Referências Fundamentais
- Manual de Certificação SBIS-CFM 2022¹: https://www.sbis.org.br/certificacao
- NGS 1 - Requisitos Obrigatórios²: https://www.sbis.org.br/ngs1
- NGS 2 - Requisitos de Segurança³: https://www.sbis.org.br/ngs2
- NGS 3 - Requisitos de Conteúdo⁴: https://www.sbis.org.br/ngs3
- Portaria GM/MS nº 3.232/2022⁵: Programa ConecteSUS

## 2. PROCESSO DE CERTIFICAÇÃO SBIS-CFM

### 2.1 Níveis de Certificação⁶

```yaml
certificacao_sbis:
  niveis:
    NGS1:
      nome: "Nível de Garantia de Segurança 1"
      requisitos:
        - "Autenticação e controle de acesso"
        - "Auditoria e rastreabilidade"
        - "Disponibilidade e integridade"
        - "Privacidade e confidencialidade"
        - "Autenticidade de documentos"
        - "Backup e recuperação"
      
    NGS2:
      nome: "Nível de Garantia de Segurança 2"
      base: NGS1
      adicional:
        - "Certificação digital ICP-Brasil"
        - "Carimbo de tempo"
        - "Assinatura digital qualificada"
        - "Criptografia avançada"
        
    NGS3:
      nome: "Nível de Garantia de Segurança 3"
      base: NGS2
      adicional:
        - "Requisitos de interoperabilidade"
        - "Conformidade com padrões nacionais"
        - "Integração com RNDS"
```

### 2.2 Requisitos Obrigatórios NGS1⁷

#### 2.2.1 Estrutura e Conteúdo (EC)
```fsh
// Profile FHIR para conformidade SBIS
Profile: SBISCompliantPatient
Parent: Patient
Id: sbis-patient
Title: "Paciente Conforme SBIS"
Description: "Perfil de paciente conforme requisitos SBIS-CFM"

// EC.01 - Identificação inequívoca do paciente
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier contains
    cpf 1..1 MS and
    cns 0..1 MS and
    rg 0..1 MS

* identifier[cpf].system = "http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf"
* identifier[cpf].value 1..1
* identifier[cpf].value obeys cpf-valid

* identifier[cns].system = "http://rnds.saude.gov.br/fhir/r4/NamingSystem/cns"
* identifier[cns].value 1..1

// EC.02 - Dados demográficos completos
* name 1..* MS
* name.use 1..1
* name.family 1..1 MS
* name.given 1..* MS

* birthDate 1..1 MS
* gender 1..1 MS

// EC.03 - Endereço estruturado
* address 1..* MS
* address.use 1..1
* address.type 1..1
* address.line 1..* MS
* address.city 1..1 MS
* address.state 1..1 MS
* address.postalCode 1..1 MS
* address.country = "BR"

// EC.04 - Contato
* telecom 1..* MS
* telecom.system 1..1
* telecom.value 1..1
* telecom.use 1..1

// Invariantes
Invariant: cpf-valid
Description: "CPF deve ser válido segundo algoritmo oficial"
Expression: "value.matches('^[0-9]{11}$') and validateCPF(value)"
Severity: #error
```

#### 2.2.2 Segurança (S)
```javascript
// Implementação de requisitos de segurança SBIS
class SBISSecurityManager {
    constructor() {
        this.auditLogger = new AuditLogger();
        this.accessControl = new AccessControl();
        this.cryptoService = new CryptoService();
    }
    
    // S.01 - Controle de acesso por perfis
    async authenticateUser(credentials) {
        const user = await this.validateCredentials(credentials);
        
        if (!user) {
            await this.auditLogger.log({
                event: 'LOGIN_FAILED',
                timestamp: new Date(),
                details: { username: credentials.username }
            });
            throw new Error('Autenticação falhou');
        }
        
        // S.02 - Timeout de sessão
        const session = {
            userId: user.id,
            profile: user.profile,
            permissions: await this.getPermissions(user.profile),
            createdAt: new Date(),
            expiresAt: new Date(Date.now() + 30 * 60 * 1000), // 30 minutos
            token: this.generateSecureToken()
        };
        
        // S.03 - Registro de auditoria
        await this.auditLogger.log({
            event: 'LOGIN_SUCCESS',
            userId: user.id,
            timestamp: new Date(),
            ipAddress: credentials.ipAddress,
            userAgent: credentials.userAgent
        });
        
        return session;
    }
    
    // S.04 - Controle de acesso a dados
    async authorizeDataAccess(userId, resourceType, resourceId, action) {
        const user = await this.getUser(userId);
        const permissions = await this.getPermissions(user.profile);
        
        // Verificar permissões baseadas em perfil
        const hasPermission = this.checkPermission(
            permissions,
            resourceType,
            action
        );
        
        if (!hasPermission) {
            await this.auditLogger.log({
                event: 'ACCESS_DENIED',
                userId: userId,
                resource: `${resourceType}/${resourceId}`,
                action: action,
                timestamp: new Date()
            });
            return false;
        }
        
        // S.05 - Verificar relação terapêutica
        if (resourceType === 'Patient') {
            const hasRelationship = await this.checkTherapeuticRelationship(
                userId,
                resourceId
            );
            
            if (!hasRelationship) {
                await this.auditLogger.log({
                    event: 'NO_THERAPEUTIC_RELATIONSHIP',
                    userId: userId,
                    patientId: resourceId,
                    timestamp: new Date()
                });
                return false;
            }
        }
        
        return true;
    }
    
    // S.06 - Criptografia de dados sensíveis
    encryptSensitiveData(data) {
        return this.cryptoService.encrypt(data, {
            algorithm: 'AES-256-GCM',
            keyDerivation: 'PBKDF2',
            iterations: 100000
        });
    }
    
    // S.07 - Backup seguro
    async createSecureBackup() {
        const backupData = await this.gatherBackupData();
        const encrypted = this.encryptSensitiveData(backupData);
        const hash = this.cryptoService.hash(encrypted);
        
        const backup = {
            data: encrypted,
            hash: hash,
            timestamp: new Date(),
            version: '1.0'
        };
        
        // Armazenar em local seguro
        await this.storeBackup(backup);
        
        // Registrar em auditoria
        await this.auditLogger.log({
            event: 'BACKUP_CREATED',
            timestamp: backup.timestamp,
            hash: hash
        });
        
        return backup;
    }
}
```

### 2.3 Requisitos NGS2 - Certificação Digital⁸

```javascript
// Implementação de assinatura digital ICP-Brasil
class ICPBrasilSigner {
    constructor() {
        this.certificateStore = new CertificateStore();
    }
    
    // NGS2.01 - Assinatura digital com certificado ICP-Brasil
    async signDocument(document, certificate) {
        // Validar certificado ICP-Brasil
        const isValid = await this.validateICPBrasilCert(certificate);
        if (!isValid) {
            throw new Error('Certificado ICP-Brasil inválido');
        }
        
        // Criar hash do documento
        const documentHash = crypto
            .createHash('sha256')
            .update(JSON.stringify(document))
            .digest();
        
        // Assinar com chave privada
        const signature = crypto.sign(
            'sha256',
            documentHash,
            certificate.privateKey
        );
        
        // NGS2.02 - Adicionar carimbo de tempo
        const timestamp = await this.getTimestamp(documentHash);
        
        // Criar envelope de assinatura
        const signedDocument = {
            document: document,
            signature: {
                algorithm: 'RSA-SHA256',
                value: signature.toString('base64'),
                certificate: certificate.publicKey,
                timestamp: timestamp,
                signerInfo: {
                    name: certificate.subject.CN,
                    cpf: certificate.subject.serialNumber,
                    role: certificate.subject.OU
                }
            }
        };
        
        // NGS2.03 - Armazenar assinatura
        await this.storeSignature(signedDocument);
        
        return signedDocument;
    }
    
    // Validar certificado ICP-Brasil
    async validateICPBrasilCert(certificate) {
        // Verificar cadeia de certificação
        const chain = await this.getCertificateChain(certificate);
        
        // Verificar AC Raiz ICP-Brasil
        const rootCA = chain[chain.length - 1];
        if (!this.isICPBrasilRoot(rootCA)) {
            return false;
        }
        
        // Verificar validade
        const now = new Date();
        if (now < certificate.validFrom || now > certificate.validTo) {
            return false;
        }
        
        // Verificar revogação (OCSP/CRL)
        const isRevoked = await this.checkRevocation(certificate);
        if (isRevoked) {
            return false;
        }
        
        // Verificar políticas de certificado
        const policies = certificate.certificatePolicies;
        if (!this.hasValidPolicy(policies)) {
            return false;
        }
        
        return true;
    }
    
    // Obter carimbo de tempo
    async getTimestamp(hash) {
        const tsr = {
            version: 1,
            messageImprint: {
                hashAlgorithm: 'SHA256',
                hashedMessage: hash
            },
            reqPolicy: '2.16.76.1.4.2.1.1', // Política ICP-Brasil
            nonce: crypto.randomBytes(8).toString('hex'),
            certReq: true
        };
        
        // Enviar para ACT (Autoridade de Carimbo do Tempo)
        const response = await this.sendToTimestampAuthority(tsr);
        
        return {
            timestamp: response.genTime,
            serialNumber: response.serialNumber,
            tsa: response.tsa,
            signature: response.signature
        };
    }
}
```

### 2.4 Requisitos NGS3 - Interoperabilidade⁹

```fsh
// IG para conformidade SBIS NGS3
ImplementationGuide: SBIS-NGS3-IG
Id: sbis-ngs3-ig
Title: "Guia de Implementação SBIS NGS3"
Status: active
Version: 1.0.0
FhirVersion: 4.0.1

* dependsOn.id = "hl7.fhir.br.core"
* dependsOn.uri = "http://hl7.org/fhir/br/core"
* dependsOn.version = "1.0.0"

* dependsOn.id = "br.gov.saude.rnds"
* dependsOn.uri = "http://rnds.saude.gov.br/fhir"
* dependsOn.version = "1.0.0"

// NGS3.01 - Conformidade com RNDS
* definition.resource[+].reference.reference = "CapabilityStatement/sbis-rnds-capability"
* definition.resource[=].name = "RNDS Capability Statement"
* definition.resource[=].description = "Capacidades para integração com RNDS"

// NGS3.02 - Suporte a terminologias nacionais
* definition.resource[+].reference.reference = "CodeSystem/tuss"
* definition.resource[=].name = "TUSS"
* definition.resource[=].description = "Terminologia Unificada da Saúde Suplementar"

* definition.resource[+].reference.reference = "CodeSystem/cbhpm"
* definition.resource[=].name = "CBHPM"
* definition.resource[=].description = "Classificação Brasileira Hierarquizada de Procedimentos Médicos"

// NGS3.03 - Profiles nacionais
* definition.resource[+].reference.reference = "StructureDefinition/br-patient"
* definition.resource[=].name = "Brazilian Patient"
* definition.resource[=].description = "Perfil brasileiro de paciente"
```

## 3. ESTRUTURA E CONTEÚDO CLÍNICO

### 3.1 Modelo de Informação SBIS¹⁰

```typescript
// Estrutura de dados conforme Manual SBIS
interface ProntuarioEletronico {
    // Identificação
    paciente: PacienteSBIS;
    estabelecimento: EstabelecimentoSaude;
    profissional: ProfissionalSaude;
    
    // Dados clínicos
    anamnese: Anamnese;
    exameFisico: ExameFisico;
    hipoteseDiagnostica: Diagnostico[];
    prescricao: Prescricao[];
    evolucao: Evolucao[];
    
    // Metadados
    dataHora: Date;
    versao: string;
    assinatura: AssinaturaDigital;
}

interface PacienteSBIS {
    // Identificadores obrigatórios
    cpf: string;
    cns?: string;
    nome: NomeCompleto;
    dataNascimento: Date;
    sexo: 'M' | 'F';
    
    // Dados demográficos
    nomeMae: string;
    naturalidade: Municipio;
    nacionalidade: string;
    
    // Contato
    endereco: Endereco[];
    telefone: Telefone[];
    email?: string;
}

interface Anamnese {
    queixaPrincipal: string;
    historiaDoencaAtual: string;
    historiaPatologicaPregressa: string;
    historiaFamiliar: string;
    historiaSocial: string;
    revisaoSistemas: RevisaoSistemas;
    alergias: Alergia[];
    medicamentosEmUso: Medicamento[];
}

interface ExameFisico {
    sinaisVitais: SinaisVitais;
    aspectoGeral: string;
    sistemas: {
        neurologico?: string;
        cardiovascular?: string;
        respiratorio?: string;
        gastrointestinal?: string;
        geniturinario?: string;
        musculoesqueletico?: string;
        peleAnexos?: string;
    };
}
```

### 3.2 Mapeamento para FHIR¹¹

```javascript
// Conversor SBIS para FHIR
class SBISToFHIRConverter {
    convertProntuario(prontuario) {
        const bundle = {
            resourceType: 'Bundle',
            type: 'document',
            timestamp: prontuario.dataHora,
            entry: []
        };
        
        // Composition principal
        const composition = {
            resourceType: 'Composition',
            id: this.generateId(),
            status: 'final',
            type: {
                coding: [{
                    system: 'http://loinc.org',
                    code: '60591-5',
                    display: 'Patient summary Document'
                }]
            },
            subject: {
                reference: `Patient/${this.getPatientId(prontuario.paciente)}`
            },
            date: prontuario.dataHora,
            author: [{
                reference: `Practitioner/${this.getPractitionerId(prontuario.profissional)}`
            }],
            title: 'Prontuário Eletrônico SBIS',
            section: []
        };
        
        // Converter paciente
        const patient = this.convertPatient(prontuario.paciente);
        bundle.entry.push({ resource: patient });
        
        // Converter anamnese
        if (prontuario.anamnese) {
            const anamneseSection = this.convertAnamnese(prontuario.anamnese);
            composition.section.push(anamneseSection);
        }
        
        // Converter exame físico
        if (prontuario.exameFisico) {
            const examSection = this.convertExameFisico(prontuario.exameFisico);
            composition.section.push(examSection);
        }
        
        // Adicionar assinatura digital
        composition.extension = [{
            url: 'http://sbis.org.br/fhir/StructureDefinition/digital-signature',
            valueSignature: this.convertSignature(prontuario.assinatura)
        }];
        
        bundle.entry.unshift({ resource: composition });
        
        return bundle;
    }
    
    convertPatient(pacienteSBIS) {
        return {
            resourceType: 'Patient',
            id: this.getPatientId(pacienteSBIS),
            identifier: [
                {
                    use: 'official',
                    type: {
                        coding: [{
                            system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
                            code: 'TAX'
                        }]
                    },
                    system: 'http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf',
                    value: pacienteSBIS.cpf
                },
                ...(pacienteSBIS.cns ? [{
                    use: 'official',
                    type: {
                        coding: [{
                            system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
                            code: 'HC'
                        }]
                    },
                    system: 'http://rnds.saude.gov.br/fhir/r4/NamingSystem/cns',
                    value: pacienteSBIS.cns
                }] : [])
            ],
            name: [{
                use: 'official',
                family: pacienteSBIS.nome.sobrenome,
                given: pacienteSBIS.nome.nomes
            }],
            gender: pacienteSBIS.sexo === 'M' ? 'male' : 'female',
            birthDate: pacienteSBIS.dataNascimento,
            address: pacienteSBIS.endereco.map(e => this.convertAddress(e)),
            telecom: pacienteSBIS.telefone.map(t => this.convertTelecom(t))
        };
    }
}
```

## 4. AUDITORIA E RASTREABILIDADE

### 4.1 Sistema de Auditoria SBIS¹²

```sql
-- Estrutura de auditoria conforme SBIS
CREATE SCHEMA sbis_audit;

CREATE TABLE sbis_audit.log_acesso (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    usuario_id VARCHAR(100) NOT NULL,
    usuario_nome VARCHAR(255) NOT NULL,
    usuario_cpf VARCHAR(11) NOT NULL,
    usuario_perfil VARCHAR(50) NOT NULL,
    
    -- Ação realizada
    acao VARCHAR(50) NOT NULL CHECK (acao IN (
        'LOGIN', 'LOGOUT', 'CREATE', 'READ', 'UPDATE', 'DELETE',
        'PRINT', 'EXPORT', 'SIGN', 'VERIFY'
    )),
    
    -- Recurso acessado
    recurso_tipo VARCHAR(50),
    recurso_id VARCHAR(100),
    recurso_descricao TEXT,
    
    -- Contexto
    paciente_id VARCHAR(100),
    paciente_cpf VARCHAR(11),
    estabelecimento_id VARCHAR(100),
    
    -- Detalhes técnicos
    ip_address INET NOT NULL,
    user_agent TEXT,
    session_id VARCHAR(100),
    
    -- Resultado
    sucesso BOOLEAN NOT NULL,
    mensagem_erro TEXT,
    
    -- Integridade
    hash_registro VARCHAR(64) NOT NULL
);

-- Índices para busca eficiente
CREATE INDEX idx_audit_timestamp ON sbis_audit.log_acesso(timestamp);
CREATE INDEX idx_audit_usuario ON sbis_audit.log_acesso(usuario_id);
CREATE INDEX idx_audit_paciente ON sbis_audit.log_acesso(paciente_id);
CREATE INDEX idx_audit_acao ON sbis_audit.log_acesso(acao);

-- Trigger para garantir integridade
CREATE OR REPLACE FUNCTION sbis_audit.calculate_hash()
RETURNS TRIGGER AS $$
BEGIN
    NEW.hash_registro = encode(
        digest(
            NEW.timestamp::text || 
            NEW.usuario_id || 
            NEW.acao || 
            COALESCE(NEW.recurso_id, '') || 
            NEW.ip_address::text,
            'sha256'
        ),
        'hex'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_hash
BEFORE INSERT ON sbis_audit.log_acesso
FOR EACH ROW
EXECUTE FUNCTION sbis_audit.calculate_hash();

-- View para relatórios de auditoria
CREATE VIEW sbis_audit.relatorio_auditoria AS
SELECT 
    DATE(timestamp) as data,
    usuario_nome,
    usuario_perfil,
    COUNT(*) FILTER (WHERE acao = 'LOGIN') as logins,
    COUNT(*) FILTER (WHERE acao IN ('CREATE', 'UPDATE', 'DELETE')) as modificacoes,
    COUNT(*) FILTER (WHERE acao = 'READ') as leituras,
    COUNT(*) FILTER (WHERE NOT sucesso) as erros
FROM sbis_audit.log_acesso
GROUP BY DATE(timestamp), usuario_nome, usuario_perfil
ORDER BY data DESC, usuario_nome;
```

### 4.2 Implementação de Trilha de Auditoria¹³

```javascript
// Serviço de auditoria SBIS
class SBISAuditService {
    constructor(database) {
        this.db = database;
        this.queue = [];
        this.startBatchProcessor();
    }
    
    async logAccess(context) {
        const entry = {
            timestamp: new Date(),
            usuario_id: context.user.id,
            usuario_nome: context.user.name,
            usuario_cpf: context.user.cpf,
            usuario_perfil: context.user.profile,
            acao: context.action,
            recurso_tipo: context.resource?.type,
            recurso_id: context.resource?.id,
            recurso_descricao: context.resource?.description,
            paciente_id: context.patient?.id,
            paciente_cpf: context.patient?.cpf,
            estabelecimento_id: context.facility?.id,
            ip_address: context.request.ip,
            user_agent: context.request.userAgent,
            session_id: context.session.id,
            sucesso: context.success,
            mensagem_erro: context.error
        };
        
        // Adicionar à fila para processamento em batch
        this.queue.push(entry);
        
        // Log crítico imediato
        if (this.isCriticalAction(context.action)) {
            await this.immediateLog(entry);
        }
    }
    
    isCriticalAction(action) {
        return ['DELETE', 'EXPORT', 'SIGN', 'LOGIN_FAILED'].includes(action);
    }
    
    async immediateLog(entry) {
        await this.db.query(
            `INSERT INTO sbis_audit.log_acesso 
            (timestamp, usuario_id, usuario_nome, usuario_cpf, usuario_perfil,
             acao, recurso_tipo, recurso_id, recurso_descricao,
             paciente_id, paciente_cpf, estabelecimento_id,
             ip_address, user_agent, session_id, sucesso, mensagem_erro)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)`,
            [entry.timestamp, entry.usuario_id, entry.usuario_nome, entry.usuario_cpf,
             entry.usuario_perfil, entry.acao, entry.recurso_tipo, entry.recurso_id,
             entry.recurso_descricao, entry.paciente_id, entry.paciente_cpf,
             entry.estabelecimento_id, entry.ip_address, entry.user_agent,
             entry.session_id, entry.sucesso, entry.mensagem_erro]
        );
    }
    
    startBatchProcessor() {
        setInterval(async () => {
            if (this.queue.length > 0) {
                const batch = this.queue.splice(0, 100);
                await this.processBatch(batch);
            }
        }, 5000); // Processar a cada 5 segundos
    }
    
    async generateAuditReport(filters) {
        const query = `
            SELECT 
                timestamp,
                usuario_nome,
                acao,
                recurso_tipo,
                recurso_id,
                paciente_id,
                sucesso,
                mensagem_erro
            FROM sbis_audit.log_acesso
            WHERE timestamp BETWEEN $1 AND $2
                ${filters.userId ? 'AND usuario_id = $3' : ''}
                ${filters.patientId ? 'AND paciente_id = $4' : ''}
                ${filters.action ? 'AND acao = $5' : ''}
            ORDER BY timestamp DESC
        `;
        
        const params = [filters.startDate, filters.endDate];
        if (filters.userId) params.push(filters.userId);
        if (filters.patientId) params.push(filters.patientId);
        if (filters.action) params.push(filters.action);
        
        const result = await this.db.query(query, params);
        
        return {
            periodo: {
                inicio: filters.startDate,
                fim: filters.endDate
            },
            totalRegistros: result.rows.length,
            registros: result.rows
        };
    }
}
```

## 5. VALIDAÇÃO E TESTES

### 5.1 Framework de Testes SBIS¹⁴

```javascript
// Suite de testes para conformidade SBIS
const { expect } = require('chai');

describe('Conformidade SBIS-CFM', () => {
    describe('NGS1 - Requisitos Básicos', () => {
        it('EC.01 - Deve identificar paciente univocamente', async () => {
            const patient = await createPatient({
                cpf: '12345678901',
                name: 'João Silva'
            });
            
            expect(patient.identifier).to.have.length.at.least(1);
            expect(patient.identifier[0].system).to.equal(
                'http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf'
            );
            expect(patient.identifier[0].value).to.match(/^\d{11}$/);
        });
        
        it('S.01 - Deve exigir autenticação', async () => {
            const response = await request('/api/patient')
                .get()
                .expect(401);
            
            expect(response.body.error).to.equal('Authentication required');
        });
        
        it('S.03 - Deve registrar auditoria', async () => {
            await performAction('READ', 'Patient/123');
            
            const audit = await getLastAuditEntry();
            expect(audit.acao).to.equal('READ');
            expect(audit.recurso_tipo).to.equal('Patient');
            expect(audit.recurso_id).to.equal('123');
            expect(audit.timestamp).to.be.closeTo(Date.now(), 1000);
        });
    });
    
    describe('NGS2 - Certificação Digital', () => {
        it('Deve assinar documento com certificado ICP-Brasil', async () => {
            const document = { type: 'prescription', content: '...' };
            const certificate = await getCertificate();
            
            const signed = await signDocument(document, certificate);
            
            expect(signed.signature).to.exist;
            expect(signed.signature.algorithm).to.equal('RSA-SHA256');
            expect(signed.signature.timestamp).to.exist;
            
            const isValid = await verifySignature(signed);
            expect(isValid).to.be.true;
        });
    });
    
    describe('NGS3 - Interoperabilidade', () => {
        it('Deve exportar dados em formato RNDS', async () => {
            const patient = await getPatient('123');
            const rndsBundle = await exportToRNDS(patient);
            
            expect(rndsBundle.resourceType).to.equal('Bundle');
            expect(rndsBundle.entry[0].resource.meta.profile).to.include(
                'http://rnds.saude.gov.br/fhir/r4/StructureDefinition/patient'
            );
        });
    });
});
```

## 6. INTEGRAÇÃO COM RNDS

### 6.1 Conformidade RNDS¹⁵

```javascript
// Adaptador RNDS para sistemas SBIS
class RNDSAdapter {
    constructor(config) {
        this.baseUrl = config.rndsUrl;
        this.certificate = config.certificate;
        this.establishmentCNES = config.cnes;
    }
    
    async sendToRNDS(resource) {
        // Validar recurso conforme perfis RNDS
        const validation = await this.validateRNDSProfile(resource);
        if (!validation.valid) {
            throw new Error(`Recurso inválido: ${validation.errors.join(', ')}`);
        }
        
        // Adicionar metadados RNDS
        resource.meta = resource.meta || {};
        resource.meta.profile = resource.meta.profile || [];
        resource.meta.profile.push(this.getRNDSProfile(resource.resourceType));
        
        // Adicionar identificador do estabelecimento
        if (resource.resourceType === 'Bundle') {
            resource.entry.forEach(entry => {
                this.addEstablishmentReference(entry.resource);
            });
        } else {
            this.addEstablishmentReference(resource);
        }
        
        // Assinar com certificado digital
        const signedResource = await this.signWithCertificate(resource);
        
        // Enviar para RNDS
        const response = await fetch(`${this.baseUrl}/${resource.resourceType}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/fhir+json',
                'Authorization': `Bearer ${await this.getToken()}`,
                'X-Certificate': this.certificate.thumbprint
            },
            body: JSON.stringify(signedResource)
        });
        
        if (!response.ok) {
            throw new Error(`RNDS error: ${response.status} - ${await response.text()}`);
        }
        
        return response.json();
    }
    
    getRNDSProfile(resourceType) {
        const profiles = {
            'Patient': 'http://rnds.saude.gov.br/fhir/r4/StructureDefinition/patient',
            'Condition': 'http://rnds.saude.gov.br/fhir/r4/StructureDefinition/diagnostic',
            'MedicationRequest': 'http://rnds.saude.gov.br/fhir/r4/StructureDefinition/prescription',
            'Immunization': 'http://rnds.saude.gov.br/fhir/r4/StructureDefinition/immunization'
        };
        
        return profiles[resourceType];
    }
}
```

## 7. REQUISITOS DE QUALIDADE

### 7.1 Métricas de Qualidade SBIS¹⁶

```sql
-- Dashboard de qualidade SBIS
CREATE VIEW sbis_quality_metrics AS
WITH metrics AS (
    SELECT 
        -- Completude de dados
        COUNT(*) as total_patients,
        COUNT(*) FILTER (WHERE cpf IS NOT NULL) as with_cpf,
        COUNT(*) FILTER (WHERE cns IS NOT NULL) as with_cns,
        COUNT(*) FILTER (WHERE nome_completo IS NOT NULL) as with_name,
        COUNT(*) FILTER (WHERE data_nascimento IS NOT NULL) as with_birthdate,
        
        -- Qualidade de documentação
        (SELECT COUNT(*) FROM prontuarios WHERE assinado = true) as signed_records,
        (SELECT COUNT(*) FROM prontuarios) as total_records,
        
        -- Segurança
        (SELECT COUNT(*) FROM usuarios WHERE ultimo_acesso > NOW() - INTERVAL '30 days') as active_users,
        (SELECT COUNT(*) FROM usuarios WHERE certificado_digital IS NOT NULL) as users_with_cert,
        
        -- Auditoria
        (SELECT COUNT(*) FROM sbis_audit.log_acesso WHERE timestamp > NOW() - INTERVAL '24 hours') as audit_last_24h
    FROM pacientes
)
SELECT 
    'Completude CPF' as metrica,
    ROUND(100.0 * with_cpf / total_patients, 2) as percentual,
    CASE 
        WHEN with_cpf::float / total_patients >= 0.99 THEN 'Conforme'
        ELSE 'Não Conforme'
    END as status
FROM metrics
UNION ALL
SELECT 
    'Documentos Assinados',
    ROUND(100.0 * signed_records / NULLIF(total_records, 0), 2),
    CASE 
        WHEN signed_records::float / NULLIF(total_records, 0) >= 1.0 THEN 'Conforme'
        ELSE 'Não Conforme'
    END
FROM metrics
UNION ALL
SELECT 
    'Usuários com Certificado Digital',
    ROUND(100.0 * users_with_cert / NULLIF(active_users, 0), 2),
    CASE 
        WHEN users_with_cert::float / NULLIF(active_users, 0) >= 0.95 THEN 'Conforme'
        ELSE 'Não Conforme'
    END
FROM metrics;
```

## 8. CHECKLIST DE CERTIFICAÇÃO

### 8.1 Preparação para Auditoria SBIS¹⁷

- [ ] **Documentação**
  - [ ] Manual do sistema atualizado
  - [ ] Política de segurança documentada
  - [ ] Procedimentos de backup documentados
  - [ ] Plano de contingência

- [ ] **NGS1 - Requisitos Básicos**
  - [ ] Identificação unívoca de pacientes
  - [ ] Controle de acesso por perfis
  - [ ] Timeout de sessão configurado
  - [ ] Sistema de auditoria completo
  - [ ] Backup automático configurado
  - [ ] Recuperação de dados testada

- [ ] **NGS2 - Certificação Digital**
  - [ ] Integração com ICP-Brasil
  - [ ] Assinatura digital implementada
  - [ ] Carimbo de tempo configurado
  - [ ] Validação de certificados

- [ ] **NGS3 - Interoperabilidade**
  - [ ] Integração com RNDS
  - [ ] Suporte a terminologias nacionais
  - [ ] Exportação em formatos padrão
  - [ ] APIs documentadas

- [ ] **Testes**
  - [ ] Testes unitários > 80% cobertura
  - [ ] Testes de integração
  - [ ] Testes de segurança
  - [ ] Testes de performance
  - [ ] Relatório de testes

## 9. MANUTENÇÃO DA CERTIFICAÇÃO

### 9.1 Processo Contínuo¹⁸

```javascript
// Monitor de conformidade SBIS
class SBISComplianceMonitor {
    constructor() {
        this.checks = [];
        this.setupDailyChecks();
    }
    
    setupDailyChecks() {
        // Verificação diária de conformidade
        this.schedule('0 2 * * *', async () => {
            const report = {
                date: new Date(),
                checks: [],
                issues: []
            };
            
            // Verificar certificados
            const certCheck = await this.checkCertificates();
            report.checks.push(certCheck);
            
            // Verificar backups
            const backupCheck = await this.checkBackups();
            report.checks.push(backupCheck);
            
            // Verificar auditoria
            const auditCheck = await this.checkAuditIntegrity();
            report.checks.push(auditCheck);
            
            // Verificar segurança
            const securityCheck = await this.checkSecurityCompliance();
            report.checks.push(securityCheck);
            
            // Gerar relatório
            await this.generateComplianceReport(report);
            
            // Alertar se houver problemas
            if (report.issues.length > 0) {
                await this.sendAlert(report.issues);
            }
        });
    }
    
    async checkCertificates() {
        const certificates = await this.getAllCertificates();
        const issues = [];
        
        for (const cert of certificates) {
            const daysToExpire = this.daysUntilExpiration(cert);
            
            if (daysToExpire < 30) {
                issues.push({
                    type: 'CERTIFICATE_EXPIRING',
                    severity: daysToExpire < 7 ? 'CRITICAL' : 'WARNING',
                    details: `Certificate ${cert.subject} expires in ${daysToExpire} days`
                });
            }
        }
        
        return {
            name: 'Certificate Validation',
            passed: issues.length === 0,
            issues
        };
    }
}
```

## 10. REFERÊNCIAS

1. SBIS. Manual de Certificação para Sistemas de Registro Eletrônico em Saúde. Versão 5.0. 2022. https://www.sbis.org.br/certificacao
2. SBIS-CFM. NGS1 - Nível de Garantia de Segurança 1. 2022.
3. SBIS-CFM. NGS2 - Nível de Garantia de Segurança 2. 2022.
4. SBIS-CFM. NGS3 - Nível de Garantia de Segurança 3. 2022.
5. Brasil. Portaria GM/MS nº 3.232/2022. Programa ConecteSUS.
6. CFM. Resolução CFM nº 2.314/2022. Regulamenta o prontuário eletrônico.
7. SBIS. Requisitos de Estrutura e Conteúdo. Manual SBIS-CFM. 2022.
8. ICP-Brasil. DOC-ICP-15. Requisitos de segurança para sistemas. 2021.
9. MS/DATASUS. Guia de Implementação da RNDS. 2023.
10. SBIS. Modelo de Informação Clínica. 2022.
11. HL7 Brasil. Guia de Implementação FHIR BR Core. 2023.
12. SBIS. Requisitos de Auditoria e Rastreabilidade. 2022.
13. ISO 27789:2021. Health informatics — Audit trails for electronic health records.
14. SBIS. Framework de Testes para Certificação. 2022.
15. RNDS. Perfis e Extensões FHIR. https://rnds.saude.gov.br/fhir
16. SBIS. Indicadores de Qualidade para S-RES. 2022.
17. SBIS. Checklist de Auditoria de Certificação. 2022.
18. SBIS. Guia de Manutenção da Certificação. 2022.

---
**Documento aprovado por:** [Comitê de Certificação SBIS]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026