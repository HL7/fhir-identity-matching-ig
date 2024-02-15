Profile: IDIPatient
Parent: Patient
Id: IDI-Patient
Title: "IDI Patient"
Description: "(Base Level) The goal of this profile is to describe a data-minimized version of Patient used to convey information about the patient for Identity Matching utilizing the $match operation.  Only requires that 'some valuable data' be populated within the Patient resource and utilizes no weighting of element values."

* . ^short = "Patient information to be supplied to $match operation"
* . ^definition = "Demographics and other administrative information about an individual which can be utilized within the $match operation."
* obeys idi-1

* meta.profile ^slicing.discriminator.type = #pattern
* meta.profile ^slicing.discriminator.path = "$this"
* meta.profile ^slicing.description = "Slice based on pattern"
* meta.profile ^slicing.ordered = false
* meta.profile ^slicing.rules = #open
* meta.profile ^comment = "meta.profile is required as a matter of convenience of receiving systems. The meta.profile SHALL be used by the Server to hint/assert/declare that this instance conforms to the stated profiles (with business versions). meta.profile does not capture any business logic, processing directives, or semantics (for example, inpatient or outpatient). "
* meta.profile contains assertedProfile 0..1
* meta.profile[assertedProfile] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient"

* identifier.type 1..1
* identifier.value 1..1
* identifier.type from IdentityIdentifierValueSet (extensible)

* name obeys idi-2

//=================================================================================================================================
// Level 0 Weighting
//
Profile: IDIPatientL0
Parent: Patient
Id: IDI-Patient-L0
Title: "IDI Patient L0"
Description: "(Level 0 weighting) The goal of this profile is to describe a data-minimized version of Patient used to convey information about the patient for Identity Matching utilizing the $match operation, and prescribe a minimum set of data elements which meet a combined 'weighted level' of at least 9"

* . ^short = "Patient information to be supplied to $match operation conforming to Level 0 weighting of information"
* . ^definition = "Demographics and other administrative information about an individual which can be utilized within the $match operation meeting a minimum combined weighting a step above the base level."
* obeys idi-L0

* meta.profile ^slicing.discriminator.type = #pattern
* meta.profile ^slicing.discriminator.path = "$this"
* meta.profile ^slicing.description = "Slice based on pattern"
* meta.profile ^slicing.ordered = false
* meta.profile ^slicing.rules = #open
* meta.profile ^comment = "meta.profile is required as a matter of convenience of receiving systems. The meta.profile SHALL be used by the Server to hint/assert/declare that this instance conforms to the stated profiles (with business versions). meta.profile does not capture any business logic, processing directives, or semantics (for example, inpatient or outpatient). "
* meta.profile contains assertedProfile 0..1
* meta.profile[assertedProfile] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L0"

* identifier.type 1..1
* identifier.value 1..1
* identifier.type from IdentityIdentifierValueSet (extensible)

* name obeys idi-2

//=================================================================================================================================
// Level 1 Weighting
//
Profile: IDIPatientL1
Parent: Patient
Id: IDI-Patient-L1
Title: "IDI Patient L1"
Description: "(Level 1 weighting) The goal of this profile is to describe a data-minimized version of Patient used to convey information about the patient for Identity Matching utilizing the $match operation, and prescribe a minimum set of data elements which meet a combined 'weighted level' of at least 10 and using attributes that are consistent with an identity that has been verified by the match requestor"

* . ^short = "Patient information to be supplied to $match operation conforming to Level 1 weighting of information"
* . ^definition = "Demographics and other administrative information about an individual which can be utilized within the $match operation meeting a minimum combined weighting higher than previous levels."
* obeys idi-L1

* meta.profile ^slicing.discriminator.type = #pattern
* meta.profile ^slicing.discriminator.path = "$this"
* meta.profile ^slicing.description = "Slice based on pattern"
* meta.profile ^slicing.ordered = false
* meta.profile ^slicing.rules = #open
* meta.profile ^comment = "meta.profile is required as a matter of convenience of receiving systems. The meta.profile SHALL be used by the Server to hint/assert/declare that this instance conforms to the stated profiles (with business versions). meta.profile does not capture any business logic, processing directives, or semantics (for example, inpatient or outpatient). "
* meta.profile contains assertedProfile 0..1
* meta.profile[assertedProfile] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L1"

* identifier.type 1..1
* identifier.value 1..1
* identifier.type from IdentityIdentifierValueSet (extensible)

* name obeys idi-2

//=================================================================================================================================
// Verified Attributes - Patient
//
Profile: VerAttPatient
Parent: Patient
Id: VerAtt-Patient
Title: "VerAtt Patient"
Description: "The goal of this profile is to assist in determining the verification status of a demographic. ID tags are attached to each demographic element to be referenced in a parallel Provenance resource."

* . ^short = "Patient information to be supplied to $match operation"
* . ^definition = "Demographics and other administrative information about an individual which can be utilized within the $match operation."

* name.id MS
* name.id 0..1
* name.id ^short = "Name ID to be used in attribute verification assertion"
* name.id ^definition = "Name ID to be used in attribute verification assertion with an associated Provenance resource"
* birthDate.id MS
* birthDate.id 0..1
* birthDate.id ^short = "Birth date ID to be used in attribute verification assertion"
* birthDate.id ^definition = "Birth date ID to be used in attribute verification assertion with an associated Provenance resource"
* gender.id MS
* gender.id 0..1
* gender.id ^short = "Gender ID to be used in attribute verification assertion"
* gender.id ^definition = "Gender ID to be used in attribute verification assertion with an associated Provenance resource"
* telecom.id MS
* telecom.id 0..1
* telecom.id ^short = "Contact Info ID to be used in attribute verification"
* telecom.id ^definition = "Contact Info ID to be used in attribute verification assertion with an associated Provenance resource"
* address.id MS
* address.id 0..1
* address.id ^short = "Address ID to be used in attribute verification"
* address.id ^definition = "Address ID to be used in attribute verification assertion with an associated Provenance resource"

