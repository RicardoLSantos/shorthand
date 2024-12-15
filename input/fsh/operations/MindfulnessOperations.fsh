Instance: MindfulnessStatisticsOperation
InstanceOf: OperationDefinition
Usage: #definition
* name = "MindfulnessStatisticsOperation"
* description = "Calculate statistics for mindfulness sessions"
* status = #draft
* kind = #operation
* code = #calculate-statistics
* system = true
* type = true
* instance = false
* parameter[0]
  * name = #patientId
  * use = #in
  * type = #string
  * documentation = "ID of the patient"
* parameter[1]
  * name = #startDate
  * use = #in
  * type = #date
  * documentation = "Start date for statistics calculation"
* parameter[2]
  * name = #endDate
  * use = #in
  * type = #date
  * documentation = "End date for statistics calculation"
* parameter[3]
  * name = #return
  * use = #out
  * type = #Bundle
  * documentation = "Bundle containing calculated statistics"

Instance: MindfulnessTrendsOperation
InstanceOf: OperationDefinition
Usage: #definition
* name = "MindfulnessTrendsOperation"
* description = "Analyze trends in mindfulness practice"
* status = #draft
* kind = #operation
* code = #analyze-trends
* system = true
* type = true
* instance = false
* parameter[0]
  * name = #patientId
  * use = #in
  * type = #string
  * documentation = "ID of the patient"
* parameter[1]
  * name = #metricType
  * use = #in
  * type = #code
  * documentation = "Type of metric to analyze (stress, mood, duration)"
* parameter[2]
  * name = #period
  * use = #in
  * type = #string
  * documentation = "Analysis period (daily, weekly, monthly)"
* parameter[3]
  * name = #return
  * use = #out
  * type = #Bundle
  * documentation = "Bundle containing trend analysis"
EOL
