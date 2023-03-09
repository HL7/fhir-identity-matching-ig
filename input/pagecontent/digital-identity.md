### Overview

Digital Identity is the unique representation of a subject engaged in an online transaction. Digital identities involved in healthcare transactions can correspond to Patients, Providers, Payers, and other healthcare actors. The combination of a legal, distinct, verified organization name and the state in which it is verified uniquely identifies an organization. A digital identity **SHALL** always be unique in the context of a digital service that is compliant with this IG, but does not necessarily need to uniquely identify the subject in all contexts. Specifically, such a digital service **SHALL NOT** require that a human subject’s real-life identity is evident from the credential identifier on its own. 

In an effort to address matching errors by prioritizing the use of Digital Identifiers, this section of the IG defines what are likely to be new Digital Identifiers suitable for use in person matching where high confidence in the Digital Identity associated with such an Identifier is needed. Though there can be usability benefits in having just one such credential, an individual's choice to utilize multiple such Digital Identifiers each from a different service, also referred to an Identity provider or Assigner, would also be consistent with the requirements of this IG. This section of the IG also describes Enterprise Identifiers which are the next best option when a Digital Identifier is unavailable or has not yet been established. In this context "Enterprise Identifiers" are identifiers issued by assigners who have not implemented the stricter requirements necessary for Digital Identifiers. For example, a clinic that leverages insurance member IDs for identifiers and therefore requires additional demographics to be provided during a match request to the insurance company because the identifier is not 1:1 with a unique identity.

&emsp;&emsp;  

### Requirements for Digital Identifiers for Individuals 

- Identifier **SHALL** be capable of a validation process. Acceptable validation methods include 1) the user authenticates themselves at a level of authentication assurance commensurate with that of the credential itself and the credential is confirmed to originate from a trusted Identity Provider -- authentication assurance **SHALL** be AAL2 or greater for any [identity assurance level](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) greater than IAL1; 2) relying party queries the Identity Provider's system to confirm demographics associated with the individual in a privacy preserving way, for example by presenting a cryptographic hash of first, last, date of birth and home street address including zip or city and state along with the Identifier; or 3) authenticated individual authorizes sharing of demographics with the relying party. Acceptable verification methods include: 1) Identifier matches an Identifier previously associated to the medical record; 2) the Individual Profile Photo associated with an OpenID Connect Credential bound to the Identifier is consistent with this Implementation Guide and NIST 800-63A requirements on the use of biometrics and is a visual match to the individual or to a government-issued photo ID previously associated with the individual during a documented Identity Proofing event and saved in their record.

- A documented Identity Proofing process, performed by the Identity Provider directly and not through a Trusted Agent, at a minimum **SHALL** establish that a unique individual is represented by each Identifier and includes a declaration of identity assertion by the individual (such that it is fraudulent to claim a false identity). This requires the Identity Provider to follow a process that is IAL1.5 or higher according to this [guidance](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html). As future guidance may require an indication of individual attribute verification status, for example, a flag indicating whether an address was verified, and the verification date, Identity Providers **SHOULD** capture sufficient detail in their Identity Proofing records that their systems can differentiate between verified and unverified identity attributes. 

- Identifier **SHALL** be a globally unique UUID and unique for all time within the assigner’s system. 

- Each Digital Identifier **SHALL** correspond 1:1 with a unique person on the Identity Provider's (assigner's) system: more than one Identifier **SHALL NOT** be generated within the assigner's system for the same individual, as that would lead to mismatches on individual identity and potential patient safety issues. In-person processes and remote equivalents exist for binding a strong credential to a Person record. As one example, a digital credential from a third-party Identity Provider can be associated with a record when IAL2-verified Full Name, Home Address, and Date of Birth exist in both places and can be matched within the record and a Declaration of Identity was made to both the Identity Provider and the managing organization responsible for the Person record. In the case of a professional credential associated with an organization, the individual also asserted their legal authority to act as a representative of that organization and the existence and uniqueness of the organization was verified by the Identity Provider at the same or a greater level of identity assurance. At a minimum, the organization name and state of existence are recorded and may be included with other verified demographics about the individual.

- Identifier **SHALL NOT** ever be reassigned to a different individual except in the case of name changes. 

- The associated individual onboarding process **SHALL** require the individual to assert that any attributes they provide correspond to their own identity. Legal names **SHALL** be used and the use of work addresses or phone numbers or other attributes not belonging to the individual **SHOULD** be discouraged. 

- The email address and mobile number provided **SHALL** be under the individual's exclusive control if used to secure the Identifier or an associated credential.

- Identifier **SHOULD** be 'FHIR-ready': The Identifier can be associated with an OpenID Connect credential that is capable of OAuth 2.0 authentication via [UDAP Consumer-Facing](https://build.fhir.org/ig/HL7/fhir-udap-security-ig/branches/main/consumer.html) or [UDAP Tiered OAuth for User Authentication](https://build.fhir.org/ig/HL7/fhir-udap-security-ig/branches/main/user.html) with UDAP JWT-Based Authentication, asserted in a [UDAP Business-to-Business](https://build.fhir.org/ig/HL7/fhir-udap-security-ig/branches/main/b2b.html) transaction within an Authorization Extension Object, or shared in another trusted context. Assigners which manage patient health records **SHALL** associate a patient with their Identifier using Patient.identifier where Identifier.system = `"http://hl7.org/fhir/us/identity-matching/ns/HL7Identifier"`, corresonding to the [Identity-HL7-Identifier naming system](NamingSystem-Identity-HL7-Identifier.html), to establish these identifiers within their own systems. The match responder **SHALL** return the appropriate matching patient when a query from a trusted party includes an Identifier as a search parameter or in a match request. When it exists, the Identifier **SHOULD** appear in OpenID Connect identity claims made to trusted healthcare relying parties; note however that the Identifier defined in this Implementation Guide is distinct from the OpenID Connect subject identifier, as the following example demonstrates:

```json
{
   ...
   "iss":"https://generalhospital.example.com/as",
   "sub":"328473298643",
   "hl7_identifier":"123e4567-e89b-12d3-a456-426614174000a",
   "amr":"http://udap.org/code/auth/aal2",
   "acr":"http://udap.org/code/id/ial2",
   "name": "Jane Doe",
   "given_name": "Jane",
   "family_name": "Doe",
   "birthdate": "1979-01-01",
   "address": {
     "street_address": "1234 Hollywood Blvd.",
     "locality": "Los Angeles",
     "region": "CA",
     "postal_code": "90210",
     "country": "US"},
   "phone_number": "+1 (555) 777-1234",
   "email": "janedoe@example.com",
   "picture":"https://generalhospital.example.com/fhir/Patient?identifier=https://generalhospital.example.com/issuer1|123e4567-e89b-12d3-a456-426614174000a"
}
```
Alternatively, the HL7 Identifier may be included as a FHIR Identifier in the Resource referenced by the fhirUser OIDC claim using the [Identity-HL7-Identifier](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/NamingSystem-Identity-HL7-Identifier.html).

- The combination of Identifier plus Assigner (if any) **SHALL NOT** be reassigned for an individual; therefore the Identifier **SHALL** be protected like a Social Security Number and **SHALL NOT** be shared other than for patient matching purposes in a healthcare setting. The Identifier itself **SHALL NOT** be used as an OpenID Connect identifier and **SHALL NOT** be programmatically derived or otherwise possible to deduce from the OpenID Connect identifier since the OpenID Connect identifier may need to be re-issued from time to time, and individuals may want to use their OpenID Connect credential to authenticate themselves in other settings in which they do not wish to share personally identifiable information. Identity Providers **SHALL NOT** enable an individual to authorize sharing of the Identifier with an endpoint that is not a trusted healthcare organziation. For Identifiers assigned at any identity assurance level greater than IAL1, Identity Providers which establish a mechanism for proof of control of the credential **SHALL** associate with the Identifier an [authenticator meeting NIST AAL2 or higher authentication assurance](https://pages.nist.gov/800-63-3/sp800-63b.html) and that can be reset, in lieu of or supplemental to the OpenID Connect 1.0 workflow.   

- The Identifier and any associated credentials **SHALL** be managed in alignment with [NIST 800-63A Digital Identity Guidelines](https://pages.nist.gov/800-63-3/) except as specified otherwise in this IG.

&emsp;&emsp;  

### Digital Identifier Workflow Example

Patient completes an [IAL 1.6](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) or greater identity verification process with a healthcare organization at registration and/or check-in, and the resultant Digital Identifier is then associated with the patient’s record in that organization's EHR. The process includes collection and verification of (at a minimum, verification of control) a personal mobile number and email address belonging to the patient. The Identity Provider binds the Digital Identifier to an OpenID Connect credential with AAL2 authentication assurance. The patient subsequently authenticates to their insurance company's system using this credential, after which the insurance company uses the Digital Identifier in a match request to the healthcare organization. Because this strong identity assurance credential has been used to authenticate the individual to both systems, and the patient authorizes sharing of PII from the Identity Provider to the healthcare organization for identity resolution, the healthcare organization can confidently share the correct patient data with the requesting party. If needed, the health system can contact the account holder out of band for additional information or can request real-time identity verification. 


&emsp;&emsp; 

### Requirements for Enterprise Identifiers

Locally-established business identifiers used in cross-organizational matching, including temporary identifiers, SHALL correspond to unique identities in the real world. In other words, business identifiers used in cross-organizational matching **SHALL NOT** be reassigned to a different person in the future, nor did they correspond to a different person at any time in the past. NOTE that these are examples of what we have in place today that can be used for matching and may not meet all the requirements required of a Digital Identifier as defined in this Implementation Guide.

Requirements:

Unique for the individual person (i.e. not the same identifier for entire family) within organizational boundaries of the exchange partner 

“assigner” plus “identifier”/ (number) is not reusable for a different person

Can be stored as an identifier along with its assigner in FHIR Patient resource and therefore used in $match operations or other transactions 

Identifiers with date issued, expiration date, or other validity period will contain this metadata when available.

Assigners **SHOULD** avoid the letters I and O in identifiers, as they are difficult to differentiate from 1 and 0.

&emsp;&emsp;  

### Enterprise Identifier Workflow Example

Patient provides their identifier(s) to a healthcare organization at registration and/or check-in, and the identifier(s) is/are then associated with the patient’s record. As an alternative to such an in-person binding to the record, patient rosters could be shared that describe how to associate each patient medical record number and insurance identifier pairing, for example, to manage identities at scale.

&emsp;&emsp;  

### Miscellaneous Established Identifiers

Absent a Digital Identifier or Enterprise Identifier as described above, other good identifiers are particularly helpful in best practice person matching, for example:

- Social Security Numbers/Last 4

- Driver's License Numbers

- Military ID Numbers

- Passport Numbers

- Individual National Provider Identifier

&emsp;&emsp;  

### Miscellaneous Identifier Workflow Example

As these Miscellaneous Identifiers are increasingly collected, they are useful on their own or along with Enterprise Identifiers in improving probabilistic [Patient Matching](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/patient-matching.html) as described elsewhere in this Implementation Guide. 

{% include link-list.md %}
