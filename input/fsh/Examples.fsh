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

Instance: example3
InstanceOf: Patient
Usage: #example
* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
* identifier[0].system = "http://hospital.abc.org"
* identifier[=].value = "a5c2498f-9b62-4c97-8dc3-03a20b0f5412"
* identifier[=].assigner = Reference(Organization/abc_hospital)
* identifier[+].system = "http://payer.xyz.org"
* identifier[=].value = "40e31ed2-4d16-4416-a66d-c3e84f8a4812"
* identifier[=].assigner = Reference(Organization/xyz_payer)
* identifier[+].system = "http://idp.def.org"
* identifier[=].value = "db0cfc86-58e4-467c-b1d7-78571598ee15"
* identifier[=].assigner = Reference(Organization/def_idp)
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

