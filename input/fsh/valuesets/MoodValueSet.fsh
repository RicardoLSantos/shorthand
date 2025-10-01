ValueSet: MoodValueSet
Id: mood
Title: "Mood Value Set"
Description: "Value set for mood states"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood"
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

CodeSystem: MoodCodeSystem
Id: mood
Title: "Mood Code System"
Description: "Code system for mood states"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mood"
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
* ^caseSensitive = true
* #elevated "Elevated" "Mood is higher than normal"
* #neutral "Neutral" "Neither elevated nor depressed mood"
* #depressed "Depressed" "Mood is lower than normal"
* #anxious "Anxious" "Feeling worried or nervous"
* #irritable "Irritable" "Easily annoyed or angered"
* #calm "Calm" "Feeling peaceful and relaxed"
