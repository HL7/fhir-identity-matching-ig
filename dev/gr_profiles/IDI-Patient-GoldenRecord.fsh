// =====================================================================================
// Golden Record Identifier — refined profile (FHIR Shorthand / SUSHI)
// HL7 FAST Interoperable Digital Identity and Patient Matching IG — STU3 working branch
//
// Companion to: Golden_Record_Identifier_Design_Brief.md
// Author: Mark Scrimshire (Co-Lead)   Date: 2026-07-23   Status: DRAFT for workgroup
//
// WHAT CHANGED vs. the current stu3 input/fsh/Patient.fsh draft:
//   1. Authoritative profile now derives from BASE FHIR Patient (universal-ready),
//      per brief §2.3 / §2.4. A US Core companion is provided as a realm adapter.
//   2. identifier slicing uses a PATTERN discriminator on `type` (brief §2.5).
//   3. Core-identity attributes are marked Must Support to express the Golden Record
//      boundary (brief §3); contextual data is deliberately left un-profiled.
//   4. Placeholders flagged for an identity-assurance extension (brief §3.3, §4 Q5).
//
// NOTE: This is a proposal. Items flagged "WG DECISION" track the open questions in
//       brief §4 and should be resolved before merge/ballot.
// =====================================================================================


// -------------------------------------------------------------------------------------
// CodeSystem: identifier type marker (carried over from the current draft, unchanged)
// -------------------------------------------------------------------------------------
CodeSystem: IdentifierTypes
Title: "Golden Identifier Type"
Description: "Code system for the type of golden identifier used in the .identifier element of the Patient resource."
* ^experimental = false
* ^caseSensitive = true
* #golden "Golden Identifier" "A unique and consistent identifier for a data subject (such as a patient or client) across different healthcare systems and organizations, used in the .identifier element of the Patient resource to support identity matching and management in healthcare transactions."

ValueSet: GoldenIdentifierTypeVS
Title: "Golden Identifier Type Value Set"
Description: "Type code(s) that mark a Patient.identifier as a Golden Record Identifier."
* include codes from system IdentifierTypes


// -------------------------------------------------------------------------------------
// AUTHORITATIVE PROFILE — base FHIR Patient (universal-ready)  [brief §2.3, §2.4]
// -------------------------------------------------------------------------------------
Profile: GoldenRecordPatient
Parent: Patient
Id: GoldenRecord-Patient
Title: "Golden Record Patient (Universal)"
Description: """
Patient carrying a Golden Record Identifier, derived from base FHIR Patient so it is
usable by any assigner — EHRs, payers, HIEs, and Credential Service Providers (CSPs) —
and portable across realms. Must-support flags express the Golden Record identity
boundary (brief §3): core identity attributes are Must Support; contextual data
(employment, organizational role, coverage, clinical/USCDI demographics) is intentionally
not required by this profile and lives in other resources.
"""

// ---- Golden Identifier slice --------------------------------------------------------
* identifier MS
* identifier ^slicing.discriminator.type = #pattern            // WG DECISION (§4 Q3): pattern > value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Allows multiple identifiers, including a required Golden Record Identifier distinguished by its type. Additional CSP-issued identifiers may appear as further repetitions (multi-CSP scenario)."
* identifier contains GoldenIdentifier 1..* MS

// The five identity relationships (brief §3.2 / action item #3):
* identifier[GoldenIdentifier].type 1..1 MS
* identifier[GoldenIdentifier].type = IdentifierTypes#golden   // marks the slice
* identifier[GoldenIdentifier].value 1..1 MS                   // the identity token
* identifier[GoldenIdentifier].system 1..1 MS                  // authoritative source / naming system
* identifier[GoldenIdentifier].assigner MS                     // issuing CSP (Organization)  [§4 Q6]
* identifier[GoldenIdentifier].period MS                       // validity period
// Assurance metadata (IDIAL / verification status) — brief §3.3, §4 Q5.
// Placeholder pending a canonical extension URL decision; uncomment once defined:
// * identifier[GoldenIdentifier].extension contains
//     $IdentityAssurance named assurance 0..1 MS

// ---- Core identity attributes (inside the boundary) — brief §3.2 --------------------
* name 1..* MS               // legal name
* birthDate MS               // stable, high-value matching attribute
* gender MS                  // administrative gender (not clinical sex)

// ---- Matching aids (verified contact / address) — WG DECISION (§4 Q4) ---------------
// Marked MS as strong matching aids; may be relaxed to optional for lighter/
// privacy-preserving payloads. Left MS here to prompt an explicit decision.
* telecom MS                 // verified mobile / email used to bind & confirm identity
* address MS                 // verified home address

// NOTE: contextual data is deliberately NOT profiled here (brief §3.2 "outside"):
//   communication, maritalStatus, contact, generalPractitioner, managingOrganization,
//   employment, coverage, and USCDI race/ethnicity/birthsex extensions.


// -------------------------------------------------------------------------------------
// REALM ADAPTER — US Core companion  [brief §2.3; only needed for US Realm]
// Reuses the identical GoldenIdentifier slice inside a US Core Patient so EHRs persist
// the Golden Identifier with no extra modeling. Omit entirely if the IG goes Universal
// (§2.4), or add other national companions (e.g. AU Base) alongside it.
// -------------------------------------------------------------------------------------
Profile: GoldenRecordPatientUSCore
Parent: us-core-patient
Id: GoldenRecord-Patient-uscore
Title: "Golden Record Patient (US Core)"
Description: "US Realm adapter: applies the Golden Record Identifier slice within a US Core Patient. Inherits US Core / USCDI must-supports in addition to the Golden Identifier slice."
* identifier MS
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier contains GoldenIdentifier 1..* MS
* identifier[GoldenIdentifier].type 1..1 MS
* identifier[GoldenIdentifier].type = IdentifierTypes#golden
* identifier[GoldenIdentifier].value 1..1 MS
* identifier[GoldenIdentifier].system 1..1 MS
* identifier[GoldenIdentifier].assigner MS
* identifier[GoldenIdentifier].period MS


// -------------------------------------------------------------------------------------
// EXAMPLES
// -------------------------------------------------------------------------------------
Instance: GoldenRecordPatientExample
InstanceOf: GoldenRecordPatient
Title: "Golden Record Patient — single CSP"
Description: "Patient with one Golden Record Identifier issued by a CSP."
* identifier[GoldenIdentifier].type = IdentifierTypes#golden
* identifier[GoldenIdentifier].value = "123e4567-e89b-12d3-a456-426614174000"  // v4 UUID per IG Digital Identifier rules
* identifier[GoldenIdentifier].system = "https://csp-a.example.org/golden-ids"
* identifier[GoldenIdentifier].period.start = "2026-01-15"
* name[0].family = "Doe"
* name[0].given[0] = "Jane"
* gender = #female
* birthDate = "1979-01-01"

Instance: GoldenRecordPatientMultiCSPExample
InstanceOf: GoldenRecordPatient
Title: "Golden Record Patient — multiple CSP-issued identifiers"
Description: "Illustrates action item #7: the same person carrying Golden Identifiers from two different CSPs, distinguished by system/assigner (brief §4 Q6)."
* identifier[GoldenIdentifier][0].type = IdentifierTypes#golden
* identifier[GoldenIdentifier][0].value = "123e4567-e89b-12d3-a456-426614174000"
* identifier[GoldenIdentifier][0].system = "https://csp-a.example.org/golden-ids"
* identifier[GoldenIdentifier][1].type = IdentifierTypes#golden
* identifier[GoldenIdentifier][1].value = "987f6543-a21b-45d6-b789-123456789abc"
* identifier[GoldenIdentifier][1].system = "https://csp-b.example.org/golden-ids"
* name[0].family = "Doe"
* name[0].given[0] = "Jane"
* gender = #female
* birthDate = "1979-01-01"
