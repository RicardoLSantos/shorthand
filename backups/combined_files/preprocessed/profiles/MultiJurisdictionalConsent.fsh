// Originally defined on lines 3 - 49
Profile: MultiJurisdictionalConsent
Parent: Consent
Id: multi-jurisdictional-consent
Title: "Multi-Jurisdictional Healthcare Consent"
Description: "Consent profile supporting GDPR, HIPAA, and LGPD compliance"
* status MS
* scope MS
* category MS
* patient 1..1
* patient MS
* dateTime 1..1
* dateTime MS
* policy 1..*
* policy MS
* policy ^slicing.discriminator.type = #value
* policy ^slicing.discriminator.path = "authority"
* policy ^slicing.rules = #open
* policy contains
    gdpr 0.. and
    hipaa 0.. and
    lgpd 0..
* policy[gdpr] 0..1
* policy[gdpr] MS
* policy[hipaa] 0..1
* policy[hipaa] MS
* policy[lgpd] 0..1
* policy[lgpd] MS
* policy[gdpr].authority = "https://eur-lex.europa.eu/eli/reg/2016/679/oj"
* policy[gdpr].uri 1..1
* policy[gdpr].uri MS
* policy[hipaa].authority = "https://www.hhs.gov/hipaa/index.html"
* policy[hipaa].uri 1..1
* policy[hipaa].uri MS
* policy[lgpd].authority = "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm"
* policy[lgpd].uri 1..1
* policy[lgpd].uri MS
* extension contains
    RegulatoryBasis named regulatoryBasis 0.. and
    JurisdictionApplicability named jurisdiction 0.. and
    DataLocalization named dataLocalization 0..
* extension[regulatoryBasis] 0..*
* extension[regulatoryBasis] MS
* extension[jurisdiction] 0..*
* extension[jurisdiction] MS
* extension[dataLocalization] 0..*
* extension[dataLocalization] MS
* provision MS
* provision.type MS
* provision.period MS
* provision.actor MS
* provision.action MS
* provision.securityLabel MS
* provision.purpose MS
* provision.dataPeriod MS

