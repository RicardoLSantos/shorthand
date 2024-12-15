Instance: CalculateMindfulnessStats
InstanceOf: OperationDefinition
Usage: #definition
Title: "Calculate Mindfulness Statistics Operation"

* status = #draft
* kind = #operation
* code = #calculate-stats
* resource = #Observation
* name = "CalculateMindfulnessStats"
* system = false
* type = true
* instance = false

* parameter[0]
  * name = #start-date
  * use = #in
  * min = 1
  * max = "1"
  * type = #date
  * documentation = "Start date for statistics calculation"

* parameter[1]
  * name = #end-date
  * use = #in
  * min = 1
  * max = "1"
  * type = #date
  * documentation = "End date for statistics calculation"

* parameter[2]
  * name = #metrics
  * use = #in
  * min = 1
  * max = "*"
  * type = #code
  * documentation = "Metrics to calculate (stress, duration, mood)"

* parameter[3]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * type = #Bundle
  * documentation = "Bundle containing calculated statistics"

Instance: GenerateMindfulnessReport
InstanceOf: OperationDefinition
Usage: #definition
Title: "Generate Mindfulness Report Operation"

* status = #draft
* kind = #operation
* code = #generate-report
* resource = #Observation
* name = "GenerateMindfulnessReport"
* system = false
* type = true
* instance = false

* parameter[0]
  * name = #period
  * use = #in
  * min = 1
  * max = "1"
  * type = #Period
  * documentation = "Time period for report"

* parameter[1]
  * name = #format
  * use = #in
  * min = 0
  * max = "1"
  * type = #code
  * documentation = "Report format (PDF, HTML)"

* parameter[2]
  * name = #return
  * use = #out
  * min = 1
  * max = "1"
  * type = #Binary
  * documentation = "Generated report in specified format"
EOF
