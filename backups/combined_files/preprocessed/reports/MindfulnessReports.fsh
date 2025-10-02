// Originally defined on lines 1 - 39
Instance: MindfulnessProgressReport
InstanceOf: Measure
Title: "Mindfulness Practice Progress Report"
Description: "Example instance of MindfulnessProgressReport"
Usage: #definition
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
* group[0].code = #practice-frequency
* group[0].description = "Frequency of mindfulness practice"
* group[0].population[0]
* group[0].population[0].code = #denominator
* group[0].population[0].criteria.language = #text/fhirpath
* group[0].population[0].criteria.expression = "Observation.where(code.coding.code='711415009')"
* group[0].stratifier[0]
* group[0].stratifier[0].code = #weekly
* group[0].stratifier[0].criteria.language = #text/fhirpath
* group[0].stratifier[0].criteria.expression = "Observation.effective.as(DateTime).truncate(@T).truncate(@W)"
* group[1]
* group[1].code = #stress-reduction
* group[1].description = "Stress level changes over time"
* group[1].population[0]
* group[1].population[0].code = #denominator
* group[1].population[0].criteria.language = #text/fhirpath
* group[1].population[0].criteria.expression = "Observation.where(component.code.coding.code='725854004')"
* group[1].stratifier[0]
* group[1].stratifier[0].code = #trend
* group[1].stratifier[0].criteria.language = #text/fhirpath
* group[1].stratifier[0].criteria.expression = "component.where(code.coding.code='725854004').value.value"

