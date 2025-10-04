// Originally defined on lines 1 - 7
ValueSet: MoodValueSet
Id: mood
Title: "Mood Value Set"
Description: "Value set for mood states"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood"
* ^status = #active

// Originally defined on lines 9 - 21
CodeSystem: MoodCodeSystem
Id: mood
Title: "Mood Code System"
Description: "Code system for mood states"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mood"
* ^status = #active
* ^caseSensitive = true
* #elevated "Elevated" "Mood is higher than normal"
* #neutral "Neutral" "Neither elevated nor depressed mood"
* #depressed "Depressed" "Mood is lower than normal"
* #anxious "Anxious" "Feeling worried or nervous"
* #irritable "Irritable" "Easily annoyed or angered"
* #calm "Calm" "Feeling peaceful and relaxed"

