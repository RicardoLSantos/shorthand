Invariant: stress-level-range
Description: "Stress level score must be between 0 and 10"
Expression: "valueQuantity.exists() implies (valueQuantity.value >= 0 and valueQuantity.value <= 10)"
Severity: #error

Invariant: stress-component-consistency
Description: "Physiological and psychological stress scores must be consistent with overall score"
Expression: "component.where(code.coding.code='89593-8').value.exists() and component.where(code.coding.code='89594-6').value.exists() implies (component.where(code.coding.code='89593-8').value + component.where(code.coding.code='89594-6').value) div 2 = valueQuantity"
Severity: #warning
