### Overview

This section provides guidance that goes beyond NIST 800-63A for its practical application in healthcare settings. The following example procedures can be used to achieve IAL2 and other identity assurance levels between IAL1 and IAL2 in typical healthcare workflows and considering the identity evidence generally available across all patient populations. The levels articulated below and the systems of Identity Providers following this guidance **SHALL** be consistent with NIST 800-63 except as specified otherwise. Specifically, IAL1.6 and IAL1.8 requirements are intended to be consistent with NIST 800-63A identity verification procedures for IAL2 identity assurance, however with different required identity evidence as indicated. 

### Best Practices for Identity Verification

The following intermediate identity assurance levels (IAL 1.2-1.8) are undergoing discussion in this group, though it should be noted that NIST has NOT endorsed these. (To do: we are in the process of inviting NIST representative(s) to a future meeting to collect their feedback).

To verify an individual’s identity at one of the levels below, the following information about the individual **SHALL** be collected:

- Full legal name
- home address
- date of birth
- email address
- phone number (a mobile number is required unless the individual does not have a mobile number)

The Identity Provider then validates this information using appropriate evidence from the list below, verifying any required evidence submitted, corresponding to the desired level of identity assurance:  

- **IAL1** requirements:  
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity

​       

- **IAL1.2** requirements: 
  - An unspecified ID was used to verify name and date of birth.
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  


​    

- **IAL1.4** requirements:
  - A US state-issued photo ID or nationally-issued photo ID was used to verify name and birth date.
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  


​    

- **IAL1.6** requirements: 

  - Gov’t issued photo ID confirmed by comparison to individual plus   

    ​    mail notice to address of record 

    ​	      **OR**

    ​    send equivalent notice via email address or phone number associated with the person in records 

  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  
  - Knowledge Based Verification (KBV) **SHALL NOT** be used as a substitute for the in-person or remote unsupervised match of the individual to the government issued photo ID and **MAY** only be used if necessary as an addition to a photo ID comparison process, when required to resolve to a unique identity


​    

IAL 1.6 identity verification is the lowest level of identity assurance that can be used to establish a unique identity that exists in the real world. It is expected to map to many existing systems’ procedures for generating a patient portal account for user access to data at a single health system. The absence of multiple pieces of identity evidence is mitigated by sending a notice of identity verification, including an email or telephone contact information for the Identity Provider, to the verified Address of Record, or to an email address or mobile number that had already been registered to the person in the Identity Provider’s system OR is billed to their name.  

- **IAL1.8** requirements: 

  2 Fair pieces of evidence--for example: 

  - Two of:  photo ID confirmed by comparison to individual; medical record; or insurance card 

    ​    **OR**

  - Gov't issued photo ID confirmed by comparison to individual + mobile number billed to the person; 
    
  
  Plus declaration of identity assertion by the individual indicating that submitted information represents their own identity(5)

In healthcare settings, additional demographics may also be collected and used in matching (for example, administrative gender and birth sex). Refer to the Patient Matching section for additional verification requirements on such attributes.  

An individual profile photo associated with an identity **SHALL** be confirmed during identity verification or during a subsequent, authenticated event to visually match the subject, to prevent errors in matching or identity resolution, e.g., as in 800-63 where the photo taken during a proofing event is confirmed as matching with the photo on the subject's identity evidence for IAL2 remote unsupervised etc. 

NOTE: The workgroup has considered whether it may be necessary to perform a Risk Analysis or have a similar discussion providing guidance on the Identity Level of Assurance that is appropriate for various use cases, for example a patient's access to their own data or to make a consent, covered entity access to health data for Treatment/Payment/Operations, verification of demographic attributes to flag as verified in the overall record/FHIR Patient resource or with Encounter context as is done in the SMART Health Cards spec.  

*To Do: Provide additional guidance on how to simplify procedures for identity verification at levels emphasized in this Implementation Guide; this may be as simple as adding example evidence lists that can be used in various levels, particularly IAL1.6-2.*

**References:**  
&nbsp;&nbsp;&nbsp;&nbsp;[UDAP Levels of Assurance](https://docs.google.com/document/d/1IEbVY4nWOP013P_oSZkLtV3uHlpjLRQT1lURDE9wTFs/edit)  
&nbsp;&nbsp;&nbsp;&nbsp;[NIST 800-63-3A](https://pages.nist.gov/800-63-3/sp800-63-3.html)  
&nbsp;&nbsp;&nbsp;&nbsp;[SMART candidate Code System for existing NIST levels plus IAL1.2 and IAL1.4](http://build.fhir.org/ig/dvci/vaccine-credential-ig/branches/main/CodeSystem-identity-assurance-level-code-system.html)  

​    

### Use of Knowledge-based verification (KBV)

From 800-63-3: 

- KBV **SHALL NOT** be used for in-person (physical or supervised remote) identity verification.

- KBV (sometimes referred to as knowledge-based authentication) has historically been used to verify a claimed identity by testing the knowledge of the applicant against information obtained from public databases. The CSP MAY use KBV to resolve to a unique, claimed identity.

- KBV can be used to verify one Fair piece of evidence

- NIST 800-63-3A contains additional restrictions on the use of KBV for identity verification at IAL2 in section 5.3.2 Knowledge-Based Verification Requirements. 

(5) See also: [Patient IAL2 as in TEFCA](https://www.healthit.gov/sites/default/files/page/2019-04/FINALTEFCAQTF41719508version.pdf) and [Kantara "IAL2 Light" proposal to NIST (1 STRONG or 3 FAIR)](https://github.com/usnistgov/800-63-4/files/6481076/IAL.1.Update.-.Kantara.comments.docx). 

{% include link-list.md %}
