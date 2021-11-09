Introduction

### Overview

This section of the guide extends the existing HL7 FHIR patient $match for cross-organizational use by authorized, trusted parties. 
NOTE: As security is generally out of scope for this guide, the conditions required to authorize an individual’s, including the patient’s own, access to the results of a match request are not specified in this guide, nor should they be inferred. 
Except where its recommendations involve $match-specific parameters, the guidance is intended to also apply to other patient matching workflows. Realizing that a better-formed match request produces the most reliable results, this implementation guide also includes a Guidance on Identity Assurance section which is a prerequisite to this best practice patient matching. 


### Match Requirements

*Questions:*

*Introduce the fact that we include best practices both for match requestor and responder*
*What variations in $match implementations exist in the wild, to date?* 

When transmitting identity attributes in a match request about individuals to authorized third parties--such as: 

- from an OpenID UserInfo endpoint or in another user information request, 
- within a UDAP assertion object, or 
- as part of a patient match or patient search request,

Each included identity attribute either must have been verified at the identity level of assurance asserted by the transmitting party (for example, the match requestor) or must be consistent with other evidence used in identity verification. If a level of assurance is not explicitly asserted, at a minimum, 
1. The combination of identity attributes submitted is consistent with and sufficient to identify a unique identity (for example, first, last, DOB and home street address OR first, last, and an Identifier that is compliant with this Implementation Guide) and corresponds to a human person whose identity has been verified at IAL1.2 or greater in accordance with the practices of NIST 800-63a using Fair or stronger evidence and/or credit bureau records (or equivalent). As a best practice, identity verification **SHOULD** be at a minimum of IAL2 or LoA-3 for the individual and for an implementer's overall operations. Otherwise, 
2. For Individual Access (or if PHI or PII will be returned, as a result of or subsequent to the match request, other than to a Covered Entity in a Treatment, Payment, or Operations workflow), a minimum of IAL1.8 or LoA-2 In Person end user identity verification is required and in that case, all identity attributes submitted for matching are verified either as part of, at minimum, an IAL1.8 or LoA-2 In Person identity verification event or are consistent with evidence presented during the event, before including those attributes in a match request.

Security best practices, including transaction authorization, are generally out of scope for this solution, however implementers also **SHALL NOT** allow patients to request a match directly. A trusted system may request a match on a patient’s behalf and use it to inform the patient, especially to: 

- Recognize that the patient already has an account (when a record represents an account)

- Recognize that a patient may have multiple identities within the system, leading to a fragmented medical record

- Recognize that a patient’s identity might have spurious records from other people mixed in

- Help remediate these situations without exposing PHI/PII

For sharing of immunization records only, patient matching **MAY** be performed using identity attributes verified at IAL1.2 or higher by requesting party and responder.

Propose approaches to matching, point to publicly shared resources, (Epic, etc.). Based on probability as much as possible, and not just on rules. 

#### Match on Identities

A responder performing a patient match **SHOULD** attempt to match identity attributes included by the requestor against the subset of responder's patient records which include only unique identities. 

*Question:*
*Does the requested count parameter mean # of patient identities or # of records?*
*Asking for at most 4 results to be returned in a match request may mean more than 4 actual Patient resources returned, if the responding system has not mapped one identity to one record. Two options:*

1) *In this case, only the requested number of identities should be returned and the requester can ask for all resources or some subset, as needed.* 
2) *All applicable records are returned; a different threshold on number of records returned could be considered instead.*
  *Note that a collection of records together can make them more valuable than one of the records may appear on its own.*
  *Use MatchGrade extension to help explain the entire story?*  

Additionally, for Individual Access requests or equivalent workflows, the match must be performed using the subset of patient records for which the patient’s identity has been verified by the responder at IAL1.8 or greater and patient attributes either directly reflect or are consistent with an identity verification event at that level or higher.

It is a best practice to include all known (required + optional) patient matching attributes in a match request (i.e. USCDI Patient Demographics); the table below indicates the minimum attributes required to obtain match results and their level of verification required in different use cases:

| **Required Minimum Included Attributes**                     | **Verification Required in B2B TPO  Workflow**               | **Verification Required in App-Mediated B2C  Workflow**      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ((First Name + Last Name) or DOB) + unique  enterprise identifier | LoA-2; onlyCertainMatches and count=1  required for patient care delivery, coverage determination, or  billing/operations | N/A; see below for specific IDs                              |
| First, Last, DOB, full (normalized as a best  practice) street address, administrative gender and birth sex | LoA-2; onlyCertainMatches and count=1  required for patient care delivery, coverage determination, or  billing/operations | Verifiable patient attributes within a match  request are consistent with IAL1.8 or greater identity verification  procedures performed for the patient |
| First, Last, Interoperable Digital Identity  Identifier      |                                                              | Identifier is established based on IAL1.8  requirements as above and First, Last are consistent with evidence |
| First, Last, Date of Birth, Current Address,  City, State    |                                                              | Consistent with the IAL1.8 or greater  identity verification event |
| First, Last, Date of Birth, Insurance Member  ID             |                                                              | Consistent with the IAL1.8 or greater  identity verification event |
| First, Last, DOB, (mobile number or email  address)          |                                                              | Consistent with the IAL1.8 or greater  identity verification event except mobile number control may be used for  verification if mobile number was not one of the two Fair pieces of evidence |

### Verification
It is helpful to know the date verification was performed, in the case of address and cell number since those attributes change.

Identity verification level to establish matching attributes is another potential metadata item.

When attributes like telephone number are verified as associated with a patient, 1) that information helps to bootstrap new account creation. *USPS API and Address Doctor*.

Indicate verification as an extension to provenance?

Probably too specific for IG to require minimum verification bar on attributes, on responding side and on requesting side although a grammar for expressing verification metadata seems useful

### Recommended Best Practices

Patient Match need not support wildcards, unlike the usual FHIR search mechanism.

Patient Match is not expected to enforce the minimum included attributes listed above. However, when a minimum combination of attributes is supplied, Patient Match **SHOULD** be able to find matching candidates if they exist. Under the hood, this is a requirement on the indexing capability for Patient Match to locate candidates before evaluating them. When something less than the minimum is supplied, Patient Match **MAY** return no candidates, even if matching candidates exist. 

- For example, a bare name might theoretically match no candidates or an overwhelming number of candidates. In this case, Patient Match may return no candidates, even if matching data exists. A simple phone number may or may not be enough for Patient Match to find candidates - that is left up to the implementation.

Patient Match **SHOULD** encourage entering more information. More information helps find the right candidate and disambiguate cases where there are several candidates. This implies that Patient Match is not simply a matter of finding a candidate that exactly matches all the given demographics. That approach tends to discourage entering more information because the user cannot know exactly which demographics will appear in the existing Identities. 

- For example, a user should not be reticent to enter an address because he is worried that the patient has moved and the search will fail to find the patient at the old address.

Patient Match **SHOULD** be in terms of groups of records that have been partitioned prior to the Patient Match call into Identities -- groups of records that are thought to represent people. 

- For example, a candidate Identity that has the right address in one record, the right name in another, and the right telephone in another could be a strong candidate, even though no single record contains all the given information. 

### Golden Records

The concept of matching Identities is best kept separate from the notion of a Golden Record. Many organizations use a Golden Record to capture all the correct and current information for a Patient while suppressing information that is thought to be out-of-date or incorrect. Often, such a Golden Record simply omits older inconsistent information such as an Address. While FHIR Patient can represent both current and old names, addresses and telecoms, its restriction on birthDate limits the representation to only one. A record partitioning system behind Patient Match may decide that two records with different birthDates represent the same person, but may not be able to know which of the birthDates is correct. Ideally, Patient Match would be able to find and appropriately evaluate such a candidate, regardless of which birthDate appears on the Golden Record.

- Matching and searching **SHOULD** be Identity-to-Identity, not Record-to-Record.

- Match output **SHOULD** contain every record of every candidate identity, subject to volume limits

- Linkage between records **SHOULD** be indicated by the Patient.link field
- Records **SHOULD** be ordered first by identity, then by score vs. the input
- Identities (sets of records) should be ordered by score vs. the input as per: "The response from an '"'mpi'"' query is a bundle containing patient records, ordered from most likely to least likely."  

If a match implementation supports creating a golden record to summarize the identity, match output should contain that record as well

- For example, it may have an opinion on the patient's current address and consolidate demographics that were distributed across records

A match implementation should enable Manual Stewardship of the partitioning based on identity

- This involves specifying not just the current state, but constraints on future states of the partitioning as records arrive or are updated

A match implementation should partition its records into identities in real time as they arrive. Doing so:

- Enables manual stewardship
- Improves the quality of matching 
- Improves the quality of searching
- Especially in regard to situations where only a single unambiguous match is desired via onlyCertainMatches

A match output should reveal a presence or lack of manual stewardship

- Currently this could be supported via extensions (add example?), but we might want to at least suggest inclusion in future versions of FHIR (add example?)
- The solution will need to consider how this works with a FHIR system that contains both records from many sources and perhaps golden records from the match implementation itself; i.e. are both types of matches accessible as Patient resources, or no?

### Scoring Matches
Scoring should be as probabilistic as possible

Common correlations such has families must be modeled (ONC recommendation reference?)

Scores should be computed, not guessed, whenever possible

### No Match Results

Recommended errors?

If no results are returned, the workflow may result in a new patient record being established [in certain use cases only?].

### Exception Handling

### Privacy Considerations

### Benchmarking

{% include link-list.md %}