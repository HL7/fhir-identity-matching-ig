Profile: IDIPatient
Parent: Patient
Id: IDI-Patient
Title: "IDI Patient (Base Level)"
Description: "The goal of this profile is to describe a data-minimized version of Patient used to convey information about the patient used for Identity Matching utilizing the $match operation.  Only requires that 'some valuable data' be populated within the Patient resource and utilizes no weighting of element values."

// Inherited short and definition include animals
* . ^short = "Patient information to be supplied to $match operation"
* . ^definition = "Demographics and other administrative information about an individual which can be utilized within the $match operation."
* obeys idi-1

* meta.profile ^slicing.discriminator.type = #pattern
* meta.profile ^slicing.discriminator.path = "$this"
* meta.profile ^slicing.description = "Slice based on pattern"
* meta.profile ^slicing.ordered = false
* meta.profile ^slicing.rules = #open
* meta.profile ^comment = "meta.profile is required as a matter of convenience of receiving systems. The meta.profile SHOULD be used by the Server to hint/assert/declare that this instance conforms to one (or more) stated profiles (with business versions). meta.profile does not capture any business logic, processing directives, or semantics (for example, inpatient or outpatient). "
* meta.profile contains supportedProfile 1..1
* meta.profile[supportedProfile] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient"

// * name 1..1 MS
// * name.given 0..3 MS
* name obeys idi-2

* telecom obeys idi-3

// * birthDate 0..1
// * birthDate ^comment = "MAY be excluded."

* gender 0..1
// * gender ^comment = "MAY be excluded."

