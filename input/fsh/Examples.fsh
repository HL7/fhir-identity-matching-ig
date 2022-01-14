Instance: Patient1
InstanceOf: IDIPatient
Description: "Example of Patient used as input to $match operation"
Usage: #example

* meta.profile = Canonical(IDI-Patient)
* meta.lastUpdated = "2020-07-07T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatient1"
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

* birthDate = "1986-01-01"

* contact.telecom[0].system = #fax
* contact.telecom[0].value = "555-555-5555"
* contact.telecom[0].use = #home

* address[0].type = #physical
* address[0].line[0] = "123 Main Street"
* address[0].city = "Pittsburgh"
* address[0].state = "PA"
* address[0].postalCode = "12519"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK

//====================================================================================================

Instance: Patient-L1
InstanceOf: IDIPatientL1
Description: "Example of Patient used as input to $match operation meeting Level 1 compliance"
Usage: #example

* meta.profile = Canonical(IDI-Patient-L1)
* meta.lastUpdated = "2021-11-01T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatientL1"
* active = true

* identifier[0].type.coding.code = #MR
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "4004-202-9999-12345678901"
* identifier[0].system = "https://www.xyzhealthplan.com/fhir/memberidentifier"

* name[0].family = "Paeshent"
* name[0].given[0] = "Nancy"

* telecom[0].system = #phone
* telecom[0].value = "444-555-3939"
* telecom[0].use = #mobile 

* gender = #female

* birthDate = "1988-02-11"

* contact.telecom[0].system = #fax
* contact.telecom[0].value = "555-555-5555"
* contact.telecom[0].use = #home

* address[0].type = #physical
* address[0].line[0] = "321 South Maple Street"
* address[0].city = "Scranton"
* address[0].state = "PA"
* address[0].postalCode = "18503"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK

//====================================================================================================

Instance: Patient-L2
InstanceOf: IDIPatientL2
Description: "Example of Patient used as input to $match operation meeting Level 2 compliance"
Usage: #example

* meta.profile = Canonical(IDI-Patient-L2)
* meta.lastUpdated = "2021-11-01T13:26:22.0314215+00:00"
* language = #en-US
* id = "ExamplePatientL2"
* active = true

* identifier[0].type.coding.code = #MR
* identifier[0].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[0].value = "3902-16532901"
* identifier[0].system = "https://www.xyzhealthplan.com/fhir/memberidentifier"

* name[0].family = "Case"
* name[0].given[0] = "Justin"

* telecom[0].system = #phone
* telecom[0].value = "726-555-2900"
* telecom[0].use = #mobile 

* gender = #female

* birthDate = "1992-05-17"

* contact.telecom[0].system = #fax
* contact.telecom[0].value = "726-555-1094"
* contact.telecom[0].use = #home

* address[0].type = #physical
* address[0].line[0] = "418 Teapot Lane"
* address[0].city = "Raleigh"
* address[0].state = "NC"
* address[0].postalCode = "27513"

* maritalStatus = http://terminology.hl7.org/CodeSystem/v3-NullFlavor#UNK
