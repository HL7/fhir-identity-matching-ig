**Authenticator Assurance Level (AAL)**:  A measure of the strength of an authentication mechanism and, therefore, the confidence in it, as defined in [NIST 800-63A](https://pages.nist.gov/800-63-3/sp800-63a.html) in terms of three levels: AAL1 (Some confidence), AAL2 (High confidence), AAL3 (Very high confidence). 

**Credential**: An object or data structure that authoritatively binds an identity, via an identifier or identifiers, and (optionally) additional attributes to at least one authenticator possessed and controlled by a cardholder or subscriber. 

Sources: NIST SP 800-63-3, NIST SP 1800-17c 

**Credential Service Provider (CSP)**: A trusted entity that issues or registers subscriber tokens and issues electronic credentials to subscribers. The CSP may encompass registration authorities (RAs) and verifiers that it operates. A CSP may be an independent third party or may issue credentials for its own use. 

Source(s): NIST SP 800-63-3 

**Digital Identity**: The term digital identity used in this guide refers to the technology and processes that support personal and business identities as they pertain to electronic health information. Digital health identity involves not just identifiers, but also components such as matching, identity vetting (also referred to as proofing or verification), authentication, authorization and access control, and other technologies and processes. The guide also defines specific minimum requirements for Digital Identifiers, representing a preferred subset of digital identities designed to improve person matching and appropriate access to health data, referred to as the HL7Identifier and found in [Requirements on Digital Identifiers for Individuals](digital-identity.html#requirements-for-digital-identifiers-for-individuals).

**Golden Record**: The golden record encompasses all the data in every system of record within a particular organization. A system of record is an information storage and retrieval system that serves as the authoritative source for a particular data element in a system containing multiple sources of the same element. 

NOTE: A Golden Record captures all the correct and current information for a Patient while suppressing information that is thought to be out-of-date or incorrect. Often, such a Golden Record simply omits older inconsistent information such as an address. 

**Identity Assurance Level (IAL)**: A category that conveys the degree of confidence that the applicant’s claimed identity is their real identity, more and more superseding LoA. 

**Knowledge Based Verification (KBV)**:  A process that involves questions related to financial transactions tied to a Social Security Number (SSN). KBV SHALL NOT be used as a substitute for the in-person or remote unsupervised match of the individual to the government issued photo ID at this level or higher and MAY only be used if necessary as an addition to a photo ID comparison process, when required to resolve to a unique identity. 

**Level of Assurance (LoA)**: Describes four levels of identity assurance (LoA1-4) and references NIST 800-63-2 technical standards and guidelines, which are developed for agencies to use in identifying the appropriate authentication technologies that meet their requirements. 

**Manual Stewardship**: Manual stewardship refers to the act or process of people contributing to the partitioning of records into identities/people. A matching system generally does the bulk of this partitioning, but humans may become involved especially when the automatic matching appears to be in error. These errors include both inappropriately merging records from different people into a single identity or by having records for a single person divided into more than one identity. 

**Medicare Beneficiary Identifier (MBI)**: An alphanumeric code assigned by the Centers for Medicare and Medicaid Services (CMS) to Medicare beneficiaries for purposes of identifying a covered individual for purposes of Medicare transactions like billing, eligibility status, and claim status. The MBI appears on a beneficiary identification card and replaces the Health Insurance Claim Numbers (HICNs), which included the beneficiary's Social Security Number. The MBI is a unique, randomly generated, non-intelligent 11-character code made up only of numbers and uppercase letters (no special characters). The MBI doesn’t use the letters S, L, O, I, B, and Z to avoid confusion between some letters and numbers (e.g., between “0” and “O”).  

**Patient Matching**: Patient matching helps address interoperability by determining whether records - both those held within a single facility and those in different healthcare organizations – correctly refer to a specific individual. Matching methods use demographic information, such as name and date of birth. 

**Patient Mediated**: Patient or their authorized representative authorizes access to their data by a third party when it is under patient’s management and not the data creator’s management (e.g., a consumer app enables the patient to manage their own data) 

**Strengths of Identity Evidence**: The quality requirements (UNACCEPTABLE, WEAK, FAIR, STRONG, and SUPERIOR) for identity evidence collected during identity proofing.  See the [Table 5-1 Strengths of Identity Evidence](https://pages.nist.gov/800-63-3/sp800-63a.html#63aSec5-Table1) 

**Trusted Referee**: A trained and approved or certified individual that can vouch for or act on behalf of an individual pursuing identity verification, in accordance with applicable laws, regulations, or agency policy, consistent with this term as used in [NIST 800-63A](https://pages.nist.gov/800-63-3/sp800-63a.html).

**Unified Data Access Profiles (UDAP)**: Published by [UDAP.org](https://www.UDAP.org) to increase confidence in open API transactions through the use of trusted identities and verified attributes. UDAP use cases support standards-based security, privacy, and scalable interoperability through reusable identities, leveraging Dynamic Client Registration, JWT-based client authentication and Tiered OAuth.  

**Verified Attributes**: The goal of identity verification is to confirm and establish a linkage between the claimed identity and the real-life existence of the subject presenting the evidence (Source: NIST 800-63-3 Digital Identity Guidelines). This [Guidance on Identity Assurance](guidance-on-identity-assurance.html) specifies identity verification requirements that are in some cases much lower, and in others higher, than NIST 800-63-3 Digital Identity Guidelines, hence the much lower values IDIAL1.2, IDIAL1.4, IDIAL1.5, and IDIAL1.6, and notably the resultant lower confidence in the linkage between a claimed identity and the real-life existence of that person. This IG also prioritizes the use of individual attributes (such as demographics) that have been verified at certain minimum levels of identity assurance. Verified attributes are confirmed either by viewing them on appropriate evidence presented, or confirming them with authoritative sources, according to the requirements of the identity assurance level sought, during an identity verification event that conforms with this IG. 


{% include link-list.md %} 
