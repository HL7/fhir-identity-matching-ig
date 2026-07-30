# HL7 Patient Matching 

Implementation Guide - Interoperable Digital Identity and Patient Matching

## View the IG

- [Current build](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/branches/master/)
- [stu3 CI build](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/branches/stu3/index.html)
- [github repository](https://github.com/HL7/fhir-identity-matching-ig/tree/stu3)

## Scope

This project is intended to enhance interoperability among patient matching and digital identity management approaches. It will leverage and build on existing and emerging standards and augment with best practices for identity verification. This is currently a gap not addressed directly by other identity related efforts.

For more information about this project see the project [Confluence Page](https://confluence.hl7.org/display/PA/Patient+Matching+PSS)

## Why the change for STU3

See [unified identity token payload discussion](unified-identity-token-payload-discussion-v0.1.md)

### John Notes

Those that have Patient data, will work with an idp to get LEI issued, and record that value in the Patient.identifier.

How will duplicate LEI issued will get merged/linked?

will the community trust all LEI issued by some set of IDPs? Regardless of if they ever identified as a patient or user?

need transactions identified between IDPs to assure non-duplicate issuance.

need transaction for authorized retrieval of LEI details given an LEI.
- usecase. New patient shows up and has an LEI. Thus the healthcare organization can get the current Demographics given that LEI. So the patient does not need to provide demographics independently.

will LEI support sensitive demographics? Will they be able to protect them? (sexual orientation, gender identity, etc) If this is not part of the LEI, then there is still recognition of the need for the FHIR Patient elements.

Do we define STU3 as a backward compatible version, where we add breaking changes in the version after that? Tefca and cms alignment may be hard.

#### questions on latest merge

- I need help understanding the 'brief §' use such as 'brief §4'
- Do we need profiles that are not us-core? The latest profiles come in two flavors.
- Latest uses #pattern slicing which is deprecated
- Latest allows for multiple golden identifiers. do we want that?
- New extension OrganizationVLEI, should be harmonized with VLEI extension. These should be extensions on Identifier, not Organization element.
- I understand that the system value for all LEI/vLEI identifiers is "https://www.gleif.org/lei"
- Should use the Profile on Identifier
- 