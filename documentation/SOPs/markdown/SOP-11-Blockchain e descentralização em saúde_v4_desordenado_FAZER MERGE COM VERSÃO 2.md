# 10. Verificar histórico descentralizado
rad log --oneline
```

### 3.3 Integração Radicle com CI/CD

```yaml
# .github/workflows/radicle-sync.yml
name: Radicle Sync

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  radicle-sync:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install Radicle
      run: |
        curl -sSf https://radicle.xyz/install | sh
        echo "$HOME/.radicle/bin" >> $GITHUB_PATH
    
    - name: Configure Radicle Identity
      run: |
        echo "${{ secrets.RADICLE_KEY }}" | rad auth init --stdin
    
    - name: Sync with Radicle Network
      run: |
        rad sync --fetch
        rad push
    
    - name: Validate FHIR Resources
      run: |
        npm install -g fsh-sushi
        sushi .
    
    - name: Create Radicle Patch for PR
      if: github.event_name == 'pull_request'
      run: |
        rad patch create \
          --title "${{ github.event.pull_request.title }}" \
          --description "${{ github.event.pull_request.body }}" \
          --target main
```

## 4. IPFS para Armazenamento Descentralizado

### 4.1 Configuração IPFS para Dados FHIR

```javascript
// ipfs-fhir-storage.js
const IPFS = require('ipfs-core');
const crypto = require('crypto');

class IPFSFHIRStorage {
    constructor() {
        this.node = null;
        this.encryptionKey = process.env.FHIR_ENCRYPTION_KEY;
    }
    
    async initialize() {
        this.node = await IPFS.create({
            repo: './ipfs-fhir-repo',
            config: {
                Addresses: {
                    Swarm: [
                        '/ip4/0.0.0.0/tcp/4002',
                        '/ip4/127.0.0.1/tcp/4003/ws'
                    ],
                    API: '/ip4/127.0.0.1/tcp/5002',
                    Gateway: '/ip4/127.0.0.1/tcp/9090'
                },
                Discovery: {
                    MDNS: {
                        Enabled: true,
                        Interval: 20
                    },
                    webRTCStar: {
                        Enabled: true
                    }
                }
            }
        });
        
        console.log('IPFS node initialized');
        const info = await this.node.id();
        console.log('Node ID:', info.id);
    }
    
    // Armazenar recurso FHIR criptografado
    async storeFHIRResource(resource) {
        // Criptografar recurso
        const encrypted = this.encryptResource(resource);
        
        // Criar metadados
        const metadata = {
            resourceType: resource.resourceType,
            id: resource.id,
            timestamp: new Date().toISOString(),
            encrypted: true,
            algorithm: 'aes-256-gcm'
        };
        
        // Adicionar ao IPFS
        const { cid } = await this.node.add(JSON.stringify({
            metadata,
            data: encrypted
        }));
        
        // Pin para persistência
        await this.node.pin.add(cid);
        
        return {
            cid: cid.toString(),
            metadata
        };
    }
    
    // Recuperar recurso FHIR
    async retrieveFHIRResource(cid) {
        const stream = this.node.cat(cid);
        let data = '';
        
        for await (const chunk of stream) {
            data += chunk.toString();
        }
        
        const stored = JSON.parse(data);
        
        if (stored.metadata.encrypted) {
            stored.data = this.decryptResource(stored.data);
        }
        
        return stored;
    }
    
    // Criptografia AES-256-GCM
    encryptResource(resource) {
        const iv = crypto.randomBytes(16);
        const cipher = crypto.createCipheriv(
            'aes-256-gcm',
            Buffer.from(this.encryptionKey, 'hex'),
            iv
        );
        
        let encrypted = cipher.update(JSON.stringify(resource), 'utf8', 'hex');
        encrypted += cipher.final('hex');
        
        const authTag = cipher.getAuthTag();
        
        return {
            encrypted,
            iv: iv.toString('hex'),
            authTag: authTag.toString('hex')
        };
    }
    
    decryptResource(encryptedData) {
        const decipher = crypto.createDecipheriv(
            'aes-256-gcm',
            Buffer.from(this.encryptionKey, 'hex'),
            Buffer.from(encryptedData.iv, 'hex')
        );
        
        decipher.setAuthTag(Buffer.from(encryptedData.authTag, 'hex'));
        
        let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
        decrypted += decipher.final('utf8');
        
        return JSON.parse(decrypted);
    }
    
    // Criar DAG para bundle FHIR
    async createFHIRBundle(resources) {
        const bundle = {
            resourceType: 'Bundle',
            type: 'collection',
            timestamp: new Date().toISOString(),
            entry: []
        };
        
        for (const resource of resources) {
            const stored = await this.storeFHIRResource(resource);
            bundle.entry.push({
                fullUrl: `ipfs://${stored.cid}`,
                resource: stored.metadata
            });
        }
        
        const { cid } = await this.node.dag.put(bundle);
        return cid.toString();
    }
    
    // Replicação entre nós
    async replicateToCluster(cid, peerIds) {
        const results = [];
        
        for (const peerId of peerIds) {
            try {
                await this.node.swarm.connect(`/p2p/${peerId}`);
                await this.node.pin.remote.add(cid, { service: peerId });
                results.push({
                    peer: peerId,
                    status: 'success'
                });
            } catch (error) {
                results.push({
                    peer: peerId,
                    status: 'failed',
                    error: error.message
                });
            }
        }
        
        return results;
    }
}

module.exports = IPFSFHIRStorage;
```

### 4.2 Gateway IPFS-FHIR

```javascript
// ipfs-fhir-gateway.js
const express = require('express');
const IPFSFHIRStorage = require('./ipfs-fhir-storage');

class IPFSFHIRGateway {
    constructor() {
        this.app = express();
        this.storage = new IPFSFHIRStorage();
        this.setupRoutes();
    }
    
    async start(port = 3000) {
        await this.storage.initialize();
        
        this.app.listen(port, () => {
            console.log(`IPFS-FHIR Gateway running on port ${port}`);
        });
    }
    
    setupRoutes() {
        this.app.use(express.json());
        
        // Store FHIR resource
        this.app.post('/fhir/:resourceType', async (req, res) => {
            try {
                const resource = {
                    ...req.body,
                    resourceType: req.params.resourceType
                };
                
                const result = await this.storage.storeFHIRResource(resource);
                
                res.json({
                    success: true,
                    cid: result.cid,
                    metadata: result.metadata
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });
        
        // Retrieve FHIR resource
        this.app.get('/ipfs/:cid', async (req, res) => {
            try {
                const resource = await this.storage.retrieveFHIRResource(req.params.cid);
                res.json(resource);
            } catch (error) {
                res.status(404).json({
                    success: false,
                    error: 'Resource not found'
                });
            }
        });
        
        // Create Bundle
        this.app.post('/fhir/Bundle', async (req, res) => {
            try {
                const resources = req.body.entry.map(e => e.resource);
                const cid = await this.storage.createFHIRBundle(resources);
                
                res.json({
                    success: true,
                    bundleCid: cid
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });
    }
}

// Iniciar gateway
const gateway = new IPFSFHIRGateway();
gateway.start(3000);
```

## 5. Identidade Auto-Soberana (SSI) com DIDs

### 5.1 Implementação de DIDs para Healthcare

```javascript
// did-healthcare.js
const { DID } = require('dids');
const { Ed25519Provider } = require('key-did-provider-ed25519');
const KeyResolver = require('key-did-resolver').default;

class HealthcareDID {
    constructor() {
        this.dids = {};
        this.credentials = [];
    }
    
    // Criar DID para entidade de saúde
    async createHealthcareDID(entityType, entityData) {
        // Gerar seed aleatória
        const seed = crypto.randomBytes(32);
        const provider = new Ed25519Provider(seed);
        const did = new DID({ provider, resolver: KeyResolver.getResolver() });
        
        await did.authenticate();
        
        // Criar documento DID
        const didDocument = {
            '@context': [
                'https://www.w3.org/ns/did/v1',
                'https://w3id.org/security/v2',
                'https://hl7.org/fhir/R4'
            ],
            id: did.id,
            entityType, // 'patient', 'practitioner', 'organization'
            publicKey: [{
                id: `${did.id}#keys-1`,
                type: 'Ed25519VerificationKey2018',
                controller: did.id,
                publicKeyBase58: did.id.split(':')[2]
            }],
            authentication: [`${did.id}#keys-1`],
            service: [{
                id: `${did.id}#fhir-service`,
                type: 'FHIRService',
                serviceEndpoint: `https://fhir.example.com/${entityType}/${entityData.id}`
            }],
            created: new Date().toISOString(),
            entityData: {
                ...entityData,
                // Remover dados sensíveis
                identifier: entityData.identifier,
                name: entityData.name
            }
        };
        
        this.dids[did.id] = {
            did,
            document: didDocument,
            seed: seed.toString('hex')
        };
        
        return {
            did: did.id,
            document: didDocument
        };
    }
    
    // Criar Verifiable Credential
    async createHealthCredential(issuerDID, subjectDID, credentialData) {
        const issuer = this.dids[issuerDID];
        if (!issuer) throw new Error('Issuer DID not found');
        
        const credential = {
            '@context': [
                'https://www.w3.org/2018/credentials/v1',
                'https://hl7.org/fhir/R4/credentials'
            ],
            id: `urn:uuid:${crypto.randomUUID()}`,
            type: ['VerifiableCredential', 'HealthCredential'],
            issuer: issuerDID,
            issuanceDate: new Date().toISOString(),
            credentialSubject: {
                id: subjectDID,
                ...credentialData
            }
        };
        
        // Assinar credential
        const jws = await issuer.did.createJWS(credential);
        
        const verifiableCredential = {
            ...credential,
            proof: {
                type: 'Ed25519Signature2018',
                created: new Date().toISOString(),
                proofPurpose: 'assertionMethod',
                verificationMethod: `${issuerDID}#keys-1`,
                jws: jws.signatures[0].signature
            }
        };
        
        this.credentials.push(verifiableCredential);
        return verifiableCredential;
    }
    
    // Verificar Credential
    async verifyCredential(credential) {
        try {
            const issuerDID = this.dids[credential.issuer];
            if (!issuerDID) {
                return {
                    verified: false,
                    error: 'Issuer not found'
                };
            }
            
            const result = await issuerDID.did.verifyJWS(credential.proof.jws);
            
            return {
                verified: result.verified,
                issuer: credential.issuer,
                subject: credential.credentialSubject.id,
                issuanceDate: credential.issuanceDate
            };
        } catch (error) {
            return {
                verified: false,
                error: error.message
            };
        }
    }
    
    // Criar Presentation
    async createPresentation(holderDID, credentials, challenge) {
        const holder = this.dids[holderDID];
        if (!holder) throw new Error('Holder DID not found');
        
        const presentation = {
            '@context': [
                'https://www.w3.org/2018/credentials/v1'
            ],
            type: 'VerifiablePresentation',
            holder: holderDID,
            verifiableCredential: credentials,
            challenge,
            created: new Date().toISOString()
        };
        
        const jws = await holder.did.createJWS(presentation);
        
        presentation.proof = {
            type: 'Ed25519Signature2018',
            created: new Date().toISOString(),
            proofPurpose: 'authentication',
            verificationMethod: `${holderDID}#keys-1`,
            challenge,
            jws: jws.signatures[0].signature
        };
        
        return presentation;
    }
}

module.exports = HealthcareDID;
```

### 5.2 Integração SSI com FHIR

```javascript
// ssi-fhir-integration.js
class SSIFHIRIntegration {
    constructor(didManager, fhirClient) {
        this.didManager = didManager;
        this.fhirClient = fhirClient;
    }
    
    // Criar identidade para paciente FHIR
    async createPatientIdentity(patient) {
        // Criar DID
        const { did, document } = await this.didManager.createHealthcareDID('patient', {
            id: patient.id,
            identifier: patient.identifier,
            name: patient.name
        });
        
        // Atualizar Patient resource com DID
        patient.identifier = patient.identifier || [];
        patient.identifier.push({
            system: 'https://w3id.org/did',
            value: did,
            use: 'official',
            assigner: {
                display: 'Decentralized Identity System'
            }
        });
        
        // Salvar no FHIR server
        await this.fhirClient.update(patient);
        
        return {
            did,
            document,
            patientId: patient.id
        };
    }
    
    // Emitir credential de vacinação
    async issueVaccinationCredential(patientDID, immunization) {
        const credential = await this.didManager.createHealthCredential(
            this.organizationDID, // Emissor
            patientDID,          // Sujeito
            {
                type: 'VaccinationCertificate',
                immunization: {
                    vaccineCode: immunization.vaccineCode,
                    occurrence: immunization.occurrenceDateTime,
                    lotNumber: immunization.lotNumber,
                    site: immunization.site,
                    route: immunization.route,
                    performer: immunization.performer
                },
                fhirReference: `Immunization/${immunization.id}`
            }
        );
        
        return credential;
    }
    
    // Compartilhar dados com consentimento
    async shareDataWithConsent(patientDID, providerDID, resources, purpose) {
        // Verificar consentimento no blockchain
        const hasConsent = await this.checkBlockchainConsent(patientDID, providerDID);
        
        if (!hasConsent) {
            throw new Error('No consent found');
        }
        
        // Criar presentation com recursos solicitados
        const credentials = [];
        
        for (const resource of resources) {
            const credential = await this.createResourceCredential(
                patientDID,
                resource
            );
            credentials.push(credential);
        }
        
        const challenge = crypto.randomBytes(32).toString('hex');
        const presentation = await this.didManager.createPresentation(
            patientDID,
            credentials,
            challenge
        );
        
        // Registrar compartilhamento no blockchain
        await this.logDataSharing(patientDID, providerDID, resources, purpose);
        
        return presentation;
    }
}
```

## 6. Integração Completa: FHIR + Blockchain + IPFS + Radicle

### 6.1 Arquitetura Integrada

```yaml
# integrated-architecture.yaml
services:
  fhir_layer:
    - hapi_fhir:
        port: 8080
        interceptors:
          - blockchain_audit
          - ipfs_storage
          - did_authentication
    
    - fhir_facade:
        endpoints:
          - /fhir/Patient
          - /fhir/Observation
          - /fhir/Bundle
  
  blockchain_layer:
    - hyperledger_fabric:
        channels:
          - healthcare_channel
        chaincodes:
          - fhir_chaincode
          - consent_chaincode
          - audit_chaincode
    
    - ethereum:
        contracts:
          - FHIRToken
          - DataMarketplace
  
  storage_layer:
    - ipfs:
        clusters:
          - primary_cluster
          - backup_cluster
        encryption: true
    
    - traditional_db:
        postgresql:
          - metadata_db
          - index_db
  
  identity_layer:
    - did_resolver:
        methods:
          - key
          - web
          - ethr
    
    - credential_issuer:
        types:
          - HealthCredential
          - ConsentCredential
          - AccessCredential
  
  version_control:
    - radicle:
        projects:
          - implementation_guides
          - smart_contracts
          - configurations
    
    - git:
        mirrors:
          - github
          - gitlab
```

### 6.2 Workflow Integrado

```javascript
// integrated-workflow.js
class IntegratedHealthcareSystem {
    constructor() {
        this.fhirClient = new FHIRClient();
        this.blockchain = new BlockchainService();
        this.ipfs = new IPFSStorage();
        this.didManager = new DIDManager();
        this.radicle = new RadicleService();
    }
    
    async processPatientData(patientData, wearableData) {
        try {
            // 1. Criar identidade descentralizada
            const { did } = await this.didManager.createPatientIdentity(patientData);
            
            // 2. Armazenar dados no IPFS
            const ipfsCID = await this.ipfs.storeEncrypted({
                patient: patientData,
                observations: wearableData
            });
            
            // 3. Registrar no blockchain
            const txHash = await this.blockchain.registerResource({
                type: 'Patient',
                did: did,
                ipfsCID: ipfsCID,
                timestamp: new Date().toISOString()
            });
            
            // 4. Criar recurso FHIR
            const patient = await this.fhirClient.createPatient({
                ...patientData,
                identifier: [{
                    system: 'did',
                    value: did
                }],
                meta: {
                    extension: [{
                        url: 'http://example.org/fhir/extension/ipfs-cid',
                        valueString: ipfsCID
                    }, {
                        url: 'http://example.org/fhir/extension/blockchain-tx',
                        valueString: txHash
                    }]
                }
            });
            
            // 5. Versionar configuração no Radicle
            await this.radicle.commitConfiguration({
                patient: patient.id,
                did: did,
                ipfs: ipfsCID,
                blockchain: txHash
            });
            
            // 6. Processar dados de wearables
            for (const observation of wearableData) {
                await this.processWearableObservation(patient.id, did, observation);
            }
            
            return {
                success: true,
                patientId: patient.id,
                did: did,
                ipfsCID: ipfsCID,
                blockchainTx: txHash
            };
            
        } catch (error) {
            console.error('Error in integrated workflow:', error);
            throw error;
        }
    }
    
    async processWearableObservation(patientId, patientDID, observation) {
        // Store observation in IPFS
        const obsCID = await this.ipfs.storeEncrypted(observation);
        
        // Create FHIR Observation
        const fhirObs = await this.fhirClient.createObservation({
            ...observation,
            subject: { reference: `Patient/${patientId}` },
            meta: {
                extension: [{
                    url: 'http://example.org/fhir/extension/ipfs-cid',
                    valueString: obsCID
                }]
            }
        });
        
        // Log in blockchain
        await this.blockchain.logObservation({
            patientDID: patientDID,
            observationId: fhirObs.id,
            ipfsCID: obsCID,
            deviceId: observation.device,
            timestamp: observation.effectiveDateTime
        });
        
        return fhirObs;
    }
    
    async queryWithConsent(requesterDID, patientDID, queryParams) {
        // 1. Verificar consentimento no blockchain
        const consent = await this.blockchain.checkConsent(patientDID, requesterDID);
        
        if (!consent.granted) {
            throw new Error('Access denied: No consent');
        }
        
        // 2. Executar query FHIR
        const results = await this.fhirClient.search(queryParams);
        
        // 3. Recuperar dados do IPFS se necessário
        for (const result of results.entry) {
            if (result.resource.meta?.extension) {
                const cidExt = result.resource.meta.extension.find(
                    e => e.url === 'http://example.org/fhir/extension/ipfs-cid'
                );
                
                if (cidExt) {
                    const ipfsData = await this.ipfs.retrieve(cidExt.valueString);
                    result.resource._ipfsData = ipfsData;
                }
            }
        }
        
        // 4. Criar audit trail
        await this.blockchain.logAccess({
            requester: requesterDID,
            patient: patientDID,
            resources: results.entry.map(e => e.resource.id),
            timestamp: new Date().toISOString(),
            purpose: queryParams.purpose
        });
        
        // 5. Retornar resultados
        return results;
    }
}

module.exports = IntegratedHealthcareSystem;
```

## 7. Scripts de Deployment e Manutenção

### 7.1 Deploy Completo do Sistema

```bash
#!/bin/bash
# deploy-decentralized-fhir.sh

set -e

echo "🚀 Deploying Decentralized FHIR System"

# 1. Deploy Hyperledger Fabric Network
echo "📦 Deploying Hyperledger Fabric..."
cd hyperledger
./network.sh up createChannel -ca
./network.sh deployCC -ccn fhir_chaincode -ccp ../chaincode -ccl javascript

# 2. Start IPFS Cluster
echo "🌐 Starting IPFS Cluster..."
docker-compose -f ipfs-cluster.yml up -d

# 3. Deploy Smart Contracts on Ethereum
echo "💎 Deploying Ethereum Smart Contracts..."
cd ../ethereum
npx hardhat run scripts/deploy.js --network polygon

# 4. Initialize Radicle Projects
echo "🌱 Initializing Radicle..."
cd ../
rad init --name "decentralized-fhir" --public
rad push

# 5. Start FHIR Server with Integrations
echo "🏥 Starting HAPI FHIR Server..."
cd fhir-server
docker-compose up -d

# 6. Configure DID Resolver
echo "🔑 Configuring DID Resolver..."
cd ../did-resolver
npm install
npm run setup
pm2 start did-resolver.js

# 7. Start Integration Services
echo "🔄 Starting Integration Services..."
cd ../integration
pm2 start ecosystem.config.js

# 8. Health Check
echo "✅ Running Health Checks..."
sleep 30
./health-check.sh

echo "✨ Deployment Complete!"
echo "Dashboard: http://localhost:3000"
echo "FHIR API: http://localhost:8080/fhir"
echo "IPFS Gateway: http://localhost:8081"
echo "Blockchain Explorer: http://localhost:8082"
```

### 7.2 Monitoramento e Manutenção

```bash
#!/bin/bash
# monitor-system.sh

# Função para verificar serviço
check_service() {
    local service=$1
    local url=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" $url)
    
    if [ $response -eq 200 ]; then
        echo "✅ $service: Online"
    else
        echo "❌ $service: Offline (HTTP $response)"
        # Tentar reiniciar
        restart_service $service
    fi
}

# Função para reiniciar serviço
restart_service() {
    local service=$1
    echo "🔄 Restarting $service..."
    
    case $service in
        "FHIR")
            docker restart hapi-fhir
            ;;
        "IPFS")
            docker restart ipfs-node
            ;;
        "Blockchain")
            cd hyperledger && ./network.sh restart
            ;;
    esac
}

# Loop de monitoramento
while true; do
    clear
    echo "==================================="
    echo "   Decentralized FHIR Monitoring"
    echo "==================================="
    echo "Time: $(date)"
    echo ""
    
    # Verificar serviços
    check_service "FHIR" "http://localhost:8080/fhir/metadata"
    check_service "IPFS" "http://localhost:5001/api/v0/id"
    check_service "Blockchain" "http://localhost:7051/healthz"
    check_service "DID Resolver" "http://localhost:8090/health"
    
    # Métricas
    echo ""
    echo "📊 Metrics:"
    echo "- FHIR Resources: $(curl -s http://localhost:8080/fhir/Patient?_summary=count | jq .total)"
    echo "- IPFS Pins: $(ipfs pin ls --type=recursive | wc -l)"
    echo "- Blockchain Height: $(docker exec peer0.org1.example.com peer channel getinfo -c mychannel | grep height)"
    
    sleep 60
done
```

## 8. Conclusão

Este SOP estabelece um framework completo para implementação de sistemas de saúde descentralizados, integrando:

- **Blockchain** para auditoria imutável e gestão de consentimento
- **IPFS** para armazenamento distribuído e resiliente
- **Radicle** para versionamento descentralizado de código
- **DIDs/SSI** para identidade auto-soberana
- **FHIR** como padrão de interoperabilidade

A implementação bem-sucedida requer:

1. **Planejamento cuidadoso** da arquitetura descentralizada
2. **Implementação gradual** começando com componentes básicos
3. **Testes rigorosos** de cada camada de integração
4. **Monitoramento contínuo** de todos os componentes
5. **Governança descentralizada** com participação dos stakeholders

## 9. Referências e Links

### Blockchain e Distributed Ledger

1. **Hyperledger Fabric Documentation**: https://hyperledger-fabric.readthedocs.io/
2. **Ethereum Developer Documentation**: https://ethereum.org/developers/
3. **Hyperledger Healthcare SIG**: https://wiki.hyperledger.org/display/HYP/Healthcare+SIG
4. **Smart Contracts Best Practices**: https://consensys.github.io/smart-contract-best-practices/
5. **Blockchain in Healthcare Today**: https://blockchainhealthcaretoday.com/

### Radicle e Versionamento Descentralizado

6. **Radicle Documentation**: https://docs.radicle.xyz/
7. **Radicle Protocol Guide**: https://radicle.xyz/guides/protocol
8. **Git for Decentralized Development**: https://radicle.community/t/git-for-decentralized-development/
9. **Radicle CLI Reference**: https://docs.radicle.xyz/guides/cli
10. **P2P Code Collaboration**: https://radicle.xyz/blog/p2p-code-collaboration

### IPFS e Armazenamento Distribuído

11. **IPFS Documentation**: https://docs.ipfs.io/
12. **IPFS JavaScript API**: https://github.com/ipfs/js-ipfs/tree/master/docs/core-api
13. **IPFS Cluster Documentation**: https://cluster.ipfs.io/documentation/
14. **Filecoin for Healthcare**: https://filecoin.io/blog/posts/filecoin-for-healthcare/
15. **Content Addressing**: https://docs.ipfs.io/concepts/content-addressing/

### Identidade Auto-Soberana (SSI/DID)

16. **W3C DID Specification**: https://www.w3.org/TR/did-core/
17. **Verifiable Credentials Data Model**: https://www.w3.org/TR/vc-data-model/
18. **DID Method Registry**: https://www.w3.org/TR/did-spec-registries/
19. **Sovrin Healthcare**: https://sovrin.org/healthcare/
20. **uPort Identity Platform**: https://www.uport.me/

### FHIR e Interoperabilidade

21. **HL7 FHIR R4**: https://hl7.org/fhir/R4/
22. **SMART on FHIR**: https://docs.smarthealthit.org/
23. **FHIR Bulk Data Access**: https://hl7.org/fhir/uv/bulkdata/
24. **FHIR IPS**: http://hl7.org/fhir/uv/ips/
25. **FHIR Consent Resource**: https://hl7.org/fhir/R4/consent.html

### Segurança e Criptografia

26. **NIST Blockchain Technology Overview**: https://nvlpubs.nist.gov/nistpubs/ir/2018/NIST.IR.8202.pdf
27. **Zero-Knowledge Proofs in Healthcare**: https://arxiv.org/abs/2107.09581
28. **Homomorphic Encryption**: https://homomorphicencryption.org/
29. **Healthcare Blockchain Privacy**: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6764776/
30. **GDPR and Blockchain**: https://www.europarl.europa.eu/RegData/etudes/STUD/2019/634445/EPRS_STU(2019)634445_EN.pdf

### Implementações e Casos de Uso

31. **MedRec**: https://medrec.media.mit.edu/
32. **Patientory**: https://patientory.com/
33. **MediLedger**: https://www.mediledger.com/
34. **BurstIQ**: https://www.burstiq.com/
35. **Guardtime Health**: https://guardtime.com/health

### Ferramentas de Desenvolvimento

36. **Truffle Suite**: https://trufflesuite.com/
37. **Hardhat**: https://hardhat.org/
38. **IPFS Desktop**: https://docs.ipfs.io/install/ipfs-desktop/
39. **Hyperledger Composer**: https://hyperledger.github.io/composer/
40. **DID Resolver Libraries**: https://github.com/decentralized-identity/did-resolver

### Padrões e Regulamentações

41. **IEEE Healthcare Blockchain Standards**: https://standards.ieee.org/initiatives/healthcare/
42. **ISO/TC 307 Blockchain Standards**: https://www.iso.org/committee/6266604.html
43. **HIMSS Blockchain in Healthcare**: https://www.himss.org/resources/blockchain-healthcare
44. **FDA Digital Health**: https://www.fda.gov/medical-devices/digital-health-center-excellence
45. **EU Blockchain Observatory**: https://www.eublockchainforum.eu/

### Comunidades e Recursos

46. **Hyperledger Healthcare SIG**: https://wiki.hyperledger.org/display/HYP/Healthcare+SIG
47. **Blockchain in Healthcare Today Journal**: https://blockchainhealthcaretoday.com/
48. **Healthcare Blockchain Review**: https://healthcareblockchain.io/
49. **Decentralized Health Community**: https://discord.gg/decentralizedhealth
50. **Reddit r/HealthcareBlockchain**: https://www.reddit.com/r/healthcareblockchain/

---
**Documento aprovado por:** [Gerência de Inovação e Tecnologia Descentralizada]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026  
**Versão:** 1.0.0  
**Status:** Completo# SOP-013: Descentralização com Blockchain e Radicle para Implementation Guides FHIR

## Resumo Executivo

Este Standard Operating Procedure estabelece diretrizes abrangentes para implementação de sistemas descentralizados em projetos de Implementation Guides FHIR, utilizando tecnologias blockchain (Hyperledger Fabric, Ethereum), sistemas de versionamento distribuído (Radicle), armazenamento descentralizado (IPFS) e identidades auto-soberanas (SSI/DID). O documento aborda desde conceitos fundamentais até implementações práticas, garantindo interoperabilidade, segurança e conformidade regulatória.

## 1. Fundamentos de Descentralização em Saúde

### 1.1 Conceitos Essenciais

**Descentralização**: Distribuição de controle e tomada de decisão entre múltiplos nós independentes, eliminando pontos únicos de falha e autoridades centrais.

**Benefícios em Saúde**:
- **Soberania de dados**: Pacientes mantêm controle sobre seus dados
- **Resiliência**: Sem ponto único de falha
- **Transparência**: Auditoria imutável de todas as transações
- **Interoperabilidade**: Padrões abertos e consensuais
- **Privacidade**: Criptografia e controle granular de acesso

### 1.2 Arquitetura de Referência

```yaml
# Arquitetura Descentralizada para FHIR
architecture:
  layers:
    application:
      - fhir_servers: ["HAPI", "IBM FHIR", "Microsoft FHIR"]
      - smart_apps: ["Clinical apps", "Patient portals"]
    
    middleware:
      - api_gateway: "Kong/Nginx"
      - identity: "DID/SSI providers"
      - consensus: "Blockchain networks"
    
    infrastructure:
      - storage: ["IPFS", "Filecoin", "Arweave"]
      - compute: ["Edge nodes", "Fog computing"]
      - network: ["P2P protocols", "Libp2p"]
    
    governance:
      - smart_contracts: "Chaincode/Solidity"
      - dao: "Decentralized governance"
      - tokenomics: "Incentive mechanisms"
```

## 2. Blockchain para Healthcare

### 2.1 Hyperledger Fabric Implementation

#### 2.1.1 Configuração da Rede

```yaml
# network-config.yaml
version: '2.0'

organizations:
  - &Hospital1
    Name: Hospital1MSP
    ID: Hospital1MSP
    MSPDir: crypto-config/peerOrganizations/hospital1.example.com/msp
    Policies:
      Readers:
        Type: Signature
        Rule: "OR('Hospital1MSP.member')"
      Writers:
        Type: Signature
        Rule: "OR('Hospital1MSP.member')"
      Admins:
        Type: Signature
        Rule: "OR('Hospital1MSP.admin')"
    AnchorPeers:
      - Host: peer0.hospital1.example.com
        Port: 7051

  - &Clinic1
    Name: Clinic1MSP
    ID: Clinic1MSP
    MSPDir: crypto-config/peerOrganizations/clinic1.example.com/msp
    Policies:
      Readers:
        Type: Signature
        Rule: "OR('Clinic1MSP.member')"
      Writers:
        Type: Signature
        Rule: "OR('Clinic1MSP.member')"
      Admins:
        Type: Signature
        Rule: "OR('Clinic1MSP.admin')"
    AnchorPeers:
      - Host: peer0.clinic1.example.com
        Port: 8051

capabilities:
  Channel: &ChannelCapabilities
    V2_0: true
  Orderer: &OrdererCapabilities
    V2_0: true
  Application: &ApplicationCapabilities
    V2_0: true

application: &ApplicationDefaults
  Organizations:
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
    LifecycleEndorsement:
      Type: ImplicitMeta
      Rule: "MAJORITY Endorsement"
    Endorsement:
      Type: ImplicitMeta
      Rule: "MAJORITY Endorsement"
  Capabilities:
    <<: *ApplicationCapabilities

orderer: &OrdererDefaults
  OrdererType: etcdraft
  Addresses:
    - orderer.example.com:7050
  EtcdRaft:
    Consenters:
      - Host: orderer.example.com
        Port: 7050
        ClientTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
        ServerTLSCert: crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  BatchTimeout: 2s
  BatchSize:
    MaxMessageCount: 10
    AbsoluteMaxBytes: 99 MB
    PreferredMaxBytes: 512 KB

channel: &ChannelDefaults
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
  Capabilities:
    <<: *ChannelCapabilities

profiles:
  HealthcareOrdererGenesis:
    <<: *ChannelDefaults
    Orderer:
      <<: *OrdererDefaults
      Organizations:
        - *OrdererOrg
      Capabilities:
        <<: *OrdererCapabilities
    Consortiums:
      HealthcareConsortium:
        Organizations:
          - *Hospital1
          - *Clinic1
  
  HealthcareChannel:
    Consortium: HealthcareConsortium
    <<: *ChannelDefaults
    Application:
      <<: *ApplicationDefaults
      Organizations:
        - *Hospital1
        - *Clinic1
      Capabilities:
        <<: *ApplicationCapabilities
```

#### 2.1.2 Smart Contracts (Chaincode) para FHIR

```javascript
// fhir-chaincode.js
const { Contract } = require('fabric-contract-api');

class FHIRContract extends Contract {
    
    async initLedger(ctx) {
        console.info('Initializing FHIR Ledger');
        const resources = [
            {
                resourceType: 'Patient',
                id: 'patient-001',
                hash: 'sha256:initial',
                timestamp: new Date().toISOString(),
                owner: 'Hospital1MSP'
            }
        ];
        
        for (const resource of resources) {
            await ctx.stub.putState(
                resource.id, 
                Buffer.from(JSON.stringify(resource))
            );
        }
    }
    
    // Registrar novo recurso FHIR
    async createFHIRResource(ctx, resourceId, resourceType, dataHash, owner) {
        const resource = {
            resourceType,
            id: resourceId,
            hash: dataHash,
            timestamp: new Date().toISOString(),
            owner,
            docType: 'fhirResource',
            status: 'active'
        };
        
        await ctx.stub.putState(resourceId, Buffer.from(JSON.stringify(resource)));
        
        // Emit event
        await ctx.stub.setEvent('FHIRResourceCreated', Buffer.from(JSON.stringify({
            resourceId,
            resourceType,
            owner,
            timestamp: resource.timestamp
        })));
        
        return JSON.stringify(resource);
    }
    
    // Atualizar recurso com nova versão
    async updateFHIRResource(ctx, resourceId, newHash, modifier) {
        const resourceAsBytes = await ctx.stub.getState(resourceId);
        if (!resourceAsBytes || resourceAsBytes.length === 0) {
            throw new Error(`Resource ${resourceId} does not exist`);
        }
        
        const resource = JSON.parse(resourceAsBytes.toString());
        
        // Criar histórico de versão
        const history = {
            resourceId,
            previousHash: resource.hash,
            newHash,
            modifier,
            timestamp: new Date().toISOString(),
            docType: 'versionHistory'
        };
        
        // Salvar histórico
        const historyKey = `${resourceId}_history_${Date.now()}`;
        await ctx.stub.putState(historyKey, Buffer.from(JSON.stringify(history)));
        
        // Atualizar recurso
        resource.hash = newHash;
        resource.lastModified = history.timestamp;
        resource.lastModifier = modifier;
        
        await ctx.stub.putState(resourceId, Buffer.from(JSON.stringify(resource)));
        
        return JSON.stringify(resource);
    }
    
    // Gerenciar consentimento do paciente
    async manageConsent(ctx, patientId, providerId, scope, action) {
        const consentKey = `consent_${patientId}_${providerId}`;
        
        const consent = {
            patientId,
            providerId,
            scope, // 'read', 'write', 'full'
            action, // 'grant', 'revoke'
            timestamp: new Date().toISOString(),
            docType: 'consent'
        };
        
        if (action === 'revoke') {
            consent.status = 'revoked';
        } else {
            consent.status = 'active';
        }
        
        await ctx.stub.putState(consentKey, Buffer.from(JSON.stringify(consent)));
        
        // Emit consent event
        await ctx.stub.setEvent('ConsentChanged', Buffer.from(JSON.stringify(consent)));
        
        return JSON.stringify(consent);
    }
    
    // Verificar consentimento
    async checkConsent(ctx, patientId, providerId) {
        const consentKey = `consent_${patientId}_${providerId}`;
        const consentAsBytes = await ctx.stub.getState(consentKey);
        
        if (!consentAsBytes || consentAsBytes.length === 0) {
            return JSON.stringify({ hasConsent: false });
        }
        
        const consent = JSON.parse(consentAsBytes.toString());
        return JSON.stringify({
            hasConsent: consent.status === 'active',
            scope: consent.scope,
            grantedAt: consent.timestamp
        });
    }
    
    // Auditoria de acesso
    async logAccess(ctx, resourceId, accessor, action, purpose) {
        const audit = {
            resourceId,
            accessor,
            action, // 'read', 'write', 'delete'
            purpose,
            timestamp: new Date().toISOString(),
            docType: 'auditLog'
        };
        
        const auditKey = `audit_${resourceId}_${Date.now()}`;
        await ctx.stub.putState(auditKey, Buffer.from(JSON.stringify(audit)));
        
        return JSON.stringify(audit);
    }
    
    // Query com CouchDB
    async queryResourcesByType(ctx, resourceType) {
        const queryString = {
            selector: {
                docType: 'fhirResource',
                resourceType: resourceType
            }
        };
        
        const iterator = await ctx.stub.getQueryResult(JSON.stringify(queryString));
        const results = await this._getIteratorResults(iterator);
        return JSON.stringify(results);
    }
    
    // Helper para processar iteradores
    async _getIteratorResults(iterator) {
        const results = [];
        let result = await iterator.next();
        
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            results.push(record);
            result = await iterator.next();
        }
        await iterator.close();
        return results;
    }
}

module.exports = FHIRContract;
```

### 2.2 Integração com Ethereum para Tokens e Incentivos

```solidity
// FHIRToken.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract FHIRHealthToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    
    mapping(address => uint256) public healthDataContributions;
    mapping(address => uint256) public rewardsClaimed;
    
    event DataContributed(address indexed contributor, uint256 dataPoints, uint256 reward);
    event RewardClaimed(address indexed claimant, uint256 amount);
    
    constructor() ERC20("FHIR Health Token", "FHT") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }
    
    function contributeHealthData(
        address contributor,
        uint256 dataPoints,
        string memory dataHash
    ) external onlyRole(MINTER_ROLE) {
        require(dataPoints > 0, "Invalid data points");
        
        // Calculate reward based on data contribution
        uint256 reward = calculateReward(dataPoints);
        
        // Mint tokens as reward
        _mint(contributor, reward);
        
        // Track contribution
        healthDataContributions[contributor] += dataPoints;
        
        emit DataContributed(contributor, dataPoints, reward);
    }
    
    function calculateReward(uint256 dataPoints) public pure returns (uint256) {
        // Reward formula: 10 tokens per data point with diminishing returns
        if (dataPoints <= 100) {
            return dataPoints * 10 * 10**18;
        } else if (dataPoints <= 1000) {
            return (100 * 10 + (dataPoints - 100) * 5) * 10**18;
        } else {
            return (100 * 10 + 900 * 5 + (dataPoints - 1000) * 2) * 10**18;
        }
    }
    
    function claimResearchReward(
        address researcher,
        uint256 amount,
        bytes memory signature
    ) external {
        // Verify signature from oracle/validator
        require(verifyResearchContribution(researcher, amount, signature), "Invalid signature");
        
        _mint(researcher, amount);
        rewardsClaimed[researcher] += amount;
        
        emit RewardClaimed(researcher, amount);
    }
    
    function verifyResearchContribution(
        address researcher,
        uint256 amount,
        bytes memory signature
    ) internal view returns (bool) {
        // Implement signature verification logic
        // This would verify that a trusted oracle has validated the research contribution
        return true; // Placeholder
    }
}
```

## 3. Radicle para Versionamento Descentralizado

### 3.1 Configuração Inicial do Radicle

```bash
#!/bin/bash
# radicle-setup.sh - Setup completo do Radicle para FHIR IGs

# Instalação do Radicle
echo "📦 Instalando Radicle..."
curl -sSf https://radicle.xyz/install | sh

# Configurar identidade
echo "🔑 Configurando identidade Radicle..."
rad auth init --alias "fhir-ig-developer"

# Inicializar projeto FHIR IG
echo "🚀 Inicializando projeto FHIR IG..."
cd /path/to/fhir-ig-project

rad init \
  --name "FHIR-IG-Lifestyle-Medicine" \
  --description "Implementation Guide for Lifestyle Medicine with wearable data integration" \
  --default-branch "main" \
  --public

# Configurar metadados do projeto
cat > .rad/project.json << EOF
{
  "name": "FHIR-IG-Lifestyle-Medicine",
  "description": "Implementation Guide for Lifestyle Medicine",
  "defaultBranch": "main",
  "delegates": [],
  "threshold": 1,
  "visibility": {
    "type": "public"
  },
  "extensions": {
    "fhir": {
      "version": "R4",
      "profiles": ["Observation", "Patient", "Device"],
      "terminology": {
        "systems": ["LOINC", "SNOMED-CT"],
        "valueSets": ["vital-signs", "lifestyle-metrics"]
      }
    }
  }
}
EOF

# Adicionar colaboradores
rad delegate add did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK

# Push inicial
git add .
git commit -m "Initial FHIR IG structure with Radicle configuration"
rad push

# Exibir URN do projeto
echo "✅ Projeto criado com sucesso!"
echo "URN do projeto:"
rad ls | grep "FHIR-IG-Lifestyle-Medicine"
```

### 3.2 Workflow de Colaboração Descentralizada

```bash
#!/bin/bash
# radicle-collaboration.sh - Workflow colaborativo

# 1. Clonar projeto via Radicle
rad clone rad:z3gqcJUoA1n9HaHKufZs5FCSGazv5 --name fhir-ig-lifestyle

# 2. Criar branch para nova feature
cd fhir-ig-lifestyle
git checkout -b feature/add-sleep-profiles

# 3. Desenvolver profiles FSH
cat > input/fsh/profiles/SleepObservation.fsh << 'EOF'
Profile: SleepObservation
Parent: Observation
Id: sleep-observation
Title: "Sleep Observation Profile"
Description: "Profile for sleep data from wearables"

* status = #final
* code from SleepMetricsVS (required)
* subject only Reference(Patient)
* device only Reference(Device)
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    sleepDuration 0..1 and
    sleepEfficiency 0..1 and
    remSleep 0..1
EOF

# 4. Commit e push para Radicle
git add input/fsh/profiles/
git commit -m "feat: Add sleep observation profiles for wearables"
rad push

# 5. Criar patch para revisão
rad patch create \
  --title "Add sleep observation profiles" \
  --description "Implements FHIR profiles for sleep data from wearables" \
  --target main

# 6. Listar patches pendentes
rad patch list

# 7. Revisar e discutir patch
rad patch show <patch-id>
rad patch comment <patch-id> --message "LGTM, mas sugiro adicionar validação"

# 8. Aprovar e fazer merge do patch
rad patch accept <patch-id>
rad patch merge <patch-id>

# 9. Sincronizar com todos os peers
rad sync --fetch
rad push