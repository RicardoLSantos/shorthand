// ====== Mindfulness Security and Consent Resources ======

Instance: MindfulnessSecurityDefinition
InstanceOf: Consent
Usage: #example
* status = #active
* scope = $consentscope#patient-privacy "Privacy Consent"
* category[0] = $loinc#59284-0 "Patient Consent"
* patient = Reference(Patient/PatientMindfulness)
* dateTime = "2024-01-01"
* organization = Reference(Organization/Org2RDoc)
* policy[0].authority = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"
* policy[0].uri = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"
* provision.type = #permit
* provision.period.start = "2024-01-01"
* provision.period.end = "2025-12-31"
* provision.actor[0].role = $v3-RoleCode#TREAT "treatment"
* provision.actor[0].reference.identifier.system = "http://terminology.hl7.org/CodeSystem/practitioner-identifier"
* provision.actor[0].reference.identifier.value = "1234567890"
* provision.securityLabel[0] = $v3-Confidentiality#N "normal"
* provision.purpose[0] = $v3-ActReason#TREAT "treatment"
* provision.dataPeriod.start = "2024-01-01"
* provision.dataPeriod.end = "2025-12-31"

Instance: MindfulnessAccessPolicy
InstanceOf: Consent
Usage: #example
* status = #active
* scope = $consentscope#patient-privacy "Privacy Consent"
* category[0] = $loinc#59284-0 "Patient Consent"
* patient = Reference(Patient/PatientMindfulness)
* dateTime = "2024-01-01"
* organization = Reference(Organization/Org2RDoc)

// Políticas multi-jurisdicionais - começando do índice 0
* policy[0].authority = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"
* policy[0].uri = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"

// GDPR - Europa
* policy[1].authority = "https://eur-lex.europa.eu/eli/reg/2016/679/oj"
* policy[1].uri = "https://health.ec.europa.eu/ehealth-digital-health-and-care/european-health-data-space-regulation-ehds_en"

// HIPAA - Estados Unidos
* policy[2].authority = "https://www.hhs.gov/hipaa/index.html"
* policy[2].uri = "https://www.hhs.gov/hipaa/for-professionals/privacy/laws-regulations/index.html"

// LGPD - Brasil
* policy[3].authority = "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm"
* policy[3].uri = "https://www.gov.br/anpd/pt-br/"

* provision.type = #permit
* provision.period.start = "2024-01-01"
* provision.period.end = "2025-12-31"
* provision.actor[0].role = $v3-RoleCode#TREAT "treatment"
* provision.actor[0].reference.identifier.system = "http://terminology.hl7.org/CodeSystem/practitioner-identifier"
* provision.actor[0].reference.identifier.value = "1234567890"
* provision.action[0] = $consentaction#access "Access"
* provision.action[1] = $consentaction#use "Use"
* provision.purpose[0] = $v3-ActReason#TREAT "treatment"
* provision.purpose[1] = $v3-ActReason#HPAYMT "healthcare payment"
* provision.purpose[2] = $v3-ActReason#HOPERAT "healthcare operations"
* provision.dataPeriod.start = "2024-01-01"
* provision.dataPeriod.end = "2025-12-31"

// ====== Aliases para simplificar referências ======
Alias: $consentscope = http://terminology.hl7.org/CodeSystem/consentscope
Alias: $loinc = http://loinc.org
Alias: $v3-RoleCode = http://terminology.hl7.org/CodeSystem/v3-RoleCode
Alias: $v3-Confidentiality = http://terminology.hl7.org/CodeSystem/v3-Confidentiality
Alias: $v3-ActReason = http://terminology.hl7.org/CodeSystem/v3-ActReason
Alias: $consentaction = http://terminology.hl7.org/CodeSystem/consentaction
