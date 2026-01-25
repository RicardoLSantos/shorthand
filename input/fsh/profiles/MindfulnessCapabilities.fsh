Instance: MindfulnessCapabilityStatement
InstanceOf: CapabilityStatement
Usage: #definition
Title: "Mindfulness Module Capabilities"
Description: "Capabilities supported by the mindfulness module implementation"

* status = #draft
* date = "2024-03-19"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml

* rest[0]
  * mode = #server
  * documentation = "RESTful server capabilities for mindfulness data"
  
  * resource[0]
    * type = #Observation
    * documentation = "Supports mindfulness session observations"
    * profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-observation"
    * interaction[0]
      * code = #read
    * interaction[1]
      * code = #create
    * interaction[2]
      * code = #update
    * interaction[3]
      * code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
      * documentation = "Search by patient reference"
    * searchParam[1]
      * name = "date"
      * type = #date
      * documentation = "Search by session date"
    * searchParam[2]
      * name = "code"
      * type = #token
      * documentation = "Search by observation type"
      
  * resource[1]
    * type = #Questionnaire
    * documentation = "Supports mindfulness questionnaires"
    * interaction[0]
      * code = #read
    * interaction[1]
      * code = #search-type
    * searchParam[0]
      * name = "title"
      * type = #string
      * documentation = "Search by questionnaire title"
      
  * resource[2]
    * type = #QuestionnaireResponse
    * documentation = "Supports mindfulness questionnaire responses"
    * interaction[0]
      * code = #create
    * interaction[1]
      * code = #read
    * interaction[2]
      * code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
      * documentation = "Search by patient reference"
    * searchParam[1]
      * name = "authored"
      * type = #date
      * documentation = "Search by response date"

  // Agent Decision Support Resources (MedAgentBench integration)
  * resource[3]
    * type = #Task
    * documentation = "Supports LLM agent-generated tasks for clinical workflow"
    * profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/agent-task"
    * interaction[0]
      * code = #read
    * interaction[1]
      * code = #create
    * interaction[2]
      * code = #update
    * interaction[3]
      * code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
      * documentation = "Search by patient"
    * searchParam[1]
      * name = "status"
      * type = #token
      * documentation = "Search by task status"
    * searchParam[2]
      * name = "code"
      * type = #token
      * documentation = "Search by task type"
    * searchParam[3]
      * name = "authored-on"
      * type = #date
      * documentation = "Search by creation date"
    * searchParam[4]
      * name = "owner"
      * type = #reference
      * documentation = "Search by assigned clinician"

  * resource[4]
    * type = #ServiceRequest
    * documentation = "Supports LLM agent-generated clinical recommendations"
    * profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/agent-service-request"
    * interaction[0]
      * code = #read
    * interaction[1]
      * code = #create
    * interaction[2]
      * code = #update
    * interaction[3]
      * code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
      * documentation = "Search by patient"
    * searchParam[1]
      * name = "status"
      * type = #token
      * documentation = "Search by request status"
    * searchParam[2]
      * name = "category"
      * type = #token
      * documentation = "Search by service category"
    * searchParam[3]
      * name = "authored"
      * type = #date
      * documentation = "Search by creation date"

  * resource[5]
    * type = #PlanDefinition
    * documentation = "Supports LLM agent decision logic definitions"
    * profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/agent-plan-definition"
    * interaction[0]
      * code = #read
    * interaction[1]
      * code = #search-type
    * searchParam[0]
      * name = "name"
      * type = #string
      * documentation = "Search by plan name"
    * searchParam[1]
      * name = "status"
      * type = #token
      * documentation = "Search by status"
    * searchParam[2]
      * name = "topic"
      * type = #token
      * documentation = "Search by decision topic"
