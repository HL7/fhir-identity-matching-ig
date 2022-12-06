### Glossary

**Patient Matching**: Patient matching help address interoperability by determining whether records - both those held within a single facility and those in different healthcare organizations – correctly refer to a specific individual. Matching methods use demographic information, such as name and date of birth.

**Digital Health Identity**: Digital health identity refers to the technology and processes that support personal identity as it pertains to electronic health information. Digital health identity includes not just identifiers, but also components such as matching, identity vetting (also referred to as proofing or verification), identity authentication, authorization and access control, as well as other technologies and processes.

**Manual Stewardship**: Manual stewardship refers to the act or process of people contributing to the partitioning of records into identities/people. A matching system generally does the bulk of this partitioning, but humans may become involved especially when the automatic matching appears to be in error. These errors include both inappropriately merging records from different people into a single identity or by having records for a single person divided into more than one identity.

Example: Suppose that a doctor at a clinic looks up a new patient in their regional HIE in order to get a more complete medical record and sees a surprising diagnosis. This could arise due to several possibilities: 1) the patient has a diagnosis that was unknown to the doctor, 2) the HIE has another patient’s record mixed into the identity of the patient of interest (an error in partitioning), 3) the clinician is simply looking at the wrong patient’s information. In all three cases, the patient’s care might be improved if the doctor reviews the set of records that constitute the identity. If the problem is the second case above, both the care of this patient and perhaps others might be improved if the doctor could contribute to how these records are partitioned.
 
While this document does not describe the form or process for such manual stewardship, it is suggested that the output of $match should support such contribution by providing the information on the records such that the doctor (or other authenticated user trusted with PII for specific people of interest) might spot the problem.

**Credential Service Provider (CSP)**: A trusted entity that issues or registers subscriber tokens and issues electronic credentials to subscribers. The CSP may encompass registration authorities (RAs) and verifiers that it operates. A CSP may be an independent third party, or may issue credentials for its own use.
Source(s): CNSSI 4009-2015

**Patient Mediated**: Patient authorizes access to their data by a third party when it is under patient’s management and not the data creator’s management (e.g. a consumer app enables the patient to manage their own data)

**Golden Record**: The golden record encompasses all the data in every system of record within a particular organization. A system of record is an information storage and retrieval system that serves as the authoritative source for a particular data element in a system containing multiple sources of the same element.

NOTE: Golden Record to capture all the correct and current information for a Patient while suppressing information that is thought to be out-of-date or incorrect. Often, such a Golden Record simply omits older inconsistent information such as an Address.

**Authenticator Assurance Level (AAL)**:  A measure of the strength of an authentication mechanism and, therefore, the confidence in it, as defined in [NIST SP 800-63-3] in terms of three levels: AAL1 (Some confidence), AAL2 (High confidence), AAL3 (Very high confidence).

**Identity Assurance Level (IAL)**: A category that conveys the degree of confidence that the applicant’s claimed identity is their real identity.

**IAL1**: Name and birth date were self-asserted.

**IAL1.2**: An unspecified ID was used to verify name and birth date.

**IAL1.4**: A US state-issued photo ID or nationally-issued photo ID was used to verify name and birth date.

**IAL1.6**:

**IAL2**: Either remote or in-person identity proofing is required. IAL2 requires identifying attributes to have been verified in person or remotely using, at a minimum, the procedures given in NIST Special Publication 800-63A.

**IAL3**: In-person identity proofing is required. Identifying attributes must be verified by an authorized CSP representative through examination of physical documentation as described in NIST Special Publication 800-63A.

**Knowledge Based Verification (KBV)**:  A process that involves questions related to financial transactions tied to a Social Security Number (SSN). KBV SHALL NOT be used as a substitute for the in-person or remote unsupervised match of the individual to the government issued photo ID at this level or higher, and MAY only be used if necessary as an addition to a photo ID comparison process, when required to resolve to a unique identity.

**Level of Assurance (LoA)**: Describes four levels of identity assurance (LoA1-4) and references NIST technical standards and guidelines, which are developed for agencies to use in identifying the appropriate authentication technologies that meet their requirements.

**LoA3**: requires Multi-Factor Authentication remote network authentication. At this level, identity proofing procedures require verification of identifying materials and information.

LoA3 authentication is based on Proof-of-Possession of a key or a One-Time password through a secure connection. 

LoA3 requires cryptographic strength mechanisms that protect the primary authentication token (secret Key, private Key or one-Time password) against compromise by the protocol threats including: eavesdropper, replay, on-line guessing, verifier impersonation and man-In-The-Middle attackers. A minimum of two Authentication Factors is required. Three kinds of tokens may be used: “soft” cryptographic tokens, “hard” cryptographic tokens and “one-time password” device tokens.

Authentication requires that the claimant prove through a secure authentication protocol that he or she controls the token, and must first unlock the token with a password or biometric data, or must also use a password in a secure authentication protocol, to establish two factor authentication. Long-term shared authentication secrets, if used, are never revealed to any party except the claimant and verifiers operated directly by the Credentials Service Provider (CSP), however session (temporary) shared secrets may be provided to independent verifiers by the CSP. Approved cryptographic techniques are used for all operations. Assertions issued about claimants as a result of a successful authentication are either cryptographically authenticated by relying parties, or are obtained directly from a trusted party via a secure authentication protocol.

LOA 3 is used to access restricted data.

**Medicare Beneficiary Identifier (MBI)**: An alphanumeric code assigned by CMS to Medicare beneficiaries for purposes of identifying a covered individual for purposes of Medicare transactions like billing, eligibility status, and claim status. The MBI appears on a beneficiary identification card, and replaces the Health Insurance Claim Numbers (HICNs), which included the beneficiary's Social Security Number. The MBI is a unique, randomly generated, non-intelligent 11-character code made up only of numbers and uppercase letters (no special characters). The MBI doesn’t use the letters S, L, O, I, B, and Z to avoid confusion between some letters and numbers (e.g., between “0” and “O”). 

**Strengths of Identity Evidence**: The quality requirements (UNACCEPTABLE, WEAK, FAIR, STRONG, and SUPERIOR) for identity evidence collected during identity proofing.  See the [Table 5-1 Strengths of Identity Evidence](https://pages.nist.gov/800-63-3/sp800-63a.html#63aSec5-Table1)

**Unified Data Access Profiles (UDAP)**: Published by [UDAP](UDAP.org) to increase confidence in open API transactions through the use of trusted identities and verified attributes. UDAP use cases support standards-based security, privacy and scalable interoperability through reusable identities, leveraging dynamic client registration,  JWT-based client authentication and Tiered OAuth. 

{% include link-list.md %}