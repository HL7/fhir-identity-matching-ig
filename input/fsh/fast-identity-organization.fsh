// =====================================================================
// FAST Identity — Organization Golden Record (LEI + vLEI)
// Draft for FAST Identity STU3 discussion (co-leads workgroup)
// Author: Mark Scrimshire / Onyx Health
// Base: US Core 6.1.0 Organization (which constrains FHIR R4 Organization)
//
// Design:
//   - LEI  = the organization's "golden record" identifier (ISO 17442,
//            issued under GLEIF). Modeled as Organization.identifier.
//   - vLEI = the cryptographically VERIFIABLE credential form of the LEI
//            (GLEIF vLEI / ACDC over KERI). Modeled as a reference to a
//            resolvable, tamper-evident source PLUS the credential SAID,
//            NOT as an inline static string.
//
// Trust note: vLEI verification is rooted in GLEIF (Legal Entity <- QVI
// <- GLEIF root of trust), NOT in DNS/TLS domain control. The source URL
// is for DISCOVERY/RETRIEVAL only; validity is confirmed cryptographically
// against the credential chain and the content-addressed SAID.
//
// NOTE: placeholder canonical host (fast.hl7.org) and LEI system URI
// should be confirmed against the official GLEIF/HL7 registrations.
// =====================================================================



// ---------------------------------------------------------------------
// CodeSystem: vLEI credential status
// ---------------------------------------------------------------------

CodeSystem: VLEIStatusCS
Id: fast-identity-vlei-status
Title: "vLEI Credential Status Code System"
Description: "Lifecycle status of a verifiable LEI (vLEI) credential."
* ^caseSensitive = true
* ^experimental = true
* #active  "Active"  "Credential is issued and currently valid."
* #revoked "Revoked" "Credential has been revoked by the issuer."
* #expired "Expired" "Credential validity period has ended."


// ---------------------------------------------------------------------
// Extension: Organization vLEI
//   - credentialSAID : content-addressed id of the ACDC credential
//                      (lets a verifier confirm what it fetched, from
//                      wherever it fetched it).
//   - source         : resolvable URL for discovery/retrieval — an OOBI
//                      (Out-Of-Band Introduction) or a .well-known path.
//   - issuer         : the Qualified vLEI Issuer (QVI) AID/name.
//   - verificationDate / status : optional provenance.
// ---------------------------------------------------------------------

Extension: OrganizationVLEI
Id: organization-vlei
Title: "Organization vLEI"
Description: "A verifiable LEI (vLEI) credential attesting the organization's LEI. Carries the content-addressed credential identifier (SAID) and a resolvable source (OOBI / .well-known) for discovery. Verification is cryptographic against the GLEIF chain of trust, not the hosting domain."
* ^context[+].type = #element
* ^context[=].expression = "Organization"
* extension contains
    leiCode 0..1 MS and
    credentialSAID 1..1 MS and
    source 1..1 MS and
    issuer 0..1 MS and
    verificationDate 0..1 and
    status 0..1 MS

* extension[leiCode].value[x] only string
* extension[leiCode] ^short = "The LEI this vLEI attests (links to Organization.identifier[lei])"

* extension[credentialSAID].value[x] only string
* extension[credentialSAID] ^short = "Self-Addressing IDentifier (SAID) of the ACDC vLEI credential"

* extension[source].value[x] only url
* extension[source] ^short = "Resolvable OOBI or .well-known URL for discovery/retrieval of the vLEI"

* extension[issuer].value[x] only string
* extension[issuer] ^short = "Qualified vLEI Issuer (QVI) that issued the credential"

* extension[verificationDate].value[x] only dateTime

* extension[status].value[x] only code
* extension[status].valueCode from VLEIStatusVS (required)

ValueSet: VLEIStatusVS
Id: fast-identity-vlei-status-vs
Title: "vLEI Credential Status Value Set"
Description: "Lifecycle status of a verifiable LEI (vLEI) credential."
* include codes from system VLEIStatusCS
* ^experimental = false


// ---------------------------------------------------------------------
// Profile: FAST Identity Organization
// ---------------------------------------------------------------------

Profile: FASTIdentityOrganization
Parent: $USCoreOrganization
//Id: fast-identity-organization
Title: "FAST Identity Organization"
Description: "US Core 6.1.0 Organization constrained for FAST Identity STU3: adds the LEI as the organizational 'golden record' identifier and a verifiable LEI (vLEI) reference. US Core NPI/CLIA identifier slices and open slicing are preserved."

// Add an LEI slice alongside the US Core NPI/CLIA slices (slicing is open in US Core).
* identifier contains lei 0..1 MS
* identifier[lei].system = "https://www.gleif.org/lei" (exactly)
* identifier[lei].system 1..1 MS
* identifier[lei].value 1..1 MS
* identifier[lei] ^short = "Legal Entity Identifier (ISO 17442) — the organizational golden record"
* identifier[lei] ^patternIdentifier.system = "https://www.gleif.org/lei"

// vLEI reference (verifiable form of the LEI).
* extension contains OrganizationVLEI named vlei 0..1 MS
* extension[vlei] ^short = "Verifiable LEI credential reference (discovery URL + content-addressed SAID)"
