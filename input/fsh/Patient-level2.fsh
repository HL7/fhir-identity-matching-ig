Profile: IDIPatientL2
Parent: Patient
Id: IDI-Patient-L2
Title: "IDI Patient 2 (Level 2 matching)"
Description: "The goal of this profile is to describe a data-minimized version of Patient used to convey information about the patient used for Identity Matching utilizing the $match operation, and prescribe a predetermined minimum set of data elements to be included and described as a 'Level'"

// Inherited short and definition include animals
* . ^short = "Patient information to be supplied to $match operation"
* . ^definition = "Demographics and other administrative information about an individual which can be utilized within the $match operation meeting a minimum combined weighting of included information of 12."
* obeys idi-L2

* meta.profile ^slicing.discriminator.type = #pattern
* meta.profile ^slicing.discriminator.path = "$this"
* meta.profile ^slicing.description = "Slice based on pattern"
* meta.profile ^slicing.ordered = false
* meta.profile ^slicing.rules = #open
* meta.profile ^comment = "meta.profile is required as a matter of convenience of receiving systems. The meta.profile SHOULD be used by the Server to hint/assert/declare that this instance conforms to one (or more) stated profiles (with business versions). meta.profile does not capture any business logic, processing directives, or semantics (for example, inpatient or outpatient). "
* meta.profile contains supportedProfile 1..1
* meta.profile[supportedProfile] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L2"

