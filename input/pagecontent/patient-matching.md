### Overview

This section of the guide extends the existing HL7 FHIR patient [$match](https://www.hl7.org/fhir/patient-operation-match.html) for cross-organizational use by authorized, trusted parties.  

> **NOTE:** As security is generally out of scope for this guide, the conditions required to share personally identifiable information (PII) or to authorize an organization's or an individual’s, including the patient’s own, access to the results of a match request are not specified completely in this guide, nor should they be inferred.  However, patient-initiated workflows (for example, "patient requested" purpose of use) **SHALL** always include explicit end-user authorization.   

Except where its recommendations involve FHIR $match-specific parameters, the guidance is intended to also apply to other patient matching workflows including non-FHIR transactions. Realizing that a better-formed match request produces the most reliable results, this implementation guide also includes a Guidance on Identity Assurance section as a companion resource to this best practice patient matching. 

### Match Requirements

When transmitting identity attributes to third parties with whom that sharing of personally identifiable information (PII) is permitted, such as: 

- from an OpenID user profile or in another user information request to an Identity Provider, 
- within a UDAP assertion object, or 
- as part of a match or search request,

and a level of identity assurance is indicated, each included identity attribute **SHALL** either have been verified at the identity level of assurance asserted by the transmitting party (for example, the match requestor) or be consistent with other evidence used in that identity verification process completed by that party. If a level of assurance is not explicitly asserted, at a minimum, the combination of identity attributes submitted **SHOULD** be consistent with, and sufficient to on their own identify, the identity of a unique person in the real world (for example, a first name, last name, DOB and home street address have been verified as belonging to the individual OR a first name, last name, and a Digital Identifier that is compliant with this Implementation Guide have been verified as belonging to the individual), consistent with the practices of NIST 800-63A using Fair or stronger evidence and/or credit bureau type records (or equivalent), and consistent with this IG's [Guidance on Identity Assurance](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html). 

As a best practice, identity verification **SHOULD** be at a minimum of IAL2 or LoA-3 for professionals who are end users of health IT systems and for an implementer's overall operations. 

Individual Access (or if PHI or PII will be returned, other than to a Covered Entity in a Treatment, Payment, or Operations workflow), is outside the scope of this IG's Patient Matching requirements. Instead, responders to such queries **SHALL** authenticate the Individual before returning PHI or PII.

Security best practices, including transaction authorization, are generally out of scope for this Implementation Guide, however implementers also **SHALL NOT** allow patients to request a match directly. A trusted system may request a match on a patient’s behalf and use it to inform the patient, especially to: 

- Recognize that the patient already has an account (when a record represents an account)

- Recognize that a patient may have multiple identities within the system, leading to a fragmented medical record

- Recognize that a patient’s identity might have spurious records from other people mixed in

- Help remediate these situations without exposing PHI/PII

For sharing of immunization records only, patient matching **MAY** be performed using identity attributes verified at IAL1.2 or higher by both requesting party and responder.

#### Match on Identities

While FHIR systems often expect to have only one Patient Resource per actual patient in the usual case, some systems may normally have many records for the same patient, typically originating from many disparate systems such as clinics, insurance companies, labs, etc. In this scenario, the Patient resources are typically already linked via automatic matching into sets of Patient Resources, where each set represents a specific patient in the opinion of the MPI system. In such a system the patient match **should** be performed against the sets of records as opposed to the individual records. For example, if 5 records are currently believed to represent the same patient, a search for that patient would find the set of 5 and consider that as one candidate as opposed to 5 candidates. Moreover, that search would benefit from all of the information in the set. For example, consider a set of 5 linked Patient records currently in the system and a Patient input to a $match operation that includes a name, birthdate, telephone and MBI such that the $match input Patient:

- name matches Patient 1 but is somewhat different from Patients 2-5
- birthdate matches all five of them
- telephone matches Patient 3 and is not present in Patients 1,2,4,5
- MBI matches Patient 5 and is absent in patients 1-4

Then the strength of the match for that single candidate should take into account all the matching information as opposed to either each record individually or some aggregation of the information in the records that tries to subset it to the “correct” information only (a “golden” record).

Asking for at most 4 results to be returned in a match request may mean more than 4 actual Patient resources returned, if the responding system has not mapped one identity to one record. Two options:

1. In this case, only the requested number of identities are returned and the requester can ask for all resources or some subset, as needed. 
2. All applicable records are returned; a different threshold on number of records returned could be considered instead.
    Note that a collection of records together can make them more valuable than one of the records may appear on its own.  *Feedback is welcome on the use of MatchGrade extension to help provide additional detail.*  

> **NOTE:** Although some systems may employ referential matching capabilities or other industry-established practices, methods for determining match and the use of any specific algorithms to produce results in which a responder is sufficiently confident to appropriately release are out of scope for this implementation guide.
 
The expectation for the use of the "IDI" profiles is:

The system making the call to $match ("the client") will assert their intent/ability to supply valuable input information to support the searching algorithm by specifying, and conforming to, a particular level of data inclusion identified by one of the profiles. An MPI (i.e., a "server" system providing the $match operation) would be able to leverage the client's assertion by validating conformance and providing a warning(s) or throwing a full exception if invariant level testing fails. In addition, the MPI may potentially direct the logical code flow for matching based on the verified assurance of data quality input, as well as possible assistance in internal match scoring processes. While any designs of the MPI are outside the scope of the IG, the profiles of the Patient resource are intended to contribute a possible communication of data quality between the client and MPI that may be utilized in a number of different ways.

4.2.2 B2B with User Authorization Extension Object

The B2B with User Authorization Extension Object is used by client apps following the client_credentials flow to provide additional information regarding the context under which the request for data is authorized. The client app constructs a JSON object containing the following keys and values and includes this object in the extensions object of the Authentication JWT, as per [UDAP Security 5.2.1.1](http://hl7.org/fhir/us/udap-security/STU1/b2b.html#b2b-authorization-extension-object), as the value associated with the key name hl7-b2b-user. The same requirements for use of hl7-b2b apply in the use of hl7-b2b-user.

Person Resource Profile for FAST ID:
```json
{
    "resourceType": "StructureDefinition",
    "id": "FASTIDPerson",
    "url": "TBD",
    "name": "FASTIDPerson",
    "title": "FAST Identity UDAP Person",
    "status": "active",
    "description": "Profile on Person for use with the Interoperable Digital Identity and Patient Matching IG",
    "fhirVersion": "4.0.1",
    "kind": "resource",
    "abstract": false,
    "type": "Person",
    "baseDefinition": "http://hl7.org/fhir/StructureDefinition/Person",
    "derivation": "constraint",
    "differential": {
        "element": [
            {
                "id": "Person.name.family",
                "path": "Person.name.family",
                "min": 1
            },
            {
                "id": "Person.name.given",
                "path": "Person.name.given",
                "min": 2
            },
            {
                "id": "Person.telecom",
                "path": "Person.telecom",
                "slicing": {
                    "discriminator": [
                        {
                            "type": "pattern",
                            "path": "system"
                        }
                    ],
                    "rules": "open",
                    "description": "Forcing both a phone and an email contact"
                },
                "min": 2
            },
            {
                "id": "Person.telecom:tphone",
                "path": "Person.telecom",
                "sliceName": "tphone",
                "min": 1,
                "max": "*"
            },
            {
                "id": "Person.telecom:tphone.system",
                "path": "Person.telecom.system",
                "min": 1,
                "patternCode": "phone"
            },
            {
                "id": "Person.telecom:email",
                "path": "Person.telecom",
                "sliceName": "email",
                "min": 1,
                "max": "*"
            },
            {
                "id": "Person.telecom:email.system",
                "path": "Person.telecom.system",
                "min": 1,
                "patternCode": "email"
            },
            {
                "id": "Person.birthDate",
                "path": "Person.birthDate",
                "min": 1
            },
            {
                "id": "Person.address.line",
                "path": "Person.address.line",
                "min": 1
            },
            {
                "id": "Person.address.city",
                "path": "Person.address.city",
                "min": 1
            },
            {
                "id": "Person.address.state",
                "path": "Person.address.state",
                "min": 1
            },
            {
                "id": "Person.address.postalCode",
                "path": "Person.address.postalCode",
                "min": 1
            }
        ]
    }
}
```
&emsp;&emsp;  

### Verification

It is helpful to know the date verification of attributes was performed, in the case of address and cell number since those attributes change. Future versions of this implementation guide will likely include a grammar for indicating verification date in match transactions, as well what evidence was used to verify individual demographic attributes or entire identities. This information may also be applied to Patient Weighted Input Information.

The identity verification level performed to establish matching attributes is another meaningful piece of information to convey in a transaction; for an example of how to include level of identity and authentication assurance in an OpenID Connect user profile, see the section on [Digital Identity](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/digital-identity.html).

When attributes like email address and telephone number are verified as associated with a patient, that information helps to bootstrap new portal account creation and (later) account recovery. 

An API from USPS may be helpful in verifying individual street addresses in future versions of this implementation guide. 

NPI records can be used to verify provider names, addresses and telephone numbers today.

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

When onlyCertainMatches are requested, responders **SHOULD** return only results which are an exact match on Given Name and First Name, where exact means there is at most a single character or two character (for example, a transposition error) difference between the Name in the match request and the name associated with the Identity(ies) or the set of records identified as matches in the responding system. Ideally the industry will work toward developing a reliable, publicly-available list of nickname associations and common misspellings that, combined with stepped up best practices in identity verification by both requesters and responders, would support requiring such exact matches in future versions of this implementation guide.

Patient Match **SHOULD** be in terms of groups of records that have been partitioned prior to the Patient Match call into Identities -- groups of records that are thought to represent people. 

- For example, a candidate Identity that has the right address in one record, the right name in another, and the right telephone in another could be a strong candidate, even though no single record contains all the given information.  
  

To request a match on a patient with a single legal name, known as a mononamous individual, requestors **SHOULD** use that name in the Last name field and leave the First name NULL.

Patient Match need not support wildcards, unlike the usual FHIR search mechanism.

The section below provides example weight values that a match requestor can use along with specialized patient resource profiles to indicate their intent to follow pre-defined minimum match input requirements. 

&emsp;   

### Patient Weighted Input Information

&emsp;&emsp;*(The information and values included here serve as an example for weights that may be adopted to achieve various threshold levels responders systems may choose to require.)*

Providing an agreed-upon value for matching (i.e., "weight") to specific Patient information elements included in a match request allows for a degree of matching capability either through profiling the Patient resource or through other potential mechanisms within the guidance.   

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


| **Weight** | **Match Input Element(s)**                  |
| :----------: | ---------------------------- |
| 10          | Passport Number (PPN) and issuing country (max weight of 10 for this category, even if multiple Passport Numbers included)      |
| 10          | Driver’s License Number (DL) or other State ID Number and (in either case) Issuing US State (max weight of 10 for this category, even if multiple ID Numbers included) |
| 4          | Address (including line plus zip or city and state), telecom email, telecom phone, identifier (other than Passport Number, DL or other State ID) OR [Individual Profile Photo](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) (max weight of 4 for inclusion of 1 or more of these) |
| 4          | First Name & Last Name       |
| 2          | Date of Birth       |
|TBD        | SSN (complete) |
|TBD        | Insurance Member Identifier |
|TBD        | SSN (last 5) |
|TBD        | SSN (last 4) |
|TBD        | Insurance Subscriber Identifier |
|TBD        | Previous First Name & Last Name       |
|TBD        | Nickname or Alias       |
|TBD        | First Name       |
|TBD        | Last Name       |
|TBD        | Middle Name (Including initial)       |
|TBD        | Date of Birth       |
|TBD        | Address City and State       |
|TBD        | Address Zip        |
|TBD        | Sex (Assigned at Birth)       |
|TBD        | Sexual Orientation       |

&emsp;&emsp;  
This guide provides multiple profiles of the Patient resource to support varying levels of information to be provided to the [$match](https://www.hl7.org/fhir/patient-operation-match.html) operation.  Patient Match **SHALL** support a minimum requirement that the *[IDI Patient]* profile be used (base level with no information "weighting" included).  More robust matching quality will necessitate stricter data inclusion and, as such, Patient Match **SHOULD** utilize profiles supporting a higher level of data inclusion requirements (e.g., *[IDI Patient L0]*, *[IDI Patient L1]*, etc.)    

> <font color="Black"><b>NOTE:</b> It is important to remember that this weighted information guidance is ONLY applicable to the patient resource instance that is provided as input to the $match operation and does not pertain in any way to the matching process or results returned from it. Data elements with weight indicated as "TBD" are known to be valuable in matching but were not identified as contributors to the defined example weight input tiers.</font> 


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
- While this document does not describe the form or process for such manual stewardship, it is suggested that the output of $match should support such contribution by providing the information on the records such that the doctor (or other authenticated user trusted with PII for specific people of interest) might spot the problem.

    Example: Suppose that a doctor at a clinic looks up a new patient in their regional HIE in order to get a more complete medical record and sees a surprising diagnosis. This could arise due to several possibilities: 1) the patient has a diagnosis that was unknown to the doctor, 2) the HIE has another patient’s record mixed into the identity of the patient of interest (an error in partitioning), 3) the clinician is simply looking at the wrong patient’s information. In all three cases, the patient’s care might be improved if the doctor reviews the set of records that constitute the identity. If the problem is the second case above, both the care of this patient and perhaps others might be improved if the doctor could contribute to how these records are partitioned.

A match implementation **SHOULD** partition its records into identities in real time as they arrive. Doing so:

- Enables manual stewardship
- Improves the quality of matching 
- Improves the quality of searching
- Especially in regard to situations where only a single unambiguous match is desired via onlyCertainMatches

A match output **SHOULD** reveal a presence or lack of manual stewardship

- Currently this could be supported via extensions *<u>(add example?)</u>*, but we might want to at least suggest inclusion in future versions of FHIR *<u>(add example?)</u>*
- The solution will need to consider how this works with a FHIR system that contains both records from many sources and perhaps golden records from the match implementation itself; i.e. are both types of matches accessible as Patient resources, *<u>or no?</u>*

&emsp;&emsp;  

### Scoring Matches & Responder's System Match Output Quality Score

<div class="note-to-balloters" markdown="1">
The information and values included here are Draft state and have not been finalized. Feedback is invited on the quality levels themselves, on the combinations of matching elements included, and on whether this publicly available definition of a search quality score (note that this is not intended to be a match probability) should be returned by responders in lieu of a locally-computed match confidence.
</div>

Scoring **SHOULD** be as probabilistic as possible, however search scoring algorithms vary and stakeholders have expressed interest in better informing the score shared across organizational boundaries in a $match response. The group therefore seeks feedback on $match implementers' interest in using either the new Score indicated below or a similar option which would include attribute-specific match result information from the $match responder (exact match, partial match, soundex match, etc.) for each demographic element relevant to matching within the Patient resource. 

Common correlations such as families **SHALL** be modeled *<u>(ONC recommendation reference?)</u>*.

Scores **SHOULD** be computed, not guessed, whenever possible.

The table below which designates a grading of match quality **SHOULD** be used to inform responder's search quality scoring algorithm, so that the search score returned by a responder is meaningful to the requestor (This grading score **SHOULD** be conveyed within the Bundle.entry.search.score element); feedback is requested on the ability of a responder to compute and return such a score, as well as the potential value of such a quality score to requesters. The Good level generally corresponds to traits the [Sequoia Initiative](https://sequoiaproject.org/resources/patient-matching/) estimates to be 95-98% unique, and Very Good corresponds to traits that are 98-99.7% unique. Superior matches include matching information that is even more likely to indicate a unique individual, while Best matches involve a match on a government- or industry-assigned identifier.  

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


| **Quality** |  **Score** | **Element(s) Matching in Responder's System**                  |
| :----------: | :----------: | ---------------------------- |
|Best       |  .99       | Responder's MRN/MPI or known Digital Identifier       |
|           |            | First Name & Last Name & Driver's License Number and Issuing US State |
|           |            | First Name & Last Name & Passport Number and Issuing Country |
|           |            | First Name & Last Name & Insurance Member Identifier       |
|           |            | First Name & Last Name & Date of Birth & Insurance Subscriber Identifier       |
|           |            | First Name & Last Name & Social Security Number       |
|Superior   |  .8        | First Name & Last Name & Insurance Subscriber Identifier       |
|           |            | First Name & Last Name & Date of Birth & Address line & Zip (first 5)       |
|           |            | First Name & Last Name & Date of Birth & Address line & City & State       |
|           |            | First Name & Last Name & Date of Birth & email       |
|Very Good  |  .7        | First Name & Last Name & Date of Birth & Sex (Assigned at Birth) & SSN (last 4)       |
|           |            | First Name & Last Name & Date of Birth & Sex (Assigned at Birth) & Phone       |
|           |            | First Name & Last Name & Date of Birth & Sex (Assigned at Birth) & Zip (first 5)       |
|           |            | First Name & Last Name & Date of Birth & Sex (Assigned at Birth) & Middle Name      |
|           |            | First Name & Last Name & Date of Birth & phone       |
|Good       |    .6      | First Name & Last Name & Date of Birth & Sex (Assigned at Birth) & Middle Name (initial)      |
|           |            | First Name & Last Name & Date of Birth & Sex (Assigned at Birth)      |
|           |            | First Name & Last Name & Date of Birth       |




Future versions of this implementation guide will include language about additional considerations regarding permitted transposition errors, edit distances, and the use of soundex and special characters.
&emsp;   

&emsp;&emsp;  

### No Match Results

<div class="note-to-balloters" markdown="1">

The group requests feedback on any specific error conditions that might arise, resulting in no results returned, that should be predictably communicated to requesters or responders. One such example is to require specific informative errors when no matches are returned. Another example is to require that responders indicate the additional demographic elements that should be provided in a subsequent request to improve match results, under the same condition or if match quality score is below a certain threshold.

</div>

NOTE: If no results are returned, some responding systems might create a new patient record from the attributes included in the match request.</u>*.

&emsp;&emsp;  

### Exception Handling

<div class="note-to-balloters" markdown="1">

The group requests feedback on any specific exception handling conditions that might arise and should be communicated to requesters or responders. For example, conditions under which a "Match request not sufficiently specific," "Match request not authorized," "ID expired or no longer valid," "ID elements inconsistent," or other exception should be returned.

</div>
&emsp;&emsp;  
### Privacy Considerations
<div class="note-to-balloters" markdown="1">

Realizing that applicable federal and state laws, as well as any relevant community agreements may exist and provide some restrictions on the content that may be included in a match request and in the patient results or error messages returned by a responder, the authors request feedback on any additional privacy considerations that should be included in this Implementation Guide.

</div>
&emsp;&emsp;  

### Benchmarking

<div class="note-to-balloters" markdown="1">

Benchmarking of patient matching has been a suggestion made previously by stakeholders. The group requests specific suggestions related to industry-wide benchmarking of best practice matching, including what stakeholders find it relevant to measure in such an activity, how results are shared, and the resources such as synthesized or actual population data that may be used in benchmarking initiatives. Organizations benchmarking matching quality and who implement this IG to enhance their performance are encouraged to report their findings via JIRA Tickets. The team will consider such input for exception handling guidance in the next version.

</div>


{% include link-list.md %}