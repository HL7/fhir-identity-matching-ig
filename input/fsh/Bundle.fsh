Profile: IDIMatchBundle
Parent: Bundle
Id: idi-match-bundle
Title: "IDI Match Bundle"
Description: "Organization resources SHALL be included."
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
  * resource 1..1 MS
  * resource only Organization
    * ^short = "Bundle entry for responding organization"

* entry[patient] ^short = "Entry in the bundle - will have the patient subject of care and may be a separate subscriber"
  * resource 1..1 MS
  * resource only Patient
    * ^short = "Bundle entry for matched Patient"

