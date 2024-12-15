Instance: MindfulnessStatistics
InstanceOf: OperationDefinition
Usage: #definition
Description: "Calculate statistics for mindfulness sessions"

* status = #draft
* kind = #operation
* code = #calculate-statistics
* resource[0] = #Observation
* system = false
* type = true
* instance = false

* parameter[0]
  * name = #patientId
  * use = #in
  * min = 1
  * max = "1"
  * type = #string
  * documentation = "ID of the patient"

* parameter[1]
  * name = #startDate
  * use = #in
  * min = 0
  * max = "1"
  * type = #date
  * documentation = "Start date for statistics calculation"

* parameter[2]
  * name = #endDate
  * use = #in
  * min = 0
  * max = "1"
  * type = #date
  * documentation = "End date for statistics calculation"

* parameter[3]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * type = #Bundle
  * documentation = "Bundle containing calculated statistics"

Instance: MindfulnessTrends
InstanceOf: OperationDefinition
Usage: #definition
Description: "Analyze trends in mindfulness practice"

* status = #draft
* kind = #operation
* code = #analyze-trends
* resource[0] = #Observation
* system = false
* type = true
* instance = false

* parameter[0]
  * name = #patientId
  * use = #in
  * min = 1
  * max = "1"
  * type = #string
  * documentation = "ID of the patient"

* parameter[1]
  * name = #metricType
  * use = #in
  * min = 1
  * max = "1"
  * type = #code
  * documentation = "Type of metric to analyze (stress, mood, duration)"

* parameter[2]
  * name = #period
  * use = #in
  * min = 0
  * max = "1"
  * type = #string
  * documentation = "Analysis period (daily, weekly, monthly)"

* parameter[3]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * type = #Bundle
  * documentation = "Bundle containing trend analysis"
