Introduction

### Overview

This section provides guidance that goes beyond NIST 800-63A for its practical application in healthcare settings–for example, articulate example procedures to achieve IAL2 and other proofing levels between IAL1 and IAL2 that are typical in healthcare workflows and which consider the available identity evidence of all patient populations.
Potential references:

### Best Practices for Identity Verification

1.2 and 1.4 are in the VCI framework, but nobody has initiated. The granularity is in concept only, though there is an absolute need to better define between 1 and 2, we may frame this as a proposal, though do not give the impression that NIST has endorsed. Carmen to invite NIST to future meeting.
To verify an individual’s identity at one of the levels below, the following information about the individual is collected:

- Full legal name
- home address
- date of birth
- email
- phone number (mobile unless the individual does not have a mobile number?)

----

The identity provider then validates this information using appropriate evidence from the list below:  

- **IAL1** requirements:  
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity

​       

- **IAL1.2** requirements: 
  - An unspecified ID was used to verify name and birth date.
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  


​    

- **IAL1.4** requirements:
  - A US state-issued photo ID or nationally-issued photo ID was used to verify name and birth date.
  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  


​    

- **IAL1.6** requirements: 

  - Gov’t issued photo ID plus -  

    ​    mail notice to address of record 

    ​	      **OR**

    ​    send equivalent notice via email address or phone number associated with the person in records 

  - Declaration of identity assertion by the individual indicates that submitted information represents their own identity  


​    

This level of identity verification is intended to map to many existing systems’ procedures for generating a patient portal account for user access to data at a single health system. The absence of multiple pieces of identity evidence is mitigated by sending a notice of identity verification, including an email or telephone contact information for the Identity Provider, to the verified Address of Record, or to an email address or mobile number that had already been registered for the person in the Identity Provider’s system OR is billed to their name.  

- **IAL1.8** requirements: 

  2 Fairs--for example: 

  - Two of:  photo ID, medical record, or insurance card 

    ​    **OR**

  - Gov't issued photo ID + mobile number billed to the person; 
    Declaration of identity assertion by the individual(5)

In healthcare settings, additional demographics may also be collected and used in matching (for example, administrative gender and birth sex). Refer to the Patient Matching section for additional verification requirements on such attributes.  

NOTE: The workgroup has considered whether it may be necessary to perform a Risk Analysis or have a similar discussion providing guidance on the Identity Level of Assurance that is appropriate for various use cases, for example a patient's access to their own data or to make a consent, covered entity access to health data for Treatment/Payment/Operations, verification of demographic attributes to flag as verified in the overall record/FHIR Patient resource or with Encounter context as is done in the SMART Health Cards spec.  

Include process for verifying a photo for use in matching, e.g., as in 800-63 where photo taken during a proofing event is confirmed as matching with photo on identity evidence for IAL2 remote unsupervised etc. 

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

(5) See also: [Patient IAL2 as in TEFCA](https://oncprojectracking.healthit.gov/wiki/see%20additional%20details%20in%20section%206.2.4:%20https:/www.healthit.gov/sites/default/files/page/2019-04/FINALTEFCAQTF41719508version.pdf) and [Kantara "IAL2 Light" proposal to NIST (1 STRONG or 3 FAIR)](https://github.com/usnistgov/800-63-4/files/6481076/IAL.1.Update.-.Kantara.comments.docx). IAL1.6 and IAL1.8 requirements are intended to be consistent with NIST 800-63a practices for IAL2 identity assurance, however with different required identity evidence. Identity verification procedures should be the same.

{% include link-list.md %}