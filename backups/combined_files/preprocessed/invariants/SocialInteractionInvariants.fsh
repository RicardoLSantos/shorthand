// Originally defined on lines 1 - 4
Invariant: social-interaction-duration
Description: "Social interaction duration must be positive"
* severity = #error
* expression = "component.where(code.coding.code='89597-9').value.exists() implies component.where(code.coding.code='89597-9').value > 0"

// Originally defined on lines 6 - 9
Invariant: social-interaction-participants
Description: "Number of participants must be at least 2 for social interaction"
* severity = #error
* expression = "component.where(code.coding.code='89600-1').value.exists() implies component.where(code.coding.code='89600-1').value >= 2"

