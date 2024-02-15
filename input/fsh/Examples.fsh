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

* telecom[0].system = #phone
* telecom[0].value = "444-555-3939"
* telecom[0].use = #mobile 

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

Alias: $v3-TribalEntityUS = http://terminology.hl7.org/CodeSystem/v3-TribalEntityUS
Alias: $v3-NullFlavor = http://terminology.hl7.org/CodeSystem/v3-NullFlavor
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

Instance: example2
InstanceOf: Patient
Usage: #example

* meta.profile = Canonical(VerAtt-Patient)
* extension[+].id = "va-birthsex"
* extension[=].url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex"
* extension[=].valueCode = #F
* extension[+].id = "va-sex"
* extension[=].url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex"
* extension[=].valueCode = #248152002
* extension[+].id = "vs-genderIdentity"
* extension[=].url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity"

* identifier.use = #usual
* identifier.type = $v2-0203#MR "Medical Record Number"
* identifier.type.text = "Medical Record Number"
* identifier.system = "http://hospital.smarthealthit.org"

* identifier.value = "1032702"
* active = true
* name[+].id = "va-name"
* name[=].family = "Baxter"
* name[=].given[0] = "Amy"
* name[=].given[+] = "V."
* name[=].suffix = "PharmD"
* name[=].period.start = "2020-07-22"

* telecom[0].system = #phone
* telecom[=].value = "555-555-5555"
* telecom[=].use = #home
* telecom[+].system = #email
* telecom[=].value = "amy.shaw@example.com"

* gender = #female

* birthDate = "1987-02-20"

* address[0].use = #old
* address[=].id = "va-address-old"
* address[=].line = "49 Meadow St"
* address[=].city = "Mounds"
* address[=].state = "OK"
* address[=].postalCode = "74047"
* address[=].country = "US"
* address[=].period.start = "2016-12-06"
* address[=].period.end = "2020-07-22"
* address[+].id = "va-address-new"
* address[=].line = "183 Mountain View St"
* address[=].city = "Mounds"
* address[=].state = "OK"
* address[=].postalCode = "74048"
* address[=].country = "US"
* address[=].period.start = "2020-07-22"

//====================================================================================================

Alias: $provenance-participant-type = http://terminology.hl7.org/CodeSystem/provenance-participant-type

Instance: provenance-example
InstanceOf: Provenance
Usage: #example

* meta.profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance"

* target = Reference(Patient/example2)
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-genderIdentity"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-birthsex"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-sex"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-name"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-gender"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-birthDate"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-address-old"
* target.extension[+].url = "http://hl7.org/fhir/StructureDefinition/targetElement"
* target.extension[=].valueUri = "va-address-new"

* recorded = "2023-02-28T15:26:23.217+00:00"

* agent.type = $provenance-participant-type#informant "Informant"
* agent.who = Reference(Patient/example2)

* entity.role = #source
* entity.what.display = "My_Form"