// Originally defined on lines 1 - 4
Invariant: mindfulness-session-duration
Description: "Mindfulness session duration must be between 1 and 180 minutes"
* severity = #error
* expression = "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').value.ofType(Quantity).value.exists() implies (component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').value.ofType(Quantity).value >= 1 and component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').value.ofType(Quantity).value <= 180)"

// Originally defined on lines 6 - 9
Invariant: mindfulness-stress-level
Description: "Stress level must be between 0 and 10"
* severity = #error
* expression = "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='725854004').value.ofType(Integer).exists() implies (component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='725854004').value.ofType(Integer) >= 0 and component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='725854004').value.ofType(Integer) <= 10)"

// Originally defined on lines 11 - 14
Invariant: mindfulness-mood-required
Description: "Mood assessment must include a mood state and intensity"
* severity = #warning
* expression = "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='373931001').exists() implies component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='373931001').value.exists()"

// Originally defined on lines 16 - 19
Invariant: mindfulness-context-complete
Description: "Mindfulness context should include location and environment"
* severity = #warning
* expression = "extension.where(url='https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-context').exists() implies (extension.where(url='https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-context').extension.where(url='location').exists() and extension.where(url='https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-context').extension.where(url='environment').exists())"

// Originally defined on lines 21 - 24
Invariant: sequential-measurements
Description: "Sequential measurements must have increasing effectiveDateTime"
* severity = #warning
* expression = "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').exists() implies (effectiveDateTime > previous().effectiveDateTime)"

