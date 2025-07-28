Instance: Patient1
InstanceOf: IDIPatient
Description: "Example of Patient used as input to $IDI-match operation"
Usage: #example

* language = #en-US
* id = "ExamplePatient"
* active = true
* identifier[0].type.coding.code = #MB
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "1234-234-1243-12345678901"
* identifier[0].system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* name[0].family = "Beegood"
* name[0].given[0] = "Johnny"
* telecom[0].system = #phone
* telecom[0].value = "301-555-2112"
* telecom[0].use = #mobile 
* gender = #male
* birthDate = "1986-05-01"
* address[0].type = #physical
* address[0].line[0] = "123 Main Street"
* address[0].city = "Pittsburgh"
* address[0].state = "PA"
* address[0].postalCode = "12519"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK

//====================================================================================================

Instance: Patient-L0
InstanceOf: IDIPatientL0
Description: "Example of Patient used as input to $IDI-match operation meeting Level 0 information conformance"
Usage: #example

* language = #en-US
* id = "ExamplePatientL0"
* active = true

* identifier[0].type.coding.code = #PN
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "4004-202-9999-12345678901"
* identifier[0].system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"

* name[0].family = "Paeshent"
* name[0].given[0] = "Nancy"

* gender = #female

* birthDate = "1988-02-11"

* address[0].type = #physical
* address[0].line[0] = "321 South Maple Street"
* address[0].city = "Scranton"
* address[0].state = "PA"
* address[0].postalCode = "18503"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK

//====================================================================================================

Instance: Patient-L1
InstanceOf: IDIPatientL1
Description: "Example of Patient used as input to $IDI-match operation meeting Level 1 information conformance"
Usage: #example

* meta.profile = Canonical(IDI-Patient-L1)
* meta.lastUpdated = "2021-11-01T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatientL1"
* active = true

* identifier[0].type.coding.code = #DL
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "3902-16532901"
* identifier[0].system = "http://terminology.hl7.org/NamingSystem/NorthCarolinaDLN"
* identifier[0].assigner[0].display[0] = "North Carolina"

* name[0].family = "Case"
* name[0].given[0] = "Justin"

* telecom[0].system = #phone
* telecom[0].value = "726-555-2900"
* telecom[0].use = #mobile 

* gender = #female

* birthDate = "1992-05-17"

* address[0].type = #physical
* address[0].line[0] = "418 Teapot Lane"
* address[0].city = "Raleigh"
* address[0].state = "NC"
* address[0].postalCode = "27513"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK

//====================================================================================================

Instance: Patient-INCOMPLETE
InstanceOf: IDIPatientL1
Description: "Example of Patient used as input to $IDI-match operation but NOT meeting Level 0, 1, OR 2 information conformance; due to partial street address, missing DL assigner, and missing first name, this example incorrectly asserts L1 and would have a match input score of only 6, amounting to insufficient data for even a B2B match"
Usage: #example

* meta.profile = Canonical(IDI-Patient-L1)
* meta.lastUpdated = "2021-11-01T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatientINCOMPLETE"
* active = true

* identifier[0].type.coding.code = #DL
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "3902-16532901"
* identifier[0].system = "http://terminology.hl7.org/NamingSystem/NorthCarolinaDLN"

* name[0].family = "Case"

* telecom[0].system = #phone
* telecom[0].value = "726-555-2900"
* telecom[0].use = #mobile 

* gender = #female

* birthDate = "1992-05-17"

* address[0].type = #physical
* address[0].line[0] = "418 Teapot Lane"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK

//====================================================================================================

Instance: patient-multi-digital-identifier
InstanceOf: Patient
Description: "Example of Patient where the individual has mulitple Digital Identifiers assigned to them from three different entities: a hospital, a payer, and an IdP."
Usage: #example
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
* id = "patient-multi-digital-identifier"
* identifier[0].system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier[=].value = "a5c2498f-9b62-4c97-8dc3-03a20b0f5412"
* identifier[=].assigner = Reference(Organization/abc-hospital)
* identifier[+].system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier[=].value = "40e31ed2-4d16-4416-a66d-c3e84f8a4812"
* identifier[=].assigner = Reference(Organization/xyz-payer)
* identifier[+].system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier[=].value = "db0cfc86-58e4-467c-b1d7-78571598ee15"
* identifier[=].assigner = Reference(Organization/def-idp)
* active = true
* name.family = "Huberdeau"
* name.given = "Honk"
* telecom[0].system = #phone
* telecom[=].value = "555-555-5555"
* telecom[=].use = #home
* telecom[+].system = #email
* telecom[=].value = "honk.huberdeau@example.com"
* gender = #male
* birthDate = "1980-01-10"
* address.line = "999 Not Real Street"
* address.city = "Columbus"
* address.state = "OH"
* address.postalCode = "43210"
* address.country = "US"

//====================================================================================================

Instance: patient-authorized-representative
InstanceOf: RelatedPerson
Description: "Example of a Patient who has been assigned a Digital Identifier, and is the authorized representative of another Patient. NOTE: Determining the nature of the authorized representative relationship and, ultimately, user authorization, is out of scope for this implementation guide. However, this example illustrates the demographics and identifiers that might be used to match on these individuals' identities assuming the authorized representative status can be confirmed. This expression of an authorized representative is therefore not intended to be normative, and feedback on preferred alternative approaches is encouraged."
Usage: #example
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-relatedperson"
* active = true
* patient.reference = "Patient/patient-multi-digital-identifier"
* relationship.coding.system = "http://terminology.hl7.org/CodeSystem/v3-ParticipationFunction"
* relationship.coding.code = #AUTM
* relationship.text = "HIPAA Authorized Representative"
* name.family = "Huberdeau"
* name.given = "Henrietta"
* telecom[0].system = #phone
* telecom[=].value = "555-978-3349"
* telecom[=].use = #home
* telecom[+].system = #email
* telecom[=].value = "etta.huberdeau@example.com"
* identifier[0].system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier[=].value = "927398f0-d506-443b-b731-fa09869625e3"
* identifier[=].assigner = Reference(Organization/abc-hospital)
* address.line = "999 Not Real Street"
* address.city = "Columbus"
* address.state = "OH"
* address.postalCode = "43210"
* address.country = "US"

//====================================================================================================

Instance: abc-hospital
InstanceOf: Organization
Description: "Example hospital as Organization issuing a Digital Identifier"
Usage: #example
* identifier[0].use = #official
* identifier[=].system = "http://example.org/fhir/endpoint/"
* identifier[=].value = "91654"
* identifier[+].use = #usual
* identifier[=].system = "http://example.org/fhir/endpoint/"
* identifier[=].value = "17-0112278"
* name = "Burgers University Medical Center"
* contact[0].telecom.system = #phone
* contact[=].telecom.value = "022-655 2300"
* contact[=].telecom.use = #work
* contact[+].address.use = #work
* contact[=].address.line = "Galapagosweg 91"
* contact[=].address.city = "Den Burg"
* contact[=].address.postalCode = "9105 PZ"
* contact[=].address.country = "NLD"
* contact[+].address.use = #work
* contact[=].address.line = "PO Box 2311"
* contact[=].address.city = "Den Burg"
* contact[=].address.postalCode = "9100 AA"
* contact[=].address.country = "NLD"
* contact[+].telecom.system = #phone
* contact[=].telecom.value = "022-655 2334"
* contact[+].telecom.system = #phone
* contact[=].telecom.value = "022-655 2335"

//====================================================================================================

Instance: xyz-payer
InstanceOf: Organization
Description: "Example payer as Organization issuing a Digital Identifier"
Usage: #example
* identifier.system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier.value = "666666"
* name = "XYZ Insurance"
* alias = "XYZ"
* contact.telecom[0].system = #phone
* contact.telecom[=].value = "+1 555 234 3523"
* contact.telecom[=].use = #work
* contact.telecom[+].system = #email
* contact.telecom[=].value = "info@xyz-payer.org"
* contact.telecom[=].use = #work

//====================================================================================================

Instance: def-idp
InstanceOf: Organization
Description: "Example of Organization used as an identity provider for digital identifier"
Usage: #example
* identifier.system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier.value = "SecureIdp"
* name = "Secure Idp"
* contact.telecom[0].system = #phone
* contact.telecom[=].value = "+1 555 234 3523"
* contact.telecom[=].use = #work
* contact.telecom[+].system = #email
* contact.telecom[=].value = "gastro@acme.org"
* contact.telecom[=].use = #work

//====================================================================================================

Alias: $organization-type = http://terminology.hl7.org/CodeSystem/organization-type
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

Instance: MATCHOperationResponse
InstanceOf: IDIMatchBundle
Description: "Example of $IDI-match operation response with patient and organization"
Usage: #example
* meta.profile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/idi-match-bundle"
* identifier[+].assigner = Reference(http://example.org/Organization/OrgExample)
* identifier[=].value = "urn:uuid:c3c6f1c5-3072-439e-a8ef-ba6a57ae3aa5"
* identifier[=].system = "urn:ietf:rfc:3986"
* type = #searchset
* link.relation = "self"
* link.url = "http://example.org/Bundle/MATCHOperationResponse"
* entry[+].fullUrl = "https://example.com/base/Organization/OrgExample"
* entry[=].resource = OrgExample
* entry[=].search.mode = #match
* entry[+].fullUrl = "https://example.com/base/Patient/PatExample"
* entry[=].resource = PatExample
* entry[=].search.mode = #match

Instance: OrgExample
InstanceOf: USCoreOrganizationProfile
Usage: #inline
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization"
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p class=\"res-header-id\"><b>Generated Narrative: Organization Insurance Company</b></p><a name=\"OrgExample\"> </a><p><b>name</b>: Insurance Company</p><p><b>address</b>: 688 Asylum Street Hartford CT 06155</p></div>"
* active = true
* type = $organization-type#pay "Payer"
* name = "Insurance Company"
* telecom.system = #phone
* telecom.value = "860-547-5001"
* telecom.use = #work
* address.line = "688 Asylum Street"
* address.city = "Hartford"
* address.state = "CT"
* address.postalCode = "06155"
* address.country = "US"

Instance: PatExample
InstanceOf: USCorePatientProfile
Usage: #inline
* meta.lastUpdated = "2020-07-07T13:26:22.0314215+00:00"
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p class=\"res-header-id\"><b>Generated Narrative: Person PatExample</b></p><a name=\"PatExample\"> </a><p><b>name</b>: Johnny Beegood (Official)</p><p><b>birthDate</b>: 1986-05-01</p><p><b>address</b>: 123 Main Street Pittsburgh PA 12519 (physical)</p></div>"
* identifier[0].type.coding.code = #MB
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier.system = "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier"
* identifier.value = "1234-234-1243-12345678901"
* active = true
* name.family = "Beegood"
* name.given = "Johnny"
* gender = #male
* birthDate = "1986-05-01"
* address.type = #physical
* address.line = "123 Main Street"
* address.city = "Pittsburgh"
* address.state = "PA"
* address.postalCode = "12519"




//====================================================================================================

Instance: FASTIDUDAPPerson-Example
InstanceOf: FASTIDUDAPPerson
Description: "Example of Person profile for use with the Interoperable Digital Identity and Patient Matching"
Usage: #example
* name.use = #official
* name.family = "Chalmers"
* name.given[0] = "Peter"
* name.given[+] = "James"
* telecom[0].system = #phone
* telecom[=].value = "(03) 5555 6473"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "Jim@example.org"
* telecom[=].use = #work
* birthDate = "1974-12-25"
* address.use = #work
* address.line = "534 Erewhon St"
* address.city = "PleasantVille"
* address.state = "Vic"
* address.postalCode = "3999"

//====================================================================================================

Instance: IDIMatchInputParameters-Example
InstanceOf: IDIMatchInputParameters
Description: "Example of IDI-Patient profile for submission as input parameter for $IDI-match operation"
Usage: #example
* parameter[IDIPatient].name = "IDIPatient"
* parameter[IDIPatient].resource = Patient1

/*
* parameter[=].resource.resourceType = "Patient"
* parameter[=].resource.text.status = #generated
* parameter[=].resource.text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p class=\"res-header-id\"><b>Generated Narrative: Example Patient</b></p><a name=\"ExamplePatient\"> </a><p><b>name</b>: ExamplePatient</p><p><b>address</b>: Peter Chalmers</p></div>"
* parameter[=].resource.id = "ExamplePatient"
* parameter[=].resource.name.use = #official
* parameter[=].resource.name.family = "Chalmers"
* parameter[=].resource.name.given[0] = "Peter"
* parameter[=].resource.name.given[+] = "James"
*/


//====================================================================================================

Instance: IDIMatchOutputParameters-Example
InstanceOf: IDIMatchOutputParameters
Description: "Example of IDI-Patient profile for used to define the outputs of the $IDI-match operation"
Usage: #example
* parameter[0].name = "IDIMatchBundle"
* parameter[=].resource = MATCHOperationResponse
