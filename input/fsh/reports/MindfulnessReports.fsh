Instance: MindfulnessProgressReport
InstanceOf: Measure
Usage: #definition
Title: "Mindfulness Practice Progress Report"
Description: "Example instance of MindfulnessProgressReport"
* name = "MindfulnessProgressReport"
* status = #active
* experimental = false
* date = "2026-09-17"
* publisher = "Example Organization"
* description = "Measures progress in mindfulness practice over time"

* scoring = http://terminology.hl7.org/CodeSystem/measure-scoring#continuous-variable
* type = http://terminology.hl7.org/CodeSystem/measure-type#process
* riskAdjustment = "none"
* rateAggregation = "Average values over time period"

* group[0]
  * code.text = "practice-frequency"
  * description = "Frequency of mindfulness practice"
  * population[0]
    * code = http://terminology.hl7.org/CodeSystem/measure-population#denominator
    * criteria.language = #text/fhirpath // 2026-09-17: the expressions are FHIRPath, not CQL identifiers (no CQL Library is attached; IG Publisher 2.3.4 reports MEASURE_M_CRITERIA_CQL_NO_LIB for text/cql-identifier criteria without a Library)
    * criteria.expression = "Observation.where(code.coding.code='711415009')"
  * stratifier[0]
    * code.text = "weekly"
    * description = "Stratified by the observation's effective date; the weekly aggregation is applied by the reporting engine (FHIRPath has no calendar-week function)"
    * criteria.language = #text/fhirpath // 2026-09-17: the expressions are FHIRPath, not CQL identifiers (no CQL Library is attached; IG Publisher 2.3.4 reports MEASURE_M_CRITERIA_CQL_NO_LIB for text/cql-identifier criteria without a Library)
    * criteria.expression = "Observation.effective.as(dateTime)" // 2026-09-17: was "Observation.effective.as(DateTime).truncate(@T).truncate(@W)", which is not valid FHIRPath (no truncate function, no @T/@W literals)

* group[1]
  * code.text = "stress-reduction"
  * description = "Stress level changes over time"
  * population[0]
    * code = http://terminology.hl7.org/CodeSystem/measure-population#denominator
    * criteria.language = #text/fhirpath // 2026-09-17: the expressions are FHIRPath, not CQL identifiers (no CQL Library is attached; IG Publisher 2.3.4 reports MEASURE_M_CRITERIA_CQL_NO_LIB for text/cql-identifier criteria without a Library)
    * criteria.expression = "Observation.where(component.code.coding.code='725854004')"
  * stratifier[0]
    * code.text = "trend"
    * criteria.language = #text/fhirpath // 2026-09-17: the expressions are FHIRPath, not CQL identifiers (no CQL Library is attached; IG Publisher 2.3.4 reports MEASURE_M_CRITERIA_CQL_NO_LIB for text/cql-identifier criteria without a Library)
    * criteria.expression = "component.where(code.coding.code='725854004').value.value"

RuleSet: ReportingMetrics
* group[+]
  * code = #session-duration
  * description = "Duration of practice sessions"
  * population[0]
    * code = #denominator
    * criteria.language = #text/cql-identifier
    * criteria.expression = "Observation.component.where(code.coding.code='118682006')"
  * stratifier[0]
    * code = #average
    * criteria.language = #text/cql-identifier
    * criteria.expression = "component.where(code.coding.code='118682006').value.value"

* group[+]
  * code = #mood-changes
  * description = "Mood state changes"
  * population[0]
    * code = #denominator
    * criteria.language = #text/cql-identifier
    * criteria.expression = "Observation.component.where(code.coding.code='373931001')"
