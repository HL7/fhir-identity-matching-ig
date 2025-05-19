### Overview

This section provides best practices to be used in addition to NIST 800-63-3 Digital Identity Guidelines for practical application in healthcare settings. These procedures can be used to achieve Identity Assurance Level 2 (IAL2) and other [identity assurance levels](glossary.html) between IAL1 and IAL2 in typical healthcare settings, considering the [identity evidence](glossary.html) generally available across patient populations and for others having a role in managing or exchanging health information and personally identifiable information.

The authors have been mindful of health equity considerations and have considered in the development of this guidance sensitive populations such as pediatric patients and persons experiencing housing insecurity. As a result, the guidance reflects an understanding of the prevalence of shared addresses (when shelters and last known hospitalization are used as a home street address) and other cases where identity evidence typically needed for IAL2 may not be available. 

### Best Practices for Identity Verification

Any system of an Identity Provider conforming to this IG **SHALL** also conform to the NIST 800-63-3 Digital Identity Guidelines except as adapted in this guide and **SHALL** publicly post their identity verification (and authentication, if authentication is offered) policy in a manner that is easily discoverable online, additionally referencing this IG if attesting to be compliant with it. Specifically, IDIAL1.6 and IDIAL1.8 requirements are intended to be consistent with NIST 800-63A identity verification procedures for IAL2 identity assurance, however, with different required identity evidence, data collection, and other procedural clarifications as indicated in the IG.

The identity verification policy **SHALL** describe the practices, consistent with this guide, used by employees or agents of Identity Provider's organization to verify and manage identities, along with whether and how those employees and agents may perform as Trusted Referees, and how personal information is managed by the Identity Provider. 

Identity Providers **SHALL** only rely on their trained employees to perform as Trusted Referees, consistent with their published identity verification policy.

Identity Providers **SHALL NOT** rely on third parties as Trusted Referees or Trusted Agents, to vouch for individuals, or to perform identity verification including on behalf of another person as is generally permitted under NIST 800-63-3 Digital Identity Guidelines. 

Additionally, the IG aims to align with NIST guidelines for using Mobile Driver's Licenses (mDLs) as a means for authentication and/or identity verification of individuals. Note that as of this time, it is known that the evidence strength of mDLs may vary from state to state.

Identity verification consistent with this IG is valid for 3 years, at which point identity verification **SHALL** be repeated.

Attaining a higher level of identity assurance than was performed in an initial identity verification event, also referred to as a "step up", **SHALL** entail repeating the identity verifiation process from the beginning according to the requirements of the higher level. 

NOTE: Although implementers, lacking more specific requirements that may exist in network participation agreements, likely want to perform their own risk analyses to determine the appropriate IAL for various use cases (for example, a patient’s access to their own data or a HIPAA Covered Entity's access to health data for Treatment, Payment, or Operations), this IG provides example [use cases](use-cases.html) in which certain input match invariants, match input data, and IALs are deemed appropriate based on industry feedback received. The guide also specifically cites recommended IALs for professional users and administrators in section 3.2. The IALs defined below are not currently specified in a code system or value set within this implementation guide (IG). Additionally, the intermediate identity assurance levels (IDIAL1.2-IDIAL1.8) described below have NOT been endorsed by NIST in any capacity, though the team has briefed NIST on our approach, and we will likely collaborate with them in the future to profile NIST 800-63-4 for use in healthcare settings. 

>**Individual Identity Verification** 
>
>To verify an individual’s identity at one of the levels below, the Identity Provider  **SHALL** collect the following information from the individual: 
>- Full Legal Name (the name that the person was officially known by at the time of issuance of the supporting evidence; not permitted are pseudonyms, aliases, an initial for surname, or initials for both First and Last names unless the actual First and/or Last name is in fact a single letter) 
>- Home Street Address (1) 
>- Date of Birth 
>- Email Address  
>- Mobile Number (preferred; if a mobile number is not available, collect an alternative number for the individual) 
>
>In some cases, data collected for identity verification cannot be verified in the typical ways. For example, persons experiencing homelessness may provide any temporary address such as a shelter, hospital, community resource center, or other location, or may provide any portion of an address that is known (e.g., zip code).
>Unless explicitly required otherwise at certain levels, at a minimum, control of the email address and mobile or alternative number **SHOULD** be verified at every level of assurance listed below through the use of an Enrollment Code as per [NIST SP 800-63A](https://pages.nist.gov/800-63-3/sp800-63a.html) section 4.6.
>NOTE: Implementers are encouraged to promote the availability of free mobile number services that support long term use, since these may facilitate [patient matching](glossary.html) and [credential](glossary.html) management; these services may be particularly helpful for those facing housing insecurity or who may be too young to have established credit bureau type records.
>
>The Identity Provider **SHALL** also verify the First Name, Last Name, Home Street Address, Date of Birth, and any other verifiable demographics which they will claim have been verified, using the required evidence listed below and corresponding to the desired level of identity assurance, and completing other required steps as follows:  
>
> **IAL1/IDIAL1** requirements:  
>  - Declaration of Identity attestation by the individual indicates that submitted information represents their own identity.
>      
> **IDIAL1.2** requirements: 
>  - Unspecified identity evidence was used to verify name and birth date.
>  - Declaration of Identity attestation by the individual indicates that submitted information represents their own identity.  
>    
> **IDIAL1.4** requirements:
>  - A US state-issued photo ID or nationally-issued photo ID was used to verify first name, last name, and date of birth.
>  - Declaration of Identity attestation by the individual indicates that submitted information represents their own identity.
>    
> **IDIAL1.5** requirements:
>  - Two of the following were used to verify first name, last name, date of birth, and home street address: 1) US state-issued photo ID, nationally-issued photo ID, or unique [Digital Identifier](digital-identity.html#requirements-for-digital-identifiers-for-individuals); 2) medical record number (and the medical record number issuer can verify that the number is consistent with other demographics submitted by the individual); or 3) insurance card (and information on card is consistent with other demographics submitted by the individual).
>  - If the claimed home street address cannot be verified using the presented two pieces of evidence, in conjunction with credit bureau type records, then at least one of the following SHALL be performed: 
>      - Verify that Fair or stronger evidence confirms the individual's ownership of an email address. 
>      - Verify that Fair or stronger evidence confirms the individual's ownership of a mobile or alternative number.
>      - Verify an Individual Profile Photo previously associated with the claimed identity.
>  -  Verify the individual's control of either a mobile or alternative phone number or an email address that the individual claims to be associated with their identity.  
>  -  Declaration of Identity attestation by the individual indicates that all submitted information including first name, last name, date of birth, and home street address represents their own identity.
>
>> IDIAL1.5 identity verification is the lowest level of identity assurance that can establish a unique human identity that exists in the real world. IDIAL1.5 is expected to map to many existing systems’ procedures for enabling patient electronic access to data at a single health system (2). Although this level of identity verification may be relevant to prevent duplicates in medical record systems and has a role in verifying demographic information used in patient matching between HIPAA Covered Entities, the lack of in-person or virtual match of an individual to a photo on identity evidence at this level or lower, or of their control of an authenticator associated with evidence or Digital Identity, generally does not provide high confidence in the identity of the individual.
>
> ​**IDIAL1.6** requirements: 
>  - US state- or nationally-issued photo ID confirmed by comparison to individual   
>  - Declaration of Identity attestation by the individual indicates that all submitted information including first name, last name, date of birth, and home street address represents their own identity   
>  - Verify the individual's physical residential Address of Record 
>  - Send a notification of identity verification, including an email or telephone contact information for the Identity Provider, by postal mail to the verified Address of Record, or to an email address or mobile or alternative number that had already been registered to the person in the Identity Provider’s system OR that appears on a utility bill in their name that is additionally submitted as identity evidence and is consistent with other evidence. The absence of multiple pieces of identity evidence in IDIAL1.6 is deemed acceptable given that there is some nominal fraud protection introduced by requiring this notification.
>    
> **IDIAL1.8** requirements: 
>  - Two Fair or stronger pieces of evidence were used to verify first name, last name, date of birth, and home street address--for example: 
>      - Two of:  1) US state-issued driver's license or other Fair or stronger photo ID confirmed by comparison to individual and consistent with other demographics submitted by the individual; 2) medical record number (and the medical record number issuer can verify that the number is consistent with other demographics submitted by the individual); or 3) insurance card (and information on card is consistent with other demographics submitted by the individual) OR 
>      - US state- or nationally-issued photo ID confirmed by comparison to individual plus mobile number billed to the individual 
>  - Declaration of Identity attestation by the individual indicates that all submitted information including first name, last name, date of birth, and home street address represents their own identity. 
>  - Verify the individual's physical residential Address of Record 
>  - Notification, including an email or telephone contact information for the Identity Provider, is either sent by postal mail to the verified Address of Record or sent via SMS to the mobile number verified as billed to the individual by name.
>
> **IAL2/IDIAL2** requirements: 
>  - One Strong plus two Fair or stronger pieces of evidence (for example: State driver's license confirmed by comparison to individual, a Fair or stronger photo ID confirmed by comparison to individual, and one other piece of Fair or stronger evidence verified) OR one Superior/Very Strong piece of evidence (for example: Government-issued passport, REAL ID, Enhanced ID, or US Military ID); this photo ID is confirmed by comparison to the individual.  
>  - Declaration of Identity attestation by the individual indicates that all submitted information including first name, last name, date of birth, and home street address represents their own identity. 
>  - Verify the individual's physical residential Address of Record. 
>  - Notification, including an email or telephone contact information for the Identity Provider, is either sent by postal mail to the verified Address of Record or sent via SMS to the mobile number verified as billed to the individual by name.
>
> **Additional Examples of Strong Evidence:**
>1. US State- or territory-issued regular (not REAL ID or Enhanced ID) driver's license or ID card including a photograph
>   
> **Additional Examples of Fair Evidence:**
>
>1. Other ID card including a photograph and issued by a federal, state, or local government agency or entity
>2. A copy of a utility bill (gas, electric, water, cable TV, or internet, etc.) indicating the individual's name and home address
>3. A mobile phone number billed to individual (a copy of the bill is one way to verify this)
>4. An individual National Provider Identifier (NPI) in individual's name (if they are a provider)
>5. A bank or credit card statement from a US-based financial institution indicating the individual's name and home address
>6. A state medical license (if they are a provider)
>7. Original or certified copy of birth certificate
>8. US Social Security Card
>
>In healthcare settings, additional demographics may also be collected and used in matching (for example, ethnicity, administrative gender, and sex assigned at birth). Refer to the Patient Matching section for any additional verification steps or assertions that may be required before including such attributes in a match request, or using them to process such a request on the responder's side.  

### Individual Profile Photo

An Individual Profile Photo associated with an identity **SHALL** be verified during identity verification or a subsequent, authenticated event that confirms the match between the photo and the individual, i.e., as in 800-63 where the photo taken during a proofing event is confirmed as matching with the photo on the individual's identity evidence for IAL2/IDIAL2 remote unsupervised or is confirmed to match the individual when identity verification is performed in person. The photo can be used to prevent errors in matching or in identity resolution. 

### Use of Social Security Number (SSN)

Social Security Number (on its own without presenting the card itself) does not have a role as evidence in IALs beyond IDIAL1.5 except as may be needed for identity resolution above and beyond other required evidence.  

### Use of Knowledge-Based Verification (KBV)

Knowledge-Based Verification (KBV) is a process that involves questions related to financial transactions tied to a Social Security Number (SSN). KBV **SHALL NOT** be used as a substitute for the in-person or remote unsupervised match of the individual to the government issued photo ID at IDIAL1.6 or higher, and **SHALL** only be used as an addition to a photo ID comparison process, when required to resolve to a unique identity.

From 800-63: 

- KBV **SHALL NOT** be used for in-person (physical or supervised remote) identity verification. 
- KBV (sometimes referred to as knowledge-based authentication) has historically been used to verify a claimed identity by testing the knowledge of the applicant against information obtained from public databases. The [CSP](glossary.html) (referred to in this IG as an Identity Provider) MAY use KBV to resolve to a unique, claimed identity. 
- KBV can be used to verify one Fair piece of evidence 
- NIST 800-63A contains additional restrictions on the use of KBV for identity verification at IAL2/IDIAL2 in section 5.3.2 Knowledge-Based Verification Requirements.

### Authorized Representatives

There are two primary actors that engage in the process of requesting health data from an external source:

- Patient – the subject of the data query being sent in a match request
- User – The individual who is being authenticated to initiate a match request

The Patient and the User may not be the same individual in a transaction. An individual who has been authorized to access another individual's health data is called an Authorized Representative. Instances where an Authorized Representative is present include, but are not limited to:

- B2C Proxy User – An authorized representative is allowed to access a patient’s health record (e.g. a parent accessing their child’s records in a special case of [Patient-Directed B2C](use-cases.html#patient-directed-b2c-intrinsic-oauth-service)).
- See the [Use Cases](use-cases.html) tab for additional examples.

An authorized representative's identity **SHALL** be verified and sufficient demographics **SHALL** be collected if matching on the identity of the representative is to be performed, and at [IDIAL1.8](guidance-on-identity-assurance.html) or higher if the match on identity will, if confidence in authentication exists, ultimately authorize access to data. In all cases whether the representative is, if any local policies are also met, authorized to access data on behalf of a patient is outside the scope of this IG. The B2C workflow with credentials at the responding organization is already broadly used as per the <a href="http://hl7.org/fhir/smart-app-launch/history.html">HL7 SMART App Launch IG</a>.


### Organizational Identity

Organizational Identity is important for relying parties such as responders to use when considering the source of a data request (for example as explicitly included in a requester's signed assertion) in their authorization decision, or to know the identity of a FHIR server or identity service--especially for the purpose of audit logging. Organizational Identity, when relevant, is verified through an attestation by an individual, whose identity is also verified at a level of assurance commensurate with that of the credential desired, that they are an authorized representative of that unique legal organizational entity. The legal existence of the organization **SHALL** also be verified along with the organization's street address included in the individual's attestation, through government records or equivalent, as well as the control of any hostname or other electronic endpoint presence that will be asserted in a credential or otherwise bound to the organizational identity.

When a transaction includes a claim of Organizational Identity in a digital certificate used to sign a claim or within another assertion such as a token request, the following details **SHALL** be included:

- Verified Legal Name of Organization responsible for data in the aspect of the transaction they are performing
- State where Organization was verified
- Street Address verified for Organization (if information more granular than State is shared)
- Entity Type specified in an attestation by the organization’s representative (either HIPAA Covered Entity, Business Associate of a HIPAA Covered Entity, Healthcare Entity that agrees to protect patient information consistent with HIPAA but is not a Covered Entity or Business Associate, Public Health, Patient/Consumer, or Non-Declared)

When the Entity Type is a Covered Entity or Business Associate, the correct type **SHALL** be stated transparently in a transaction. Additionally, if a Covered Entity is participating in a transaction they **SHALL** obtain their own credentials and a Business Associate **SHALL NOT** use the credentials of a Covered Entity.

When the requirements above are also met, the individual identity verification of the organization's representative **SHALL** be used to establish the identity assurance level for the Organizational Identity.


**References:**  
&nbsp;&nbsp;&nbsp;&nbsp;[UDAP Levels of Assurance](https://www.udap.org/udap-identity-assurance-levels)  
&nbsp;&nbsp;&nbsp;&nbsp;[NIST 800-63A](https://pages.nist.gov/800-63-3/sp800-63-3.html)  
&nbsp;&nbsp;&nbsp;&nbsp;[SMART candidate Code System for existing NIST levels plus IDIAL1.2 and IDIAL1.4](http://hl7.org/fhir/uv/shc-vaccination/2021Sep/ValueSet-identity-assurance-level.html)  

(1) This IG provides a number of alternatives to Home Address verification since it may be difficult to verify or to match on the home address of a youth or of a person who is experiencing housing insecurity. This can also be an issue for multi-family dwellings when a unit number is not specified or cannot be verified. 
(2) [Patient Records Electronic Access Playbook](https://www.ama-assn.org/system/files/2020-02/patient-records-playbook.pdf), [Patient IAL2 as in TEFCA](https://www.healthit.gov/sites/default/files/page/2019-04/FINALTEFCAQTF41719508version.pdf) and [Kantara "IAL2 Light" proposal to NIST (1 STRONG or 3 FAIR)](https://github.com/usnistgov/800-63-4/files/6481076/IAL.1.Update.-.Kantara.comments.docx). 

{% include link-list.md %}
