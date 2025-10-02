Instance: MindfulnessSecurityDefinition
InstanceOf: Consent
Usage: #definition
Title: "Mindfulness Data Security Policy"

* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category = http://loinc.org#59284-0 "Consent Document"

* policy[0]
  * authority = "http://example.org/privacy-policy"
  * uri = "http://example.org/mindfulness-privacy"

* provision
  * type = #permit
  * period
    * start = "2024-03-19"
  * actor[0]
    * role = http://terminology.hl7.org/CodeSystem/v3-ParticipationType#PRCP
    * reference
      * identifier.system = "http://example.org/practitioners"
      * identifier.value = "mindfulness-practitioners"

RuleSet: SecurityRequirements
* meta.security from http://terminology.hl7.org/ValueSet/v3-SecurityPolicy (required)
* meta.tag from http://terminology.hl7.org/ValueSet/v3-Confidentiality (required)

* extension contains
    http://hl7.org/fhir/StructureDefinition/resource-security-category named securityCategory 0..1 MS and
    http://hl7.org/fhir/StructureDefinition/patient-confidentiality named confidentiality 0..1 MS

Instance: MindfulnessAccessPolicy
InstanceOf: Consent
Usage: #definition
Title: "Mindfulness Data Access Policy"

* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category = http://loinc.org#59284-0 "Consent Document"

* policy[0]
  * authority = "http://example.org/access-policy"
  * uri = "http://example.org/mindfulness-access"

* provision
  * type = #permit
  * period
    * start = "2024-03-19"
  * actor[0]
    * role = http://terminology.hl7.org/CodeSystem/v3-ParticipationType#PRCP
    * reference
      * identifier.system = "http://example.org/practitioners"
      * identifier.value = "mindfulness-practitioners"
  * action = http://terminology.hl7.org/CodeSystem/consentaction#access "Access"
