The Golden Identity is a concept that represents a unique and consistent identifier for a data subject (such as a patient or client) across different healthcare systems and organizations. It is designed to improve the accuracy of patient matching and identity management in healthcare transactions. The Golden Identity can be used in conjunction with limited demographics to deterministically match an individual human or organizational identity, providing a preferred method for matching on an individual across different systems.

- [Golden Identity Design Notes](golden-design-notes.html) 
- [Golden Record Identity Design Brief](golden-record-identity-design-brief.html) 

### Identifier

Patient.identifier

[Golden Record Patient](StructureDefinition-GoldenRecordPatient.html) is a profile of the Patient resource that includes a required identifier element with a specific type for the Golden Identifier. The identifier.type is coded with a value from the IdentifierTypes code system, which includes a code for "golden" to indicate that the identifier is a Golden Identity. The identifier.value is the actual unique identifier for the patient.
- [Golden Record Patient USCore](StructureDefinition-GoldenRecordPatientUSCore.html) is a profile of the US-Core Patient resource that includes a required identifier element with a specific type for the Golden Identifier. 

[Example Patient with Golden Identifier](Patient-GoldenRecordPatientExample.html) is an instance of the Golden Record Patient profile that includes a Golden Identifier in the .identifier element, along with other demographic information such as name and a medical record number (MRN). This example illustrates how the Golden Identity can be represented in a FHIR resource to support identity matching and management in healthcare transactions.

[Example Patient with multiple CSP issued Golden Identifiers](Patient-GoldenRecordPatientMultiCSPExample.html) is an instance of the IDIPatient profile that includes multiple Golden Identifiers issued by different Credential Service Providers (CSPs). This example demonstrates how the Golden Identity can be used to represent a patient with multiple identifiers from different sources, allowing for accurate matching and management of patient identities across different healthcare systems.

### Matching

Sometimes the identifier is not available, and matching must be done on demographics.  This IG recommends the use of the FHIR `$match` operation to request a match given the information that the client knows. The algorithm that the server uses is not specified.

