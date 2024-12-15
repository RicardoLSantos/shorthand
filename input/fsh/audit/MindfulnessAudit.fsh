Instance: MindfulnessAuditEvent
InstanceOf: AuditEvent
Usage: #definition
Title: "Mindfulness Session Audit Event"

* type = http://terminology.hl7.org/CodeSystem/audit-event-type#rest "RESTful Operation"
* subtype[0] = http://hl7.org/fhir/restful-interaction#create "create"
* action = #C
* recorded = "2024-03-19T10:00:00Z"
* outcome = #0

* agent[0]
  * type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
  * who.identifier.system = "http://example.org/practitioners"
  * who.identifier.value = "practitioner123"
  * requestor = true
  * network.address = "127.0.0.1"
  * network.type = #2

* source
  * observer.identifier.system = "http://example.org/mindfulness-systems"
  * observer.identifier.value = "mindfulness-app"
  * type = http://terminology.hl7.org/CodeSystem/security-source-type#4

* entity[0]
  * what.reference = "Observation/mindfulness-session-1"
  * type = http://terminology.hl7.org/CodeSystem/audit-entity-type#2
  * role = http://terminology.hl7.org/CodeSystem/object-role#4

RuleSet: AuditRequirements
* type MS
* subtype MS
* action MS
* recorded MS
* outcome MS
* agent MS
* source MS
* entity MS

* agent obeys audit-agent-who
* source obeys audit-source-observer
* entity obeys audit-entity-what

Invariant: audit-agent-who
Description: "Agent must have who reference"
Expression: "agent.all(who.exists())"
Severity: #error

Invariant: audit-source-observer
Description: "Source must have observer"
Expression: "source.observer.exists()"
Severity: #error

Invariant: audit-entity-what
Description: "Entity must have what reference"
Expression: "entity.all(what.exists())"
Severity: #error

Instance: MindfulnessAuditConfig
InstanceOf: Basic
Usage: #definition
Title: "Mindfulness Audit Configuration"

* extension[0]
  * url = "http://example.org/StructureDefinition/audit-config"
  * extension[0]
    * url = "eventTypes"
    * valueCode = #create
  * extension[1]
    * url = "eventTypes"
    * valueCode = #update
  * extension[2]
  * valueCode = #delete
EOF
