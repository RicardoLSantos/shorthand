// ====== Perfil Multi-Jurisdicional de Consent ======

Profile: MultiJurisdictionalConsent
Parent: Consent
Id: multi-jurisdictional-consent
Title: "Multi-Jurisdictional Healthcare Consent"
Description: "Consent profile supporting GDPR, HIPAA, and LGPD compliance"

* status MS
* scope MS
* category MS
* patient 1..1 MS
* dateTime 1..1 MS

// Múltiplas políticas para diferentes jurisdições
* policy 1..* MS
* policy ^slicing.discriminator.type = #value
* policy ^slicing.discriminator.path = "authority"
* policy ^slicing.rules = #open

* policy contains
    gdpr 0..1 MS and
    hipaa 0..1 MS and
    lgpd 0..1 MS

* policy[gdpr].authority = "https://eur-lex.europa.eu/eli/reg/2016/679/oj"
* policy[gdpr].uri 1..1 MS

* policy[hipaa].authority = "https://www.hhs.gov/hipaa/index.html"  
* policy[hipaa].uri 1..1 MS

* policy[lgpd].authority = "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm"
* policy[lgpd].uri 1..1 MS

// Extensões de compliance
* extension contains
    RegulatoryBasis named regulatoryBasis 0..* MS and
    JurisdictionApplicability named jurisdiction 0..* MS and
    DataLocalization named dataLocalization 0..* MS

// Provisions com segurança
* provision MS
* provision.type MS
* provision.period MS
* provision.actor MS
* provision.action MS
* provision.securityLabel MS
* provision.purpose MS
* provision.dataPeriod MS
