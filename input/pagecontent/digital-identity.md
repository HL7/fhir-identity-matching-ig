### Overview

Digital Identity is the unique representation of a subject engaged in an online transaction. A digital identity **SHALL** be unique in the context of a digital service that is compliant with this IG, but does not necessarily need to uniquely identify the subject in all contexts. Specifically, such a digital service **SHALL NOT** require that the subject’s real-life identity be evident from the credential identifier on its own. 

In our efforts to address matching errors by prioritizing the use of Digital Identifiers, this section of the IG defines what are likely to be new Digital Identifiers suitable for use in person matching where high confidence in the Digital Identity associated with such an Identifier is needed. Though there can be usability benefits in having just one such credential, an individual's choice to utilize multiple such Digital Identifiers from multiple services, also referred to as identity providers and assigners, would also be consistent with the requirements of this IG. This section of the IG also describes Enterprise Identifiers which are the next best option when a Digital Identifier is unavailable or has not yet been established, as well as other Miscellaneous Identifiers.

**Note:** digital identities involved in healthcare transactions may correspond to Patients, Providers, Payers, and other healthcare actors.

&emsp;&emsp;  

### Requirements for Digital Identifiers

- Identifier **SHALL** be capable of a validation process. (To do: add details about the meaning of this. For example, if user profile data may be used validate the identity of an authenticated user)

- A documented identity proofing process at a minimum **SHALL** establish that a unique individual is represented by each Identifier and includes a declaration of identity assertion (such that it is fraudulent to claim a false identity). To do: clarify language regarding Digital Identifier being 1:1 with unique person on assigner's system; how to handle name changes in this case.

- Identifier **SHALL** be unique for all time within the assigner’s system.

- Identifier **SHALL NOT** be reassigned to a different individual and patient onboarding process requires that patient assert that any attributes they provide uniquely represent them. (To do: more speific details about what this means for certain types of attributes such as phone number, address, email.)

- Identifier **SHOULD** be 'FHIR-ready'. The identifier can be associated with an OpenID Connect credential that is capable of OAuth 2.0 authentication via UDAP Tiered OAuth; assigners which manage patient health records **SHALL** recognize such an Identifier when associated with a patient in their system as a Patient.identifier resource element and respond to queries that use this Identifier as a search parameter or in a match request.

&emsp;&emsp;  

### Digital Identifier Workflow Example

&emsp;&emsp;  
&emsp;&emsp;  
### Requirements for Enterprise Identifiers

Locally established business identifiers used in cross-organizational matching MUST correspond to unique identities in the real world (TBD? WAS: will have minimum metadata and verification constraints and is designed for cross-walking between the many systems necessary for successful patient matching in health information exchange). NOTE that these are examples of what we have in place today that can be used for matching and may not meet all the requirements we’d like to have of a Digital Identifier as defined in this IG.

Requirements:

Unique for the individual person (i.e. not the same identifier for entire family) within organizational boundaries of the exchange partner 

“assigner” plus “identifier”/ (number) is not reusable for a different person

Can be stored as an identifier along with its assigner in FHIR Patient resource and therefore used in $match operations or other transactions (To do: provide examples of how to represent in other HL7 modalities?)

IDs with date issued, expiration date, or validity periods will contain this metadata when available.

&emsp;&emsp;  

### Enterprise Identifier Workflow Example

Patient provides their identifier(s) to a healthcare organization at registration and/or check-in, and the identifier(s) is/are then associated with the patient’s record. As an alternative to such an in-person binding to the record, patient rosters could be shared that describe how to associate each patient medical record number and insurance identifier pairing, for example, to manage identities at scale.

&emsp;&emsp;  

### Miscellaneous Established Identifiers

Absent a Digital Identifier or Enterprise Identifier as described above, other good identifiers are of particularly good use in best practice person matching, for example:

- Social Security Numbers/Last 4

- Driver's License Numbers

- Military ID Numbers

- Passport Numbers

- Individual National Provider Identifier

&emsp;&emsp;  

### Miscellaneous Identifier Workflow Example



{% include link-list.md %}