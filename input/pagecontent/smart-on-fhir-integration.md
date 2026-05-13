# SMART on FHIR Integration

This page documents how the iOS Lifestyle Medicine FHIR IG supports the **SMART on FHIR App Launch Framework STU2.2** (HL7 ballot trial-use). Apps integrating with servers conformant to this IG MAY use the SMART authorization flow to obtain OAuth 2.0 access tokens scoped to a single patient, a practitioner user, or a backend system role.

The companion artifact is the [SMARTOnFHIRConformance CapabilityStatement](CapabilityStatement-LifestyleMedicineSMARTCapabilityStatement.html) (FSH-defined). This page provides the narrative walkthrough, scope grammar, resource scope mapping, and a `launch.html` example.

## Overview

SMART on FHIR App Launch defines two complementary mechanisms:

| Mechanism | Use case | Discovery | Notes |
|-----------|----------|-----------|-------|
| **EHR launch** | App launched from inside an existing EHR session | `iss` + `launch` parameters supplied by host EHR | Server-side `launch=<id>` is opaque; app exchanges it for context at token endpoint |
| **Standalone launch** | App launched outside the EHR (mobile, web, kiosk) | App contacts `iss` and discovers SMART endpoints via `/.well-known/smart-configuration` | App MUST supply `aud` equal to `iss` to bind token to FHIR server |

In both flows, the authorization server returns an OAuth 2.0 access token (and optional `id_token` + `refresh_token`). The token carries the granted **scopes** (see [Scope Grammar](#scope-grammar)) and the **launch context** (patient, encounter, practitioner) negotiated at authorization.

> **SMART STU2.2 deprecation note**: discovery of OAuth endpoints via the `CapabilityStatement` `oauth-uris` extension is deprecated in favor of the `/.well-known/smart-configuration` JSON document. The IG retains the extension for legacy STU1/DSTU2 clients but recommends the well-known endpoint for new integrations.

## Launch Flow

### EHR Launch (host-initiated)

1. EHR opens app URL with `iss=<FHIR-base>&launch=<opaque-id>` query parameters.
2. App contacts `<iss>/.well-known/smart-configuration` to discover authorization, token, registration, and management endpoints.
3. App redirects user to authorization endpoint with `response_type=code`, `client_id`, `redirect_uri`, `scope`, `state`, `aud=<iss>`, and `launch=<opaque-id>`.
4. Authorization server prompts user for consent (or skips, per host policy), then redirects back with `code`.
5. App exchanges `code` at token endpoint for access token + launch context (e.g., `patient`, `encounter`).
6. App calls FHIR API with `Authorization: Bearer <access-token>` honoring the granted scopes.

### Standalone Launch (app-initiated)

Identical to EHR launch except step 1 is replaced by the user opening the app directly. The app MUST request a `launch/patient` or `launch/encounter` scope to receive a patient or encounter context after consent.

The IG's reference authorization endpoints (per the CapabilityStatement) are:

- **Authorize**: `https://2rdoc.pt/auth/authorize`
- **Token**: `https://2rdoc.pt/auth/token`
- **Register**: `https://2rdoc.pt/auth/register`
- **Manage**: `https://2rdoc.pt/auth/manage`

Production deployments SHOULD also expose a `/.well-known/smart-configuration` JSON document at the FHIR base URL.

## Scope Grammar

SMART scopes follow `[user-type]/[resource-type].[verbs]` where:

- **user-type**: `patient`, `user`, `system`
- **resource-type**: a FHIR resource type, or `*` (wildcard)
- **verbs** (SMART v2): subset of `c r u d s` (create, read, update, delete, search)

The IG accepts both v1 and v2 scope grammars during the SMART STU2.2 trial-use period:

| v1 syntax | v2 syntax | Meaning |
|-----------|-----------|---------|
| `patient/Observation.read` | `patient/Observation.rs` | Read + search single Observation for current patient |
| `patient/*.read` | `patient/*.rs` | Read + search any resource for current patient |
| `patient/*.write` | `patient/*.cud` | Create, update, delete on any resource for current patient |
| `user/*.read` | `user/*.rs` | Read + search resources accessible to the authenticated user |
| `system/*.read` | `system/*.rs` | Backend service read + search (e.g., Bulk Export) |

The IG-specific [SMARTLaunchScopeVS](ValueSet-smart-launch-scope-vs.html) enumerates the canonical scopes recognized by conformant servers, including `openid fhirUser`, `offline_access`, `launch`, `launch/patient`, `launch/practitioner`, and `launch/encounter`.

## Resource Scope Mapping (Lifestyle Medicine domains)

| FHIR resource | Scope (read) | Scope (write) | Lifestyle Medicine purpose |
|---------------|--------------|---------------|----------------------------|
| `Patient` | `patient/Patient.rs` | `patient/Patient.u` | Demographics + multi-jurisdictional jurisdiction tag |
| `Observation` | `patient/Observation.rs` | `patient/Observation.c` | HRV, sleep stages, physical activity minutes, nutrition intake, stress score |
| `MedicationStatement` | `patient/MedicationStatement.rs` | `user/MedicationStatement.c` | Self-reported medication adherence |
| `Goal` | `patient/Goal.rs` | `patient/Goal.cu` | Lifestyle behavior goals (sleep duration, MVPA minutes/week) |
| `CarePlan` | `patient/CarePlan.rs` | `user/CarePlan.cu` | Multi-domain lifestyle care plan |
| `Consent` | `patient/Consent.rs` | `patient/Consent.c` | Multi-jurisdictional + Bulk Export research consent |
| `Group` | `system/Group.rs` | `system/Group.c` | Bulk Export cohort definition (backend only) |
| `AuditEvent` | `system/AuditEvent.rs` | `system/AuditEvent.c` | Data-access + AI-interaction audit (backend only) |

Patient-facing apps SHOULD request the minimum scope set required (least privilege). Backend services performing Bulk Export MUST use `system/*` scopes with the SMART Backend Services profile (JWT client assertion, no end-user OAuth flow).

## Example `launch.html` Template

The following minimal HTML+JS snippet illustrates an EHR-launched patient-facing app. It uses the open-source [FHIR Client JS](http://docs.smarthealthit.org/client-js/) library (other SMART clients are equivalent):

```html
<!-- launch.html: minimal SMART EHR launch entry point -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Lifestyle Medicine App — Launch</title>
  <script src="https://cdn.jsdelivr.net/npm/fhirclient/build/fhir-client.js"></script>
</head>
<body>
  <script>
    FHIR.oauth2.authorize({
      clientId: "lifestyle-medicine-app",
      scope:    "launch openid fhirUser patient/Observation.rs patient/Goal.cu patient/CarePlan.rs offline_access",
      redirectUri: "index.html"
    });
  </script>
</body>
</html>
```

The companion `index.html` then reads the granted context and queries the FHIR server:

```html
<script>
  FHIR.oauth2.ready().then(function(client) {
    client.request("Observation?patient=" + client.patient.id +
                   "&category=lifestyle&date=ge" + last30days())
          .then(displayObservations);
  });
</script>
```

A working example with the full pattern (launch + index + retry + token refresh) is provided as supplementary in the IG's GitHub repository.

## Conformance Expectations for LMConnect Clients

Apps claiming conformance to this IG MUST:

1. Discover endpoints via `/.well-known/smart-configuration` (preferred) or `oauth-uris` extension (legacy).
2. Request scopes using either v1 or v2 grammar, with explicit verb enumeration (no implicit `*.write` shorthand).
3. Honor `aud` parameter (set to FHIR base URL) on standalone launch.
4. Validate the `id_token` signature and `iss` claim when using OpenID Connect.
5. Refresh access tokens via `offline_access` when long-lived sessions are required (e.g., wearable sync workers).
6. Log all data-access operations to `AuditEvent` resources conformant to [AuditEventDataAccess](StructureDefinition-AuditEventDataAccess.html).
7. Respect patient consent decisions encoded in [MultiJurisdictionalConsent](StructureDefinition-MultiJurisdictionalConsent.html) before exposing personal data.

Servers claiming conformance MUST additionally:

1. Publish a `/.well-known/smart-configuration` JSON document at the FHIR base URL.
2. Support PKCE for public clients (mandatory in SMART STU2.2).
3. Expose `introspect` and `revoke` endpoints per OAuth 2.0 Token Introspection (RFC 7662) and Token Revocation (RFC 7009).
4. Enforce least-privilege scope grants — never grant `*.cruds` when `*.rs` would suffice.
5. Log every token issuance and refresh to `AuditEvent` for traceability.

## Cross-References

- [SMARTOnFHIRConformance CapabilityStatement](CapabilityStatement-LifestyleMedicineSMARTCapabilityStatement.html)
- [SMART Launch Scopes ValueSet](ValueSet-smart-launch-scope-vs.html)
- [CDS Hooks Integration](cds-hooks-integration.html) (complementary clinical decision support)
- [Data Protection Policies](data-protection-policies.html) (LGPD + GDPR + HIPAA mapping)
- [Multi-Jurisdictional Consent](StructureDefinition-MultiJurisdictionalConsent.html)
- [AuditEvent Data Access Profile](StructureDefinition-AuditEventDataAccess.html)

## Normative References

- [HL7 SMART App Launch STU2.2](http://hl7.org/fhir/smart-app-launch/STU2.2/) (trial use, ballot)
- [OAuth 2.0 RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
- [OAuth 2.0 Token Introspection RFC 7662](https://datatracker.ietf.org/doc/html/rfc7662)
- [OAuth 2.0 Token Revocation RFC 7009](https://datatracker.ietf.org/doc/html/rfc7009)
- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- [Proof Key for Code Exchange (PKCE) RFC 7636](https://datatracker.ietf.org/doc/html/rfc7636)

## Sources

This narrative was authored as a companion to the FSH artifact [SMARTOnFHIRConformance.fsh](https://github.com/RicardoLSantos/iOS_Lifestyle_Medicine_HEADS2_FMUP/blob/main/input/fsh/capabilities/SMARTOnFHIRConformance.fsh) committed by T2 S20 (7 May 2026) and confirmed at IG v0.3.0 source HEAD `8333a04c4` (T2 S21, 12 May 2026). Drafted by T1 S34 (13 May 2026). Course material referenced: HL7 FHIR Intermediate Brasil 1ª Edição (Mabi A. Souza + Lucas A. de Paula, 2026), Unit 4 SMART on FHIR + CDS Hooks. Domain-specific scope mapping derived from the eleven lifestyle medicine domains catalogued in the IG's [Index](index.html) and the openEHR archetype methodology surfaced in T1 S31 EXT and T1 S32 course extracts (Moner 2018, Browne 2008, Heard 2008 — Level 4 verification pending Pitfall #43 Level 5 graduation).
