// CodeSystem: Mindfulness Alert Type
CodeSystem: MindfulnessAlertTypeCS
Id: mindfulness-alert-type
Title: "Mindfulness Alert Type"
Description: "Types of alerts for mindfulness practice reminders and notifications"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-alert-type"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #reminder "Mindfulness Reminder" "Alert to remind user to practice mindfulness"
* #session-start "Session Start" "Alert when mindfulness session begins"
* #session-end "Session End" "Alert when mindfulness session ends"
* #goal-achieved "Goal Achieved" "Alert when mindfulness goal is achieved"
* #streak "Streak Milestone" "Alert for consecutive days of practice"

// CodeSystem: Mindfulness Config Type
CodeSystem: MindfulnessConfigTypeCS
Id: mindfulness-config-type
Title: "Mindfulness Configuration Type"
Description: "Types of configuration settings for mindfulness practice"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-config-type"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #settings "Mindfulness Settings" "General mindfulness practice settings"
* #audit "Audit Configuration" "Configuration for audit and tracking"
* #notifications "Notification Settings" "Alert and notification preferences"
* #privacy "Privacy Settings" "Data privacy and security settings"
* #goals "Goal Settings" "Mindfulness practice goals and targets"

// CodeSystem: Mindfulness Schedule Type
CodeSystem: MindfulnessScheduleTypeCS
Id: mindfulness-schedule-type
Title: "Mindfulness Schedule Type"
Description: "Types of schedules for mindfulness practice sessions"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-schedule-type"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #daily "Daily Schedule" "Daily mindfulness practice schedule"
* #weekly "Weekly Schedule" "Weekly mindfulness practice schedule"
* #recurring "Recurring Schedule" "Recurring mindfulness practice schedule"
* #custom "Custom Schedule" "Custom-defined practice schedule"
* #on-demand "On Demand" "Practice sessions initiated by user"

// CodeSystem: Mindfulness Audit Type
CodeSystem: MindfulnessAuditTypeCS
Id: mindfulness-audit-type
Title: "Mindfulness Audit Type"
Description: "Types of audit events for mindfulness practice tracking"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-audit-type"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #session "Session Audit" "Audit of mindfulness practice session"
* #data-access "Data Access" "Audit of mindfulness data access"
* #config-change "Configuration Change" "Audit of configuration changes"
* #export "Data Export" "Audit of data export operations"

// CodeSystem: Mobility Assessment Method
CodeSystem: MobilityAssessmentMethodCS
Id: mobility-assessment-method
Title: "Mobility Assessment Method"
Description: "Methods used to assess mobility and balance"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mobility-assessment-method"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #sensor "Sensor-based" "Assessment using device sensors (accelerometer, gyroscope)"
* #clinical "Clinical Assessment" "Assessment by healthcare professional"
* #self-report "Self-reported" "User-reported mobility assessment"
* #timed-test "Timed Test" "Timed mobility performance test"
* #standardized "Standardized Test" "Standardized mobility assessment test"

// CodeSystem: Mindfulness Message Events
CodeSystem: MindfulnessMessageEventsCS
Id: mindfulness-message-events
Title: "Mindfulness Message Events"
Description: "Events that trigger mindfulness-related messages"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-message-events"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #start-session "Start Session" "Event when mindfulness session starts"
* #session-start "Session Start" "Event when mindfulness session starts (alias)"
* #end-session "End Session" "Event when mindfulness session ends"
* #session-end "Session End" "Event when mindfulness session ends (alias)"
* #pause "Pause Session" "Event when session is paused"
* #resume "Resume Session" "Event when session is resumed"
* #complete "Complete Practice" "Event when practice goal is completed"
