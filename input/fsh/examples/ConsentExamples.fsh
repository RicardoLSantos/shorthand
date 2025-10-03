Instance: MultiJurisdictionalConsentExample
InstanceOf: MultiJurisdictionalConsent
Usage: #example
Description: "Multi-jurisdictional healthcare consent supporting GDPR, HIPAA, and LGPD"
Title: "Multi-Jurisdictional Consent Example"
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy "Privacy Consent"
* category = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL "information disclosure"
* patient = Reference(Patient/PatientExample)
* dateTime = "2024-03-19T09:00:00Z"
* policy[gdpr].authority = "https://eur-lex.europa.eu/eli/reg/2016/679/oj"
* policy[gdpr].uri = "urn:eu:gdpr:2016:679"
* policy[hipaa].authority = "https://www.hhs.gov/hipaa/index.html"
* policy[hipaa].uri = "urn:us:hipaa:privacy"
* policy[lgpd].authority = "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm"
* policy[lgpd].uri = "urn:br:lgpd:2018"
* provision.type = #permit
* provision.period.start = "2024-03-19"
* provision.period.end = "2025-03-19"
* provision.action = http://terminology.hl7.org/CodeSystem/consentaction#access "Access"
* provision.securityLabel = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "normal"
