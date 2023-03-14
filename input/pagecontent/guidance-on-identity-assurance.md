### Overview

This section provides guidance that goes beyond [NIST 800-63A](https://pages.nist.gov/800-63-3/sp800-63a.html) for its practical application in healthcare settings. The following example procedures can be used to achieve IAL2 and other [identity assurance levels](glossary.html) between IAL1 and IAL2 in typical healthcare workflows and considering the [identity evidence](glossary.html) generally available across all patient populations. With a desire to address this guidance in a way that is mindful of health equity considerations, the group has spent a substantial amount of time contemplating sensitive populations such as pediatric patients and persons experiencing housing insecurity, and this guidance therefore reflects an understanding of the prevalence of shared home addresses (when shelters and last known hospitalization are used for this) and other cases where identity evidence typically needed for IAL2 remote may not be available. The levels articulated below and the systems of Identity Providers following this guidance **SHALL** be consistent with NIST 800-63-3 Digital Identity Guidelines except as specified otherwise in this guide. Specifically, IAL1.6 and IAL1.8 requirements are intended to be consistent with NIST 800-63A identity verification procedures for IAL2 identity assurance, however with different required identity evidence and procedural clarifications as indicated. 

NOTE: The IALs defined below are not currently specified in a code system or value set within this IG.

### Best Practices for Identity Verification

The intermediate identity assurance levels (IAL1.2-1.8) described below have NOT been endorsed by NIST in any capacity, though feedback has been invited.

To verify an individual’s identity at one of the levels below, the following information about the individual **SHALL** be collected:
{:.bg-info}
- Full Legal Name (the name that the person was officially known by at the time of issuance of the supporting evidence; not permitted are pseudonyms, aliases, an initial for surname, or initials for both First and Last names unless the actual First and/or Last name is in fact a single letter)
- Home Address(1)
- Date of Birth
- Email Address 
- Mobile Number (preferred; if a mobile number is not available, collect an alternative number for the individual) 
{:.bg-info}
{:.bg-info}
In some cases, data collected for identity verification cannot be verified. For example, persons experiencing homelessness may provide any temporary address such as a shelter, hospital, community resource center, or other location, or may provide any portion of an address that is known (e.g., zip code). Unless explicitly required otherwise at certain levels, at a minimum control of the email address and mobile number **SHOULD** be verified at every [level of assurance](glossary.html) through the use of an Enrollment Code as per [NIST SP 800-63A](https://pages.nist.gov/800-63-3/sp800-63a.html) section 4.6. NOTE: Consider that there are free mobile number services available, since having one facilitates [patient matching](glossary.html) and [credential](glossary.html) management, for anyone although particularly helpful for those facing housing insecurity or who may be too young to have established credit bureau type records.
{:.bg-info}

The Identity Provider then validates this information using appropriate evidence from the list below, verifying any required evidence submitted, corresponding to the desired level of identity assurance and completing other required steps as follows:  
{:.bg-info}

- **IAL1** requirements:  
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity
{:.bg-info}

​       

- **IAL1.2** requirements: 
  - An unspecified ID was used to verify name and birth date.
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  

​    

- **IAL1.4** requirements:
  - A US state-issued photo ID or nationally-issued photo ID was used to verify name and birth date.
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  
{:.bg-info}

​    

- **IAL1.5** requirements:
  - Two of the following were used to verify name, birth date, and home address: 1) US state-issued photo ID, nationally-issued photo ID, or unique [Digital Identifier](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/digital-identity.html#requirements-for-digital-identifiers); 2) insurance card; 3) medical record
  - PLUS if claimed address cannot be verified using those two pieces of evidence along with credit bureau type records:
    ​    verify the individual's control of an email address **OR** Fair or stronger evidence confirms the email address belongs to the individual 
    ​	      **OR**
    ​    verify the individual's control of a mobile number **OR** Fair or stronger evidence confirms the mobile number belongs to the individual 
    ​	      **OR**
    ​    verify an Individual Profile Photo previously associated with the identity 
  - In cases when an individual is unable to verify either a mobile phone number or an email address, identity assurance does not meet IAL1.5.
  - Declaration of identity assertion by the individual indicates that all submitted information including name, birth date, and home address represents their own identity 

IAL1.5 identity verification is the lowest level of identity assurance that can be used to establish a unique identity that exists in the real world. It is expected to map to many existing systems’ procedures for enabling patient electronic access to data at a single health system.(2) Although this level of identity verification may be relevant to prevent duplicates in medical record systems, the lack of in person or virtual match of an individual to a photo in evidence or control of an authenticator associated with evidence generally does not provide high confidence in the identity of the individual.

​    

- **IAL1.6** requirements: 
  - Gov’t issued photo ID confirmed by comparison to individual PLUS mail notice to address of record or send equivalent notice via email address or phone number associated with the person in records 
  - Declaration of identity assertion by the individual indicates that all submitted information including name, birth date, and home address represents their own identity  
  - Verify the individual's physical residential Address of Record
  - The absence of multiple pieces of identity evidence in IAL1.6 is mitigated by sending a notice of identity verification, including an email or telephone contact information for the Identity Provider, to the verified Address of Record, or to an email address or mobile number that had already been registered to the person in the Identity Provider’s system OR is billed to their name
{:.bg-info}

​    

- **IAL1.8** requirements: 
  - 2 Fair or stronger pieces of evidence were used to verify name, birth date, and home address--for example: 
      - 2 of:  1) US state-issued driver's license or other Fair or stronger photo ID confirmed by comparison to individual; 2) medical record; or 3) insurance card OR
      - Gov't issued photo ID confirmed by comparison to individual + mobile number billed to the individual; 
  - Declaration of identity assertion by the individual indicates that all submitted information including name, birth date, and home address represents their own identity
  - Verify the individual's physical residential Address of Record
  - Notice, including an email or telephone contact information for the Identity Provider, is either mailed to the home Address of Record or sent via SMS to the mobile number verified as billed to the individual.

​    

- **IAL2** requirements: 

  - 1 Strong plus 2 Fair or stronger pieces of evidence (for example: State driver's license confirmed by comparison to individiual, a Fair or stronger photo ID confirmed by comparison to individual, and one other piece of Fair or stronger evidence verified) OR 1 Superior/Very Strong piece of evidence (for example: Gov't-issued passport, REAL ID, Enhanced ID, or US Military ID); this photo ID is confirmed by comparison to the individual 
  - Declaration of identity assertion by the individual indicates that all submitted information including name, birth date, and home address represents their own identity
  - Verify the individual's physical residential Address of Record
  - Notice, including an email or telephone contact information for the Identity Provider, is either mailed to the home Address of Record or sent via SMS to the mobile number verified as billed to the individual.
{:.bg-info}

​     

**Additional Examples of Strong Evidence:**
(1) US State- or territory-issued regular (not REAL ID or Enhanced ID) driver's license or ID card including a photograph

**Additional Examples of Fair Evidence:**
(1) Other ID card including a photograph and issued by a federal, state, or local government agency or entity
(2) A copy of a utility bill (gas, electric, water, cable TV or internet, etc.) indicating the individual's name and home address
(3) A mobile phone number billed to individual 
(4) An individual NPI in individual's name (if they are a provider)
(5) A bank or credit card statement from a US-based financial institution indicating the individual's name and home address
(6) A state medical license (if they are a provider)
(7) Original or certified copy of birth certificate
(8) US Social Security Card

In healthcare settings, additional demographics may also be collected and used in matching (for example, ethnicity, administrative gender and sex assigned at birth). Refer to the Patient Matching section for any additional verification steps or assertions that may be required before including such attributes in a match request, or using them to process such a request on the responder's side.  

**Organizational identity**, when relevant, is verified through an attestation by an individual, whose identity is also verified at a level of assurance commensurate with that of the credential desired, that they are an authorized representative of that unique legal organizational entity. The legal existence of the organization **SHALL** also be verified along with its street address that is asserted by the individual, through government records or equivalent, as well as the control of any hostname or other electronic endpoint presence that will be asserted in a credential or otherwise bound to the organizational identity. 

NOTE: Although implementers, lacking more specific requirements in network participation agreements, likely want to perform their own risk analysis to determine the appropriate Identity Assurance Level for various use cases, for example a patient’s access to their own data or covered entity access to health data for Treatment/Payment/Operations, this Implementation Guide provides example use cases in which certain input match invariant or identity assurance levels are deemed appropriate based on industry feedback received. The guide does also specifically cite recommended Identity Assurance Levels for professional users and administrators in section 4.2. 

### Individual Profile Photo

An Individual Profile Photo to be associated with an identity **SHALL** be verified during identity verification or a subsequent, authenticated event that confirms the match between the photo and the individual, i.e., as in 800-63 where the photo taken during a proofing event is confirmed as matching with the photo on the individual's identity evidence for IAL2 remote unsupervised or is confirmed to match the individual when identity verification is performed in person. The photo can be used to prevent errors in matching or in identity resolution.

### Use of Social Security Number (SSN)

Social Security Number (on its own without presenting the card itself) does not have a role as evidence in identity assurance levels beyond IAL1.5 except as may be needed for identity resolution above and beyond other requried evidence.  

### Use of Knowledge-Based Verification (KBV)

Knowledge-Based Verification (KBV) is a process that involves questions related to financial transactions tied to a Social Security Number (SSN). KBV **SHALL NOT** be used as a substitute for the in-person or remote unsupervised match of the individual to the government issued photo ID at IAL1.6 or higher, and **MAY** only be used if necessary as an addition to a photo ID comparison process, when required to resolve to a unique identity

From 800-63: 

- KBV **SHALL NOT** be used for in-person (physical or supervised remote) identity verification.

- KBV (sometimes referred to as knowledge-based authentication) has historically been used to verify a claimed identity by testing the knowledge of the applicant against information obtained from public databases. The CSP MAY use KBV to resolve to a unique, claimed identity.

- KBV can be used to verify one Fair piece of evidence

- NIST 800-63A contains additional restrictions on the use of KBV for identity verification at IAL2 in section 5.3.2 Knowledge-Based Verification Requirements. 



**References:**  
&nbsp;&nbsp;&nbsp;&nbsp;[UDAP Levels of Assurance](https://www.udap.org/udap-identity-assurance-levels)  
&nbsp;&nbsp;&nbsp;&nbsp;[NIST 800-63A](https://pages.nist.gov/800-63-3/sp800-63-3.html)  
&nbsp;&nbsp;&nbsp;&nbsp;[SMART candidate Code System for existing NIST levels plus IAL1.2 and IAL1.4](http://hl7.org/fhir/uv/shc-vaccination/2021Sep/ValueSet-identity-assurance-level.html)  

(1) This Implementation Guide provides a number of alternatives to Home Address since it may be difficult to verify or to match on the home address of a youth or of a person who is experiencing housing insecurity. This can also be an issue for multi-family dwellings when a unit number is not specified or cannot be verified.
(2) [Patient Records Electronic Access Playbook](https://www.ama-assn.org/system/files/2020-02/patient-records-playbook.pdf), [Patient IAL2 as in TEFCA](https://www.healthit.gov/sites/default/files/page/2019-04/FINALTEFCAQTF41719508version.pdf) and [Kantara "IAL2 Light" proposal to NIST (1 STRONG or 3 FAIR)](https://github.com/usnistgov/800-63-4/files/6481076/IAL.1.Update.-.Kantara.comments.docx). 

{% include link-list.md %}
