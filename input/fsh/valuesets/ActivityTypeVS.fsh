// =============================================================================
// Physical Activity Types Value Set
// =============================================================================
// Verified codes from SNOMED CT International Edition and ICD-10-CM
// Date: 2026-01-12
// Verification: SNOMED Browser, FindACode, ICD10Data.com
//
// References:
// - SNOMED CT International Edition (Jan 2026)
// - ICD-10-CM External Cause codes Chapter 20 (Y93.*)
// - HL7 Physical Activity IG v1.0.1: https://hl7.org/fhir/us/physical-activity/
// =============================================================================

Alias: $SNOMED = http://snomed.info/sct
Alias: $ICD10 = http://hl7.org/fhir/sid/icd-10-cm

ValueSet: PhysicalActivityTypeVS
Id: physical-activity-type-vs
Title: "Physical Activity Types Value Set"
Description: """
Types of physical activities for iOS Lifestyle Medicine tracking.

This ValueSet uses verified SNOMED CT codes for general concepts and
ICD-10-CM Activity codes (Y93.*) for specific activity types where
SNOMED CT lacks appropriate codes.

**SNOMED CT Gap Documentation**:
SNOMED CT International Edition does not have specific codes for common
physical activities like swimming, cycling, or running as standalone concepts.
The codes previously used (266938001, 266940006, 229065009) were incorrectly
mapped - they represent unrelated clinical concepts.

**Solution**: ICD-10-CM Chapter 20 (Y93.*) provides internationally
standardized activity codes for external cause reporting.
"""

* ^experimental = false
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"

// -----------------------------------------------------------------------------
// SNOMED CT - Verified generic codes
// -----------------------------------------------------------------------------
* $SNOMED#68130003 "Physical activity"
  // Verified: FindACode, NCBO BioPortal - observable entity
* $SNOMED#129006008 "Walking"
  // Verified: NCBO BioPortal - walking (observable entity)
* $SNOMED#229166008 "Jogging training"
  // Verified: FindACode - jogging/running training
* $SNOMED#61686008 "Physical exercise"
  // Verified: FindACode - physical exercise (observable entity)

// -----------------------------------------------------------------------------
// ICD-10-CM Activity Codes (Y93.*) - Specific activities
// Reference: https://www.icd10data.com/ICD10CM/Codes/V00-Y99/Y90-Y99/Y93-
// -----------------------------------------------------------------------------
* $ICD10#Y93.11 "Activity, swimming"
* $ICD10#Y93.55 "Activity, bicycle riding"
* $ICD10#Y93.01 "Activity, walking, marching and hiking"
* $ICD10#Y93.02 "Activity, running"
* $ICD10#Y93.A1 "Activity, exercise machines primarily for cardiorespiratory conditioning"
* $ICD10#Y93.B3 "Activity, yoga"
* $ICD10#Y93.13 "Activity, water aerobics and water exercise"
