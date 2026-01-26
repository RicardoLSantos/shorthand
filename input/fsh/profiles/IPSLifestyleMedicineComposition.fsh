// IPS Lifestyle Medicine Composition Profile
// Created: 2026-01-26
// Purpose: Extends IPS Composition for lifestyle medicine documentation
// Reference: HL7 IPS 2.0.0, ISO 27269:2021

Alias: $IPS = http://hl7.org/fhir/uv/ips/StructureDefinition
Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct
Alias: $LifestyleCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs

// =============================================================================
// COMPOSITION PROFILE
// =============================================================================

Profile: IPSLifestyleMedicineComposition
Parent: http://hl7.org/fhir/uv/ips/StructureDefinition/Composition-uv-ips
Id: ips-lifestyle-medicine-composition
Title: "IPS Lifestyle Medicine Composition"
Description: """
An IPS-compliant Composition profile extended for lifestyle medicine documentation.

This profile:
- Inherits all IPS required sections (Medications, Allergies, Problems)
- Extends Social History for detailed lifestyle factors
- Adds optional Lifestyle Medicine section for wearable-derived data
- Enables LHS (Learning Health System) integration through structured observations

Sections include:
- Required IPS sections (unchanged)
- Enhanced Social History (tobacco, alcohol, diet, exercise)
- Lifestyle Medicine section (HRV, sleep, physical activity, stress)
- Vital Signs extension for continuous monitoring data
"""

* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"
* ^publisher = "Ricardo Lourenco dos Santos, FMUP"

// Composition metadata
* type = $LOINC#60591-5 "Patient summary Document"
* title = "Patient Summary - Lifestyle Medicine"

// =============================================================================
// SECTION SLICING - Additional slices for lifestyle medicine
// Note: Inherits slicing discriminator from IPS base (value:code)
// =============================================================================

// Define lifestyle medicine specific sections (extends IPS sections)
* section contains
    sectionLifestyleMedicine 0..1 MS and
    sectionWearableData 0..1 MS and
    sectionSleepHealth 0..1 MS and
    sectionNutritionStatus 0..1 MS

// =============================================================================
// LIFESTYLE MEDICINE SECTION (NEW)
// =============================================================================

* section[sectionLifestyleMedicine] ^short = "Lifestyle Medicine Section"
* section[sectionLifestyleMedicine] ^definition = """
Section containing lifestyle medicine observations including physical activity,
stress management, social connections, and substance avoidance patterns.
Maps to ACLM 6 pillars: nutrition, exercise, sleep, stress, relationships, substances.
"""
* section[sectionLifestyleMedicine].code = $LOINC#29762-2 "Social history Narrative"
* section[sectionLifestyleMedicine].title = "Lifestyle Medicine"
* section[sectionLifestyleMedicine].text 1..1 MS
* section[sectionLifestyleMedicine].entry 0..* MS
* section[sectionLifestyleMedicine].entry only Reference(
    Observation or
    QuestionnaireResponse or
    Condition or
    Goal or
    CarePlan
)
* section[sectionLifestyleMedicine].emptyReason 0..1

// =============================================================================
// WEARABLE DATA SECTION (NEW)
// =============================================================================

* section[sectionWearableData] ^short = "Wearable Device Data Section"
* section[sectionWearableData] ^definition = """
Section containing observations from personal health devices and wearables.
Includes HRV, continuous heart rate, step counts, and activity metrics.
Aligns with PHD IG (hl7.fhir.uv.phd) device metadata standards.
"""
* section[sectionWearableData].code = $LOINC#73985-4 "Exercise activity"
* section[sectionWearableData].title = "Wearable Device Data"
* section[sectionWearableData].text 1..1 MS
* section[sectionWearableData].entry 0..* MS
* section[sectionWearableData].entry only Reference(
    Observation or
    Device or
    DeviceUseStatement
)

// =============================================================================
// SLEEP HEALTH SECTION (NEW)
// =============================================================================

* section[sectionSleepHealth] ^short = "Sleep Health Section"
* section[sectionSleepHealth] ^definition = """
Section containing sleep-related observations and assessments.
Includes sleep duration, sleep stages, sleep quality scores, and circadian data.
Supports ICD-11 sleep disorder classification (7A00-7A4Z).
"""
* section[sectionSleepHealth].code = $LOINC#93832-4 "Sleep panel"
* section[sectionSleepHealth].title = "Sleep Health"
* section[sectionSleepHealth].text 1..1 MS
* section[sectionSleepHealth].entry 0..* MS
* section[sectionSleepHealth].entry only Reference(
    Observation or
    Condition
)

// =============================================================================
// NUTRITION STATUS SECTION (NEW)
// =============================================================================

* section[sectionNutritionStatus] ^short = "Nutrition Status Section"
* section[sectionNutritionStatus] ^definition = """
Section containing nutrition-related observations and assessments.
Includes dietary intake, hydration, BMI trends, and nutritional risk scores.
Supports ICD-11 nutrition codes (5B70-5B82, QD60-QD6Z).
"""
* section[sectionNutritionStatus].code = $LOINC#61150-9 "Diet and nutrition Narrative"
* section[sectionNutritionStatus].title = "Nutrition Status"
* section[sectionNutritionStatus].text 1..1 MS
* section[sectionNutritionStatus].entry 0..* MS
* section[sectionNutritionStatus].entry only Reference(
    Observation or
    NutritionOrder or
    RiskAssessment
)

// =============================================================================
// BUNDLE PROFILE FOR IPS DOCUMENT
// =============================================================================

Profile: IPSLifestyleMedicineBundle
Parent: Bundle
Id: ips-lifestyle-medicine-bundle
Title: "IPS Lifestyle Medicine Bundle"
Description: """
A Bundle profile for packaging the IPS Lifestyle Medicine Composition with all
referenced resources. This Bundle type is 'document' and includes:
- The Composition as first entry
- Patient resource
- All referenced Observations, Conditions, and supporting resources
"""

* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"

* type = #document
* timestamp 1..1 MS
* identifier 1..1 MS

* entry ^slicing.discriminator.type = #type
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open

* entry contains
    composition 1..1 MS and
    patient 1..1 MS

* entry[composition].resource only IPSLifestyleMedicineComposition
* entry[patient].resource only Patient

// =============================================================================
// SECTION CODE VALUESET
// =============================================================================

ValueSet: IPSLifestyleMedicineSectionCodes
Id: ips-lifestyle-medicine-section-codes-vs
Title: "IPS Lifestyle Medicine Section Codes"
Description: """
LOINC codes used for section identification in the IPS Lifestyle Medicine Composition.
Includes standard IPS section codes plus lifestyle medicine extensions.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/ips-lifestyle-medicine-section-codes-vs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"

// Standard IPS sections
* $LOINC#48765-2 "Allergies and adverse reactions Document"
* $LOINC#11450-4 "Problem list - Reported"
* $LOINC#10160-0 "History of Medication use Narrative"
* $LOINC#47519-4 "History of Procedures Document"
* $LOINC#11369-6 "History of Immunization Narrative"
* $LOINC#46264-8 "History of medical device use"
* $LOINC#30954-2 "Relevant diagnostic tests/laboratory data Narrative"
* $LOINC#8716-3 "Vital signs"
* $LOINC#11348-0 "History of Past illness Narrative"
* $LOINC#10162-6 "History of pregnancies Narrative"
* $LOINC#29762-2 "Social history Narrative"
* $LOINC#47420-5 "Functional status assessment note"
* $LOINC#18776-5 "Plan of care note"

// Lifestyle medicine extension sections
* $LOINC#73985-4 "Exercise activity"
* $LOINC#93832-4 "Sleep panel"
* $LOINC#61150-9 "Diet and nutrition Narrative"

// =============================================================================
// EXAMPLE INSTANCE
// =============================================================================

Instance: ExampleIPSLifestyleMedicineComposition
InstanceOf: IPSLifestyleMedicineComposition
Usage: #example
Title: "Example IPS Lifestyle Medicine Composition"
Description: "Example of an IPS Composition extended for lifestyle medicine"

* status = #final
* type = $LOINC#60591-5 "Patient summary Document"
* subject = Reference(Patient/example-patient)
* date = "2026-01-26T10:00:00Z"
* author = Reference(Practitioner/example-practitioner)
* title = "Patient Summary - Lifestyle Medicine"
* confidentiality = #N

// Required IPS sections (empty for example)
* section[sectionMedications].title = "Medication Summary"
* section[sectionMedications].code = $LOINC#10160-0 "History of Medication use Narrative"
* section[sectionMedications].text.status = #generated
* section[sectionMedications].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">No current medications</div>"
* section[sectionMedications].emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#nilknown

* section[sectionAllergies].title = "Allergies and Intolerances"
* section[sectionAllergies].code = $LOINC#48765-2 "Allergies and adverse reactions Document"
* section[sectionAllergies].text.status = #generated
* section[sectionAllergies].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">No known allergies</div>"
* section[sectionAllergies].emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#nilknown

* section[sectionProblems].title = "Problem List"
* section[sectionProblems].code = $LOINC#11450-4 "Problem list - Reported"
* section[sectionProblems].text.status = #generated
* section[sectionProblems].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Obesity (ICD-11: 5B82)</div>"
* section[sectionProblems].entry[0] = Reference(Condition/example-obesity)

// Lifestyle Medicine section
* section[sectionLifestyleMedicine].title = "Lifestyle Medicine"
* section[sectionLifestyleMedicine].code = $LOINC#29762-2 "Social history Narrative"
* section[sectionLifestyleMedicine].text.status = #generated
* section[sectionLifestyleMedicine].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Patient engages in moderate physical activity (150 min/week). Non-smoker. Occasional alcohol use. Mediterranean diet adherence: good.</p></div>"

// Wearable Data section
* section[sectionWearableData].title = "Wearable Device Data"
* section[sectionWearableData].code = $LOINC#73985-4 "Exercise activity"
* section[sectionWearableData].text.status = #generated
* section[sectionWearableData].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Apple Watch Series 9 data: Average HRV (SDNN): 45ms, Resting HR: 62 bpm, Daily steps: 8,500 avg</p></div>"

// Sleep Health section
* section[sectionSleepHealth].title = "Sleep Health"
* section[sectionSleepHealth].code = $LOINC#93832-4 "Sleep panel"
* section[sectionSleepHealth].text.status = #generated
* section[sectionSleepHealth].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Average sleep duration: 7.2 hours. Sleep efficiency: 88%. No sleep apnea detected.</p></div>"

// Nutrition Status section
* section[sectionNutritionStatus].title = "Nutrition Status"
* section[sectionNutritionStatus].code = $LOINC#61150-9 "Diet and nutrition Narrative"
* section[sectionNutritionStatus].text.status = #generated
* section[sectionNutritionStatus].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>BMI: 28.5 kg/m2 (overweight). Adequate hydration. Following Mediterranean diet with good adherence.</p></div>"

