# SOP-018: Gestão de APIs e Interfaces FHIR

**Versão:** 1.0.0  
**Data de Criação:** 2024  
**Última Atualização:** 2024  
**Responsável:** Equipe de Interoperabilidade  
**Status:** Ativo

## 1. OBJETIVO

Estabelecer procedimentos padronizados para desenvolvimento, gestão, monitoramento e manutenção de APIs FHIR e interfaces de integração, garantindo alta disponibilidade, segurança e conformidade com padrões RESTful e especificações HL7 FHIR¹.

## 2. ESCOPO

Este SOP abrange:
- Design e desenvolvimento de APIs FHIR
- Gestão de ciclo de vida de APIs
- Autenticação e autorização (OAuth 2.0, SMART on FHIR)
- Monitoramento e observabilidade
- Versionamento e retrocompatibilidade
- Rate limiting e throttling
- Documentação e descoberta de serviços

## 3. DEFINIÇÕES E CONCEITOS

### 3.1 Fundamentos Teóricos

**RESTful FHIR API Architecture**: Segundo a especificação FHIR RESTful API², as interfaces devem implementar:
- **Operações CRUD**: Create, Read, Update, Delete sobre recursos
- **Operações de Pesquisa**: Parâmetros padronizados e chains
- **Operações Customizadas**: Operations framework ($operation)
- **Operações em Lote**: Batch e Transaction bundles
- **Versionamento**: ETags e version-aware updates

**SMART on FHIR**: Framework de autorização³ que define:
- Fluxos OAuth 2.0 para aplicações clínicas
- Scopes granulares por recurso e ação
- Launch contexts (EHR, standalone)
- Refresh tokens e gestão de sessão

### 3.2 Padrões de Interface

**HL7 FHIR Conformance Framework**⁴:
- CapabilityStatement para descoberta de serviços
- StructureDefinition para validação
- OperationDefinition para operações customizadas
- SearchParameter para extensão de busca

## 4. RESPONSABILIDADES

### 4.1 Arquiteto de APIs
- Definir contratos de interface
- Aprovar mudanças breaking
- Estabelecer políticas de versionamento

### 4.2 Equipe de Desenvolvimento
- Implementar endpoints conforme especificação
- Manter documentação atualizada
- Realizar testes de integração

### 4.3 Equipe de Operações
- Monitorar disponibilidade e performance
- Gerenciar certificados e credenciais
- Escalar infraestrutura conforme demanda

## 5. PROCEDIMENTOS - PARTE TEÓRICA

### 5.1 Arquitetura de APIs FHIR

**Camadas da Arquitetura**⁵:

1. **Camada de Apresentação**:
   - API Gateway para roteamento
   - Load balancer para distribuição
   - CDN para conteúdo estático

2. **Camada de Segurança**:
   - WAF (Web Application Firewall)
   - OAuth 2.0 Authorization Server
   - Token validation e introspection

3. **Camada de Negócio**:
   - FHIR Server implementation
   - Business logic e validações
   - Orchestration services

4. **Camada de Dados**:
   - Repository pattern
   - Cache layer (Redis)
   - Persistence (PostgreSQL, MongoDB)

### 5.2 Modelo de Maturidade Richardson

Implementação seguindo o Richardson Maturity Model⁶:

**Nível 0**: RPC sobre HTTP
**Nível 1**: Recursos individuais
**Nível 2**: Verbos HTTP e status codes
**Nível 3**: HATEOAS (Hypermedia)

FHIR APIs devem atingir minimamente Nível 2, com Nível 3 recomendado através de Bundle.link.

## 6. PROCEDIMENTOS - PARTE PRÁTICA

### 6.1 Implementação de FHIR Server

```javascript
// server/fhirServer.js
const express = require('express');
const { Strategy } = require('passport-http-bearer');
const FHIRValidator = require('./validators/fhirValidator');
const AuditLogger = require('./audit/auditLogger');

class FHIRServer {
  constructor(config) {
    this.app = express();
    this.config = config;
    this.validator = new FHIRValidator(config.profiles);
    this.auditLogger = new AuditLogger(config.audit);
    
    this.setupMiddleware();
    this.setupRoutes();
    this.setupErrorHandling();
  }
  
  setupMiddleware() {
    // CORS Configuration
    this.app.use((req, res, next) => {
      res.header('Access-Control-Allow-Origin', '*');
      res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,PATCH,OPTIONS');
      res.header('Access-Control-Allow-Headers', 
        'Content-Type, Authorization, Content-Location, Location, Prefer');
      res.header('Access-Control-Expose-Headers', 
        'Content-Location, Location, ETag, Last-Modified');
      
      if (req.method === 'OPTIONS') {
        return res.sendStatus(200);
      }
      next();
    });
    
    // Body parsing
    this.app.use(express.json({ 
      type: ['application/fhir+json', 'application/json'],
      limit: '50mb' 
    }));
    
    // Request ID injection
    this.app.use((req, res, next) => {
      req.id = req.headers['x-request-id'] || generateUUID();
      res.setHeader('X-Request-Id', req.id);
      next();
    });
    
    // Rate limiting
    const rateLimit = require('express-rate-limit');
    this.app.use(rateLimit({
      windowMs: 60 * 1000, // 1 minute
      max: this.config.rateLimit || 100,
      message: {
        resourceType: 'OperationOutcome',
        issue: [{
          severity: 'error',
          code: 'throttled',
          diagnostics: 'Rate limit exceeded. Please try again later.'
        }]
      }
    }));
  }
  
  setupRoutes() {
    // Metadata endpoint
    this.app.get('/metadata', (req, res) => {
      res.json(this.generateCapabilityStatement());
    });
    
    // Resource type routes
    const resourceTypes = ['Patient', 'Observation', 'Encounter', 'Condition'];
    
    resourceTypes.forEach(resourceType => {
      const router = express.Router();
      
      // Search
      router.get('/', this.authenticate, async (req, res) => {
        try {
          const bundle = await this.search(resourceType, req.query, req.user);
          await this.auditLogger.log('search', resourceType, req.user, bundle);
          res.json(bundle);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      // Create
      router.post('/', this.authenticate, this.authorize('write'), async (req, res) => {
        try {
          // Validate resource
          const validationResult = await this.validator.validate(req.body);
          if (!validationResult.valid) {
            return res.status(400).json(validationResult.operationOutcome);
          }
          
          const resource = await this.create(resourceType, req.body, req.user);
          await this.auditLogger.log('create', resourceType, req.user, resource);
          
          res.status(201)
             .location(`${this.config.baseUrl}/${resourceType}/${resource.id}`)
             .json(resource);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      // Read
      router.get('/:id', this.authenticate, async (req, res) => {
        try {
          const resource = await this.read(resourceType, req.params.id, req.user);
          
          if (!resource) {
            return res.status(404).json({
              resourceType: 'OperationOutcome',
              issue: [{
                severity: 'error',
                code: 'not-found',
                diagnostics: `${resourceType}/${req.params.id} not found`
              }]
            });
          }
          
          await this.auditLogger.log('read', resourceType, req.user, resource);
          
          res.setHeader('ETag', `W/"${resource.meta.versionId}"`);
          res.setHeader('Last-Modified', resource.meta.lastUpdated);
          res.json(resource);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      // Update
      router.put('/:id', this.authenticate, this.authorize('write'), async (req, res) => {
        try {
          // Check If-Match header for version conflict
          const ifMatch = req.headers['if-match'];
          if (ifMatch) {
            const current = await this.read(resourceType, req.params.id);
            if (current && `W/"${current.meta.versionId}"` !== ifMatch) {
              return res.status(409).json({
                resourceType: 'OperationOutcome',
                issue: [{
                  severity: 'error',
                  code: 'conflict',
                  diagnostics: 'Version conflict. Resource has been modified.'
                }]
              });
            }
          }
          
          const resource = await this.update(
            resourceType, 
            req.params.id, 
            req.body, 
            req.user
          );
          
          await this.auditLogger.log('update', resourceType, req.user, resource);
          
          res.setHeader('ETag', `W/"${resource.meta.versionId}"`);
          res.json(resource);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      // Patch
      router.patch('/:id', this.authenticate, this.authorize('write'), async (req, res) => {
        try {
          const patches = req.body;
          const resource = await this.patch(
            resourceType, 
            req.params.id, 
            patches, 
            req.user
          );
          
          await this.auditLogger.log('patch', resourceType, req.user, resource);
          res.json(resource);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      // Delete
      router.delete('/:id', this.authenticate, this.authorize('write'), async (req, res) => {
        try {
          await this.delete(resourceType, req.params.id, req.user);
          await this.auditLogger.log('delete', resourceType, req.user, { id: req.params.id });
          res.sendStatus(204);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      // History
      router.get('/:id/_history', this.authenticate, async (req, res) => {
        try {
          const bundle = await this.history(resourceType, req.params.id, req.user);
          res.json(bundle);
        } catch (error) {
          this.handleError(error, res);
        }
      });
      
      this.app.use(`/${resourceType}`, router);
    });
    
    // Batch/Transaction endpoint
    this.app.post('/', this.authenticate, async (req, res) => {
      if (req.body.resourceType !== 'Bundle' || 
          !['batch', 'transaction'].includes(req.body.type)) {
        return res.status(400).json({
          resourceType: 'OperationOutcome',
          issue: [{
            severity: 'error',
            code: 'invalid',
            diagnostics: 'Expected Bundle resource with type batch or transaction'
          }]
        });
      }
      
      try {
        const responseBundle = await this.processBundle(req.body, req.user);
        res.json(responseBundle);
      } catch (error) {
        this.handleError(error, res);
      }
    });
  }
  
  generateCapabilityStatement() {
    return {
      resourceType: 'CapabilityStatement',
      id: 'server-capability-statement',
      version: this.config.version,
      name: this.config.name,
      title: this.config.title,
      status: 'active',
      date: new Date().toISOString(),
      publisher: this.config.publisher,
      kind: 'instance',
      software: {
        name: 'FHIR Server',
        version: this.config.version
      },
      implementation: {
        description: this.config.description,
        url: this.config.baseUrl
      },
      fhirVersion: '4.0.1',
      format: ['json', 'xml'],
      rest: [{
        mode: 'server',
        security: {
          cors: true,
          service: [{
            coding: [{
              system: 'http://terminology.hl7.org/CodeSystem/restful-security-service',
              code: 'SMART-on-FHIR'
            }]
          }],
          description: 'OAuth2 using SMART-on-FHIR profile'
        },
        resource: this.generateResourceCapabilities(),
        interaction: [
          { code: 'batch' },
          { code: 'transaction' },
          { code: 'search-system' }
        ]
      }]
    };
  }
}
```

### 6.2 Implementação de OAuth 2.0 e SMART on FHIR

```javascript
// auth/smartAuthServer.js
const express = require('express');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

class SMARTAuthorizationServer {
  constructor(config) {
    this.app = express();
    this.config = config;
    this.clients = new Map(); // Client registry
    this.authCodes = new Map(); // Temporary auth codes
    this.tokens = new Map(); // Active tokens
    
    this.setupRoutes();
  }
  
  setupRoutes() {
    // Discovery endpoint
    this.app.get('/.well-known/smart-configuration', (req, res) => {
      res.json({
        authorization_endpoint: `${this.config.baseUrl}/authorize`,
        token_endpoint: `${this.config.baseUrl}/token`,
        token_endpoint_auth_methods_supported: ['client_secret_basic', 'client_secret_post'],
        registration_endpoint: `${this.config.baseUrl}/register`,
        scopes_supported: [
          'launch', 'launch/patient', 'launch/encounter',
          'patient/*.read', 'patient/*.write',
          'user/*.read', 'user/*.write',
          'offline_access', 'online_access'
        ],
        response_types_supported: ['code', 'token'],
        introspection_endpoint: `${this.config.baseUrl}/introspect`,
        revocation_endpoint: `${this.config.baseUrl}/revoke`,
        capabilities: [
          'launch-ehr', 'launch-standalone',
          'client-public', 'client-confidential-symmetric',
          'context-passthrough-banner', 'context-passthrough-style',
          'context-ehr-patient', 'context-ehr-encounter',
          'permission-offline', 'permission-patient', 'permission-user'
        ],
        code_challenge_methods_supported: ['S256']
      });
    });
    
    // Authorization endpoint
    this.app.get('/authorize', (req, res) => {
      const {
        response_type,
        client_id,
        redirect_uri,
        scope,
        state,
        aud,
        launch,
        code_challenge,
        code_challenge_method
      } = req.query;
      
      // Validate client
      const client = this.clients.get(client_id);
      if (!client) {
        return res.status(400).json({
          error: 'invalid_client',
          error_description: 'Client not found'
        });
      }
      
      // Validate redirect URI
      if (!client.redirect_uris.includes(redirect_uri)) {
        return res.status(400).json({
          error: 'invalid_request',
          error_description: 'Invalid redirect URI'
        });
      }
      
      // Generate authorization code
      const code = crypto.randomBytes(32).toString('hex');
      const authCodeData = {
        client_id,
        redirect_uri,
        scope,
        state,
        aud,
        launch,
        code_challenge,
        code_challenge_method,
        expires: Date.now() + 600000 // 10 minutes
      };
      
      this.authCodes.set(code, authCodeData);
      
      // In production, show consent screen here
      // For demo, auto-approve
      const redirectUrl = new URL(redirect_uri);
      redirectUrl.searchParams.append('code', code);
      if (state) {
        redirectUrl.searchParams.append('state', state);
      }
      
      res.redirect(redirectUrl.toString());
    });
    
    // Token endpoint
    this.app.post('/token', express.urlencoded({ extended: true }), async (req, res) => {
      const {
        grant_type,
        code,
        redirect_uri,
        client_id,
        client_secret,
        code_verifier,
        refresh_token
      } = req.body;
      
      // Validate client credentials
      const client = this.validateClient(client_id, client_secret, req);
      if (!client) {
        return res.status(401).json({
          error: 'invalid_client',
          error_description: 'Client authentication failed'
        });
      }
      
      if (grant_type === 'authorization_code') {
        // Exchange auth code for token
        const authCodeData = this.authCodes.get(code);
        
        if (!authCodeData || authCodeData.expires < Date.now()) {
          return res.status(400).json({
            error: 'invalid_grant',
            error_description: 'Invalid or expired authorization code'
          });
        }
        
        // Validate PKCE if present
        if (authCodeData.code_challenge) {
          const challenge = crypto
            .createHash('sha256')
            .update(code_verifier)
            .digest('base64url');
            
          if (challenge !== authCodeData.code_challenge) {
            return res.status(400).json({
              error: 'invalid_grant',
              error_description: 'PKCE verification failed'
            });
          }
        }
        
        // Generate tokens
        const tokens = this.generateTokens(client, authCodeData);
        
        // Clean up auth code
        this.authCodes.delete(code);
        
        // Store token for introspection
        this.tokens.set(tokens.access_token, {
          client_id,
          scope: authCodeData.scope,
          expires: Date.now() + 3600000,
          patient: authCodeData.launch?.patient,
          encounter: authCodeData.launch?.encounter
        });
        
        res.json(tokens);
        
      } else if (grant_type === 'refresh_token') {
        // Refresh token flow
        const tokenData = this.validateRefreshToken(refresh_token);
        
        if (!tokenData) {
          return res.status(400).json({
            error: 'invalid_grant',
            error_description: 'Invalid refresh token'
          });
        }
        
        const tokens = this.generateTokens(client, tokenData);
        res.json(tokens);
        
      } else {
        res.status(400).json({
          error: 'unsupported_grant_type',
          error_description: `Grant type ${grant_type} not supported`
        });
      }
    });
    
    // Introspection endpoint
    this.app.post('/introspect', express.urlencoded({ extended: true }), (req, res) => {
      const { token, token_type_hint } = req.body;
      
      const tokenData = this.tokens.get(token);
      
      if (!tokenData || tokenData.expires < Date.now()) {
        return res.json({ active: false });
      }
      
      res.json({
        active: true,
        scope: tokenData.scope,
        client_id: tokenData.client_id,
        exp: Math.floor(tokenData.expires / 1000),
        patient: tokenData.patient,
        encounter: tokenData.encounter
      });
    });
    
    // Revocation endpoint
    this.app.post('/revoke', express.urlencoded({ extended: true }), (req, res) => {
      const { token, token_type_hint } = req.body;
      
      this.tokens.delete(token);
      res.sendStatus(200);
    });
  }
  
  generateTokens(client, authData) {
    const accessToken = jwt.sign(
      {
        sub: client.id,
        iss: this.config.issuer,
        aud: authData.aud || this.config.baseUrl,
        exp: Math.floor(Date.now() / 1000) + 3600,
        scope: authData.scope,
        patient: authData.launch?.patient,
        encounter: authData.launch?.encounter
      },
      this.config.jwtSecret
    );
    
    const response = {
      access_token: accessToken,
      token_type: 'Bearer',
      expires_in: 3600,
      scope: authData.scope
    };
    
    if (authData.scope?.includes('offline_access')) {
      response.refresh_token = crypto.randomBytes(32).toString('hex');
    }
    
    if (authData.launch?.patient) {
      response.patient = authData.launch.patient;
    }
    
    if (authData.launch?.encounter) {
      response.encounter = authData.launch.encounter;
    }
    
    return response;
  }
  
  validateClient(clientId, clientSecret, req) {
    const client = this.clients.get(clientId);
    if (!client) return null;
    
    // Check Basic auth header
    const authHeader = req.headers.authorization;
    if (authHeader?.startsWith('Basic ')) {
      const credentials = Buffer.from(
        authHeader.slice(6), 
        'base64'
      ).toString().split(':');
      
      if (credentials[0] === clientId && credentials[1] === clientSecret) {
        return client;
      }
    }
    
    // Check POST body
    if (clientSecret === client.secret) {
      return client;
    }
    
    return null;
  }
}
```

### 6.3 API Gateway e Rate Limiting

```javascript
// gateway/apiGateway.js
const express = require('express');
const httpProxy = require('http-proxy-middleware');
const CircuitBreaker = require('opossum');

class FHIRAPIGateway {
  constructor(config) {
    this.app = express();
    this.config = config;
    this.circuitBreakers = new Map();
    
    this.setupMiddleware();
    this.setupRouting();
    this.setupMonitoring();
  }
  
  setupMiddleware() {
    // Request logging
    const morgan = require('morgan');
    this.app.use(morgan('combined'));
    
    // Rate limiting with Redis
    const RedisStore = require('rate-limit-redis');
    const rateLimit = require('express-rate-limit');
    
    this.app.use(rateLimit({
      store: new RedisStore({
        client: this.config.redisClient,
        prefix: 'rl:'
      }),
      windowMs: 60 * 1000,
      max: (req) => {
        // Different limits based on auth and endpoint
        if (req.path === '/metadata') return 1000;
        if (req.headers.authorization) return 200;
        return 50;
      },
      keyGenerator: (req) => {
        // Rate limit by API key or IP
        const apiKey = req.headers['x-api-key'];
        if (apiKey) return `key:${apiKey}`;
        return `ip:${req.ip}`;
      },
      handler: (req, res) => {
        res.status(429).json({
          resourceType: 'OperationOutcome',
          issue: [{
            severity: 'error',
            code: 'throttled',
            diagnostics: 'Rate limit exceeded',
            extension: [{
              url: 'http://hl7.org/fhir/StructureDefinition/operationoutcome-retry-after',
              valueInteger: 60
            }]
          }]
        });
      }
    }));
    
    // API key validation
    this.app.use((req, res, next) => {
      const apiKey = req.headers['x-api-key'];
      
      if (apiKey) {
        // Validate API key
        this.validateAPIKey(apiKey)
          .then(valid => {
            if (!valid) {
              return res.status(401).json({
                resourceType: 'OperationOutcome',
                issue: [{
                  severity: 'error',
                  code: 'security',
                  diagnostics: 'Invalid API key'
                }]
              });
            }
            next();
          })
          .catch(next);
      } else {
        next();
      }
    });
  }
  
  setupRouting() {
    // Service discovery
    const services = {
      'patient': {
        target: 'http://patient-service:3000',
        changeOrigin: true,
        pathRewrite: { '^/api/v1': '' }
      },
      'observation': {
        target: 'http://observation-service:3001',
        changeOrigin: true,
        pathRewrite: { '^/api/v1': '' }
      },
      'encounter': {
        target: 'http://encounter-service:3002',
        changeOrigin: true,
        pathRewrite: { '^/api/v1': '' }
      }
    };
    
    // Create circuit breakers for each service
    Object.keys(services).forEach(service => {
      const breaker = new CircuitBreaker(
        httpProxy.createProxyMiddleware(services[service]),
        {
          timeout: 5000,
          errorThresholdPercentage: 50,
          resetTimeout: 30000
        }
      );
      
      breaker.fallback(() => ({
        resourceType: 'OperationOutcome',
        issue: [{
          severity: 'error',
          code: 'timeout',
          diagnostics: `Service ${service} is temporarily unavailable`
        }]
      }));
      
      this.circuitBreakers.set(service, breaker);
    });
    
    // Route to appropriate service based on resource type
    this.app.use('/api/v1/:resourceType', (req, res, next) => {
      const resourceType = req.params.resourceType.toLowerCase();
      const breaker = this.circuitBreakers.get(resourceType);
      
      if (!breaker) {
        return res.status(404).json({
          resourceType: 'OperationOutcome',
          issue: [{
            severity: 'error',
            code: 'not-supported',
            diagnostics: `Resource type ${req.params.resourceType} not supported`
          }]
        });
      }
      
      breaker.fire(req, res, next);
    });
  }
  
  setupMonitoring() {
    const prometheus = require('prom-client');
    const register = new prometheus.Registry();
    
    // Metrics
    const httpDuration = new prometheus.Histogram({
      name: 'http_request_duration_seconds',
      help: 'Duration of HTTP requests in seconds',
      labelNames: ['method', 'route', 'status'],
      buckets: [0.1, 0.5, 1, 2, 5]
    });
    
    const httpRequests = new prometheus.Counter({
      name: 'http_requests_total',
      help: 'Total number of HTTP requests',
      labelNames: ['method', 'route', 'status']
    });
    
    register.registerMetric(httpDuration);
    register.registerMetric(httpRequests);
    
    // Middleware to collect metrics
    this.app.use((req, res, next) => {
      const start = Date.now();
      
      res.on('finish', () => {
        const duration = (Date.now() - start) / 1000;
        const labels = {
          method: req.method,
          route: req.route?.path || req.path,
          status: res.statusCode
        };
        
        httpDuration.observe(labels, duration);
        httpRequests.inc(labels);
      });
      
      next();
    });
    
    // Metrics endpoint
    this.app.get('/metrics', (req, res) => {
      res.set('Content-Type', register.contentType);
      res.end(register.metrics());
    });
    
    // Health check endpoint
    this.app.get('/health', async (req, res) => {
      const health = {
        status: 'UP',
        timestamp: new Date().toISOString(),
        services: {}
      };
      
      for (const [name, breaker] of this.circuitBreakers) {
        health.services[name] = {
          status: breaker.opened ? 'DOWN' : 'UP',
          stats: breaker.stats
        };
      }
      
      const overallStatus = Object.values(health.services)
        .every(s => s.status === 'UP');
      
      health.status = overallStatus ? 'UP' : 'DEGRADED';
      
      res.status(overallStatus ? 200 : 503).json(health);
    });
  }
}
```

### 6.4 Documentação OpenAPI/Swagger

```yaml
# api-docs/fhir-api.yaml
openapi: 3.0.3
info:
  title: FHIR API
  description: RESTful FHIR API Implementation
  version: 1.0.0
  contact:
    name: API Support
    email: api-support@example.org
  license:
    name: Apache 2.0
    url: https://www.apache.org/licenses/LICENSE-2.0

servers:
  - url: https://api.example.org/fhir/r4
    description: Production server
  - url: https://staging-api.example.org/fhir/r4
    description: Staging server

security:
  - BearerAuth: []
  - ApiKeyAuth: []

paths:
  /metadata:
    get:
      summary: Get Capability Statement
      operationId: getMetadata
      tags:
        - System
      responses:
        '200':
          description: Capability Statement
          content:
            application/fhir+json:
              schema:
                $ref: '#/components/schemas/CapabilityStatement'

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
```

## 7. MÉTRICAS E INDICADORES

### 7.1 KPIs de Performance

**Métricas Primárias**⁷:
- **Latência média de resposta**: <200ms para 95% das requisições
- **Taxa de disponibilidade**: >99.9% (menos de 8.76 horas de downtime/ano)
- **Taxa de erro**: <0.1% das requisições
- **Throughput**: >1000 requisições por segundo

### 7.2 Métricas de Segurança

**Indicadores de Segurança**⁸:
- Taxa de autenticação bem-sucedida (>98%)
- Tentativas de acesso não autorizado (<100/dia)
- Tempo médio de detecção de incidentes (<5 minutos)
- Taxa de conformidade com políticas (100%)

## 8. FERRAMENTAS E RECURSOS

### 8.1 Ferramentas Recomendadas

1. **Postman/Insomnia**: Testes manuais de API
2. **Swagger UI**: Documentação interativa
3. **Kong/Apigee**: API Gateway empresarial
4. **Prometheus/Grafana**: Stack de monitoramento
5. **OAuth2 Proxy**: Camada de autenticação

### 8.2 Bibliotecas e SDKs

**Principais bibliotecas por linguagem**⁹:
- **Java**: HAPI FHIR (v6.8.0+)
- **JavaScript/TypeScript**: FHIR.js, fhirclient
- **.NET**: fhir-net-api, Firely SDK
- **Python**: fhirclient, fhir.resources

## 9. RESOLUÇÃO DE PROBLEMAS

### 9.1 Problemas Comuns e Soluções

| Problema | Causa Provável | Solução |
|----------|---------------|---------|
| 401 Unauthorized | Token expirado ou inválido | Renovar token usando refresh_token |
| 429 Too Many Requests | Rate limit excedido | Implementar exponential backoff |
| 503 Service Unavailable | Servidor sobrecarregado | Ativar circuit breaker |
| CORS errors | Headers incorretos | Configurar Access-Control-* headers |

## 10. REFERÊNCIAS

1. HL7 FHIR. **RESTful API Specification R5**. Disponível em: [https://www.hl7.org/fhir/R5/http.html](https://www.hl7.org/fhir/R5/http.html). Acesso em: 2024.

2. HL7 FHIR. **FHIR REST API Documentation**. Disponível em: [https://www.hl7.org/fhir/http.html](https://www.hl7.org/fhir/http.html). Acesso em: 2024.

3. SMART Health IT. **SMART on FHIR Authorization Guide v2.1**. Disponível em: [https://docs.smarthealthit.org/authorization/](https://docs.smarthealthit.org/authorization/). Acesso em: 2024.

4. HL7 International. **FHIR Conformance Framework**. Disponível em: [https://www.hl7.org/fhir/conformance-module.html](https://www.hl7.org/fhir/conformance-module.html). Acesso em: 2024.

5. Fielding, R. T. **Architectural Styles and the Design of Network-based Software Architectures**. Doctoral dissertation, University of California, Irvine, 2000. Disponível em: [https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm](https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm). Acesso em: 2024.

6. Richardson, L.; Ruby, S. **RESTful Web Services**. O'Reilly Media, 2007. ISBN: 978-0-596-52926-0. Disponível em: [https://www.oreilly.com/library/view/restful-web-services/9780596529260/](https://www.oreilly.com/library/view/restful-web-services/9780596529260/). Acesso em: 2024.

7. OAuth 2.0. **The OAuth 2.0 Authorization Framework**. RFC 6749. Disponível em: [https://tools.ietf.org/html/rfc6749](https://tools.ietf.org/html/rfc6749). Acesso em: 2024.

8. OpenAPI Initiative. **OpenAPI Specification v3.1.0**. Disponível em: [https://spec.openapis.org/oas/v3.1.0](https://spec.openapis.org/oas/v3.1.0). Acesso em: 2024.

9. SMART Health IT. **SMART App Launch Framework v2.0.0**. Disponível em: [https://hl7.org/fhir/smart-app-launch/](https://hl7.org/fhir/smart-app-launch/). Acesso em: 2024.

10. Martin Fowler. **Circuit Breaker Pattern**. Disponível em: [https://martinfowler.com/bliki/CircuitBreaker.html](https://martinfowler.com/bliki/CircuitBreaker.html). Acesso em: 2024.

11. Kong Inc. **Kong API Gateway Documentation**. Disponível em: [https://docs.konghq.com/gateway/latest/](https://docs.konghq.com/gateway/latest/). Acesso em: 2024.

12. Prometheus. **Prometheus Monitoring System Documentation**. Disponível em: [https://prometheus.io/docs/introduction/overview/](https://prometheus.io/docs/introduction/overview/). Acesso em: 2024.

---

**Histórico de Revisões:**
- v1.0.0 (2024): Versão inicial

**Aprovações:**
- Arquiteto de APIs: _________________
- Gerente de Segurança: _________________
- Diretor Técnico: _________________

**Distribuição:**
- Equipe de Desenvolvimento
- Equipe de Operações
- Equipe de Segurança
- Parceiros de Integração