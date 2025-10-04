# Políticas de Acesso a Dados de Saúde e Frameworks de Segurança para FHIR

**Os três principais frameworks regulatórios globais (GDPR, HIPAA e LGPD) exigem implementações técnicas específicas em sistemas FHIR para garantir compliance, com URLs canônicos oficiais, padrões de consentimento padronizados, e arquiteturas de segurança multinacionais já comprovadas em produção.** Organizações que operam internacionalmente podem agora referenciar regulamentações específicas usando códigos HL7 padronizados, implementar consent management através de Implementation Guides consolidados como IHE PCF, e adotar padrões técnicos que atendem simultaneamente múltiplas jurisdições através de frameworks como EHDS e SMART on FHIR.

## URLs oficiais e canônicos para sistemas FHIR

As três principais jurisdições oferecem **URLs oficiais específicos** que devem ser referenciados em implementações FHIR para garantir compliance legal e interoperabilidade técnica.

### Europa (GDPR)
- **URL Canônico Principal**: `https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng` (Regulation EU 2016/679)
- **Versão Consolidada**: `https://eur-lex.europa.eu/legal-content/EN/AUTO/?uri=CELEX:02016R0679-20160504`
- **European Health Data Space (EHDS)**: `https://health.ec.europa.eu/ehealth-digital-health-and-care/european-health-data-space-regulation-ehds_en`
- **Autoridade Supervisora Europeia**: `https://www.edps.europa.eu/data-protection/our-work/subjects/health_en`

**Para referência em FHIR Consent:**
```json
{
  "regulatoryBasis": [{
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/consentpolicycodes",
      "code": "gdpr",
      "display": "GDPR Consent"
    }]
  }],
  "policyBasis": {
    "url": "https://eur-lex.europa.eu/eli/reg/2016/679/oj"
  }
}
```

### Estados Unidos (HIPAA)
- **URL Oficial HHS**: `https://www.hhs.gov/hipaa/index.html`
- **Privacy Rule**: `https://www.hhs.gov/hipaa/for-professionals/privacy/laws-regulations/index.html`
- **Security Rule**: `https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html`
- **CFR References**: 45 CFR Parts 160 e 164

**Para referência em FHIR Consent:**
```json
{
  "regulatoryBasis": [{
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/consentpolicycodes",
      "code": "hipaa-auth",
      "display": "HIPAA Authorization"
    }]
  }],
  "policyBasis": {
    "url": "https://www.hhs.gov/hipaa/for-professionals/privacy/laws-regulations/"
  }
}
```

### Brasil (LGPD)
- **URL Oficial**: `http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm`
- **ANPD**: `https://www.gov.br/anpd/pt-br/`
- **Assuntos Internacionais**: `https://www.gov.br/anpd/pt-br/assuntos/assuntos-internacionais/international-affairs`

**Para referência em FHIR Consent:**
```json
{
  "regulatoryBasis": [{
    "text": "Brazilian General Data Protection Law (LGPD)",
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/consentpolicycodes",
      "code": "lgpd",
      "display": "LGPD Consent"
    }]
  }],
  "policyBasis": {
    "url": "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm"
  }
}
```

## URLs válidos do HL7 para consent policies internacionais

O HL7 estabeleceu **CodeSystems oficiais** para referenciar políticas de consentimento internacionais, centralizados no serviço de terminologia oficial.

### Terminologia Oficial HL7
- **Base URL**: `https://terminology.hl7.org/`
- **FHIR R4 Version**: `https://terminology.hl7.org/5.1.0/`
- **FHIR R5 Version**: `https://terminology.hl7.org/6.5.0/`

### CodeSystems Fundamentais para Consent
```
http://terminology.hl7.org/CodeSystem/consentcategorycodes
http://terminology.hl7.org/CodeSystem/consentscope
http://terminology.hl7.org/CodeSystem/consentaction  
http://terminology.hl7.org/CodeSystem/consentpolicycodes
```

### Value Sets Oficiais
```
http://hl7.org/fhir/ValueSet/consent-category
http://hl7.org/fhir/ValueSet/consent-scope
http://hl7.org/fhir/ValueSet/consent-action
http://terminology.hl7.org/ValueSet/consent-policy
```

**Códigos Específicos para Políticas Internacionais:**
- `hipaa-auth`: HIPAA Authorization
- `hipaa-npp`: HIPAA Notice of Privacy Practices
- `gdpr`: GDPR Consent Directive
- `nl-lsp`: Netherlands LSP Permission
- `at-elga`: Austria ELGA Opt-in Consent
- `ch-epr`: Switzerland EPR Consent

## Melhores práticas para consent e privacy policies

Três **padrões técnicos comprovados** emergiram como melhores práticas para implementar consent management em sistemas de saúde multinacionais, cada um com diferentes níveis de maturidade e aplicabilidade.

### Padrão IHE Privacy Consent on FHIR (PCF)
**Status**: Produção (v1.1.0)  
**URL**: `https://profiles.ihe.net/ITI/PCF/volume-1.html`

**Características técnicas:**
- **Três Níveis de Maturidade**: Basic (consent simples), Intermediate (scoping de dados), Advanced (segmentação de dados sensíveis)
- **Múltiplas Políticas**: Suporta "múltiplas regulamentações e políticas de consentimento diferentes" através de PolicyBasis único
- **Integração OAuth**: Construído sobre IUA com extensões para tokens conscientes de consentimento
- **Auditoria Obrigatória**: Integração BALP para atividades sensíveis à privacidade

### Arquitetura SMART on FHIR Security
**URL**: `https://docs.smarthealthit.org/authorization/best-practices/`

**Implementação técnica:**
- **Segurança de Transporte**: TLS 1.2+ obrigatório
- **Modelos de Grant OAuth**: Authorization Code (preferido) e Client Credentials para B2B
- **Segurança de Token**: Tokens de acesso de curta duração (1 hora recomendado)
- **Proteção CSRF**: Parâmetros state imprevisíveis com 128+ bits de entropia

### European Health Data Space (EHDS)
**Status**: Operacional março 2029  
**URL**: `https://health.ec.europa.eu/ehealth-digital-health-and-care/european-health-data-space-regulation-ehds_en`

**Framework multinacional:**
- **Cobertura**: 27 estados-membros da UE com framework unificado
- **Compliance Dupla**: Opera sob GDPR e leis nacionais de saúde
- **Infraestrutura Cross-Border**: MyHealth@EU para uso primário, HealthData@EU para uso secundário
- **Controle do Paciente**: Cidadãos podem "restringir acesso de profissionais de saúde a todos ou partes dos seus dados eletrônicos de saúde pessoais"

## Como referenciar políticas em recursos FHIR Consent

O **FHIR R5 introduziu elementos específicos** para referenciar múltiplas jurisdições regulatórias simultaneamente, oferecendo maior granularidade e rastreabilidade compliance.

### Estrutura FHIR R5 Consent Resource
```json
{
  "resourceType": "Consent",
  "status": "active",
  "category": [{
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/consentcategorycodes",
      "code": "59284-0"
    }]
  }],
  "subject": {
    "reference": "Patient/example"
  },
  "regulatoryBasis": [
    {
      "coding": [{
        "system": "http://terminology.hl7.org/CodeSystem/consentpolicycodes",
        "code": "gdpr"
      }]
    },
    {
      "coding": [{
        "system": "http://terminology.hl7.org/CodeSystem/consentpolicycodes", 
        "code": "hipaa-auth"
      }]
    }
  ],
  "policyBasis": {
    "reference": {
      "reference": "Contract/multi-jurisdiction-policy"
    }
  },
  "decision": "permit"
}
```

### Principais mudanças do R4 para R5
- **regulatoryBasis**: Novo elemento para referenciar frameworks regulatórios
- **policyBasis**: Estrutura aprimorada para referências de políticas
- **decision**: Substitui policyRule para decisão base

### Padrão de Conflito Multi-jurisdicional
```json
{
  "provision": [{
    "type": "permit",
    "actor": [{
      "role": {
        "coding": [{
          "system": "http://terminology.hl7.org/CodeSystem/v3-RoleCode",
          "code": "TREAT"
        }]
      }
    }],
    "purpose": [{
      "system": "http://terminology.hl7.org/CodeSystem/v3-ActReason",
      "code": "TREAT"
    }],
    "securityLabel": [{
      "system": "http://terminology.hl7.org/CodeSystem/v3-Confidentiality",
      "code": "N"
    }]
  }]
}
```

## Implementation Guides para múltiplas jurisdições

Três **Implementation Guides estabelecidos** oferecem padrões técnicos para gerenciamento de consentimento multi-jurisdicional, com diferentes níveis de maturidade e focos de aplicação.

### IHE Privacy Consent on FHIR (PCF) v1.1.0
**Status**: Pronto para produção  
**URL**: `https://profiles.ihe.net/ITI/PCF/`

**Características multi-jurisdicionais:**
- **Suporte a Múltiplas Políticas**: Através de PolicyBasis único que "resolve e reconcilia várias políticas"
- **Adaptabilidade Jurisdicional**: Suporta "regras jurisdicionais apoiadas por leis"
- **Rastreamento de Base Regulatória**: Usa elemento RegulatoryBasis para rastrear regulamentações específicas
- **Atores Técnicos**: Consent Recorder, Registry, Authorization Server, Enforcement Point

### HL7 FAST Scalable Consent Management v0.1.0
**Status**: Em desenvolvimento  
**URL**: `https://build.fhir.org/ig/HL7/fhir-consent-management/`

**Recursos cross-organizacionais:**
- **Consent Cross-Repository**: Projetado para "lidar com casos de uso através de conjunto de repositórios de gerenciamento de consentimento de forma escalável"
- **Suporte Multi-Organizacional**: Responde "é possível determinar se pagador/provedor X tem autoridade para visualizar dados de saúde Y sobre paciente Z?"
- **Operações FHIR Customizadas**: Define operações especializadas para workflows de cerimônia e gerenciamento de consentimento

### International Patient Summary (IPS)
**Status**: Padrão global ISO/EN  
**URL**: `https://build.fhir.org/ig/HL7/fhir-ips/`

**Recursos multi-jurisdicionais:**
- **Padrão ISO**: ISO 27269 fornece framework de interoperabilidade global
- **Considerações de Privacidade**: Suporte integrado para redação de "dados de saúde altamente sensíveis"
- **Integração de Consentimento**: Referencia IHE PCF para gerenciamento de consentimento
- **Implementação Global**: Usado por Epic, MEDITECH, CommonHealth, Google e outros

### European Health Data Space Implementation
**Status**: Framework multinacional operacional  
**Cobertura**: 27 países UE + infraestrutura cross-border

**Padrões técnicos:**
- **Integração FHIR**: Mandatório como padrão de interoperabilidade principal
- **Gerenciamento de Consentimento**: Mecanismos integrados para uso primário e secundário
- **Autoridades Digitais de Saúde**: Cada estado-membro deve designar autoridades para coordenação cross-border

## Estrutura de NamingSystem para practitioners internacionais

O **HL7 estabeleceu padrões específicos** para identificadores de practitioners que suportam contextos internacionais, incluindo elementos de jurisdição e tipos de identificadores padronizados.

### NamingSystem Resource Base
**URL Oficial**: `http://hl7.org/fhir/namingsystem.html`

### Exemplo US National Provider Identifier
```json
{
  "resourceType": "NamingSystem",
  "url": "http://terminology.hl7.org/NamingSystem/npi",
  "name": "NationalProviderIdentifier", 
  "title": "US National Provider Identifier",
  "status": "active",
  "kind": "identifier",
  "type": {
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
      "code": "NPI",
      "display": "National Provider Identifier"
    }]
  },
  "uniqueId": [{
    "type": "uri",
    "value": "http://hl7.org/fhir/sid/us-npi",
    "preferred": true
  }]
}
```

### Padrão Internacional com Jurisdição
```json
{
  "resourceType": "NamingSystem",
  "name": "InternationalPractitionerID",
  "type": {
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/v2-0203", 
      "code": "PRN",
      "display": "Provider Number"
    }]
  },
  "jurisdiction": [{
    "coding": [{
      "system": "urn:iso:std:iso:3166",
      "code": "BE",
      "display": "Belgium"
    }]
  }]
}
```

### Exemplos de Implementação por País
**Belgian SSIN:**
```json
{
  "system": "https://www.ehealth.fgov.be/standards/fhir/core/NamingSystem/ssin",
  "value": "79121137740"
}
```

**Netherlands UZI:**
```json
{
  "system": "http://fhir.nl/fhir/NamingSystem/uzi-nr",
  "value": "12345678901"
}
```

## Conclusão

**A implementação de políticas de acesso a dados de saúde em sistemas FHIR requer abordagem técnica multinível** que combina compliance regulatório, padrões técnicos internacionais, e arquiteturas de segurança robustas. Os frameworks GDPR, HIPAA e LGPD convergem em princípios fundamentais - consentimento informado, direitos do titular dos dados, e segurança técnica - mas diferem em implementação específica, penalidades, e requisitos técnicos.

**As organizações devem priorizar** o uso de URLs canônicos oficiais para referências regulatórias, implementar consent management através de Implementation Guides comprovados como IHE PCF, e adotar arquiteturas técnicas que suportam simultaneamente múltiplas jurisdições. **A evolução para FHIR R5** oferece elementos específicos como regulatoryBasis e policyBasis que simplificam significativamente o compliance multi-jurisdicional, enquanto frameworks emergentes como EHDS demonstram viabilidade técnica de sistemas de saúde digitais verdadeiramente internacionais.

**Para implementações futuras**, organizações devem considerar padrões de segurança layered (TLS, OAuth, RBAC/ABAC, encryption), tecnologias privacy-preserving (differential privacy, homomorphic encryption), e governance frameworks que incluem DPOs, DPIAs regulares, e procedimentos de resposta a incidentes que atendem simultaneamente todos os frameworks regulatórios aplicáveis.

## Referências

### Legislação e Regulamentação

1. **GDPR - General Data Protection Regulation (Europa)**
   - Texto oficial: [https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng)
   - European Health Data Space (EHDS): [https://health.ec.europa.eu/ehealth-digital-health-and-care/european-health-data-space-regulation-ehds_en](https://health.ec.europa.eu/ehealth-digital-health-and-care/european-health-data-space-regulation-ehds_en)
   - European Data Protection Supervisor - Health: [https://www.edps.europa.eu/data-protection/our-work/subjects/health_en](https://www.edps.europa.eu/data-protection/our-work/subjects/health_en)

2. **HIPAA - Health Insurance Portability and Accountability Act (Estados Unidos)**
   - Portal oficial HHS: [https://www.hhs.gov/hipaa/index.html](https://www.hhs.gov/hipaa/index.html)
   - Privacy Rule: [https://www.hhs.gov/hipaa/for-professionals/privacy/laws-regulations/index.html](https://www.hhs.gov/hipaa/for-professionals/privacy/laws-regulations/index.html)
   - Security Rule: [https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html](https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html)

3. **LGPD - Lei Geral de Proteção de Dados (Brasil)**
   - Lei 13.709/2018 compilada: [http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm](http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm)
   - ANPD - Autoridade Nacional de Proteção de Dados: [https://www.gov.br/anpd/pt-br/](https://www.gov.br/anpd/pt-br/)

### Especificações FHIR e HL7

4. **FHIR Core Specifications**
   - FHIR R5 Consent Resource: [http://hl7.org/fhir/consent.html](http://hl7.org/fhir/consent.html)
   - FHIR R4 Consent Resource: [https://hl7.org/fhir/R4/consent.html](https://hl7.org/fhir/R4/consent.html)
   - FHIR Security: [https://www.hl7.org/fhir/security.html](https://www.hl7.org/fhir/security.html)
   - FHIR NamingSystem: [http://hl7.org/fhir/namingsystem.html](http://hl7.org/fhir/namingsystem.html)

5. **HL7 Terminology Services**
   - Base de Terminologia HL7: [https://terminology.hl7.org/](https://terminology.hl7.org/)
   - Consent Scope Codes: [https://terminology.hl7.org/CodeSystem-consentscope.html](https://terminology.hl7.org/CodeSystem-consentscope.html)
   - Consent PolicyRule Codes: [https://terminology.hl7.org/ValueSet-consent-policy.html](https://terminology.hl7.org/ValueSet-consent-policy.html)

### Implementation Guides

6. **IHE Privacy Consent on FHIR (PCF)**
   - Especificação principal v1.1.0: [https://profiles.ihe.net/ITI/PCF/volume-1.html](https://profiles.ihe.net/ITI/PCF/volume-1.html)
   - Repositório GitHub: [https://github.com/IHE/ITI.PCF](https://github.com/IHE/ITI.PCF)
   - Advanced Consent Definitions: [https://profiles.ihe.net/ITI/PCF/StructureDefinition-IHE.PCF.consentAdvanced-definitions.html](https://profiles.ihe.net/ITI/PCF/StructureDefinition-IHE.PCF.consentAdvanced-definitions.html)

7. **HL7 Scalable Consent Management**
   - IG v0.1.0: [https://build.fhir.org/ig/HL7/fhir-consent-management/](https://build.fhir.org/ig/HL7/fhir-consent-management/)

8. **International Patient Summary (IPS)**
   - IG v2.0.0: [https://build.fhir.org/ig/HL7/fhir-ips/](https://build.fhir.org/ig/HL7/fhir-ips/)
   - Privacy and Security Considerations: [https://build.fhir.org/ig/HL7/fhir-ips/Privacy-and-Security-Considerations.html](https://build.fhir.org/ig/HL7/fhir-ips/Privacy-and-Security-Considerations.html)

### Segurança e Autenticação

9. **SMART on FHIR**
   - Authorization Best Practices: [https://docs.smarthealthit.org/authorization/best-practices/](https://docs.smarthealthit.org/authorization/best-practices/)
   - Scopes and Launch Context: [http://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context/](http://www.hl7.org/fhir/smart-app-launch/scopes-and-launch-context/)

### Recursos Adicionais

10. **Análises Comparativas e Guias**
    - GDPR vs HIPAA Compliance: [https://www.onetrust.com/blog/hipaa-vs-gdpr-compliance/](https://www.onetrust.com/blog/hipaa-vs-gdpr-compliance/)
    - FHIR Security Best Practices: [https://kodjin.com/blog/fhir-security-best-practices/](https://kodjin.com/blog/fhir-security-best-practices/)
    - Cross-border Health Data Transfer Rules: [https://incountry.com/blog/cross-border-health-data-transfer-rules-around-the-world/](https://incountry.com/blog/cross-border-health-data-transfer-rules-around-the-world/)
    - Mental Health App Data Privacy (HIPAA-GDPR): [https://secureprivacy.ai/blog/mental-health-app-data-privacy-hipaa-gdpr-compliance](https://secureprivacy.ai/blog/mental-health-app-data-privacy-hipaa-gdpr-compliance)

11. **European Health Data Space Resources**
    - EHDS Overview - BC Platforms: [https://ehds.bcplatforms.com/overview-of-ehds/](https://ehds.bcplatforms.com/overview-of-ehds/)
    - The European Health Data Space: [https://www.european-health-data-space.com/](https://www.european-health-data-space.com/)

12. **Brasil - Recursos LGPD**
    - Brazil's Data Protection Authority Guidance: [https://www.hoganlovells.com/en/publications/brazils-data-protection-authority-releases-guidance-on-data-protection-officer-responsibilities-and-duties](https://www.hoganlovells.com/en/publications/brazils-data-protection-authority-releases-guidance-on-data-protection-officer-responsibilities-and-duties)
    - LGPD Compliance Guide: [https://www.cookiebot.com/en/lgpd/](https://www.cookiebot.com/en/lgpd/)
    - Data Protection for Health Insurance in Brazil: [https://www.ibanet.org/data-protection-health-insurance-brazil](https://www.ibanet.org/data-protection-health-insurance-brazil)