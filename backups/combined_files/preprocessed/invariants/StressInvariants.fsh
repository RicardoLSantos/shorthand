// Originally defined on lines 1 - 4
Invariant: stress-level-range
Description: "Stress level score must be between 0 and 10"
* severity = #error
* expression = "valueQuantity.exists() implies (valueQuantity.value >= 0 and valueQuantity.value <= 10)"

// Originally defined on lines 6 - 9
Invariant: stress-component-consistency
Description: "Physiological and psychological stress scores must be consistent with overall score"
* severity = #warning
* expression = "component.where(code.coding.code='89593-8').value.exists() and component.where(code.coding.code='89594-6').value.exists() implies (component.where(code.coding.code='89593-8').value + component.where(code.coding.code='89594-6').value) div 2 = valueQuantity"

