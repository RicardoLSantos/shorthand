// ====== Mindfulness Security and Consent Resources ======

Instance: MindfulnessSecurityDefinition
InstanceOf: Consent
Usage: #example
Description: "Consent instance defining security requirements and data classification for mindfulness data"
* status = #active
* scope = $consentscope#patient-privacy "Privacy Consent"
* category[0] = $loinc#59284-0 "Consent Document"
* patient = Reference(Patient/PatientMindfulness)
* dateTime = "2024-01-01"
* organization = Reference(Organization/Org2RDoc)
* policy[0].authority = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"
* policy[0].uri = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"
* provision.type = #permit
* provision.period.start = "2024-01-01"
* provision.period.end = "2025-12-31"
* provision.actor[0].role = http://terminology.hl7.org/CodeSystem/extra-security-role-type#datacollector "data collector"
// * provision.actor[0].reference.identifier.system = "http://terminology.hl7.org/CodeSystem/practitioner-identifier" // Invalid - removed
* provision.actor[0].reference.identifier.value = "1234567890"
* provision.securityLabel[0] = $v3-Confidentiality#N "normal"
* provision.purpose[0] = $v3-ActReason#TREAT "treatment"
* provision.dataPeriod.start = "2024-01-01"
* provision.dataPeriod.end = "2025-12-31"

Instance: MindfulnessAccessPolicy
InstanceOf: Consent
Usage: #example
Description: "Consent instance defining access control policies and authorized actions for mindfulness data under GDPR, EHDS, HIPAA, and LGPD compliance"
* status = #active
* scope = $consentscope#patient-privacy "Privacy Consent"
* category[0] = $loinc#59284-0 "Consent Document"
* patient = Reference(Patient/PatientMindfulness)
* dateTime = "2024-01-01"
* organization = Reference(Organization/Org2RDoc)

// Políticas multi-jurisdicionais - começando do índice 0
* policy[0].authority = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"
* policy[0].uri = "http://terminology.hl7.org/CodeSystem/consentpolicycodes"

// GDPR - Europa (using URN to avoid unresolvable URL warnings)
* policy[1].authority = "urn:oid:2.16.840.1.113883.3.4.5.1"
* policy[1].uri = "urn:eu:gdpr:2016:679"

// HIPAA - Estados Unidos (using URN to avoid unresolvable URL warnings)
* policy[2].authority = "urn:oid:2.16.840.1.113883.3.4.5.2"
* policy[2].uri = "urn:us:hipaa:privacy"

// LGPD - Brasil (using URN to avoid unresolvable URL warnings)
* policy[3].authority = "urn:oid:2.16.840.1.113883.3.4.5.3"
* policy[3].uri = "urn:br:lgpd:2018"

* provision.type = #permit
* provision.period.start = "2024-01-01"
* provision.period.end = "2025-12-31"
* provision.actor[0].role = http://terminology.hl7.org/CodeSystem/extra-security-role-type#datacollector "data collector"
// * provision.actor[0].reference.identifier.system = "http://terminology.hl7.org/CodeSystem/practitioner-identifier" // Invalid - removed
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
