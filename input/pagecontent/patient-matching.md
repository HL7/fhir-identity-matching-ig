
This section of the guide extends the existing HL7 FHIR patient [$match](https://www.hl7.org/fhir/patient-operation-match.html) for cross-organizational use by authorized, trusted parties. The IG profiles the operation [$IDI-match](StructureDefinition-idi-match-bundle.html) to account for these additional constraints. 

- a match on a Golden Identifier is considered a match.
- all other matches not based on Golden Identifiers are at the discretion of the service provider.

