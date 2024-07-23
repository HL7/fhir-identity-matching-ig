Instance: Patient1
InstanceOf: IDIPatient
Description: "Example of Patient used as input to $match operation"
Usage: #example

* meta.profile = Canonical(IDI-Patient)
* meta.lastUpdated = "2020-07-07T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatient"
* active = true

* identifier[0].type.coding.code = #MB
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "1234-234-1243-12345678901"
* identifier[0].system = "https://www.xyzhealthplan.com/fhir/memberidentifier"

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
Description: "Example of Patient used as input to $match operation meeting Level 0 information conformance"
Usage: #example

* meta.profile = Canonical(IDI-Patient-L0)
* meta.lastUpdated = "2021-11-01T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatientL0"
* active = true

* identifier[0].type.coding.code = #MR
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "4004-202-9999-12345678901"
* identifier[0].system = "https://www.xyzhealthplan.com/fhir/memberidentifier"

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
Description: "Example of Patient used as input to $match operation meeting Level 1 information conformance"
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

Instance: patient-multi-digital-identifier
InstanceOf: Patient
Description: "Example of Patient where the individual has mulitple Digital Identifiers assigned to them from three different entities: a hospital, a payer, and an IdP."
Usage: #example
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
* identifier[0].system = "http://hospital.abc.org"
* identifier[=].value = "a5c2498f-9b62-4c97-8dc3-03a20b0f5412"
* identifier[=].assigner = Reference(Organization/abc-hospital)
* identifier[+].system = "http://payer.xyz.org"
* identifier[=].value = "40e31ed2-4d16-4416-a66d-c3e84f8a4812"
* identifier[=].assigner = Reference(Organization/xyz-payer)
* identifier[+].system = "http://idp.def.org"
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

Instance: abc-hospital
InstanceOf: Organization
Description: "Example of Organization used as a hospital for digital identifier"
Usage: #example
* identifier[0].use = #official
* identifier[=].system = "urn:oid:2.16.528.1"
* identifier[=].value = "91654"
* identifier[+].use = #usual
* identifier[=].system = "urn:oid:2.16.840.1.113883.2.4.6.1"
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
Description: "Example of Organization used as a payer for digital identifier"
Usage: #example
* identifier.system = "urn:oid:2.16.840.1.113883.3.19.2.3"
* identifier.value = "666666"
* name = "XYZ Insurance"
* alias = "ABC Insurance"
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
* identifier.system = "http://www.secureidp.com/units"
* identifier.value = "SecureIdp"
* name = "Secure Idp"
* contact.telecom[0].system = #phone
* contact.telecom[=].value = "+1 555 234 3523"
* contact.telecom[=].use = #work
* contact.telecom[+].system = #email
* contact.telecom[=].value = "gastro@acme.org"
* contact.telecom[=].use = #work

//====================================================================================================


Instance: MATCHOperationResponse
InstanceOf: IDIMatchBundle
Description: "Example of $MATCH operation response with patient and organization"
Usage: #example
* meta.lastUpdated = "2024-07-18T03:28:49Z"
* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:1eaddf4c-2ec0-4dc4-b26f-9586d7a777e9"
* identifier.assigner = Reference(Organization/bumc-hospital)
* type = #collection
* entry[0].fullUrl = "https://example.com/base/Organization/bumc-hospital"
* entry[=].resource = bumc-hospital
* entry[+].fullUrl = "https://example.com/base/Patient/MATCHOperationResponsePatient"
* entry[=].resource = MATCHOperationResponsePatient


//====================================================================================================

Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203


Instance: MATCHOperationResponsePatient
InstanceOf: Patient
Usage: #inline
* identifier.use = #usual
* identifier.type = $v2-0203#MR
* identifier.system = "urn:oid:1.2.36.146.595.217.0.1"
* identifier.value = "12345"
* identifier.period.start = "2001-05-06"
* identifier.assigner.display = "Acme Healthcare"
* active = true
* name[0].use = #official
* name[=].family = "Chalmers"
* name[=].given[0] = "Peter"
* name[=].given[+] = "James"
* name[+].use = #usual
* name[=].given = "Jim"
* name[+].use = #maiden
* name[=].family = "Windsor"
* name[=].given[0] = "Peter"
* name[=].given[+] = "James"
* name[=].period.end = "2002"
* telecom[0].use = #home
* telecom[+].system = #phone
* telecom[=].value = "(03) 5555 6473"
* telecom[=].use = #work
* telecom[=].rank = 1
* telecom[+].system = #phone
* telecom[=].value = "(03) 3410 5613"
* telecom[=].use = #mobile
* telecom[=].rank = 2
* telecom[+].system = #phone
* telecom[=].value = "(03) 5555 8834"
* telecom[=].use = #old
* telecom[=].period.end = "2014"
* gender = #male
* birthDate = "1974-12-25"
* birthDate.extension.url = "http://hl7.org/fhir/StructureDefinition/patient-birthTime"
* birthDate.extension.valueDateTime = "1974-12-25T14:35:45-05:00"
* deceasedBoolean = false
* address.use = #home
* address.type = #both
* address.text = "534 Erewhon St PeasantVille, Rainbow, Vic  3999"
* address.line = "534 Erewhon St"
* address.city = "PleasantVille"
* address.district = "Rainbow"
* address.state = "Vic"
* address.postalCode = "3999"
* address.period.start = "1974-12-25"
* managingOrganization = Reference(abc-hospital)

//====================================================================================================


Instance: bumc-hospital
InstanceOf: Organization
Usage: #inline
* identifier[0].use = #official
* identifier[=].system = "urn:oid:2.16.528.1"
* identifier[=].value = "91654"
* identifier[+].use = #usual
* identifier[=].system = "urn:oid:2.16.840.1.113883.2.4.6.1"
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
