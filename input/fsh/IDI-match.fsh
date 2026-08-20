Instance: IDIMatchOperation
InstanceOf: OperationDefinition
Description: "§1:This operation is an alternative of the $match operation, constrained to meet the additional requirements found in this IG. One of the IDI Patient profiles outline in this guide (IDI-Patient, IDI-Patient-L0, IDI-Patient-L1, IDI-Patient-L2) SHALL be used as the input for the match request. An IDI-Match-Bundle will be returned to the requesting entity. This Bundle will contain the full URLs of the sourced information, an Organization resource, and any matched Patient resources."
Usage: #definition

* id = "IDI-match"
//* url = "http://hl7.org/fhir/us/identity-matching/OperationDefinition/IDI-match"
* name = "IDIMatch"
* title = "IDI Match Operation"
* status = #active
* kind = #operation
* description = "This extension of the $match operation is further constrained to meet the additional requirements found in this IG. One of the IDI Patient profiles outline in this guide (IDI-Patient, IDI-Patient-L0, IDI-Patient-L1, IDI-Patient-L2) **SHALL** be used as the input for the match request. An IDI-Match-Bundle will be returned to the requesting entity. This Bundle will contain the full URLs of the sourced information, an Organization resource, and any matched Patient resources."
* code = #idi-match
* base = "http://hl7.org/fhir/OperationDefinition/Patient-match"
// * resource = #Patient
* system = false
* type = true
* instance = false
* inputProfile = Canonical(idi-match-input-parameters)
* outputProfile = Canonical(idi-match-output-parameters)

* parameter[0].name = #IDIPatient
* parameter[0].use = #in
* parameter[0].min = 1
* parameter[0].max = "1"
* parameter[0].documentation = "A Patient resource that is being requested in the match operation. The requester **SHALL** use one of the IDI Patient profiles for the resource in their submission."
* parameter[0].type = #Patient
// * parameter[0].targetProfile[0] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient"
// * parameter[0].targetProfile[+] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L0"
// * parameter[0].targetProfile[+] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L1"
// * parameter[0].targetProfile[+] = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L2"

* parameter[+].name = #onlySingleMatch
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "If there are multiple potential matches, the server should identify the single most appropriate match that should be used with future interactions with the server (for example, as part of a subsequent create interaction)."
* parameter[=].type = #boolean

* parameter[+].name = #onlyCertainMatches
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "If there are multiple potential matches, the server should be certain that each of the records are for the same patients. This could happen if the records are duplicates, are the same person for the purpose of data segregation, or other reasons. When false, the server may return multiple results with each result graded accordingly."
* parameter[=].type = #boolean

* parameter[+].name = #count
* parameter[=].use = #in
* parameter[=].min = 0
* parameter[=].max = "1"
* parameter[=].documentation = "The maximum number of records to return. If no value is provided, the server decides how many matches to return. Note that clients should be careful when using this, as it may prevent probable - and valid - matches from being returned."
* parameter[=].type = #integer

* parameter[+].name = #IDIMatchBundle
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].documentation = "When successful, a Bundle resource containing Patient resources of a high confidence match **SHALL** be returned to the requestor. In addition, an Organization resource of the responding entity **SHALL** be included in the Bundle for error reporting purposes. When the responding server is unable to return a match, a response of 'No Match Found' will be returned."
* parameter[=].type = #Bundle
// * parameter[=].targetProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/idi-match-bundle"


Profile:        IDIMatchInputParameters
Parent:         Parameters
Id:             idi-match-input-parameters
Title:          "IDI Match Input Parameters"
Description:    "The Parameters profile used to define the inputs of the $IDI-match operation using an IDI-Patient profile for submission."

* ^status = #active
* parameter ^slicing.discriminator.type = #value
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open
* parameter ^slicing.description = "Slice based on $this pattern"
* parameter 1..* MS
* parameter contains 
	    IDIPatient 1..1 MS and
      onlySingleMatch 0..1 MS and
      onlyCertainMatches 0..1 MS and
      count 0..1 MS

* parameter[IDIPatient]
  * name = "IDIPatient"
  * resource 1..1 MS
  * resource only GoldenRecordPatientUSCore

* parameter[onlySingleMatch]
  * name = "onlySingleMatch" (exactly)
  * value[x] 1..1 MS
  * value[x] only boolean
  * resource 0..0

* parameter[onlyCertainMatches]
  * name = "onlyCertainMatches" (exactly)
  * value[x] 1..1 MS
  * value[x] only boolean
  * resource 0..0

* parameter[count]
  * name = "count" (exactly)
  * value[x] 1..1 MS
  * value[x] only integer
  * resource 0..0

//=============================================================//

Profile:        IDIMatchOutputParameters
Parent:         Parameters
Id:             idi-match-output-parameters
Title:          "IDI Match Output Parameters"
Description:    "The Parameters profile used to define the outputs of the $IDI-match operation."

* ^status = #active
* parameter ^slicing.discriminator.type = #value
* parameter ^slicing.discriminator.path = "name"
* parameter ^slicing.rules = #open
* parameter ^slicing.description = "Slice based on $this pattern"
* parameter 1..1 MS
* parameter contains 
	  IDIMatchBundle 1..1 MS

* parameter[IDIMatchBundle]
  * name = "IDIMatchBundle" (exactly)
  * resource 1..1 MS
  * resource only idi-match-bundle

Profile: IDIMatchBundle
Parent: Bundle
Id: idi-match-bundle
Title: "IDI Match Bundle"
Description: "Bundle requirements for responders to an $IDI-match request. Responders **SHALL** include only absolute URL FHIR server addresses, and **SHALL NOT** include URIs for UUIDs or OIDs, in the fullURL returned. This additional constraint on a response to $IDI-match is intended to help recipients understand the source of the response, particularly when a patient match is invoked as part of record location--such that the URL would be needed for additional health data requests performed subsequent to matching. Additionally, the .identifier.assigner element within the returned Bundle **SHOULD** include an Organization resource that contains at least one appropriate contact point."

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
