Invariant: mindfulness-session-duration
Description: "Mindfulness session duration must be between 1 and 180 minutes"
Expression: "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').value.ofType(Quantity).value.exists() implies (component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').value.ofType(Quantity).value >= 1 and component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').value.ofType(Quantity).value <= 180)"
Severity: #error

Invariant: mindfulness-stress-level
Description: "Stress level must be between 0 and 10"
Expression: "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='725854004').value.ofType(Integer).exists() implies (component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='725854004').value.ofType(Integer) >= 0 and component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='725854004').value.ofType(Integer) <= 10)"
Severity: #error

Invariant: mindfulness-mood-required
Description: "Mood assessment must include a mood state and intensity"
Expression: "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='373931001').exists() implies component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='373931001').value.exists()"
Severity: #warning

Invariant: mindfulness-context-complete
Description: "Mindfulness context should include location and environment"
Expression: "extension.where(url='https://example.org/StructureDefinition/mindfulness-context').exists() implies (extension.where(url='https://example.org/StructureDefinition/mindfulness-context').extension.where(url='location').exists() and extension.where(url='https://example.org/StructureDefinition/mindfulness-context').extension.where(url='environment').exists())"
Severity: #warning

Invariant: sequential-measurements
Description: "Sequential measurements must have increasing effectiveDateTime"
Expression: "component.where(code.coding.system='http://snomed.info/sct' and code.coding.code='118682006').exists() implies (effectiveDateTime > previous().effectiveDateTime)"
Severity: #warning
