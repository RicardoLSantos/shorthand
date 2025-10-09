Invariant: social-interaction-duration
Description: "Social interaction duration must be positive"
Expression: "component.where(code.coding.code='89597-9').value.exists() implies component.where(code.coding.code='89597-9').value > 0"
Severity: #error

Invariant: social-interaction-participants
Description: "Number of participants must be at least 2 for social interaction"
Expression: "component.where(code.coding.code='89600-1').value.exists() implies component.where(code.coding.code='89600-1').value >= 2"
Severity: #error
