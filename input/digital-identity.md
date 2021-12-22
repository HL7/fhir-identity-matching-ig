Introduction

### Overview
Best practices from solutions document pasted below, needs revising...

Digital Identity is the unique representation of a subject engaged in an online transaction. A digital identity is always unique in the context of a digital service, but does not necessarily need to uniquely identify the subject in all contexts. In other words, accessing a digital service may not mean that the subject’s real-life identity is always evident from the credential identifier on its own.

Note: In the FAST proposed solutions, digital identities involved in FHIR transactions may represent Patients, Providers, Payers, and other Healthcare actors.

### Requirements for Enterprise Identifiers

Each locally established business identifier will have minimum metadata and verification constraints and is designed for cross-walking between the many systems necessary for successful patient matching in health information exchange.
Requirements:

Unique for the individual person (i.e. not the same identifier for entire family) within organizational boundaries of the exchange partner 

“assigner” plus “identifier”/ (number) is not reusable for a different person

Can be stored as an identifier along with its assigner in FHIR Patient resource and therefore used in $match operations or searches

IDs with date issued, expiration date, or validity periods will contain this metadata when available.

Patient provides their identifier(s) to a healthcare organization at registration and/or check-in, and the identifier(s) is/are then associated with the patient’s record. As an alternative to in-person binding to the record, patient rosters could be shared that describe how to associate each patient medical record number and insurance identifier pairing, for example, to manage identities at scale.

### Requirements for Digital Patient Identifiers 

- Identifier **SHALL** be validated.

- Identity proofing process at a minimum establishes that a unique individual is represented by each Identifier and includes a declaration of identity assertion (such that it is fraudulent to claim a false identity).

- Identifier **SHALL** be unique for all time within the assigner’s system.

- Identifier **SHALL NOT** be reassigned to a different individual and patient onboarding process requires that patient assert that these attributes uniquely represents them. 

- Identifier **SHALL** be <span style="background-color:yellow">'FHIR-ready'</span>. The identifier can be associated with an OpenID Connect credential that is capable of OAuth 2.0 authentication via UDAP Tiered OAuth; assigners which manage patient health records recognizes this type of identity for patients in their system as a Patient.identifier resource element and respond to queries that use this Identifier as a search parameter or in a match request.

{% include link-list.md %}