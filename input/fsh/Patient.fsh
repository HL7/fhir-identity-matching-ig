
CodeSystem: IdentifierTypes
Title: "Golden Identifier Type"
Description: "Code system for the type of golden identifier used in the .identifier element of the Patient resource."
* ^experimental = false
* ^caseSensitive = true
* #golden "Golden Identifier" "A unique and consistent identifier for a data subject (such as a patient or client) across different healthcare systems and organizations, used in the .identifier element of the Patient resource to support identity matching and management in healthcare transactions."


Profile: IDIPatient
Parent: us-core-patient
Id: IDI-Patient
Title: "IDI Patient"
Description: "Patient with a Golden Identifier in the .identifier element."
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slicing on the .identifier element to allow for multiple identifiers, including a required Golden Identifier with a specific type."
* identifier contains GoldenIdentifier 1.. MS
* identifier[GoldenIdentifier].type 1..1 MS
* identifier[GoldenIdentifier].type = IdentifierTypes#golden
* identifier[GoldenIdentifier].value 1..1 MS
* identifier[GoldenIdentifier].system 1..1 MS
* identifier[GoldenIdentifier].period MS
* identifier[GoldenIdentifier].assigner MS

//=================================================================================================================================
// Level 0 Weighting
//
Instance: IDIPatientL0
InstanceOf: IDIPatient
Title: "IDI Patient L0"
Description: "Simple Patient with an identifier"
* identifier[GoldenIdentifier].type = IdentifierTypes#golden
* identifier[GoldenIdentifier].value = "GOLDEN12345"
* identifier[GoldenIdentifier].system = "http://example.org/golden-ids"

* name[0].family = "Smith"
* name[0].given[0] = "John"
* gender = #male

