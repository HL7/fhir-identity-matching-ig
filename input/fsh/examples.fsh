

Instance: FastOrgExample
InstanceOf: FASTIdentityOrganization
Usage: #example
Title: "FAST Organization Example"
Description: "Example Health System — NPI plus LEI (golden record) and a vLEI credential referenced by OOBI/.well-known with its content-addressed SAID."
* extension[vlei].extension[leiCode].valueString = "5493001KJTIIGC8Y1R12"
* extension[vlei].extension[credentialSAID].valueString = "EBfdlu8R27Fbx-ehrqwImnK-8Cm79sqbAQ4MmvEAYqao"
* extension[vlei].extension[source].valueUrl = "https://examplehealth.org/.well-known/vlei/oobi/EBfdlu8R27Fbx-ehrqwImnK-8Cm79sqbAQ4MmvEAYqao"
* extension[vlei].extension[issuer].valueString = "Qualified vLEI Issuer — Example QVI Inc. (AID: EKY1t...QVI)"
* extension[vlei].extension[verificationDate].valueDateTime = "2026-05-19T14:32:00Z"
* extension[vlei].extension[status].valueCode = #active
* identifier[NPI].type = http://terminology.hl7.org/CodeSystem/v2-0203#NPI "National provider identifier"
* identifier[NPI].system = "http://hl7.org/fhir/sid/us-npi"
* identifier[NPI].value = "1234567893"
* identifier[lei].use = #official
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1R12"
* identifier[lei].assigner.display = "GLEIF (via accredited LOU)"
* active = true
* name = "Example Health System"
* telecom[0].system = #phone
* telecom[0].value = "+1-617-555-0142"
* telecom[0].use = #work
* address[0].line[0] = "500 Interoperability Way"
* address[0].city = "Boston"
* address[0].state = "MA"
* address[0].postalCode = "02110"
* address[0].country = "US"

Instance: FastDualCitizenExample
InstanceOf: FASTIdentityPatient
Usage: #example
Title: "FAST Dual Citizen Example"
Description: "Jordan Alexander Rivera — dual US/UK citizen. Two jurisdiction-scoped Golden Record Identifiers plus two CSP identities (CLEAR, ID.me) with NIST 800-63-3 assurance metadata."
* identifier[goldenRecord][+].extension[jurisdiction].valueCodeableConcept.coding[0] = urn:iso:std:iso:3166#US "United States of America"
* identifier[goldenRecord][=].use = #official
//* identifier[goldenRecord][=].type = FASTIdentifierTypeCS#GRI "Golden Record Identifier"
* identifier[goldenRecord][=].system = "https://fast.hl7.org/identity/golden-record/us"
* identifier[goldenRecord][=].value = "US-GRI-8f3a1c2e-6b41-4d9a-9f21-1a2b3c4d5e6f"
* identifier[goldenRecord][=].assigner.display = "US FAST Identity Trust Network"
* identifier[goldenRecord][+].extension[jurisdiction].valueCodeableConcept.coding[0] = urn:iso:std:iso:3166#GB "United Kingdom of Great Britain and Northern Ireland"
* identifier[goldenRecord][=].use = #official
//* identifier[goldenRecord][=].type = FASTIdentifierTypeCS#GRI "Golden Record Identifier"
* identifier[goldenRecord][=].system = "https://fast.hl7.org/identity/golden-record/gb"
* identifier[goldenRecord][=].value = "GB-GRI-4471-9920-3388"
* identifier[goldenRecord][=].assigner.display = "NHS England Identity Authority"
* identifier[cspIdentifier][+].extension[assurance].extension[identityAssuranceLevel].valueCoding = FASTAssuranceLevelCS#IAL2 "Identity Assurance Level 2"
* identifier[cspIdentifier][=].extension[assurance].extension[authenticatorAssuranceLevel].valueCoding = FASTAssuranceLevelCS#AAL2 "Authenticator Assurance Level 2"
* identifier[cspIdentifier][=].extension[assurance].extension[verificationDate].valueDateTime = "2026-03-14"
* identifier[cspIdentifier][=].extension[assurance].extension[verificationEvidence][0].valueString = "Government-issued photo ID + liveness selfie match"
* identifier[cspIdentifier][=].use = #secondary
//* identifier[cspIdentifier][=].type = FASTIdentifierTypeCS#CSPID "Credential Service Provider Identifier"
* identifier[cspIdentifier][=].system = "https://clearme.com/identity"
* identifier[cspIdentifier][=].value = "CLEAR-99201-JAR"
* identifier[cspIdentifier][=].assigner.display = "CLEAR"
* identifier[cspIdentifier][+].extension[assurance].extension[identityAssuranceLevel].valueCoding = FASTAssuranceLevelCS#IAL2 "Identity Assurance Level 2"
* identifier[cspIdentifier][=].extension[assurance].extension[verificationDate].valueDateTime = "2025-11-02"
* identifier[cspIdentifier][=].use = #secondary
//* identifier[cspIdentifier][=].type = FASTIdentifierTypeCS#CSPID "Credential Service Provider Identifier"
* identifier[cspIdentifier][=].system = "https://id.me/identity"
* identifier[cspIdentifier][=].value = "IDME-44817-JAR"
* identifier[cspIdentifier][=].assigner.display = "ID.me"
* identifier[+].use = #usual
* identifier[=].type = http://terminology.hl7.org/CodeSystem/v2-0203#MR "Medical Record Number"
* identifier[=].system = "https://hospital.example.org/mrn"
* identifier[=].value = "MRN-556677"
* identifier[=].assigner.display = "Example Health System"
* name[0].use = #official
* name[0].family = "Rivera"
* name[0].given[0] = "Jordan"
* name[0].given[1] = "Alexander"
* gender = #other
* birthDate = "1988-07-21"

Instance: GoldenRecordCSPExampleFromJson
InstanceOf: GoldenRecordPatient
Usage: #example
Title: "Golden Record CSP Example"
Description: "Jane Marie Doe — a Golden Record Identifier asserted by a Credential Service Provider on a base FHIR Patient. Universal-ready: no USCDI demographics required (design brief §2.3, §3.2)."
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

Instance: GoldenRecordMultiCSPExampleFromJson
InstanceOf: GoldenRecordPatient
Usage: #example
Title: "Golden Record Multi-CSP Example"
Description: "Jane Doe — one person carrying Golden Record Identifiers from two different CSPs, distinguished by system and assigner (multi-CSP scenario, design brief §4 Q6)."
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

Instance: GoldenRecordUSCoreExampleFromJson
InstanceOf: GoldenRecordPatientUSCore
Usage: #example
Title: "Golden Record US Core Example"
Description: "Jane Doe — the same Golden Record Identifier persisted inside a US Core Patient by an EHR. Carries USCDI must-supports (race, ethnicity, birth sex) alongside the shared Golden Identifier slice (design brief §2.3 realm adapter)."
* extension[us-core-race].extension[ombCategory].valueCoding = $omb-race-ethnicity#2106-3 "White"
* extension[us-core-race].extension[text].valueString = "White"
* extension[us-core-ethnicity].extension[ombCategory].valueCoding = $omb-race-ethnicity#2186-5 "Not Hispanic or Latino"
* extension[us-core-ethnicity].extension[text].valueString = "Not Hispanic or Latino"
* extension[us-core-birthsex].valueCode = #F
* identifier[GoldenIdentifier].use = #official
* identifier[GoldenIdentifier].type = IdentifierTypes#golden "Golden Identifier"
* identifier[GoldenIdentifier].system = "https://csp-a.example.org/golden-ids"
* identifier[GoldenIdentifier].value = "123e4567-e89b-12d3-a456-426614174000"
* identifier[GoldenIdentifier].period.start = "2026-01-15"
* identifier[GoldenIdentifier].assigner.display = "CSP-A Identity Trust Network"
* identifier[+].use = #usual
* identifier[=].type = http://terminology.hl7.org/CodeSystem/v2-0203#MR "Medical Record Number"
* identifier[=].system = "https://hospital.example.org/mrn"
* identifier[=].value = "MRN-556677"
* identifier[=].assigner.display = "Example Health System"
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