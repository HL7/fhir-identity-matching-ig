Instance: IDIMatchOperation
InstanceOf: OperationDefinition
Description: "This extension of the $match operation is further constrained to meet the additional requirements found in this IG. One of the IDI Patient profiles outline in this guide (IDI-Patient, IDI-Patient-L0, IDI-Patient-L1, IDI-Patient-L2) SHALL be used as the input for the match request. An IDI-Match-Bundle will be returned to the requesting entity. This Bundle will contain the full URLs of the sourced information, an Organization resource, and any matched Patient resources."
Usage: #definition

* id = "IDI-match"
* url = "http://hl7.org/fhir/us/identity-matching/OperationDefinition/IDI-match"
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
* inputProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/idi-match-input-parameters"
* outputProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/idi-match-output-parameters"

* parameter[0].name = #resource
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

* parameter[+].name = #return
* parameter[=].use = #out
* parameter[=].min = 1
* parameter[=].max = "1"
* parameter[=].documentation = "When successful, a Bundle resource containing Patient resources of a high confidence match **SHALL** be returned to the requestor. In addition, an Organization resource of the responding entity **SHALL** be included in the Bundle for error reporting purposes. When the responding server is unable to return a match, a response of 'No Match Found' will be returned."
* parameter[=].type = #Bundle
// * parameter[=].targetProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/idi-match-bundle"
