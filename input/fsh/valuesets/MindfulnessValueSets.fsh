ValueSet: EnvironmentTypeValueSet
Id: environment-type
Title: "Environment Type Value Set"
Description: "Value set for environmental context types"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/environment-type"
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* AppLogicCS#environment-type-indoor "Indoor"
* AppLogicCS#environment-type-outdoor "Outdoor"
* AppLogicCS#quiet "Quiet Space"
* AppLogicCS#environment-type-group "Group Setting"

ValueSet: MindfulnessTypeValueSet
Id: mindfulness-type
Title: "Mindfulness Type Value Set"
Description: "Value set for types of mindfulness practices"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-type"
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* LifestyleMedicineTemporaryCS#mindfulness-type-meditation "Meditation"
* LifestyleMedicineTemporaryCS#breathing "Breathing Exercise"
* LifestyleMedicineTemporaryCS#bodyScan "Body Scan"
* LifestyleMedicineTemporaryCS#mindfulness-type-walking "Mindful Walking"
* LifestyleMedicineTemporaryCS#movement "Mindful Movement"
