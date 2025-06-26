Profile: IDIMatchBundle
Parent: Bundle
Id: idi-match-bundle
Title: "IDI Match Bundle"
Description: "Bundle requirements for responders to an $IDI-match request. Responders SHALL include only absolute URL FHIR server addresses, and SHALL NOT include URIs for UUIDs or OIDs, in the fullURL returned. This additional constraint on a response to $IDI-match is intended to help recipients understand the source of the response, particularly when a patient match is invoked as part of record location--such that the URL would be needed for additional health data requests performed subsequent to matching."

* identifier 1..1 MS
* identifier.assigner 1..1 MS
* type = #searchset (exactly)
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
* entry[organization].resource only USCoreOrganizationProfile
* entry[organization].resource ^short = "Bundle entry for responding organization"

* entry[patient] ^short = "Entry in the bundle - will have the patient subject of care and may be a separate subscriber"
* entry[patient].resource 1..1 MS
* entry[patient].resource only USCorePatientProfile
* entry[patient].resource ^short = "Bundle entry for matched Patient"
