// =============================================================================
// CFM Resolution 2.454/2026 — Example Instances
// Created: 2026-03-28 T1 S15
// =============================================================================

// =============================================================================
// AI Disclosure Communication (Art. 4 + Art. 9 + Art. 11)
// Scenario: Physician notifies patient that HRV analysis uses BioMistral-7B
// =============================================================================

Instance: ExampleCommunicationAIDisclosure
InstanceOf: CommunicationAIDisclosure
Usage: #example
Title: "AI Disclosure — HRV Analysis Notification"
Description: "Physician informs patient that HRV cardiovascular risk analysis uses AI (BioMistral-7B, classified as médio risco)."

* status = #completed
* category = AgentDecisionSupportCS#ai-disclosure-completed
* subject = Reference(Patient/PatientExample)
* sender = Reference(Practitioner/PractitionerExample)
* recipient = Reference(Patient/PatientExample)
* sent = "2026-03-28T09:00:00-03:00"
* payload[0].contentString = "A sua análise de variabilidade cardíaca (HRV) utiliza inteligência artificial (modelo BioMistral-7B, classificação de risco: médio). O resultado final é sempre validado pelo seu médico. Você tem direito a: (1) solicitar segunda opinião, (2) recusar análise por IA, (3) aceder aos dados utilizados."
* reasonCode = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"

// =============================================================================
// AI Governance Organization (Art. 8)
// Scenario: HEADS AI Commission at CHUSJ/FMUP
// =============================================================================

Instance: ExampleOrganizationAIGovernance
InstanceOf: OrganizationAIGovernance
Usage: #example
Title: "HEADS AI Governance Commission"
Description: "AI Commission at Centro Hospitalar Universitário de São João per CFM 2.454 Art. 8."

* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#dept "Hospital Department"
* name = "Comissão de Inteligência Artificial em Saúde — CHUSJ/FMUP"
* contact[0].name.text = "Prof. Ricardo Cruz-Correia"
* contact[0].purpose = http://terminology.hl7.org/CodeSystem/contactentity-type#ADMIN "Administrative"
* contact[0].telecom[0].system = #email
* contact[0].telecom[0].value = "rcorreia@med.up.pt"

// =============================================================================
// AI Technical Director (Art. 8)
// Scenario: AI Director at HEADS research group
// =============================================================================

Instance: ExamplePractitionerRoleAIDirector
InstanceOf: PractitionerRoleAIDirector
Usage: #example
Title: "AI Technical Director — HEADS"
Description: "AI Technical Director (Responsável Técnico de IA) at HEADS per CFM 2.454 Art. 8."

* active = true
* period.start = "2026-08-01"
* practitioner = Reference(Practitioner/PractitionerExample)
* organization = Reference(Organization/ExampleOrganizationAIGovernance)
* code = http://terminology.hl7.org/CodeSystem/practitioner-role#researcher "Researcher"
* specialty = http://snomed.info/sct#394814009 "General practice (specialty)"

// =============================================================================
// Patient Refuses AI (Art. 9)
// Scenario: Patient exercises right to refuse AI-assisted analysis
// =============================================================================

Instance: ExampleConsentAIRefusal
InstanceOf: Consent
Usage: #example
Title: "Patient Refuses AI — CFM 2.454 Art. 9"
Description: "Patient exercises right to refuse AI-assisted analysis per CFM 2.454 Art. 9."

* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#treatment "Treatment"
* category = http://loinc.org#59284-0 "Consent Document"
* patient = Reference(Patient/PatientExample)
* dateTime = "2026-03-28T10:00:00-03:00"
* performer = Reference(Patient/PatientExample)
* organization = Reference(Organization/ExampleOrganizationAIGovernance)
* policyRule = http://terminology.hl7.org/CodeSystem/v3-ActCode#OPTIN "opt-in"
* provision.type = #deny
* provision.purpose = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
