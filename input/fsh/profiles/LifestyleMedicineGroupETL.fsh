// ============================================================================
// Lifestyle Medicine Group for ETL Operations (Profile #4)
// ============================================================================
// Date: 2026-05-19 (T2 S25 — Tier 1B Profile #4 / G2 antecedent)
// Purpose: Specialization of BulkExportGroup for ETL operations targeting
//          vendor cohort + time window + transformation pipeline + destination
//          warehouse definitions. Used as input parameter for $export operations
//          to enumerate which patients + vendors + measurement types are
//          subject to a single ETL run.
// Reference:
//   - FHIR R4 Group: https://hl7.org/fhir/R4/group.html
//   - BulkExportGroup parent: T2 S20 (`profiles/BulkExportGroup.fsh`)
//   - Bulk Data Access IG STU2: http://hl7.org/fhir/uv/bulkdata/STU2/
//   - LifestyleMedicineETLBatch (Profile #1, T2 S24): bundle returned by $export
//   - WearableMeasurementProvenance (Profile #2, T2 S24): per-Observation provenance
//   - PatientDataPipelineCapability (Profile #3, T2 S25): server-side declaration
// Companion:
//   - BulkExportConsent.fsh (T2 S20) — research-specific consent for $export
//   - LifestyleMedicineETLBatch.fsh — Bundle.type=batch payload returned by $export
// G2 RS antecedent: RS4 (Living SR methodology), RS13 (FHIRconnect implementation).
// ============================================================================

// ============================================================================
// Profile: LifestyleMedicineGroupETL
// ============================================================================

Profile: LifestyleMedicineGroupETL
Parent: BulkExportGroup
Id: lifestyle-medicine-group-etl
Title: "Lifestyle Medicine Group for ETL Operations"
Description: """
Specialization of BulkExportGroup for ETL operations targeting vendor-cohort
+ time-window + transformation-pipeline definitions. Cohorts conforming to
this profile drive Bulk Data Access $export operations returning
LifestyleMedicineETLBatch bundles for the enumerated patient + vendor +
measurement-type tuple, scoped to the declared temporal window.

Used by:
  - Research ETL pipelines (e.g., RS4 Living SR cohort population)
  - Quality improvement extracts (e.g., HRV-decline 90-day cohorts)
  - Vendor onboarding validation runs (e.g., Apple HealthKit pilot)

Cross-profile dependencies:
  - Profile #1 LifestyleMedicineETLBatch — Bundle.type=batch returned by $export
  - Profile #2 WearableMeasurementProvenance — per-Observation provenance in returned Bundle entries
  - Profile #3 PatientDataPipelineCapability — server declaration accepting this Group as $export input
"""

* ^experimental = false

// All inherited cardinalities from BulkExportGroup preserved:
//   type = #person (1..1 MS)
//   actual (1..1 MS)
//   active = true (1..1 MS exactly)
//   code (1..1 MS from BulkExportGroupCategoryVS extensible)

// ETL-specific extensions
* extension contains
    VendorCohort named vendorCohort 1..1 MS and
    TimeWindow named timeWindow 1..1 MS and
    TransformationPipeline named pipeline 0..1 MS and
    DestinationWarehouse named destination 0..1 MS

// Tighten characteristic — at least vendor + measurement type filters expected
* characteristic 1..* MS
* characteristic ^slicing.discriminator.type = #value
* characteristic ^slicing.discriminator.path = "code"
* characteristic ^slicing.rules = #open

* characteristic contains
    measurementTypeFilter 0..* MS and
    vendorFilter 0..* MS and
    patientCohortFilter 0..* MS

// measurementTypeFilter — filter by LOINC code (e.g., 80404-7 SDNN, 8867-4 HR)
* characteristic[measurementTypeFilter].code 1..1 MS
* characteristic[measurementTypeFilter].code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/etl-group-characteristic#measurement-type (exactly)
* characteristic[measurementTypeFilter].value[x] 1..1 MS
* characteristic[measurementTypeFilter].valueCodeableConcept 1..1 MS

// vendorFilter — filter by vendor identifier (e.g., Apple, Fitbit, Garmin)
* characteristic[vendorFilter].code 1..1 MS
* characteristic[vendorFilter].code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/etl-group-characteristic#vendor (exactly)
* characteristic[vendorFilter].value[x] 1..1 MS
* characteristic[vendorFilter].valueCodeableConcept 1..1 MS

// patientCohortFilter — filter by clinical criteria (e.g., 'HRV-decline-90d', 'PA-non-adherence-WHO')
* characteristic[patientCohortFilter].code 1..1 MS
* characteristic[patientCohortFilter].code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/etl-group-characteristic#patient-cohort (exactly)
* characteristic[patientCohortFilter].value[x] 1..1 MS
* characteristic[patientCohortFilter].valueCodeableConcept 1..1 MS

// ============================================================================
// CodeSystem: ETL Group Characteristic Codes
// ============================================================================

CodeSystem: ETLGroupCharacteristicCS
Id: etl-group-characteristic
Title: "ETL Group Characteristic CodeSystem"
Description: "Local CodeSystem for LifestyleMedicineGroupETL characteristic slicing discriminator codes."
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true

* #measurement-type "Measurement Type Filter" "Filter by LOINC measurement code (e.g., 80404-7 SDNN)"
* #vendor "Vendor Filter" "Filter by vendor identifier (Apple, Fitbit, Garmin, Oura, Polar, Withings, Samsung)"
* #patient-cohort "Patient Cohort Filter" "Filter by clinical cohort criterion (e.g., HRV-decline-90d)"

// ============================================================================
// Extension: Vendor Cohort
// ============================================================================

Extension: VendorCohort
Id: vendor-cohort
Title: "Vendor Cohort Extension"
Description: """
Declares which vendor(s) this ETL Group draws data from. May be a single
vendor (e.g., Apple HealthKit pilot) or multi-vendor cohort (e.g., HRV
decline cohort across Apple + Fitbit + Polar). Used by the pipeline to
select correct vendor adapter(s) for the $export operation.
"""
* ^context.type = #element
* ^context.expression = "Group"

* value[x] only CodeableConcept
* valueCodeableConcept 1..1 MS
* valueCodeableConcept ^short = "Vendor identifier (e.g., 'Apple', 'Fitbit', 'Garmin', 'Oura', 'Polar', 'Withings', 'Samsung') or composite for multi-vendor"

// ============================================================================
// Extension: Time Window
// ============================================================================

Extension: TimeWindow
Id: time-window
Title: "ETL Time Window Extension"
Description: """
Temporal scope for which the ETL Group draws data. start = earliest
measurement timestamp included; end = latest measurement timestamp included
(exclusive). Used by the pipeline to bound vendor API queries during the
$export operation. Required for any operational ETL run; absent or open-ended
windows are rejected at pipeline server-side to prevent unbounded extracts.
"""
* ^context.type = #element
* ^context.expression = "Group"

* value[x] only Period
* valuePeriod 1..1 MS
* valuePeriod.start 1..1 MS
* valuePeriod.end 1..1 MS

// ============================================================================
// Extension: Transformation Pipeline
// ============================================================================

Extension: TransformationPipeline
Id: transformation-pipeline
Title: "Transformation Pipeline Extension"
Description: """
Reference to the PlanDefinition describing the transformation pipeline this
ETL Group is processed through. PlanDefinition encodes the steps: vendor
adapter → unit normalization (UCUM) → LOINC code mapping → de-duplication
→ FHIR Observation generation. Allows different Groups to target different
transformation pipelines for vendor-specific quirks (e.g., Apple raw HRV vs
Fitbit derived HRV).
"""
* ^context.type = #element
* ^context.expression = "Group"

* value[x] only Reference(PlanDefinition)
* valueReference 1..1 MS

// ============================================================================
// Extension: Destination Warehouse
// ============================================================================

Extension: DestinationWarehouse
Id: destination-warehouse
Title: "Destination Warehouse Extension"
Description: """
URL of the destination data warehouse where $export output is delivered.
For FHIR-native warehouses, the endpoint accepts Bundle.type=batch directly.
For OMOP CDM warehouses, the endpoint may be a separate ETL adapter that
transforms Bundle.type=batch into OMOP MEASUREMENT + PERSON + OBSERVATION
records (cf. Vulcan FHIR-to-OMOP IG, alignment under evaluation per T4 S59
2026-05-18 cross-terminal note).
"""
* ^context.type = #element
* ^context.expression = "Group"

* value[x] only url
* valueUrl 1..1 MS

// ============================================================================
// Example: Apple HealthKit HRV Decline Cohort
// ============================================================================

Instance: LifestyleMedicineGroupETLAppleHRVDeclineExample
InstanceOf: LifestyleMedicineGroupETL
Usage: #example
Title: "Lifestyle Medicine Group ETL — Apple HealthKit HRV Decline 90d Cohort Example"
Description: """
Example ETL Group representing an Apple HealthKit cohort with HRV decline
trend over the last 90 days. Used as input to $export to retrieve raw
HRV (SDNN + RMSSD) + sleep + activity observations for downstream analysis.
"""

* type = #person
* actual = false
* active = true
* code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/bulk-export-group-category#research
* name = "ETL-AppleHealthKit-HRVdecline-90d-2026Q2-cohort-001"

// Inherited from BulkExportGroup parent (1..* MS): consent reference
* extension[consentRef].valueReference.reference = "Consent/BulkExportConsentHRVResearchExample"

* extension[vendorCohort].valueCodeableConcept.text = "Apple HealthKit"
* extension[timeWindow].valuePeriod.start = "2026-02-19"
* extension[timeWindow].valuePeriod.end = "2026-05-19"
* extension[pipeline].valueReference = Reference(LifestyleRiskAssessmentPlanDefinition)
* extension[destination].valueUrl = "https://2rdoc.pt/fhir/warehouse/research"

* characteristic[measurementTypeFilter][0].code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/etl-group-characteristic#measurement-type
* characteristic[measurementTypeFilter][0].valueCodeableConcept = http://loinc.org#80404-7 "R-R interval.standard deviation"
* characteristic[measurementTypeFilter][0].exclude = false

* characteristic[vendorFilter][0].code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/etl-group-characteristic#vendor
* characteristic[vendorFilter][0].valueCodeableConcept.text = "Apple HealthKit"
* characteristic[vendorFilter][0].exclude = false

* characteristic[patientCohortFilter][0].code = http://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/etl-group-characteristic#patient-cohort
* characteristic[patientCohortFilter][0].valueCodeableConcept.text = "HRV-decline-90d (SDNN downward slope p<0.05 over 90 days)"
* characteristic[patientCohortFilter][0].exclude = false
