// Originally defined on lines 1 - 73
Instance: MindfulnessCapabilityStatement
InstanceOf: CapabilityStatement
Title: "Mindfulness Module Capabilities"
Description: "Capabilities supported by the mindfulness module implementation"
Usage: #definition
* status = #draft
* date = "2024-03-19"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml
* rest[0]
* rest[0].mode = #server
* rest[0].documentation = "RESTful server capabilities for mindfulness data"
* rest[0].resource[0]
* rest[0].resource[0].type = #Observation
* rest[0].resource[0].documentation = "Supports mindfulness session observations"
* rest[0].resource[0].profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-observation"
* rest[0].resource[0].interaction[0]
* rest[0].resource[0].interaction[0].code = #read
* rest[0].resource[0].interaction[1]
* rest[0].resource[0].interaction[1].code = #create
* rest[0].resource[0].interaction[2]
* rest[0].resource[0].interaction[2].code = #update
* rest[0].resource[0].interaction[3]
* rest[0].resource[0].interaction[3].code = #search-type
* rest[0].resource[0].searchParam[0]
* rest[0].resource[0].searchParam[0].name = "patient"
* rest[0].resource[0].searchParam[0].type = #reference
* rest[0].resource[0].searchParam[0].documentation = "Search by patient reference"
* rest[0].resource[0].searchParam[1]
* rest[0].resource[0].searchParam[1].name = "date"
* rest[0].resource[0].searchParam[1].type = #date
* rest[0].resource[0].searchParam[1].documentation = "Search by session date"
* rest[0].resource[0].searchParam[2]
* rest[0].resource[0].searchParam[2].name = "code"
* rest[0].resource[0].searchParam[2].type = #token
* rest[0].resource[0].searchParam[2].documentation = "Search by observation type"
* rest[0].resource[1]
* rest[0].resource[1].type = #Questionnaire
* rest[0].resource[1].documentation = "Supports mindfulness questionnaires"
* rest[0].resource[1].profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-questionnaire"
* rest[0].resource[1].interaction[0]
* rest[0].resource[1].interaction[0].code = #read
* rest[0].resource[1].interaction[1]
* rest[0].resource[1].interaction[1].code = #search-type
* rest[0].resource[1].searchParam[0]
* rest[0].resource[1].searchParam[0].name = "title"
* rest[0].resource[1].searchParam[0].type = #string
* rest[0].resource[1].searchParam[0].documentation = "Search by questionnaire title"
* rest[0].resource[2]
* rest[0].resource[2].type = #QuestionnaireResponse
* rest[0].resource[2].documentation = "Supports mindfulness questionnaire responses"
* rest[0].resource[2].profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-questionnaire-response"
* rest[0].resource[2].interaction[0]
* rest[0].resource[2].interaction[0].code = #create
* rest[0].resource[2].interaction[1]
* rest[0].resource[2].interaction[1].code = #read
* rest[0].resource[2].interaction[2]
* rest[0].resource[2].interaction[2].code = #search-type
* rest[0].resource[2].searchParam[0]
* rest[0].resource[2].searchParam[0].name = "patient"
* rest[0].resource[2].searchParam[0].type = #reference
* rest[0].resource[2].searchParam[0].documentation = "Search by patient reference"
* rest[0].resource[2].searchParam[1]
* rest[0].resource[2].searchParam[1].name = "authored"
* rest[0].resource[2].searchParam[1].type = #date
* rest[0].resource[2].searchParam[1].documentation = "Search by response date"

