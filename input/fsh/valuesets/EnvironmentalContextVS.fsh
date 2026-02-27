ValueSet: EnvironmentalContextValueSet
Id: environmental-context-vs
Title: "Environmental Context Value Set"
Description: "Valid contexts for environmental measurements"
* ^experimental = false

* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/environmental-context-vs"
* AppLogicCS#environment-indoor "Indoor"
* AppLogicCS#environment-outdoor "Outdoor"
* AppLogicCS#environment-urban "Urban"
* AppLogicCS#environment-rural "Rural"
* AppLogicCS#environment-workplace "Workplace"
* AppLogicCS#environment-home "Home"
* AppLogicCS#healthcare-facility "Healthcare Facility"
* AppLogicCS#environment-recreational "Recreational"
