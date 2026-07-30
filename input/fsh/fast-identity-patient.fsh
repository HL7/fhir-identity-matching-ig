// =====================================================================
// FAST Identity — Golden Record & CSP Identifier representation
// Draft for FAST Identity STU3 discussion (co-leads workgroup)
// Author: Mark Scrimshire / Onyx Health
// Base: US Core 6.1.0 Patient (which itself constrains FHIR R4 Patient)
//
// Design goals:
//   1. Represent one-or-many jurisdiction-scoped Golden Record IDs (GRI)
//      so dual citizens can hold multiple GRIs (US, GB, ...).
//   2. Represent zero-or-many CSP-issued person identifiers, each
//      carrying identity/authenticator assurance metadata (NIST 800-63-3).
//   3. Remain US Core 6.1.0 compliant (identifier stays MS; slicing is
//      additive and open, so MRNs/member IDs still validate).
//
// NOTE: canonical URLs use a placeholder host (fast.hl7.org) — replace
// with the official FAST canonical base before publication.
// =====================================================================



// ---------------------------------------------------------------------
// Code Systems
// ---------------------------------------------------------------------

CodeSystem: FASTIdentifierTypeCS
Id: fast-identity-identifier-type
Title: "FAST Identity Identifier Type Code System"
Description: "Identifier type codes distinguishing Golden Record and CSP-issued person identifiers within FAST Identity."
* ^caseSensitive = true
* ^experimental = true
* #GRI   "Golden Record Identifier" "A jurisdiction-scoped master person identifier maintained by a governing identity authority. A person may hold more than one (e.g. dual citizenship)."
* #CSPID "Credential Service Provider Identifier" "A person identifier issued by a Credential Service Provider (e.g. CLEAR, ID.me, Login.gov)."

CodeSystem: FASTAssuranceLevelCS
Id: fast-identity-assurance-level
Title: "FAST Identity Assurance Level Code System"
Description: "NIST SP 800-63-3 assurance levels used to qualify a CSP-issued identity."
* ^caseSensitive = true
* ^experimental = true
* #IAL1 "Identity Assurance Level 1"
* #IAL2 "Identity Assurance Level 2"
* #IAL3 "Identity Assurance Level 3"
* #AAL1 "Authenticator Assurance Level 1"
* #AAL2 "Authenticator Assurance Level 2"
* #AAL3 "Authenticator Assurance Level 3"
* #FAL1 "Federation Assurance Level 1"
* #FAL2 "Federation Assurance Level 2"
* #FAL3 "Federation Assurance Level 3"


// ---------------------------------------------------------------------
// Value Sets
// ---------------------------------------------------------------------

ValueSet: FASTIdentityAssuranceLevelVS
Id: fast-identity-identity-assurance-level
Title: "FAST Identity Assurance Level (IAL) Value Set"
Description: "Permitted NIST 800-63-3 Identity Assurance Levels."
* FASTAssuranceLevelCS#IAL1
* FASTAssuranceLevelCS#IAL2
* FASTAssuranceLevelCS#IAL3
* ^experimental = false

ValueSet: FASTAuthenticatorAssuranceLevelVS
Id: fast-identity-authenticator-assurance-level
Title: "FAST Authenticator Assurance Level (AAL) Value Set"
Description: "Permitted NIST 800-63-3 Authenticator Assurance Levels."
* FASTAssuranceLevelCS#AAL1
* FASTAssuranceLevelCS#AAL2
* FASTAssuranceLevelCS#AAL3
* ^experimental = false


// ---------------------------------------------------------------------
// Extension: Identity Jurisdiction (scopes a Golden Record Identifier)
// ---------------------------------------------------------------------

Extension: IdentityJurisdiction
Id: identity-jurisdiction
Title: "Identity Jurisdiction"
Description: "The governing jurisdiction (nation and, optionally, state/region) that issues and maintains a Golden Record Identifier. Enables multiple jurisdiction-scoped GRIs for one person."
* ^context[+].type = #element
* ^context[=].expression = "Patient.identifier"
* value[x] only CodeableConcept
* valueCodeableConcept 1..1
// Nation is expected via ISO 3166-1; state/region optionally via ISO 3166-2.
* valueCodeableConcept ^binding.strength = #extensible
* valueCodeableConcept ^binding.description = "ISO 3166 country (and optionally sub-division) of the issuing identity authority."


// ---------------------------------------------------------------------
// Extension: CSP Assurance (per CSP-issued identity)
// ---------------------------------------------------------------------

Extension: CSPAssurance
Id: csp-assurance
Title: "CSP Assurance"
Description: "Assurance metadata for a CSP-issued person identity, aligned to NIST SP 800-63-3."
* ^context[+].type = #element
* ^context[=].expression = "Patient.identifier"
* extension contains
    identityAssuranceLevel 0..1 MS and
    authenticatorAssuranceLevel 0..1 MS and
    verificationDate 0..1 MS and
    verificationEvidence 0..*

* extension[identityAssuranceLevel].value[x] only Coding
* extension[identityAssuranceLevel].valueCoding from FASTIdentityAssuranceLevelVS (required)
* extension[authenticatorAssuranceLevel].value[x] only Coding
* extension[authenticatorAssuranceLevel].valueCoding from FASTAuthenticatorAssuranceLevelVS (required)
* extension[verificationDate].value[x] only dateTime
* extension[verificationEvidence].value[x] only string


// ---------------------------------------------------------------------
// Profile: FAST Identity Patient
// ---------------------------------------------------------------------

Profile: FASTIdentityPatient
Parent: $USCorePatient
Id: fast-identity-patient
Title: "FAST Identity Patient"
Description: "US Core 6.1.0 Patient constrained for FAST Identity STU3: adds jurisdiction-scoped Golden Record Identifier(s) and CSP-issued identifier(s) with assurance metadata. Slicing is open, so US Core / local identifiers (MRN, member ID) remain valid."

// Open slicing on identifier, discriminated by the identifier type code.
* identifier ^slicing.discriminator[0].type = #value
* identifier ^slicing.discriminator[0].path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Named slices for Golden Record and CSP identifiers; all other identifiers permitted."
* identifier contains
    goldenRecord 0..* MS and
    cspIdentifier 0..* MS

// --- Golden Record Identifier slice (jurisdiction-scoped, repeatable) ---
* identifier[goldenRecord].type = FASTIdentifierTypeCS#GRI
* identifier[goldenRecord].type 1..1 MS
* identifier[goldenRecord].system 1..1 MS
* identifier[goldenRecord].value 1..1 MS
* identifier[goldenRecord].assigner 1..1 MS
* identifier[goldenRecord].assigner ^short = "Governing identity authority for this jurisdiction"
* identifier[goldenRecord].extension contains IdentityJurisdiction named jurisdiction 1..1 MS
* identifier[goldenRecord].extension[jurisdiction] ^short = "Jurisdiction that owns this Golden Record (enables multiple GRIs for dual citizens)"

// --- CSP Identifier slice (repeatable, assurance-qualified) ---
* identifier[cspIdentifier].type = FASTIdentifierTypeCS#CSPID
* identifier[cspIdentifier].type 1..1 MS
* identifier[cspIdentifier].system 1..1 MS
* identifier[cspIdentifier].value 1..1 MS
* identifier[cspIdentifier].assigner 1..1 MS
* identifier[cspIdentifier].assigner ^short = "The Credential Service Provider that issued this identity"
* identifier[cspIdentifier].extension contains CSPAssurance named assurance 0..1 MS
