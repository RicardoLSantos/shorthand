Instance: MindfulnessProgressReport
InstanceOf: Measure
Usage: #definition
Title: "Mindfulness Practice Progress Report"
Description: "Example instance of MindfulnessProgressReport"
* status = #active
* experimental = false
* date = "2024-03-19"
* publisher = "Example Organization"
* description = "Measures progress in mindfulness practice over time"

* scoring = #continuous-variable
* type = #process
* riskAdjustment = "none"
* rateAggregation = "Average values over time period"

* group[0]
  * code = #practice-frequency
  * description = "Frequency of mindfulness practice"
  * population[0]
    * code = #denominator
    * criteria.language = #text/fhirpath
    * criteria.expression = "Observation.where(code.coding.code='711020003')"
  * stratifier[0]
    * code = #weekly
    * criteria.language = #text/fhirpath
    * criteria.expression = "Observation.effective.as(DateTime).truncate(@T).truncate(@W)"

* group[1]
  * code = #stress-reduction
  * description = "Stress level changes over time"
  * population[0]
    * code = #denominator
    * criteria.language = #text/fhirpath
    * criteria.expression = "Observation.where(component.code.coding.code='725854004')"
  * stratifier[0]
    * code = #trend
    * criteria.language = #text/fhirpath
    * criteria.expression = "component.where(code.coding.code='725854004').value.value"

RuleSet: ReportingMetrics
* group[+]
  * code = #session-duration
  * description = "Duration of practice sessions"
  * population[0]
    * code = #denominator
    * criteria.language = #text/fhirpath
    * criteria.expression = "Observation.component.where(code.coding.code='118682006')"
  * stratifier[0]
    * code = #average
    * criteria.language = #text/fhirpath
    * criteria.expression = "component.where(code.coding.code='118682006').value.value"

* group[+]
  * code = #mood-changes
  * description = "Mood state changes"
  * population[0]
    * code = #denominator
    * criteria.language = #text/fhirpath
    * criteria.expression = "Observation.component.where(code.coding.code='373931001')"
