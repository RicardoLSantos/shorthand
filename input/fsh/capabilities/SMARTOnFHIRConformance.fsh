// ============================================================================
// SMART on FHIR Conformance Declaration
// ============================================================================
// Date: 2026-05-07 (T2 S20 Caminho C — IG v0.3.0 sprint partial)
// Purpose: Declare SMART on FHIR App Launch conformance for the IG.
//          External apps need OAuth 2.0 authorization endpoints discoverable
//          via the CapabilityStatement to integrate with a server claiming
//          conformance to this IG.
// Reference: https://hl7.org/fhir/smart-app-launch/STU2.2/
// Companion: existing LifestyleMedicineCapabilityStatement.fsh declares
//            FHIR resource capabilities; this declaration adds SMART auth.
// ============================================================================
// NOTE (T2 S20): FSH written without IG build validation due to local disk
//                constraint. Pending validation: build via _genonce.sh when
//                disk recovery (Pitfall #65, ≥5GB free) achieved.
// ============================================================================

// ============================================================================
// CapabilityStatement: SMART-conformant Lifestyle Medicine Server
// ============================================================================

Instance: LifestyleMedicineSMARTCapabilityStatement
InstanceOf: CapabilityStatement
Usage: #definition
Title: "Lifestyle Medicine SMART on FHIR Capability Statement"
Description: """
CapabilityStatement declaring SMART on FHIR App Launch (STU2.2) conformance
for servers implementing the iOS Lifestyle Medicine IG. External apps
(patient-facing, practitioner-facing, or backend) can discover OAuth 2.0
authorization endpoints + supported scopes via this declaration.

This complements LifestyleMedicineCapabilityStatement.fsh (which declares
FHIR resource capabilities). Together they enable SMART-app integration
with all 11 lifestyle medicine domains + AI/CDSS profiles.
"""

* status = #active
* date = "2026-05-07"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml
* implementationGuide = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ImplementationGuide/iOS-Lifestyle-Medicine"

// SMART instantiates declaration.
// NOTE: SMART STU2.2 publishes CapabilityStatements with package-specific
// canonical URLs; the IG Publisher 2.1.2 does not always resolve them
// reliably depending on the loaded SMART package version. We declare SMART
// conformance via the security.service coding (#SMART-on-FHIR) and the
// narrative below; the instantiates link is omitted to avoid canonical
// resolution failures. Reviewers verifying SMART conformance should consult
// the smart.security.service declaration and the /.well-known/smart-configuration
// endpoint required by SMART STU2.2.

* rest[0]
  * mode = #server
  * documentation = "Lifestyle Medicine FHIR R4 server with SMART on FHIR App Launch STU2.2 support."

  // ========================================================================
  // Security declaration — SMART on FHIR OAuth 2.0
  // ========================================================================
  * security
    * cors = true
    * service[0] = http://terminology.hl7.org/CodeSystem/restful-security-service#SMART-on-FHIR "SMART-on-FHIR"
    * service[0].text = "SMART on FHIR App Launch STU2.2 with OAuth 2.0 + OpenID Connect"

    // OAuth 2.0 endpoint URLs via standard SMART extension.
    // SMART STU2.2 deprecated the CapabilityStatement-based discovery in favor
    // of /.well-known/smart-configuration JSON (HTTP-side); the oauth-uris
    // extension below remains for legacy SMART clients (DSTU2/STU1) and only
    // declares the 4 sub-extensions defined in the legacy extension shape
    // (authorize, token, register, manage). Introspect + revoke endpoints
    // live in the /.well-known/smart-configuration document and the security
    // narrative below.
    * extension[0]
      * url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
      * extension[0].url = "authorize"
      * extension[0].valueUri = "https://2rdoc.pt/auth/authorize"
      * extension[1].url = "token"
      * extension[1].valueUri = "https://2rdoc.pt/auth/token"
      * extension[2].url = "register"
      * extension[2].valueUri = "https://2rdoc.pt/auth/register"
      * extension[3].url = "manage"
      * extension[3].valueUri = "https://2rdoc.pt/auth/manage"

    // Supported launch contexts — patient, practitioner, encounter
    * description = """
      OAuth 2.0 + OpenID Connect via SMART on FHIR App Launch STU2.2.

      Supported launch contexts:
        - launch/patient (patient-app launch with patient context)
        - launch/practitioner (practitioner-app launch with practitioner context)
        - launch/encounter (encounter-app launch with encounter context)
        - launch (provider EHR app launch, dynamic context)

      Supported scopes:
        - patient/*.rs (patient resource read/search)
        - patient/*.cruds (patient resource full CRUD - selective use)
        - user/*.rs (user resource read/search)
        - system/*.rs (backend service read/search - bulk export)
        - openid fhirUser profile (identity)
        - offline_access (refresh tokens for backend services)
        - launch (launch context)
        - launch/patient launch/encounter (specific launch context)

      App registration: https://2rdoc.pt/developer/apps/register
      Documentation: https://2rdoc.pt/ig/ios-lifestyle-medicine/smart-conformance.html
    """

  // ========================================================================
  // Resource minimal declaration — references existing CapStmt for full list
  // ========================================================================
  * resource[0]
    * type = #Patient
    * documentation = "Patient resource with SMART app launch context."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0].name = "_id"
    * searchParam[0].type = #token

  * resource[1]
    * type = #Observation
    * documentation = "Observation resource — see LifestyleMedicineCapabilityStatement for full profile list. SMART scope: patient/Observation.rs"
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * interaction[2].code = #create
    * searchParam[0].name = "patient"
    * searchParam[0].type = #reference
    * searchParam[1].name = "category"
    * searchParam[1].type = #token

  * resource[2]
    * type = #Group
    * documentation = "Group resource for cohort-based Bulk FHIR Export. Backend services use system/Group.rs scope."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * operation[0].name = "export"
    * operation[0].definition = "http://hl7.org/fhir/uv/bulkdata/OperationDefinition/group-export"
    * operation[0].documentation = "Bulk Data Access $export — retrieve cohort data asynchronously."

  * resource[3]
    * type = #Consent
    * documentation = "Consent resource — see MultiJurisdictionalConsent + BulkExportConsent profiles."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * interaction[2].code = #create

  * resource[4]
    * type = #AuditEvent
    * documentation = "AuditEvent resource — see AuditEventAIInteraction + AuditEventDataAccess profiles."
    * interaction[0].code = #read
    * interaction[1].code = #search-type

// ============================================================================
// Extension: SMART Launch Scope (for documenting supported launch contexts)
// ============================================================================

Extension: SMARTLaunchScope
Id: smart-launch-scope
Title: "SMART Launch Scope Extension"
Description: """
Extension to document specific SMART on FHIR launch scopes supported by
a server beyond the canonical OAuth URIs declaration. Captures supported
launch contexts (patient, encounter, practitioner) and bulk-export scopes.
"""
* ^context.type = #element
* ^context.expression = "CapabilityStatement.rest.security"

* value[x] only code
* valueCode 1..1 MS
* valueCode from SMARTLaunchScopeVS (required)

// ============================================================================
// ValueSet: SMART Launch Scopes
// ============================================================================

ValueSet: SMARTLaunchScopeVS
Id: smart-launch-scope-vs
Title: "SMART Launch Scopes"
Description: "Enumeration of SMART on FHIR App Launch scopes supported by this IG"
* ^status = #active
* ^experimental = false

* IOSLifestyleMedicineSMARTScopes#patient-rs "patient/*.rs"
* IOSLifestyleMedicineSMARTScopes#patient-cruds "patient/*.cruds"
* IOSLifestyleMedicineSMARTScopes#user-rs "user/*.rs"
* IOSLifestyleMedicineSMARTScopes#system-rs "system/*.rs"
* IOSLifestyleMedicineSMARTScopes#openid-fhirUser "openid fhirUser"
* IOSLifestyleMedicineSMARTScopes#offline-access "offline_access"
* IOSLifestyleMedicineSMARTScopes#launch "launch"
* IOSLifestyleMedicineSMARTScopes#launch-patient "launch/patient"
* IOSLifestyleMedicineSMARTScopes#launch-practitioner "launch/practitioner"
* IOSLifestyleMedicineSMARTScopes#launch-encounter "launch/encounter"

// ============================================================================
// CodeSystem: SMART Scopes (local for ValueSet binding stability)
// ============================================================================

CodeSystem: IOSLifestyleMedicineSMARTScopes
Id: ios-lm-smart-scopes
Title: "iOS Lifestyle Medicine SMART Scopes CodeSystem"
Description: "Local CodeSystem for SMART on FHIR App Launch scopes used by this IG. Mirrors canonical SMART scopes from STU2.2 specification for stable ValueSet binding."
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^caseSensitive = true

* #patient-rs "patient/*.rs" "Patient resource read/search"
* #patient-cruds "patient/*.cruds" "Patient resource full CRUD operations"
* #user-rs "user/*.rs" "User resource read/search"
* #system-rs "system/*.rs" "Backend system resource read/search (bulk export)"
* #openid-fhirUser "openid fhirUser" "Identity scope (OpenID Connect)"
* #offline-access "offline_access" "Refresh tokens for backend services"
* #launch "launch" "Generic launch scope (EHR-driven context)"
* #launch-patient "launch/patient" "Patient-context app launch"
* #launch-practitioner "launch/practitioner" "Practitioner-context app launch"
* #launch-encounter "launch/encounter" "Encounter-context app launch"
