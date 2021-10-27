Alias: $restful-security-service = http://terminology.hl7.org/CodeSystem/restful-security-service
Alias: $udap-capability-rest-security-service = http://fhir.udap.org/CodeSystem/capability-rest-security-service

Instance: udap-server
InstanceOf: CapabilityStatement
Title: "UDAP Server CapabilityStatement"
Usage: #definition
Description: "CapabilityStatement indicating server support for UDAP workflows"

* url = "http://hl7.org/fhir/us/udap-security/CapabilityStatement/udap-server"
* version = "0.9.0"
* name = "UDAPServerCapabilityStatement"
* title = "UDAP Server CapabilityStatement"
* status = #active
* experimental = false
* date = "2021-06-14"
* publisher = "HL7 International - Security WG and UDAP.org"
* contact[0].telecom[0].system = #url
* contact[0].telecom[0].value = "http://www.hl7.org/Special/committees/secure"
* contact[1].telecom[0].system = #url
* contact[1].telecom[0].value = "https://www.udap.org"
* description = "CapabilityStatement indicating server support for UDAP workflows"
* jurisdiction = urn:iso:std:iso:3166#US
* copyright = "(c) 2021+ HL7 International - Security WG and UDAP.org"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[+] = #xml
* implementationGuide = "http://hl7.org/fhir/us/udap-security/ImplementationGuide/hl7.fhir.us.udap-security"
* rest.mode = #server
* rest.documentation = "This CapabilityStatement focuses on expressing the expected RESTful security services supported by a server. Additionally, servers are generally expected to support at least one interaction or operation at the resource or system level."
* rest.security.extension.url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
* rest.security.extension.extension[0].url = "token"
* rest.security.extension.extension[=].valueUri = "https://{token_url}"
* rest.security.extension.extension[+].url = "authorize"
* rest.security.extension.extension[=].valueUri = "https://{authz_url}"
* rest.security.extension.extension[+].url = "register"
* rest.security.extension.extension[=].valueUri = "https://{register_url}"
* rest.security.service[0] = $restful-security-service#SMART-on-FHIR
* rest.security.service[=].text = "OAuth2 using SMART-on-FHIR profile (see http://docs.smarthealthit.org)"
* rest.security.service[+] = $udap-capability-rest-security-service#UDAP
* rest.security.service[=].text = "OAuth 2 using UDAP profile (see http://www.udap.org)"
