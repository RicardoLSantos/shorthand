// ============================================================================
// External Systems Stub CodeSystems
// ============================================================================
// Purpose: Provide formal CodeSystem definitions for external systems referenced
//          in ConceptMaps. These are stub definitions - the actual codes are
//          maintained externally.
// Created: 2025-11-30
// HL7 FHIR Conformance: Satisfies validator requirements for ConceptMap targets
//
// Note: These CodeSystems use content = #not-present to indicate that the
//       actual code content is maintained externally and not included here.

// ============================================================================
// OHDSI OMOP CDM Concepts (Athena)
// ============================================================================

CodeSystem: OMOPConceptsCS
Id: omop-concepts-stub
Title: "OHDSI OMOP CDM Concepts (External Reference)"
Description: "Stub CodeSystem representing OHDSI OMOP Common Data Model concepts from Athena. This CodeSystem serves as a formal reference target for ConceptMaps mapping to OMOP. Actual concept codes are maintained at https://athena.ohdsi.org/"
* ^url = "http://athena.ohdsi.org/search-terms/terms"
* ^version = "5.4"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "OHDSI (Observational Health Data Sciences and Informatics)"
* ^contact.name = "OHDSI Community"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://ohdsi.org"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0

// Note: OMOP CDM contains millions of concepts across multiple vocabularies
// Actual concepts are accessed via Athena: https://athena.ohdsi.org/
// Common domains include: Condition, Drug, Measurement, Observation, Procedure


// ============================================================================
// openEHR Archetypes (External Reference)
// ============================================================================

CodeSystem: OpenEHRArchetypesCS
Id: openehr-archetypes-stub
Title: "openEHR Clinical Knowledge Manager Archetypes (External Reference)"
Description: "Stub CodeSystem representing openEHR archetypes from the Clinical Knowledge Manager (CKM). This CodeSystem serves as a formal reference target for ConceptMaps mapping between FHIR and openEHR. Actual archetypes are maintained at https://ckm.openehr.org/"
* ^url = "https://ckm.openehr.org/ckm/archetypes"
* ^version = "2024.1"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "openEHR Foundation"
* ^contact.name = "openEHR Foundation"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://openehr.org"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0

// Note: openEHR archetypes use a specific naming convention:
// openEHR-EHR-{class}.{concept}.v{version}
// Example: openEHR-EHR-OBSERVATION.heart_rate_variability.v0
// Archetypes are browsable at: https://ckm.openehr.org/


// ============================================================================
// Apple HealthKit (External Reference)
// ============================================================================

CodeSystem: AppleHealthKitCS
Id: apple-healthkit-stub
Title: "Apple HealthKit Types (External Reference)"
Description: "Stub CodeSystem representing Apple HealthKit quantity and category types. This CodeSystem serves as a formal reference for mapping wearable data from Apple devices."
* ^url = "https://developer.apple.com/documentation/healthkit"
* ^version = "2024"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "Apple Inc."
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://developer.apple.com/healthkit/"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0

// Note: Apple HealthKit types include:
// HKQuantityTypeIdentifierHeartRate
// HKQuantityTypeIdentifierHeartRateVariabilitySDNN
// HKQuantityTypeIdentifierStepCount
// HKCategoryTypeIdentifierSleepAnalysis
// Full documentation: https://developer.apple.com/documentation/healthkit


// ============================================================================
// Fitbit Web API (External Reference)
// ============================================================================

CodeSystem: FitbitAPICS
Id: fitbit-api-stub
Title: "Fitbit Web API Types (External Reference)"
Description: "Stub CodeSystem representing Fitbit Web API data types. This CodeSystem serves as a formal reference for mapping wearable data from Fitbit devices."
* ^url = "https://dev.fitbit.com/build/reference/web-api"
* ^version = "1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "Fitbit (Google)"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://dev.fitbit.com/"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0


// ============================================================================
// Garmin Connect (External Reference)
// ============================================================================

CodeSystem: GarminConnectCS
Id: garmin-connect-stub
Title: "Garmin Connect API Types (External Reference)"
Description: "Stub CodeSystem representing Garmin Connect and Health API data types."
* ^url = "https://developer.garmin.com/gc-developer-program"
* ^version = "1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "Garmin Ltd."
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://developer.garmin.com/"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0


// ============================================================================
// Oura Ring API (External Reference)
// ============================================================================

CodeSystem: OuraAPICS
Id: oura-api-stub
Title: "Oura Ring API Types (External Reference)"
Description: "Stub CodeSystem representing Oura Ring API data types."
* ^url = "https://cloud.ouraring.com/v2/docs"
* ^version = "2.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "Oura Health Oy"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://ouraring.com/"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0


// ============================================================================
// Polar API (External Reference)
// ============================================================================

CodeSystem: PolarAPICS
Id: polar-api-stub
Title: "Polar AccessLink API Types (External Reference)"
Description: "Stub CodeSystem representing Polar AccessLink API data types."
* ^url = "https://www.polar.com/accesslink-api"
* ^version = "3.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "Polar Electro Oy"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "https://www.polar.com/"
* ^caseSensitive = true
* ^content = #not-present
* ^count = 0
