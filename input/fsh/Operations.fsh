Instance: IDIMatchOperation
InstanceOf: OperationDefinition
Description: "This operation is used by an entity to submit one or multiple GFEs as a Bundle containing the GFE(s) and other referenced resources for processing. The only input parameter is the single Bundle resource with one or multiple GFE(s) - each of which is based on the Claim resource (along with other referenced resources). The only output is a url for subsequent polling per [async pattern](http://build.fhir.org/async-bundle.html). If after polling the response is complete, then the result will either be a single Bundle with the AEOB - which is based on the ExplanationOfBenefit resource, (and other referenced resources) or an OperationOutcome resource indicating the AEOB will be sent directly to the patient and not to the provider."
Usage: #definition

* id = "IDI-match"
* url = "http://hl7.org/fhir/us/identity-matching/OperationDefinition/IDI-match"
* name = "IDIMatch"
* title = "Additional constraints for $match"
* status = #draft
* kind = #operation
* description = "This operation is used by an entity to submit one or multiple GFEs as a Bundle containing the GFE(s) and other referenced resources for processing. The only input parameter is the single Bundle resource with one or multiple GFE(s) - each of which is based on the Claim resource (along with other referenced resources). The only output is a url for subsequent polling per [async pattern](http://build.fhir.org/async-bundle.html). If after polling the response is complete, then the result will either be a single Bundle with the AEOB - which is based on the ExplanationOfBenefit resource, (and other referenced resources) or an OperationOutcome resource indicating the AEOB will be sent directly to the patient."
* code = #idi-match
* base = "http://hl7.org/fhir/us/identity-matching/OperationDefinition/IDI-match"
* resource = #Patient
* system = false
* type = true
* instance = false
* parameter[0].name = #resource
* parameter[0].use = #in
* parameter[0].min = 1
* parameter[0].max = "1"
* parameter[0].documentation = "A Patient resource that is being requested in a $match operation."
* parameter[0].type = #Patient
* parameter[1].name = #return
* parameter[1].use = #out
* parameter[1].min = 1
* parameter[1].max = "1"
* parameter[1].documentation = "When successful, a Bundle resource containing Patient resources of a high confidence match is returned to the requestor. In addition, an Organization resource of the responding entity will be included in the Bundle for error reporting purposes. When the responding server is unable to return a match, a response of 'No Match Found' will be returned."
* parameter[1].type = #Bundle