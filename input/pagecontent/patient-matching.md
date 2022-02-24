### Overview

This section of the guide extends the existing HL7 FHIR patient [$match](https://www.hl7.org/fhir/patient-operation-match.html) for cross-organizational use by authorized, trusted parties.  

> **NOTE:** As security is generally out of scope for this guide, the conditions required to share personally identifiable information (PII) or to authorize an organization's or an individual’s, including the patient’s own, access to the results of a match request are not specified completely in this guide, nor should they be inferred.  However, patient-initiated workflows (for example, "patient requested" purpose of use) **SHALL** always include explicit end-user authorization.   

Except where its recommendations involve FHIR $match-specific parameters, the guidance is intended to also apply to other patient matching workflows including non-FHIR transactions. Realizing that a better-formed match request produces the most reliable results, this implementation guide also includes a Guidance on Identity Assurance section as a companion resource to this best practice patient matching. 

### Match Requirements

When transmitting identity attributes to third parties with whom that sharing of personally identifiable information (PII) is permitted, such as: 

- from an OpenID user profile or in another user information request to an Identity Provider, 
- within a UDAP assertion object, or 
- as part of a match or search request,

and a level of identity assurance is indicated, each included identity attribute **SHALL** either have been verified at the identity level of assurance asserted by the transmitting party (for example, the match requestor) or be consistent with other evidence used in that identity verification process completed by that party. If a level of assurance is not explicitly asserted, at a minimum, the combination of identity attributes submitted **SHOULD** be consistent with, and sufficient to on their own identify, the identity of a unique person in the real world (for example, a first name, last name, DOB and home street address have been verified as belonging to the individual OR a first name, last name, and a Digital Identifier that is compliant with this Implementation Guide have been verified as belonging to the individual), consistent with the practices of NIST 800-63 using Fair or stronger evidence and/or credit bureau type records (or equivalent), and consistent with this IG's [Guidance on Identity Assurance](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html). 

As a best practice, identity verification **SHOULD** be at a minimum of IAL2 or LoA-3 for end users of health IT systems and for an implementer's overall operations. 

Individual Access (or if PHI or PII will be returned, other than to a Covered Entity in a Treatment, Payment, or Operations workflow), is outside the scope of this IG's Patient Matching requirements. Instead, responders to such queries **SHALL** authenticate the Individual before returning PHI or PII.

Security best practices, including transaction authorization, are generally out of scope for this Implementation Guide, however implementers also **SHALL NOT** allow patients to request a match directly. A trusted system may request a match on a patient’s behalf and use it to inform the patient, especially to: 

- Recognize that the patient already has an account (when a record represents an account)

- Recognize that a patient may have multiple identities within the system, leading to a fragmented medical record

- Recognize that a patient’s identity might have spurious records from other people mixed in

- Help remediate these situations without exposing PHI/PII

For sharing of immunization records only, patient matching **MAY** be performed using identity attributes verified at IAL1.2 or higher by both requesting party and responder.

#### Match on Identities

A responder performing a patient match **SHOULD** attempt to match identity attributes included by the requestor against the subset of responder's patient records which include only unique identities. 

Asking for at most 4 results to be returned in a match request may mean more than 4 actual Patient resources returned, if the responding system has not mapped one identity to one record. Two options:

1. In this case, only the requested number of identities should be returned and the requester can ask for all resources or some subset, as needed. 
2. All applicable records are returned; a different threshold on number of records returned could be considered instead.
    Note that a collection of records together can make them more valuable than one of the records may appear on its own.  *Use MatchGrade extension to help explain the entire story?*  

> **NOTE:** Although some systems may employ referential matching capabilities or other industry-established practices, methods for determining match and the use of any specific algorithms to produce results in which a responder is sufficiently confident to appropriately release are out of scope for this implementation guide.

&emsp;&emsp;  

### Verification

It is helpful to know the date verification of attributes was performed, in the case of address and cell number since those attributes change. Future versions of this implementation guide will likely include a grammar for indicating this information in match transactions.

The identity verification level performed to establish matching attributes is another meaningful piece of information to convey in a transaction; for an example of how to include level of identity and authentication assurance in an OpenID Connect user profile, see the section on [Digital Identity](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/digital-identity.html).

When attributes like telephone number are verified as associated with a patient, that information helps to bootstrap new account creation. An API from USPS may be helpful in verifying individual street addresses in future versions of this implementation guide. NPI records can be used to verify provider addresses and telephone numbers today.

&emsp;&emsp;  

### Recommended Best Practices

It is a best practice to include all known (required + optional) patient matching attributes in a match request (i.e. USCDI Patient Demographics); the table below indicates examples of attributes and levels of verification for consideration in different use cases:

| **Minimum Included Attributes**                     | **Attribute Verification in B2B TPO  Workflow**               | **Attribute Verification in App-Mediated B2C  Workflow**      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ((First Name + Last Name) or DOB) + unique  enterprise identifier | LoA-2; onlyCertainMatches and count=1  required for patient care delivery, coverage determination, or  billing/operations | N/A; see below for specific IDs                              |
| First, Last, DOB, full (normalized as a best  practice) street address, administrative gender and birth sex | LoA-2; onlyCertainMatches and count=1  required for patient care delivery, coverage determination, or  billing/operations | Verifiable patient attributes within a match  request are consistent with IAL1.8 or greater identity verification  procedures performed for the patient |
| First, Last, Interoperable Digital Identity  Identifier      |                                                              | Identifier is established based on IAL1.8  requirements as above and First, Last are consistent with evidence |
| First, Last, Date of Birth, Current Address,  City, State    |                                                              | Consistent with the IAL1.8 or greater  identity verification event |
| First, Last, Date of Birth, Insurance Member  ID             |                                                              | Consistent with the IAL1.8 or greater  identity verification event |
| First, Last, DOB, (mobile number or email  address)          |                                                              | Consistent with the IAL1.8 or greater  identity verification event except mobile number control may be used for  verification if mobile number was not one of the two Fair pieces of evidence |

Patient Match is not expected to enforce the minimum included attributes listed above. However, when a minimum combination of attributes is supplied, Patient Match **SHOULD** be able to find matching candidates if they exist. Under the hood, this is a requirement on the indexing capability for Patient Match to locate candidates before evaluating them. When something less than the minimum is supplied, Patient Match **MAY** return no candidates, even if matching candidates exist. 

- For example, a bare name might theoretically match no candidates or an overwhelming number of candidates. In this case, Patient Match may return no candidates, even if matching data exists. A simple phone number may or may not be enough for Patient Match to find candidates - that is left up to the implementation.

Patient Match is expected to supply a Patient resource conforming to the Patient profile(s) defined within this Implementation Guide to [$match](https://www.hl7.org/fhir/patient-operation-match.html) and entering as much information as possible is encouraged.  More information helps find the right candidate and disambiguate cases where there are several candidates. This implies that Patient Match is not simply a matter of finding a candidate that exactly matches all the given demographics. That approach tends to discourage entering more information because the user cannot know exactly which demographics will appear in the existing Identities. 

- For example, a user should not be reticent to enter an address because he is worried that the patient has moved and the search will fail to find the patient at the old address.

Patient Match **SHOULD** return only match candidates which are an exact match on Name, where exact means there is at most a single character or two character (for example, a transposition error) difference between the Name in the match request and the name associated with the Identity(ies) or the set of records identified as matches in the responding system. Ideally the industry will work toward developing a reliable list of nickname associations that would support requiring such exact matches in future versions of this guide.

Patient Match **SHOULD** be in terms of groups of records that have been partitioned prior to the Patient Match call into Identities -- groups of records that are thought to represent people. 

- For example, a candidate Identity that has the right address in one record, the right name in another, and the right telephone in another could be a strong candidate, even though no single record contains all the given information.  
  

Patient Match need not support wildcards, unlike the usual FHIR search mechanism.

The section below provides example weight values that a match requestor can use along with specialized patient resource profiles to indicate their intent to follow pre-defined minimum match input requirements. 

&emsp;   

### Patient Weighted Input Information

&emsp;&emsp;*(The information and values included here are Draft state and have not been finalized)*

Providing an agreed upon value for matching (i.e., "weight") to specific Patient information elements allows for a degree of matching capability either through profiling the Patient resource or through other potential mechanisms within the guidance.   

<style>
table, th, td 
{
  border: 1px solid Silver; 
  padding: 5px
}
th {
  background: Azure; 
}
</style>


| **Weight** | **Element(s)**                  |
| :----------: | ---------------------------- |
| 10          | Passport Number (PPN) and issuing country (max weight of 10 for this category, even if multiple Passport Numbers included)      |
| 10          | Driver’s License Number (DL) or other State ID Number and (in either case) Issuing US State (max weight of 10 for this category, even if multiple ID Numbers included) |
| 4          | Address (including line and city), telecom email, telecom phone, identifier (other than Passport Number, DL or other State ID) OR [Individual Profile Photo](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) (max weight of 4 for inclusion of 1 or more of these) |
| 4          | First Name & Last Name       |
| 2          | Date of Birth       |


&emsp;&emsp;  
This guide provides multiple profiles of the Patient resource to support varying levels of information to be provided to the [$match](https://www.hl7.org/fhir/patient-operation-match.html) operation.  Patient Match **SHALL** support a minimum requirement that the *[IDI Patient]* profile be used (base level with no information "weighting" included).  More robust matching quality will necessitate stricter data inclusion and, as such, Patient Match **SHOULD** utilize profiles supporting a higher level of data inclusion requirements (e.g., *[IDI Patient 0]*, *[IDI Patient 1]*, etc.)    

> <font color="Black"><b>NOTE:</b> It is important to remember that this weighted information guidance is ONLY applicable to the patient resource instance that is provided as input to the $match operation and does not pertain in any way to the matching process or results returned from it. </font> 

### Patient Weighted Information for use in Match Success Rate

&emsp;&emsp;*(The information and values included here are Draft state and have not been finalized)*

Providing information to help grade the success of match results in a deterministic way that is understandable across organizational boundaries.   

<style>
table, th, td 
{
  border: 1px solid Silver; 
  padding: 5px
}
th {
  background: Azure; 
}
</style>


| **Weight** | **Matching Element(s)**                  |
| :----------: | ---------------------------- |
|           | Name PLUS Driver's License Number and Issuing US State |
|           | SSN (complete) |
|           | Passport Number (PPN) and issuing country |
|           | Driver’s License Number (DL) or other State ID Number and (in either case) Issuing US State |
|           | Insurance Member Identifier |
|           | SSN (last 4) |
|           | Address (including line and city (or zip) and state), Previous Address, telecom email, telecom phone, identifier (other than those specified elsewhere in this table) OR [Individual Profile Photo](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) |
|           | Address line, Zip and State       |
|           | First Name & Last Name       |
|           | First Name & Last Name       |
|           | telecom email |
|           | telecom phone (mobile) |
|           | telecom phone (other than mobile)|
|           | SSN (last 5) |
|           | SSN (last 4) |
|           | Previous First Name & Last Name       |
|           | Nickname or Alias       |
|           | Date of Birth       |
|           | Address City and State       |
|           | Address Zip and State       |
|           | Sex (Assigned at Birth)       |


&emsp;   

### Golden Records

The concept of matching Identities is best kept separate from the notion of a Golden Record. Many organizations use a Golden Record to capture all the correct and current information for a Patient while suppressing information that is thought to be out-of-date or incorrect. Often, such a Golden Record simply omits older inconsistent information such as an Address. While FHIR Patient can represent both current and old names, addresses and telecoms, its restriction on birthDate limits the representation to only one. A record partitioning system behind Patient Match may decide that two records with different birthDates represent the same person, but may not be able to know which of the birthDates is correct. Ideally, Patient Match would be able to find and appropriately evaluate such a candidate, regardless of which birthDate appears on the Golden Record.

- Matching and searching **SHOULD** be Identity-to-Identity, not Record-to-Record.

- Match output **SHOULD** contain every record of every candidate identity, subject to volume limits

- Linkage between records **SHOULD** be indicated by the Patient.link field
- Records **SHOULD** be ordered first by identity, then by score vs. the input
- Identities (sets of records) **SHOULD** be ordered by score vs. the input as per: "The response from an 'mpi' query is a bundle containing patient records, ordered from most likely to least likely."  

If a match implementation supports creating a golden record to summarize the identity, match output **SHOULD** contain that record as well

- For example, it may have an opinion on the patient's current address and consolidate demographics that were distributed across records

A match implementation **SHOULD** enable Manual Stewardship of the partitioning based on identity

- This involves specifying not just the current state, but constraints on future states of the partitioning as records arrive or are updated

A match implementation **SHOULD** partition its records into identities in real time as they arrive. Doing so:

- Enables manual stewardship
- Improves the quality of matching 
- Improves the quality of searching
- Especially in regard to situations where only a single unambiguous match is desired via onlyCertainMatches

A match output **SHOULD** reveal a presence or lack of manual stewardship

- Currently this could be supported via extensions *<u>(add example?)</u>*, but we might want to at least suggest inclusion in future versions of FHIR *<u>(add example?)</u>*
- The solution will need to consider how this works with a FHIR system that contains both records from many sources and perhaps golden records from the match implementation itself; i.e. are both types of matches accessible as Patient resources, *<u>or no?</u>*

&emsp;&emsp;  

### Scoring Matches

Scoring **SHOULD** be as probabilistic as possible

Common correlations such has families **SHALL** be modeled *<u>(ONC recommendation reference?)</u>*

Scores **SHOULD** be computed, not guessed, whenever possible

&emsp;&emsp;  

### No Match Results

Recommended errors?

If no results are returned, the workflow may result in a new patient record being established *<u>[in certain use cases only? Question for OCR about whether this is permitted &  additional text we might include along those lines.]</u>*.

&emsp;&emsp;  

### Exception Handling

To do

### Privacy Considerations

To do


### Benchmarking

To do


{% include link-list.md %}
