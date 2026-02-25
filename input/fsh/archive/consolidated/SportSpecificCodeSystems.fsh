// Sport-Specific CodeSystems for iOS Lifestyle Medicine IG
// Supporting cycling, running, swimming, and strength training profiles
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP

// ============================================================================
// CYCLING METRICS CODE SYSTEM
// ============================================================================

CodeSystem: CyclingMetricsCS
Id: cycling-metrics-cs
Title: "Cycling Metrics CodeSystem"
Description: "CodeSystem for cycling dynamics and power metrics from cycling computers and smart trainers."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cycling-metrics-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-28"
* ^publisher = "Ricardo Lourenco dos Santos, FMUP"
* ^caseSensitive = true
* ^content = #complete

// Power metrics
* #instant-power "Instantaneous Power" "Current power output in watts"
* #avg-power "Average Power" "Arithmetic mean of power output over the activity"
* #np "Normalized Power" "Weighted average power accounting for variability (Coggan formula)"
* #max-power "Maximum Power" "Peak power achieved during the activity"
* #ftp "Functional Threshold Power" "Highest power sustainable for approximately one hour"
* #power-to-weight "Power-to-Weight Ratio" "Power output relative to body mass (W/kg)"

// Training load
* #tss "Training Stress Score" "Quantifies training load from power data"
* #if "Intensity Factor" "Ratio of Normalized Power to FTP"
* #ctl "Chronic Training Load" "Long-term training load (fitness)"
* #atl "Acute Training Load" "Short-term training load (fatigue)"
* #tsb "Training Stress Balance" "CTL minus ATL (form)"
* #kj "Kilojoules" "Work performed in kilojoules"

// Cadence
* #cadence "Cadence" "Current pedaling rate"
* #avg-cadence "Average Cadence" "Mean cadence over the activity"

// Balance and pedaling dynamics
* #lr-balance "Left/Right Power Balance" "Power distribution between legs"
* #left-te "Left Torque Effectiveness" "Percentage of positive torque on left side"
* #right-te "Right Torque Effectiveness" "Percentage of positive torque on right side"
* #left-ps "Left Pedal Smoothness" "Consistency of power application on left pedal stroke"
* #right-ps "Right Pedal Smoothness" "Consistency of power application on right pedal stroke"

// Session
* #avg-speed "Average Speed" "Mean speed over the activity"
* #elevation "Elevation Gain" "Total vertical meters climbed"
* #zone "Training Zone" "Coggan power zone (1-7)"
* #type "Activity Type" "Type of cycling activity"


// ============================================================================
// RUNNING METRICS CODE SYSTEM
// ============================================================================

CodeSystem: RunningMetricsCS
Id: running-metrics-cs
Title: "Running Metrics CodeSystem"
Description: "CodeSystem for running dynamics and biomechanical metrics from wearable devices."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/running-metrics-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-28"
* ^publisher = "Ricardo Lourenco dos Santos, FMUP"
* ^caseSensitive = true
* ^content = #complete

// Ground contact
* #gct "Ground Contact Time" "Duration of foot contact with the ground per step"
* #gcb "Ground Contact Balance" "Percentage of ground contact time on the left foot"
* #flight-time "Flight Time" "Time when both feet are off the ground"
* #duty-factor "Duty Factor" "Ground contact time as percentage of stride cycle"

// Vertical motion
* #vo "Vertical Oscillation" "Vertical bounce during running"
* #vr "Vertical Ratio" "Vertical oscillation relative to stride length"

// Cadence and stride
* #cadence "Running Cadence" "Steps per minute during running"
* #stride "Stride Length" "Distance covered in two steps"
* #step-length "Step Length" "Distance covered in one step"
* #step-variability "Step Rate Variability" "Variability in step timing"

// Power
* #power "Running Power" "Instantaneous running power in watts"
* #form-power "Form Power" "Power used for bouncing/oscillation"
* #fpr "Form Power Ratio" "Form power as percentage of total power"
* #air-power "Air Power" "Power used to overcome air resistance"

// Impact and biomechanics
* #stiffness "Leg Stiffness" "Spring-like behavior of the leg"
* #v-stiffness "Vertical Stiffness" "Vertical component of leg stiffness"
* #impact "Impact G-forces" "Peak impact force in G-forces"
* #braking "Braking G-forces" "Braking force in G-forces"
* #loading-rate "Impact Loading Rate" "Rate of impact force application"
* #footstrike "Footstrike Type" "Pattern of foot contact with ground"
* #pronation "Pronation Angle" "Inward roll angle of the foot"

// Session
* #pace "Pace" "Time per distance unit"
* #speed "Average Speed" "Mean speed over the activity"
* #elevation "Elevation Gain" "Total elevation climbed"

// Scores
* #symmetry "Symmetry Score" "Left-right symmetry percentage"
* #form-score "Form Score" "Overall running form score (0-100)"
* #injury-risk "Injury Risk" "Estimated injury risk based on biomechanics"
* #efficiency "Running Economy" "Oxygen cost per distance at given speed"


// ============================================================================
// SWIMMING METRICS CODE SYSTEM
// ============================================================================

CodeSystem: SwimmingMetricsCS
Id: swimming-metrics-cs
Title: "Swimming Metrics CodeSystem"
Description: "CodeSystem for swimming performance metrics from wearable devices."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/swimming-metrics-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-28"
* ^publisher = "Ricardo Lourenco dos Santos, FMUP"
* ^caseSensitive = true
* ^content = #complete

// Session summary
* #distance "Total Distance" "Total distance swum in the session"
* #laps "Total Laps" "Total number of pool lengths completed"
* #strokes "Total Strokes" "Total number of strokes in the session"
* #active-time "Active Swim Time" "Time spent actively swimming"
* #rest-time "Rest Time" "Time spent resting between sets"

// Stroke metrics
* #stroke-type "Primary Stroke Type" "Main stroke type used in the session"
* #strokes-per-lap "Strokes Per Lap" "Average number of strokes per lap"
* #stroke-rate "Stroke Rate" "Number of strokes per minute"
* #dps "Distance Per Stroke" "Average distance traveled per stroke"
* #stroke-index "Stroke Index" "Swimming efficiency metric (speed x DPS)"

// SWOLF
* #avg-swolf "Average SWOLF" "Average SWOLF score for the session"
* #best-swolf "Best SWOLF" "Best (lowest) SWOLF score achieved"

// Pace
* #avg-pace "Average Pace" "Average time per 100 meters"
* #best-pace "Best Pace" "Fastest pace achieved"
* #speed "Average Speed" "Average swimming speed"
* #css "Critical Swim Speed" "Sustainable threshold pace"

// Environment
* #pool-length "Pool Length" "Length of the pool"
* #environment "Swimming Environment" "Type of swimming venue"

// Heart rate
// NOTE: LOINC 101692-2 now used as primary code in SwimmingWorkoutObservation (verified 2026-02-24)
// This custom code retained for backward compatibility and ConceptMap references
* #max-hr "Maximum Heart Rate" "Maximum heart rate reached during session"

// Training effect
* #aerobic-te "Aerobic Training Effect" "Impact on aerobic fitness (0-5)"
* #anaerobic-te "Anaerobic Training Effect" "Impact on anaerobic capacity (0-5)"
* #training-load "Training Load" "Quantified training stress"


// ============================================================================
// STRENGTH TRAINING CODE SYSTEM
// ============================================================================

CodeSystem: StrengthTrainingCS
Id: strength-training-cs
Title: "Strength Training CodeSystem"
Description: "CodeSystem for strength training metrics from gym equipment and VBT devices."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/strength-training-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-28"
* ^publisher = "Ricardo Lourenco dos Santos, FMUP"
* ^caseSensitive = true
* ^content = #complete

// Exercise identification
* #exercise-name "Exercise Name" "Name of the exercise performed"
* #category "Exercise Category" "Classification of the exercise type"
* #muscle "Primary Muscle Group" "Main muscle groups targeted"
* #equipment "Equipment Type" "Type of equipment used"

// Set details
* #set-num "Set Number" "Sequential number of the set"
* #set-type "Set Type" "Classification of the set"
* #reps "Repetitions Performed" "Actual number of repetitions completed"
* #target-reps "Target Repetitions" "Planned number of repetitions"
* #load "Load" "Weight/resistance used for the set"
* #pct-1rm "Percentage of 1RM" "Load expressed as percentage of one repetition maximum"
* #rir "Repetitions in Reserve" "Estimated repetitions remaining before failure"
* #set-rpe "Set RPE" "Rating of Perceived Exertion for the set"
* #rest "Rest Period" "Rest time taken after this set"
* #tempo "Tempo" "Tempo prescription (e.g., 3-1-2-0)"

// Velocity-based training
* #mean-vel "Mean Concentric Velocity" "Average velocity during the concentric phase"
* #peak-vel "Peak Concentric Velocity" "Maximum velocity achieved during concentric phase"
* #vel-loss "Velocity Loss" "Percentage decrease in velocity from first to last rep"
* #mean-power "Mean Power Output" "Average power generated during the lift"
* #peak-power "Peak Power Output" "Maximum power achieved during the lift"
* #rom "Range of Motion" "Vertical displacement of the bar/implement"
* #tut "Time Under Tension" "Total duration of muscle tension during the set"

// Volume
* #total-sets "Total Sets" "Total number of working sets performed"
* #total-reps "Total Repetitions" "Sum of all repetitions across all sets"
* #volume-load "Volume Load" "Total volume = sets x reps x load"
* #avg-intensity "Average Intensity" "Mean percentage of 1RM across all working sets"

// 1RM
* #tested-1rm "Tested 1RM" "Directly tested one repetition maximum"
* #est-1rm "Estimated 1RM" "One repetition maximum calculated from submaximal performance"
* #est-method "1RM Estimation Method" "Formula or method used to estimate 1RM"

// Session
* #session-rpe "Session RPE" "Overall rating of perceived exertion for the session"
* #session-load "Session Training Load" "Session RPE x duration (sRPE method)"
* #training-type "Training Type" "Primary training goal of the session"
* #split-type "Split Type" "Training split/body part organization"
