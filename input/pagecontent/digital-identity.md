### Overview

Digital Identity is the unique representation of a subject engaged in an online transaction. A digital identity **SHALL** always be unique in the context of a digital service that is compliant with this IG, but does not necessarily need to uniquely identify the subject in all contexts. Specifically, such a digital service **SHALL NOT** require that the subject’s real-life identity is evident from the credential identifier on its own. 

In an effort to address matching errors by prioritizing the use of Digital Identifiers, this section of the IG defines what are likely to be new Digital Identifiers suitable for use in person matching where high confidence in the Digital Identity associated with such an Identifier is needed. Though there can be usability benefits in having just one such credential, an individual's choice to utilize multiple such Digital Identifiers each from a different service, also referred to an Identity provider or Assigner, would also be consistent with the requirements of this IG. This section of the IG also describes Enterprise Identifiers which are the next best option when a Digital Identifier is unavailable or has not yet been established, as well as other Miscellaneous Identifiers.

**Note:** digital identities involved in healthcare transactions may correspond to Patients, Providers, Payers, and other healthcare actors.

### Requirements for Digital Identifiers 

- Identifier **SHALL** be capable of a validation process. Acceptable validation methods include 1) the user authenticates themselves at a level of authentication assurance commensurate with that of the credential itself and the credential is confirmed to originate from a trusted Identity Provider (authentication assurance **SHALL** be AAL2 or greater for any [identity assurance level](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) greater than IAL1; 2) relying party queries the Identity Provider's system to confirm demographics associated with the individual in a privacy preserving way, for example by presenting a cryptographic hash of first, last, date of birth and home address along with the Identifier. Acceptable verification methods include: 1) the profile photo associated with an OpenID Credential bound to the Identifier is consistent with this Implementation Guide and NIST requirements on use of biometrics and is a visual match to the individual or to a government-issued photo ID previously associated with the individual during a documented identity verification event and saved in their record.

- A documented identity proofing process at a minimum **SHALL** establish that a unique individual is represented by each Identifier and includes a declaration of identity assertion (such that it is fraudulent to claim a false identity). Each Digital Identifier **SHALL** correspond 1:1 with a unique person on the Identity Provider's (assigner's) system. 

- Identifier **SHALL** be unique for all time within the assigner’s system. More than one Identifier cannot be generated within the assigner's system for the same individual, as that would lead to mismatches on patient identity and potential patient safety issues. 

- Identifier **SHALL NOT** ever be reassigned to a different individual except in the case of name changes. The associated patient onboarding process **SHALL** require the patient to assert that any attributes they provide correspond to their own identity. Legal names **SHALL** be used and the use of work addresses or phone numbers not belonging to the individual **SHOULD** be discouraged. The email address and mobile number provided **SHALL** be under the individual's exclusive control if used to secure the Identifier or an associated credential.

- Identifier **SHOULD** be 'FHIR-ready'. The identifier can be associated with an OpenID Connect credential that is capable of OAuth 2.0 authentication via UDAP Tiered OAuth; assigners which manage patient health records **SHALL** recognize such an Identifiers when associated with a patient in their system as a Patient.identifier resource element and respond to queries that use this Identifier as a search parameter or in a match request. For example, the Identifier **SHOULD** appear in OpenID Connect identity claims made to trusted healthcare relying parties and is different from the OpenID Connect subject identifier, for example:

```json
{
   ...
   "iss":"https://generalhospital.example.com/as",
   "sub":"328473298643",
   "identifier":"123e4567-e89b-12d3-a456-426614174000a",
   "amr":"http://udap.org/code/auth/aal2",
   "acr":"http://udap.org/code/id/ial2",
   "picture":"https://generalhospital.example.com/fhir/Patient?identifier=https://generalhospital.example.com/issuer1|123e4567-e89b-12d3-a456-426614174000a"
}
```

- The combination of Identifier plus Assigner cannot be reassigned for an individual; therefore the Identifier **SHALL** be protected like a Social Security Number and **SHALL NOT** be shared other than for patient matching purposes in a healthcare setting. The Identifier itself **SHALL NOT** be used as an OpenID Connect identifier and one **MAY NOT** be programmatically derived from the other since the OpenID Connect identifier may need to be re-issued from time to time and individuals may want to use their OpenID Connect credential to authenticate themselves in other settings. Identity Providers **SHALL NOT** enable an individual to authorize sharing of the Identifier with an endpoint that is not a trusted healthcare organziation. For Identifiers assigned at any identity assurance level greater than IAL1, Identity Providers which establish a mechanism for proof of control of the credential **SHALL** associate with the Identifier an [authenticator meeting NIST AAL2 or higher authentication assurance](https://pages.nist.gov/800-63-3/sp800-63b.html) and that can be reset, in lieu of or in addition to the OpenID Connect credential.   

- The Identifier and any associated credentials **SHALL** be managed in alignment with [NIST 800-63-3 Digital Identity Guidelines](https://pages.nist.gov/800-63-3/) except as specified otherwise in this IG.

&emsp;&emsp;  

### Digital Identifier Workflow Example

Patient completes an [IAL 1.6](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) or greater identity verification process with a healthcare organization at registration and/or check-in, and the resultant Digital Identifier is then associated with the patient’s record in that organization's EHR. The process includes collection and verification of (at a minimum, verification of control) a personal mobile number and email address belonging to the patient. The Identity Provider binds the Digital Identifier to an OpenID Connect credential with AAL2 authentication assurance. The patient subsequently authenticates to their insurance company's system using this credential, after which the insurance company uses the Digital Identifier in a match request to the healthcare organization. Because this strong assurance credential has been used to authenticate the individual to both systems, the healthcare organization can confidently share the correct patient data with the requesting party. 

### Requirements for Enterprise Identifiers

Locally established business identifiers used in cross-organizational matching SHALL correspond to unique identities in the real world (TBD? WAS: will have minimum metadata and verification constraints and is designed for cross-walking between the many systems necessary for successful patient matching in health information exchange). NOTE that these are examples of what we have in place today that can be used for matching and may not meet all the requirements we’d like to have of a Digital Identifier as defined in this IG.

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

### Miscellaneous Identifier Workflow Example



{% include link-list.md %}
