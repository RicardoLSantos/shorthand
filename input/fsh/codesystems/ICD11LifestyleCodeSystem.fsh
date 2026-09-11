// ICD-11 Lifestyle Medicine CodeSystem
// Republished subset of ICD-11 MMS codes relevant to lifestyle medicine, under the IG namespace.
//
// Why a republished CodeSystem: validation of this IG must not depend on the availability of a
// terminology server. Every code below is re-verified against the terminology owner (WHO) and
// against tx.fhir.org on the dates recorded in the per-concept verification properties and in
// input/data/terminology-verification-ledger.csv (see terminology-verification.md).
//
// Correction of 2026-09-11: the 2026-03 edition of this CodeSystem carried 34 codes, of which
// 9 did not exist in ICD-11 MMS and 12 carried the title of a different concept (block ranges
// had been typed as category codes). Every concept was re-derived from the WHO linearization
// table and tx.fhir.org; titles are the WHO MMS titles verbatim.

RuleSet: ICD11Verified(code)
* #{code} ^property[+].code = #verified-on
* #{code} ^property[=].valueDateTime = "2026-09-11"
* #{code} ^property[+].code = #verified-via
* #{code} ^property[=].valueString = "tx.fhir.org (ICD-11 MMS 2026-01) and the WHO ICD-11 MMS linearization export from icd.who.int (2026-03-20)"
* #{code} ^property[+].code = #source-version
* #{code} ^property[=].valueString = "ICD-11 MMS 2026-01"

CodeSystem: ICD11LifestyleMedicineCS
Id: icd-11-lifestyle-cs
Title: "ICD-11 Lifestyle Medicine Codes"
Description: """
Republished subset of 46 ICD-11 MMS codes relevant to lifestyle medicine (health behaviours,
nutrition, overweight and obesity, sleep-wake disorders, stress and burnout), sourced from WHO ICD-11
MMS release 2026-01. Titles are the WHO MMS titles.

This CodeSystem exists under the IG namespace by design: the IG validates without depending on a
terminology server. The authoritative source remains WHO ICD-11 at https://icd.who.int (official
system URL: http://id.who.int/icd/release/11/mms), which tx.fhir.org also serves; both are used as
verification sources. Each concept carries the properties verified-on, verified-via and source-version,
and the machine-readable record is input/data/terminology-verification-ledger.csv.

History: the 2026-03 edition (34 codes) contained 9 codes absent from ICD-11 MMS and 12 codes whose
title belonged to another concept; it was rebuilt on 2026-09-11 from the WHO linearization table and
tx.fhir.org. Physical-activity types (walking, running, cycling, swimming) have no ICD-11 category
and are coded with SNOMED CT and LOINC elsewhere in this IG.
"""

* ^version = "0.3.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-09-11"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"
* ^contact.name = "Ricardo L. Santos"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "ricardolourencosantos@gmail.com"
* ^caseSensitive = true
* ^content = #complete
* ^count = 46
* ^copyright = "Codes sourced from ICD-11 © World Health Organization (WHO), CC BY-NC-ND 3.0 IGO. Republished under IG namespace for FHIR validation."

// Verification properties (defined in AppLogicCS; recorded per concept)
* ^property[+].code = #verified-on
* ^property[=].uri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#verified-on"
* ^property[=].description = "Date on which the code was last verified against its source terminology"
* ^property[=].type = #dateTime
* ^property[+].code = #verified-via
* ^property[=].uri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#verified-via"
* ^property[=].description = "Source consulted for the last verification"
* ^property[=].type = #string
* ^property[+].code = #source-version
* ^property[=].uri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#source-version"
* ^property[=].description = "Release of the source terminology against which the code was verified"
* ^property[=].type = #string


// =============================================================================
// Chapter 24 · Problems associated with health behaviours (blocks QE1 hazardous substance use · QE2 health-related behaviours)
// =============================================================================
* #QE10 "Hazardous alcohol use"
* insert ICD11Verified(QE10)
* #QE11 "Hazardous drug use"
* insert ICD11Verified(QE11)
* #QE11.Z "Hazardous drug use, unspecified"
* insert ICD11Verified(QE11.Z)
* #QE12 "Hazardous nicotine use"
* insert ICD11Verified(QE12)
* #QE13 "Tobacco use"
* insert ICD11Verified(QE13)
* #QE1Y "Other specified hazardous substance use"
* insert ICD11Verified(QE1Y)
* #QE1Z "Hazardous substance use, unspecified"
* insert ICD11Verified(QE1Z)
* #QE20 "Lack of physical exercise"
* insert ICD11Verified(QE20)
* #QE21 "Hazardous gambling or betting"
* insert ICD11Verified(QE21)
* #QE22 "Hazardous gaming"
* insert ICD11Verified(QE22)
* #QE23 "Problems with inappropriate diet or eating habits"
* insert ICD11Verified(QE23)
* #QE2Z "Problem with health-related behaviours, unspecified"
* insert ICD11Verified(QE2Z)

// =============================================================================
// Chapter 24 · Psychosocial circumstances: stress, burnout, employment, participation
// =============================================================================
* #QE01 "Stress, not elsewhere classified"
* insert ICD11Verified(QE01)
* #QD85 "Burnout"
* insert ICD11Verified(QD85)
* #QD8Y "Other specified problems associated with employment or unemployment"
* insert ICD11Verified(QD8Y)
* #QD8Z "Problems associated with employment or unemployment, unspecified"
* insert ICD11Verified(QD8Z)
* #QF2A "Difficulty or need for assistance with community participation"
* insert ICD11Verified(QF2A)

// =============================================================================
// Chapter 24 · Problems associated with drinking water or nutrition (block QD6)
// =============================================================================
* #QD60 "Problems associated with inadequate drinking-water"
* insert ICD11Verified(QD60)
* #QD61 "Inadequate food"
* insert ICD11Verified(QD61)
* #QD6Z "Problems associated with drinking water or nutrition, unspecified"
* insert ICD11Verified(QD6Z)

// =============================================================================
// Chapter 05 · Undernutrition (block 5B5) and overweight or obesity (block 5B8)
// =============================================================================
* #5B50 "Underweight in infants, children or adolescents"
* insert ICD11Verified(5B50)
* #5B54 "Underweight in adults"
* insert ICD11Verified(5B54)
* #5B71 "Protein deficiency"
* insert ICD11Verified(5B71)
* #5B7Z "Unspecified undernutrition"
* insert ICD11Verified(5B7Z)
* #5B80 "Overweight or localised adiposity"
* insert ICD11Verified(5B80)
* #5B80.0 "Overweight"
* insert ICD11Verified(5B80.0)
* #5B80.0Z "Overweight, unspecified"
* insert ICD11Verified(5B80.0Z)
* #5B81 "Obesity"
* insert ICD11Verified(5B81)
* #5B81.0 "Obesity due to energy imbalance"
* insert ICD11Verified(5B81.0)
* #5B81.Z "Obesity, unspecified"
* insert ICD11Verified(5B81.Z)

// =============================================================================
// Chapter 07 · Sleep-wake disorders (insomnia 7A0 · hypersomnolence 7A2 · sleep-related breathing 7A4 · circadian 7A6)
// =============================================================================
* #7A00 "Chronic insomnia"
* insert ICD11Verified(7A00)
* #7A01 "Short-term insomnia"
* insert ICD11Verified(7A01)
* #7A0Z "Insomnia disorders, unspecified"
* insert ICD11Verified(7A0Z)
* #7A21 "Idiopathic hypersomnia"
* insert ICD11Verified(7A21)
* #7A24 "Hypersomnia due to a medication or substance"
* insert ICD11Verified(7A24)
* #7A26 "Insufficient sleep syndrome"
* insert ICD11Verified(7A26)
* #7A2Z "Hypersomnolence disorders, unspecified"
* insert ICD11Verified(7A2Z)
* #7A40 "Central sleep apnoeas"
* insert ICD11Verified(7A40)
* #7A41 "Obstructive sleep apnoea"
* insert ICD11Verified(7A41)
* #7A4Y "Other specified sleep-related breathing disorders"
* insert ICD11Verified(7A4Y)
* #7A4Z "Sleep-related breathing disorders, unspecified"
* insert ICD11Verified(7A4Z)
* #7A60 "Delayed sleep-wake phase disorder"
* insert ICD11Verified(7A60)
* #7A64 "Circadian rhythm sleep-wake disorder, shift work type"
* insert ICD11Verified(7A64)
* #7A65 "Circadian rhythm sleep-wake disorder, jet lag type"
* insert ICD11Verified(7A65)
* #7A6Z "Circadian rhythm sleep-wake disorders, unspecified"
* insert ICD11Verified(7A6Z)
* #7B2Z "Sleep-wake disorders, unspecified"
* insert ICD11Verified(7B2Z)
