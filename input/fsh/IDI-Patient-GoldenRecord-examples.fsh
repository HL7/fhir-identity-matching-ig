// =====================================================================================
// Golden Record Identifier — worked examples (FHIR Shorthand / SUSHI)
// HL7 FAST Interoperable Digital Identity and Patient Matching IG — STU3 working branch
//
// Companion to: Golden_Record_Identifier_Design_Brief.md
//               IDI-Patient-GoldenRecord.fsh  (defines the two profiles used below)
// Author: Mark Scrimshire (Co-Lead)   Date: 2026-07-23   Status: DRAFT for workgroup
//
// PURPOSE
//   Demonstrate the brief's two-profile approach (§2.3) with worked instances:
//     A. GoldenRecordPatient        — base FHIR Patient, CSP assigner (universal-ready)
//     B. GoldenRecordPatient        — base FHIR Patient, two CSP-issued golden IDs
//     C. GoldenRecordPatientUSCore  — US Core realm adapter, EHR-persisted record
//
//   Together they show the Golden Record boundary from brief §3: every instance
//   carries only core-identity attributes inside the profile, while contextual data
//   (employment, role, coverage, and — for the base examples — USCDI demographics) is
//   deliberately absent. The US Core example additionally satisfies US Core / USCDI
//   must-supports, illustrating why the realm adapter costs an EHR "zero extra modeling."
//
// These instances validate against the profiles in IDI-Patient-GoldenRecord.fsh.
// The standalone .json files in this folder are the raw-resource equivalents of A–C.
// =====================================================================================



// -------------------------------------------------------------------------------------
// EXAMPLE A — Authoritative base profile, single CSP assigner (universal-ready)
// Shows a non-EHR assigner (a Credential Service Provider) carrying a Golden Record
// Identifier on a plain FHIR Patient. No USCDI obligations — the whole point of §2.3.
// -------------------------------------------------------------------------------------
Instance: GoldenRecordPatientCSPExample
InstanceOf: GoldenRecordPatient
Usage: #example
Title: "Golden Record Patient — CSP assigner (base FHIR Patient)"
Description: """
A Credential Service Provider asserts a Golden Record Identifier on a base FHIR Patient.
Demonstrates the universal-ready authoritative profile (brief §2.3): the assigner is not
a US Core producer, yet the record is fully conformant because only core identity
attributes are required. No USCDI demographics are present, by design (brief §3.2).
"""
* identifier[GoldenIdentifier].use = #official
* identifier[GoldenIdentifier].type = IdentifierTypes#golden "Golden Identifier"
* identifier[GoldenIdentifier].system = "https://csp-a.example.org/golden-ids"
* identifier[GoldenIdentifier].value = "123e4567-e89b-12d3-a456-426614174000"
* identifier[GoldenIdentifier].period.start = "2026-01-15"
* identifier[GoldenIdentifier].assigner.display = "CSP-A Identity Trust Network"
* name[0].use = #official
* name[0].family = "Doe"
* name[0].given[0] = "Jane"
* name[0].given[1] = "Marie"
* gender = #female
* birthDate = "1979-01-01"
* telecom[0].system = #phone
* telecom[0].value = "+1-617-555-0187"
* telecom[0].use = #mobile
* telecom[1].system = #email
* telecom[1].value = "jane.doe@example.com"
* address[0].use = #home
* address[0].line[0] = "742 Evergreen Terrace"
* address[0].city = "Springfield"
* address[0].state = "MA"
* address[0].postalCode = "01101"
* address[0].country = "US"


// -------------------------------------------------------------------------------------
// EXAMPLE B — Authoritative base profile, two CSP-issued Golden Identifiers
// Action item #7 / brief §4 Q6: the same person carries Golden Identifiers from two
// different CSPs, distinguished by system + assigner. Open slicing permits repetition.
// -------------------------------------------------------------------------------------
Instance: GoldenRecordPatientMultiCSPExample2
InstanceOf: GoldenRecordPatient
Usage: #example
Title: "Golden Record Patient — two CSP-issued identifiers (base FHIR Patient)"
Description: """
One person, two Golden Record Identifiers from different CSPs (multi-CSP scenario,
brief §4 Q6). The identifiers share the #golden type but differ in system and assigner,
which is how a matcher tells the issuing authorities apart.
"""
* identifier[GoldenIdentifier][+].use = #official
* identifier[GoldenIdentifier][=].type = IdentifierTypes#golden "Golden Identifier"
* identifier[GoldenIdentifier][=].system = "https://csp-a.example.org/golden-ids"
* identifier[GoldenIdentifier][=].value = "123e4567-e89b-12d3-a456-426614174000"
* identifier[GoldenIdentifier][=].period.start = "2026-01-15"
* identifier[GoldenIdentifier][=].assigner.display = "CSP-A Identity Trust Network"
* identifier[GoldenIdentifier][+].use = #official
* identifier[GoldenIdentifier][=].type = IdentifierTypes#golden "Golden Identifier"
* identifier[GoldenIdentifier][=].system = "https://csp-b.example.org/golden-ids"
* identifier[GoldenIdentifier][=].value = "987f6543-a21b-45d6-b789-123456789abc"
* identifier[GoldenIdentifier][=].period.start = "2025-09-30"
* identifier[GoldenIdentifier][=].assigner.display = "CSP-B Identity Services"
* name[0].use = #official
* name[0].family = "Doe"
* name[0].given[0] = "Jane"
* gender = #female
* birthDate = "1979-01-01"


// -------------------------------------------------------------------------------------
// EXAMPLE C — US Core realm adapter, EHR-persisted record
// The identical Golden Identifier slice inside a US Core Patient. The record also
// carries the USCDI must-supports an EHR already emits (race, ethnicity, birth sex),
// showing the "zero extra modeling" claim in brief §2.3 — and, by contrast with A/B,
// what the base profile deliberately keeps outside the identity boundary (§3.2).
// -------------------------------------------------------------------------------------
Instance: GoldenRecordPatientUSCoreExample
InstanceOf: GoldenRecordPatientUSCore
Usage: #example
Title: "Golden Record Patient — US Core realm adapter (EHR)"
Description: """
An EHR persists the Golden Record Identifier inside a US Core Patient. Beyond the
shared Golden Identifier slice it satisfies US Core / USCDI must-supports (race,
ethnicity, birth sex, name, telecom, gender, birthDate, address). Contrast with
Examples A and B: those USCDI demographics are contextual to identity resolution and
are only present here because US Core requires them — the reason the authoritative
profile stays on base Patient (brief §2.3, §3.2).
"""
* identifier[GoldenIdentifier].use = #official
* identifier[GoldenIdentifier].type = IdentifierTypes#golden "Golden Identifier"
* identifier[GoldenIdentifier].system = "https://csp-a.example.org/golden-ids"
* identifier[GoldenIdentifier].value = "123e4567-e89b-12d3-a456-426614174000"
* identifier[GoldenIdentifier].period.start = "2026-01-15"
* identifier[GoldenIdentifier].assigner.display = "CSP-A Identity Trust Network"
// A local EHR MRN co-exists on the same record (open slicing keeps it valid).
* identifier[+].use = #usual
* identifier[=].type = http://terminology.hl7.org/CodeSystem/v2-0203#MR "Medical Record Number"
* identifier[=].system = "https://hospital.example.org/mrn"
* identifier[=].value = "MRN-556677"
* identifier[=].assigner.display = "Example Health System"
// US Core / USCDI must-supports an EHR already emits:
* extension[us-core-race].extension[ombCategory].valueCoding = $omb-race-ethnicity#2106-3 "White"
* extension[us-core-race].extension[text].valueString = "White"
* extension[us-core-ethnicity].extension[ombCategory].valueCoding = $omb-race-ethnicity#2186-5 "Not Hispanic or Latino"
* extension[us-core-ethnicity].extension[text].valueString = "Not Hispanic or Latino"
* extension[us-core-birthsex].valueCode = #F
* name[0].use = #official
* name[0].family = "Doe"
* name[0].given[0] = "Jane"
* gender = #female
* birthDate = "1979-01-01"
* telecom[0].system = #phone
* telecom[0].value = "+1-617-555-0187"
* telecom[0].use = #mobile
* address[0].use = #home
* address[0].line[0] = "742 Evergreen Terrace"
* address[0].city = "Springfield"
* address[0].state = "MA"
* address[0].postalCode = "01101"
* address[0].country = "US"
