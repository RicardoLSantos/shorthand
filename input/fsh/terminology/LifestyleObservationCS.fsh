// Lifestyle Medicine Observation CodeSystem
// For concepts not covered by LOINC or SNOMED CT
// Created: 2025-10-01

CodeSystem: LifestyleObservationCS
Id: lifestyle-observation-cs
Title: "Lifestyle Medicine Observation Codes"
Description: "Local codes for lifestyle medicine observations not covered by standard terminologies like LOINC. These codes are used for consumer health device data and wellness measurements where standardized codes do not exist."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 42

// Sleep Measurements (5 codes)
* #sleep-panel "Sleep measurement panel"
  "Panel for comprehensive sleep measurements including duration, stages, and quality metrics"

// Environmental Noise Exposure (4 codes)
* #noise-avg "Environmental noise average level"
  "Average environmental noise level measured in decibels (dB) over a specified time period"

* #noise-duration "Environmental noise exposure duration"
  "Duration of exposure to environmental noise above a threshold level"

* #noise-peak "Peak environmental sound level"
  "Maximum (peak) environmental sound level measured during a monitoring period"

* #noise-background "Background environmental noise level"
  "Baseline or background environmental noise level measured in quiet conditions"

* #sleep-deep "Deep sleep duration"
  "Duration of deep (slow-wave) sleep stage as measured by consumer sleep tracking device"

* #sleep-light "Light sleep duration"
  "Duration of light sleep stage as measured by consumer sleep tracking device"

* #sleep-awakenings "Number of sleep awakenings"
  "Count of awakenings or sleep interruptions during a sleep period"

* #sleep-time-bed "Time in bed"
  "Total time spent in bed, including time awake before and after sleep"

// Social Interaction Metrics (4 codes)
* #social-duration "Social interaction duration"
  "Total duration of social interactions or time spent in social activities"

* #social-quality "Social interaction quality score"
  "Subjective quality rating of social interactions"

* #social-medium "Social interaction medium"
  "Method or medium of social interaction (in-person, phone, video, text, etc.)"

* #social-count "Number of social interactions"
  "Count of distinct social interactions or social contacts during a time period"

// Stress Assessment Components (3 codes)
* #stress-physiological "Physiological stress indicator"
  "Physiological markers or indicators of stress response (e.g., heart rate variability, cortisol)"

* #stress-psychological "Psychological stress score"
  "Self-reported psychological stress level or score from validated assessment"

* #stress-chronicity "Stress chronicity assessment"
  "Assessment of stress duration and persistence (acute vs. chronic stress)"

* #stress-impact "Stress impact assessment"
  "Assessment of the impact or severity of stress on daily functioning and health"

// Environmental Exposure (2 codes)
* #uv-index "UV index"
  "Ultraviolet radiation index measurement indicating sun exposure intensity"

* #uv-duration "UV exposure duration"
  "Duration of exposure to ultraviolet radiation"

* #uv-intensity "UV intensity"
  "Intensity of ultraviolet radiation exposure"

* #exposure-time "Time of environmental exposure"
  "Duration of time exposed to a specific environmental condition"

// Advanced Vital Signs (9 codes)
* #hrv-frequency "Heart rate variability frequency band"
  "Heart rate variability measurement in specific frequency band (LF, HF, VLF)"

* #hrv-entropy "Heart rate variability entropy"
  "Entropy measurement of heart rate variability indicating complexity"

* #pulse-wave "Pulse wave analysis"
  "Analysis of arterial pulse wave characteristics"

* #respiratory-variability "Respiratory rate variability"
  "Variability in respiratory rate over time"

* #oxygenation-index "Oxygenation index"
  "Calculated index of blood oxygenation efficiency"

* #physiological-stress "Physiological stress index"
  "Composite index of physiological stress markers"

* #temperature-gradient "Temperature gradient"
  "Body temperature gradient measurement"

* #autonomic-balance "Autonomic balance index"
  "Index measuring balance between sympathetic and parasympathetic activity"

* #recovery-rate "Recovery rate index"
  "Index measuring rate of physiological recovery after activity"

* #allostatic-load "Allostatic load index"
  "Measure of cumulative physiological burden and wear-and-tear on the body from chronic stress"

// Mobility Metrics (4 codes)
* #balance-score "Balance assessment score"
  "Quantitative score from balance assessment test"

* #balance-assessment "Balance assessment"
  "Comprehensive balance and stability assessment"

* #gait-assessment "Gait assessment"
  "Assessment of walking pattern and gait characteristics"

* #movement-assessment "Movement assessment"
  "General movement quality and mobility assessment"

// Nutrition Tracking (5 codes)
* #caloric-intake "Total caloric intake"
  "Total calories consumed in a specified time period"

* #macronutrients-panel "Macronutrients intake panel"
  "Panel for comprehensive macronutrient intake measurements"

* #protein-intake "Protein intake"
  "Amount of protein consumed"

* #fat-intake "Fat intake"
  "Amount of dietary fats consumed"

* #carbohydrate-intake "Carbohydrate intake"
  "Amount of carbohydrates consumed"

// Reproductive Health (1 code)
* #ovulation-status "Ovulation status"
  "Status of ovulation as measured by consumer fertility tracking device"

// Body Composition (1 code)
* #body-composition-panel "Body composition measurement panel"
  "Panel for comprehensive body composition measurements from bioimpedance analysis"


// ValueSet for all local lifestyle codes
ValueSet: LifestyleObservationVS
Id: lifestyle-observation-vs
Title: "Lifestyle Medicine Observation Value Set"
Description: "Value set containing all local lifestyle medicine observation codes"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/lifestyle-observation-vs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleObservationCS
