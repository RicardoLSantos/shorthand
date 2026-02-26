// iOS/Apple HealthKit Physical Activity CodeSystem
// Based on HKWorkoutActivityType from Apple HealthKit framework
// Source: https://developer.apple.com/documentation/healthkit/hkworkoutactivitytype
// Created: 2025-11-22

CodeSystem: IOSPhysicalActivityCS
Id: ios-physical-activity-cs
Title: "iOS Physical Activity CodeSystem"
Description: "CodeSystem for physical activity types from Apple HealthKit HKWorkoutActivityType. Enables interoperability between iOS Health App data and standard terminologies (SNOMED CT, LOINC)."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ios-physical-activity-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-22"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"
* ^contact.name = "Ricardo L. Santos"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#620 "Portugal"
* ^caseSensitive = true
* ^content = #complete
* ^purpose = "Represents physical activity types captured by iOS Health App (HKWorkoutActivityType). Used as source codes in ConceptMaps to SNOMED CT for semantic interoperability with clinical systems."

// Core aerobic activities (most common)
* #walking "Walking"
  "General walking activity, includes outdoor and indoor walking. Maps to HKWorkoutActivityType.walking."
* #running "Running"
  "Running activity, includes outdoor and indoor running. Maps to HKWorkoutActivityType.running."
* #cycling "Cycling"
  "Cycling activity, includes outdoor and stationary cycling. Maps to HKWorkoutActivityType.cycling."
* #swimming "Swimming"
  "Swimming activity, includes pool and open water swimming. Maps to HKWorkoutActivityType.swimming."

// Other common activities
* #hiking "Hiking"
  "Hiking activity. Maps to HKWorkoutActivityType.hiking."
* #yoga "Yoga"
  "Yoga practice. Maps to HKWorkoutActivityType.yoga."
* #dancing "Dancing"
  "Dancing activity, includes social dance. Maps to HKWorkoutActivityType.dance and HKWorkoutActivityType.socialDance."
* #strength-training "Strength Training"
  "Traditional strength training with weights. Maps to HKWorkoutActivityType.traditionalStrengthTraining."

// Racket sports
* #tennis "Tennis"
  "Tennis. Maps to HKWorkoutActivityType.tennis."
* #badminton "Badminton"
  "Badminton. Maps to HKWorkoutActivityType.badminton."
* #squash "Squash"
  "Squash. Maps to HKWorkoutActivityType.squash."
* #table-tennis "Table Tennis"
  "Table tennis (ping pong). Maps to HKWorkoutActivityType.tableTennis."

// Team sports
* #soccer "Soccer"
  "Soccer (football). Maps to HKWorkoutActivityType.soccer."
* #basketball "Basketball"
  "Basketball. Maps to HKWorkoutActivityType.basketball."
* #volleyball "Volleyball"
  "Volleyball. Maps to HKWorkoutActivityType.volleyball."

// Mind-body activities
* #tai-chi "Tai Chi"
  "Tai Chi practice. Maps to HKWorkoutActivityType.taiChi."
* #pilates "Pilates"
  "Pilates exercise. Maps to HKWorkoutActivityType.pilates."

// Water activities
* #rowing "Rowing"
  "Rowing activity. Maps to HKWorkoutActivityType.rowing."
* #paddle-sports "Paddle Sports"
  "Paddle sports including kayaking, canoeing. Maps to HKWorkoutActivityType.paddleSports."

// Winter activities
* #skiing "Skiing"
  "Skiing activity. Maps to HKWorkoutActivityType.downhillSkiing and HKWorkoutActivityType.crossCountrySkiing."
* #snowboarding "Snowboarding"
  "Snowboarding. Maps to HKWorkoutActivityType.snowboarding."

// Other
* #climbing "Climbing"
  "Climbing activity. Maps to HKWorkoutActivityType.climbing."
* #golf "Golf"
  "Golf. Maps to HKWorkoutActivityType.golf."
* #elliptical "Elliptical"
  "Elliptical trainer exercise. Maps to HKWorkoutActivityType.elliptical."
* #stairs "Stairs"
  "Stair climbing. Maps to HKWorkoutActivityType.stairs and HKWorkoutActivityType.stairStepper."

// Aggregate activity metrics (from wearables)
* #active-minutes "Active Minutes"
  "Minutes of activity in heart rate zones (moderate to vigorous). Apple: Exercise Ring minutes, Fitbit: Active Zone Minutes, Garmin: Intensity Minutes."

* #met-minutes "MET-Minutes"
  "Metabolic Equivalent of Task × Duration. Standard measure for physical activity dose. 1 MET = 1 kcal/kg/hour (resting). Target: 500-1000 MET-min/week per guidelines."

* #sedentary-time "Sedentary Time"
  "Time spent in sedentary activities (<1.5 METs). Target: Reduce prolonged sitting, break every 30-60 min. Independent risk factor for mortality."

* #floors-climbed "Floors Climbed"
  "Number of floors/flights of stairs climbed. Indicates vertical displacement activity. Typically measured via barometric altimeter."

* #stand-hours "Stand Hours"
  "Hours with at least 1 minute standing. Apple Watch specific metric. Target: 12 stand hours/day. Proxy for sedentary behavior interruption."
