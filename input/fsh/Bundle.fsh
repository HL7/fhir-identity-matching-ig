Profile: IDIMatchBundle
Parent: Bundle
Id: idi-match-bundle
Title: "IDI Match Bundle"
Description: "Bundle requirements for responders of a $IDI-match request."

* identifier 1..1 MS
* identifier.assigner 1..1 MS
* type = #collection (exactly)
* entry 1..* MS
* entry.fullUrl 1..1 MS
* entry ^slicing.discriminator.type = #profile
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry ^slicing.description = "Slice different resources included in the bundle"
* entry contains
    organization 1..1 MS and
    patient 0..* MS

* entry[organization] ^short = "Entry in the bundle - will have the payer organization and may have provider organization(s)"
* entry[organization].resource 1..1 MS
* entry[organization].resource only Organization
* entry[organization].resource ^short = "Bundle entry for responding organization"

* entry[patient] ^short = "Entry in the bundle - will have the patient subject of care and may be a separate subscriber"
* entry[patient].resource 1..1 MS
* entry[patient].resource only IDIPatient or IDIPatientL0 or IDIPatientL1
* entry[patient].resource ^short = "Bundle entry for matched Patient"

