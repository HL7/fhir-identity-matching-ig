
Profile: LEI
Parent: Identifier
Title: "An Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "An Identifier with a value that is a Legal Entity Identifier (LEI), and may carry the verified LEI (vLEI)"
* use MS // should this be fixed? Doesn't seem this should be fixed.
* type MS // TODO: should this be specified? should we identify a type code for LEI? Should that be here or in THO?
* system 1..1 MS
* system = "https://www.gleif.org/lei"
* system ^comment = "The system URI for the LEI is https://www.gleif.org/lei, which is the official source for LEI information. This URI indicates that the identifier value is a Legal Entity Identifier (LEI) as defined by the Global Legal Entity Identifier Foundation (GLEIF)."
* value 1..1 MS
* value ^comment = "The value of the identifier is a Legal Entity Identifier (LEI) as defined in ISO 17442. The LEI is a 20-character alphanumeric code that uniquely identifies legal entities participating in financial transactions. The vLEI may be used to indicate that the LEI has been verified and is valid."
* value obeys lei-format
* period 0..1 MS
* period ^comment = "The period during which the binding of the LEI to this Identifier use is valid. This should not be longer than the valid life of the LEI itself."
* assigner 0..1 MS
* assigner ^comment = "The organization that issued the LEI. This should be the organization that is responsible for the LEI, which is typically the Local Operating Unit (LOU) that issued the LEI. The assigner should be an organization that is authorized to issue LEIs and is recognized by the Global Legal Entity Identifier Foundation (GLEIF). This value shall not be the QVI."
* assigner.reference 0..1 MS
* assigner.reference ^comment = "The reference to the organization that issued the LEI should point to an Organization resource that represents the Local Operating Unit (LOU) that issued the LEI. This allows for better interoperability and consistency in representing the issuer of the LEI across different systems and implementations."
* assigner.identifier 0..1 MS
* assigner.identifier ^comment = "The identifier for the organization that issued the LEI should be a unique identifier that can be used to reference the organization. This could be an identifier from a recognized system such as the Global Legal Entity Identifier Foundation (GLEIF) or another authoritative source for organizational identifiers. The identifier should be used to ensure that the organization can be uniquely identified and referenced in a consistent manner across different systems and implementations."
* extension contains VLEI named vlei 0..* // one or more LEI

Invariant: lei-format
Description: "The value of the identifier must be a valid Legal Entity Identifier (LEI) as defined in ISO 17442. The LEI is a 20-character alphanumeric code that uniquely identifies legal entities participating in financial transactions. The vLEI may be used to indicate that the LEI has been verified and is valid."
Expression: "value.matches('^[0-9A-Z]{20}$')"
Severity: #error

Extension: VLEI
Title: "vLEI"
Description: "An extension to hold the verified LEI (vLEI) indicating that the LEI has been verified and is valid. Note that the vLEI is not further decomposed into the Attachment elements, as pulling these values outside of the vLEI leaves them unprotected. Thus any access to the vLEI elements should go through the proper vLEI validation process and use the values in the then validated vLEI."
Context: Identifier
* value[x] 1..1 MS
* value[x] only Attachment
* valueAttachment.contentType 1..1 MS
* valueAttachment.contentType = #application/json
* valueAttachment.data 1..1 MS
* valueAttachment.url 0..1 MS
* valueAttachment.size 0..0
* valueAttachment.hash 0..0
* valueAttachment.title 0..0
* valueAttachment.creation 0..0
* valueAttachment.language 0..0
//* valueAttachment.height 0..0
//* valueAttachment.width 0..0
//* valueAttachment.frames 0..0
//* valueAttachment.duration 0..0
//* valueAttachment.pages 0..0

Profile: PersonLei
Parent: Person
Title: "A Person resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "A Person resource that includes an Identifier with a value that is a Legal Entity Identifier
(LEI), and may carry the verified LEI (vLEI). This profile is used to represent a person who has a legal entity identifier, which is typically used for individuals who are associated with legal entities in financial transactions. The profile includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains lei 1..* MS
* identifier[lei] only LEI


Instance: example-person-lei
InstanceOf: PersonLei
Title: "Example of a Person with a Legal Entity Identifier (LEI)"
Description: "This is an example of a Person resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI). The Identifier uses the LEI profile to specify that the value is a valid LEI, and includes the system URI for the LEI. The example also includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
Usage: #example 
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1H11"
* identifier[lei].extension[vlei].valueAttachment.contentType = #application/json
* identifier[lei].extension[vlei].valueAttachment.data = "eyJ2bG9nSW5mb1Jlc3VsdCI6eyJ2bG9nSW5mb0NvZGVDb250ZW50IjoiQmVzdCB2bG9nSW5mbw=="
* active = true
* name.text = "John Doe"
* name.family = "Doe"
* name.given = "John"
* birthDate = "1980-01-01"

Profile: OrganizationLei
Parent: us-core-organization
Title: "An Organization resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "An Organization resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI), and may carry the verified LEI (vLEI). This profile is used to represent an organization that has a legal entity identifier, which is typically used for organizations that are involved in financial transactions. The profile includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
//* identifier ^slicing.discriminator.type = #value
//* identifier ^slicing.discriminator.path = "system"
//* identifier ^slicing.rules = #open
* identifier contains lei 1..* MS
* identifier[lei] only LEI
* identifier[lei].system = "https://www.gleif.org/lei"

Instance: example-organization-lei
InstanceOf: OrganizationLei
Title: "Example of an Organization with a Legal Entity Identifier (LEI)"
Description: "This is an example of an Organization resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI). The Identifier uses the LEI profile to specify that the value is a valid LEI, and includes the system URI for the LEI. The example also includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
Usage: #example
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1H11"
* identifier[lei].extension[vlei].valueAttachment.contentType = #application/json
* identifier[lei].extension[vlei].valueAttachment.data = "eyJ2bG9nSW5mb1Jlc3VsdCI6eyJ2bG9nSW5mb0NvZGVDb250ZW50IjoiQmVzdCB2bG9nSW5mbw=="
* active = true
* name = "Example Organization"

Profile: PractitionerLei
Parent: us-core-practitioner
Title: "A Practitioner resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "A Practitioner resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI), and may carry the verified LEI (vLEI). This profile is used to represent a practitioner who has a legal entity identifier, which is typically used for individuals who are associated with legal entities in financial transactions. The profile includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
//* identifier ^slicing.discriminator.type = #value
//* identifier ^slicing.discriminator.path = "system"
//* identifier ^slicing.rules = #open
* identifier contains lei 1..* MS
* identifier[lei] only LEI
* identifier[lei].system = "https://www.gleif.org/lei"

Instance: example-practitioner-lei
InstanceOf: PractitionerLei
Title: "Example of a Practitioner with a Legal Entity Identifier (LEI)"
Description: "This is an example of a Practitioner resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI). The Identifier uses the LEI profile to specify that the value is a valid LEI, and includes the system URI for the LEI. The example also includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
Usage: #example
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1H11"
* identifier[lei].extension[vlei].valueAttachment.contentType = #application/json
* identifier[lei].extension[vlei].valueAttachment.data = "eyJ2bG9nSW5mb1Jlc3VsdCI6eyJ2bG9nSW5mb0NvZGVDb250ZW50IjoiQmVzdCB2bG9nSW5mbw=="
* active = true
* name.family = "Smith"
* name.given = "Jane"
* birthDate = "1990-02-01"

Profile: PractitionerRoleLei
Parent: us-core-practitionerrole
Title: "A PractitionerRole resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "A PractitionerRole resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI), and may carry the verified LEI (vLEI). This profile is used to represent a practitioner role that has a legal entity identifier, which is typically used for roles that are associated with legal entities in financial transactions. The profile includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains lei 1..* MS
* identifier[lei] only LEI

Instance: example-practitionerrole-lei
InstanceOf: PractitionerRoleLei
Title: "Example of a PractitionerRole with a Legal Entity Identifier (LEI)"
Description: "This is an example of a PractitionerRole resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI). The Identifier uses the LEI profile to specify that the value is a valid LEI, and includes the system URI for the LEI. The example also includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
Usage: #example
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1H11"
* identifier[lei].extension[vlei].valueAttachment.contentType = #application/json
* identifier[lei].extension[vlei].valueAttachment.data = "eyJ2bG9nSW5mb1Jlc3VsdCI6eyJ2bG9nSW5mb0NvZGVDb250ZW50IjoiQmVzdCB2bG9nSW5mbw=="
* active = true
* practitioner = Reference(Practitioner/example-practitioner-lei)
* organization = Reference(Organization/example-organization-lei)
* telecom.system = #phone
* telecom.value = "555-123-4567"


Profile: PatientLei
Parent: us-core-patient
Title: "A Patient resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "A Patient resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI), and may carry the verified LEI (vLEI). This profile is used to represent a patient who has a legal entity identifier, which is typically used for individuals who are associated with legal entities in financial transactions. The profile includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains lei 1..* MS
* identifier[lei] only LEI


Instance: example-patient-lei
InstanceOf: PatientLei
Title: "Example of a Patient with a Legal Entity Identifier (LEI)"
Description: "This is an example of a Patient resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI). The Identifier uses the LEI profile to specify that the value is a valid LEI, and includes the system URI for the LEI. The example also includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
Usage: #example
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1H11"
* identifier[lei].extension[vlei].valueAttachment.contentType = #application/json
* identifier[lei].extension[vlei].valueAttachment.data = "eyJ2bG9nSW5mb1Jlc3VsdCI6eyJ2bG9nSW5mb0NvZGVDb250ZW50IjoiQmVzdCB2bG9nSW5mbw=="
* active = true
* name.family = "Doe"
* name.given = "John"
* birthDate = "1980-01-01"
* gender = #male

Profile: RelatedPersonLei
Parent: us-core-relatedperson
Title: "A RelatedPerson resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI)"
Description: "A RelatedPerson resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI), and may carry the verified LEI (vLEI). This profile is used to represent a related person who has a legal entity identifier, which is typically used for individuals who are associated with legal entities in financial transactions. The profile includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains lei 1..* MS
* identifier[lei] only LEI

Instance: example-relatedperson-lei
InstanceOf: RelatedPersonLei
Title: "Example of a RelatedPerson with a Legal Entity Identifier (LEI)"
Description: "This is an example of a RelatedPerson resource that includes an Identifier with a value that is a Legal Entity Identifier (LEI). The Identifier uses the LEI profile to specify that the value is a valid LEI, and includes the system URI for the LEI. The example also includes an extension for the verified LEI (vLEI) to indicate that the LEI has been verified and is valid."
Usage: #example
* identifier[lei].system = "https://www.gleif.org/lei"
* identifier[lei].value = "5493001KJTIIGC8Y1H11"
* identifier[lei].extension[vlei].valueAttachment.contentType = #application/json
* identifier[lei].extension[vlei].valueAttachment.data = "eyJ2bG9nSW5mb1Jlc3VsdCI6eyJ2bG9nSW5mb0NvZGVDb250ZW50IjoiQmVzdCB2bG9nSW5mbw=="
* active = true
* name.family = "Doe"
* name.given = "John"
* birthDate = "1980-01-01"
* patient = Reference(Patient/example-patient-lei)

