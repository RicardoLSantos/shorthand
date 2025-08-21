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
    * profile = "https://github.com/RicardoLSantos/shorthand/StructureDefinition/mindfulness-observation"
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
    * profile = "https://github.com/RicardoLSantos/shorthand/StructureDefinition/mindfulness-questionnaire"
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
    * profile = "https://github.com/RicardoLSantos/shorthand/StructureDefinition/mindfulness-questionnaire-response"
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
