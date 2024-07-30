Instance: IDIMatchOperation
InstanceOf: OperationDefinition
Description: "This extension of the $match operation is further constrained to meet the additional requirements found in this IG. One of the IDI Patient profiles outline in this guide (IDI-Patient, IDI-Patient-L0, IDI-Patient-L1) SHALL be used as the input for the match request. An IDI-Match-Bundle will be returned to the requesting entity. This Bundle will contain the full URLs of the sourced information, an Organization resource, and any matched Patient resources."
Usage: #definition

* id = "IDI-match"
* url = "http://hl7.org/fhir/us/identity-matching/OperationDefinition/IDI-match"
* name = "IDIMatch"
* title = "IDI Match Operation"
* status = #draft
* kind = #operation
* description = "This extension of the $match operation is further constrained to meet the additional requirements found in this IG. One of the IDI Patient profiles outline in this guide (IDI-Patient, IDI-Patient-L0, IDI-Patient-L1) SHALL be used as the input for the match request. An IDI-Match-Bundle will be returned to the requesting entity. This Bundle will contain the full URLs of the sourced information, an Organization resource, and any matched Patient resources."
* code = #idi-match
* base = "http://hl7.org/fhir/us/identity-matching/OperationDefinition/IDI-match"
* resource = #Patient
* system = false
* type = true
* instance = false
* inputProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient"
* inputProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L0"
* inputProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/IDI-Patient-L1"
* outputProfile = "http://hl7.org/fhir/us/identity-matching/StructureDefinition/idi-match-bundle"

* parameter[0].name = #IDIPatient
* parameter[0].use = #in
* parameter[0].min = 1
* parameter[0].max = "1"
* parameter[0].documentation = "A Patient resource that is being requested in the match operation. The requester must use one of the IDI Patient profiles for the resource in their submission."
* parameter[0].type = #Patient

* parameter[1].name = #IDIMatchBundle
* parameter[1].use = #out
* parameter[1].min = 1
* parameter[1].max = "1"
* parameter[1].documentation = "When successful, a Bundle resource containing Patient resources of a high confidence match is returned to the requestor. In addition, an Organization resource of the responding entity will be included in the Bundle for error reporting purposes. When the responding server is unable to return a match, a response of 'No Match Found' will be returned."
* parameter[1].type = #Bundle