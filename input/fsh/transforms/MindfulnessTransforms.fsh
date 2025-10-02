// DISABLED (Phase 3.18): StructureMaps require proper logical models for custom types
// These will be re-enabled once logical models are properly defined
// See: Phase 3.18 report for details

// Instance: MindfulnessHealthKitTransform
// InstanceOf: StructureMap
// Usage: #definition
// Title: "HealthKit to FHIR Mindfulness Transform"
//
// * status = #draft
// * name = "MindfulnessHealthKitTransform"
// * structure[0]
//   * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/healthkit-mindfulness"
//   * mode = #source
//   * documentation = "HealthKit mindfulness session structure"
//
// * structure[1]
//   * url = "http://hl7.org/fhir/StructureDefinition/Observation"
//   * mode = #target
//   * documentation = "FHIR Observation resource"
//
// * group[0]
//   * name = "MindfulnessSessionToObservation"
//   * typeMode = #none
//   * input[0]
//     * name = "source"
//     * type = "HealthKitMindfulness"
//     * mode = #source
//   * input[1]
//     * name = "target"
//     * type = "Observation"
//     * mode = #target
//   * rule[0]
//     * name = "Session"
//     * source[0]
//       * context = "source"
//       * element = "startDate"
//     * target[0]
//       * context = "target"
//       * element = "effectiveDateTime"
//   * rule[1]
//     * name = "Duration"
//     * source[0]
//       * context = "source"
//       * element = "duration"
//     * target[0]
//       * context = "target"
//       * element = "component.where(code.coding.code='118682006').valueQuantity"
//
// Instance: MindfulnessCSVTransform
// InstanceOf: StructureMap
// Usage: #definition
// Title: "CSV to FHIR Mindfulness Transform"
//
// * status = #draft
// * name = "MindfulnessCSVTransform"
// * structure[0]
//   * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/csv-mindfulness"
//   * mode = #source
//   * documentation = "CSV mindfulness data structure"
//
// * group[0]
//   * name = "CSVToMindfulnessObservation"
//   * typeMode = #none
//   * input[0]
//     * name = "source"
//     * type = "CSVMindfulness"
//     * mode = #source
//   * input[1]
//     * name = "target"
//     * type = "Observation"
//     * mode = #target
//   * rule[0]
//     * name = "MapDatetime"
//     * source[0]
//       * context = "source"
//       * element = "date,time"
//     * target[0]
//       * context = "target"
//       * element = "effectiveDateTime"
//       * transform = #append

RuleSet: TransformValidationRules
* rule[+]
  * name = "ValidateStatus"
  * source[0]
    * context = "target"
    * element = "status"
  * assert[0]
    * description = "Status must be final"
    * expression = "%status = 'final'"

* rule[+]
  * name = "ValidateCode"
  * source[0]
    * context = "target"
    * element = "code"
  * assert[0]
    * description = "Must use SNOMED CT code"
    * expression = "%code.system = 'http://snomed.info/sct'"
