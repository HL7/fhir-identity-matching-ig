### Overview 

This section of the guide extends the existing HL7 FHIR patient [$match](https://www.hl7.org/fhir/patient-operation-match.html) for cross-organizational use by authorized, trusted parties. The IG profiles the operation [$IDI-match] to account for these additional constraints.

The best practices and suggested weights are based on this team's original research which included the sources cited on the [Home](index.html) tab as well as FAST webinar feedback, FAST subject matter expert (SME) sessions, HL7 FHIR Connectathon events, and FAST Identity team participants' additional suggestions made to the FAST Identity solution document; this work has been ongoing since spring 2018.   

&emsp;     

### Recommended Best Practices 

It is a best practice to include all known (required + optional) patient matching attributes in a match request (e.g., USCDI Patient Demographics); the table below indicates examples of attributes and levels of verification for consideration in different use cases: 

| **Minimum Included Attributes**                     | **Attribute Verification in B2B TPO  Workflow**               | **Attribute Verification in App-Mediated B2B with Patient User Workflow**      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ((First Name and Last Name) or DOB) and unique Enterprise Identifier | IAL1.5; onlyCertainMatches and count=1  required for patient care delivery, coverage determination, or  billing/operations | N/A; see below instead                              |
| First, Last, DOB, full (normalized as a best practice) street address | Same as above | N/A; see below instead |
| First, Last, DOB, Digital Identifier      | Same as above    | Identifier is established based on [IAL1.8  requirements](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html#best-practices-for-identity-verification) and First, Last are consistent with evidence |
| First, Last, DOB, Current Address, City, State, Medical Record Number and Assigner    | Same as above             | Verifiable patient attributes within a match request are consistent with the IAL1.8 or greater  identity verification event |
| First, Last, DOB, Current Address, Zip, Insurance Member ID, Payer ID             | Same as above       | Verifiable patient attributes within a match request are consistent with the IAL1.8 or greater  identity verification event |
| First, Last, DOB, mobile number and email address          | Same as above      | Verifiable patient attributes within a match request are consistent with the IAL1.8 or greater  identity verification event except mobile number control may be used for  verification if mobile number was not one of the two Fair pieces of evidence |

Patient Match is not expected to enforce the minimum included attributes listed above. However, when a minimum combination of attributes is supplied, Patient Match **SHOULD** find matching candidates if they exist. Under the hood, this is a requirement on the indexing capability for Patient Match to locate candidates before evaluating them. When something less than the minimum is supplied, Patient Match **MAY** return no candidates, even if matching candidates exist.  

- For example, a bare name might theoretically match no candidates or an overwhelming number of candidates. In this case, Patient Match may return no candidates, even if matching data exists. A simple phone number may or may not be enough for Patient Match to find candidates - that is left up to the implementation. 

Patient Match is expected to supply a Patient resource conforming to the Patient profile(s) defined within this IG to [$IDI-match] and entering as much information as possible is encouraged. However, requestors **SHOULD NOT** include elements whose value is unknown, since that may eliminate potential matches where the responder's system contains that information. More information helps find the right candidate and disambiguate cases where there are several candidates. This implies that Patient Match is not simply a matter of finding a candidate that exactly matches all the given demographics.  Requiring a match on every included attribute tends to discourage entering more information because the user cannot know exactly which demographics will appear in the existing Identities.  

- For example, a user should enter an address even if they are worried the patient has moved and the search will fail to find the patient at the old address. 

When onlyCertainMatches are requested, responders **SHOULD** return only results which are an exact match on Last Name and First Name, where exact means there is at most a single character or two character (for example, a transposition error) difference between the Name in the match request and the name associated with the Identity(ies) or the set of records identified as matches in the responding system. Ideally the industry will work toward developing a reliable, publicly-available list of nickname associations and common misspellings that, combined with stepped up best practices in identity verification by both requesters and responders, would support requiring such exact matches in future versions of this IG. 

Patient Match **SHOULD** be in terms of groups of records that have been partitioned prior to the Patient Match call into Identities -- groups of records that are thought to represent people.  

- For example, a candidate Identity that has the right address in one record, the right name in another, and the right telephone in another could be a strong candidate, even though no single record contains all the given information.   

Names are verified at a point in time and previous names are often useful in matching. However, best practices include periodic reverification, and it is generally expected that First and Last names reflect current names. Best practice data stewardship expects previous names to be designated as such within the Patient resource. Appropriate use of Patient.name.use and Patient.name.period are expected for use of previous names. 

Although it is possible to request a match with only First or only Last Name and still be compliant with this IG, the example [Invariants](artifacts.html) highlight minimum thresholds for the primary use cases where this is expected to occur. 

To request a match on a patient with a single legal name, known as a mononamous individual, requestors **SHOULD** use that name in the Last name field and leave the First name NULL. 

When it is permitted by [$IDI-match] or other match transaction types, and if the requestor is using a profile that includes these, additional matching information can be included as input extensions or contained resources within the Patient resource. For example, current occupation data for health attributes from Resource Profile: Past Or Present Job as per the [Occupational Data for Health (ODH)](http://hl7.org/fhir/us/odh/) set of profiles on Observation resource, **SHOULD** be included by requestors since this information is useful to matching. 

Patient Match need not support wildcards, unlike the usual FHIR search mechanism. 
 
The section below provides example weight values that a match requestor can use along with specialized patient resource profiles to indicate their intent to follow pre-defined minimum match input requirements.  

<div class="stu-note" markdown="1"> 
The workgroup invites suggestions from commenters regarding the use of Artificial Intelligence and Referential Matching in identity and matching. For example, should attributes not claimed by an individual be added to a record, match input request, and/or match result based on identity management resources when not part of a Declaration of Identity assertion by the individual? In what cases would this be acceptable? Is the guidance different when resources are authoritative or are derived from authoritative sources (such as credit bureau type records)? Are there other generative workflows in which guidance would be helpful?
</div> 

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
| 5          | Passport Number (PPN) and issuing country, Driver’s License Number (DL) or other State ID Number and (in either case) Issuing US State or Territory, or Digital Identifier (max weight of 10 for this category, even if multiple ID Numbers included) |
| 4          | Address (including line plus zip or city and state), telecom email, telecom phone, identifier (other than Passport Number, DL, other State ID, or Digital Identifier--for example, last 4 of SSN, Insurance Member Identifier along with Payer Identifier, or Medical Record Number along with Assigner) or [Individual Profile Photo](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/guidance-on-identity-assurance.html) (max weight of 5 for inclusion of 2 or more of these) |
| 3          | First Name and Last Name       |
| 2          | Date of Birth       |
|TBD        | SSN (complete) |
|TBD        | Insurance Member Identifier |
|TBD        | SSN (last 5) |
|TBD        | Insurance Subscriber Identifier |
|TBD        | Previous First Name & Last Name       |
|TBD        | Nickname or Alias       |
|TBD        | First Name       |
|TBD        | Last Name       |
|TBD        | Middle Name (Including initial)       |
|TBD        | Address City and State       |
|TBD        | Address Zip        |
|TBD        | Sex (Assigned at Birth)       |
|TBD        | Sexual Orientation       |

&emsp;&emsp;

In cases where Address is not a single-family residence–for example, an apartment building without unit number, hospital, or homeless shelter–the alternative inputs are particularly important. 

The expectation for the use of the "IDI" profiles is:

The system making the call to [$IDI-match] ("the client") will assert their intent/ability to supply valuable input information to support the searching algorithm by specifying, and conforming to, a particular level of data inclusion identified by one of the profiles. An Master Patient Index (MPI) (i.e., a "server" system providing the $match operation) will leverage the client's assertion by validating conformance and providing a warning(s) or throwing a full exception if invariant level testing fails. In addition, the MPI may potentially direct the logical code flow for matching based on the verified assurance of data quality input, as well as possible assistance in internal match scoring processes. While any designs of the MPI are outside the scope of the IG, the profiles of the Patient resource are intended to contribute a possible communication of data quality between the client and MPI that may be used in different ways.

Reminder: Historical demographics are held to the same requirements and guidance as current demographics.

This guide provides multiple profiles of the Patient resource to support varying levels of information to be provided to the [$IDI-match] operation.  Patient Match **SHALL** support a minimum requirement that the *[IDI Patient]* profile be used (base level with no information "weighting" included).  More robust matching quality will necessitate stricter data inclusion requirements and, as such, Patient Match **SHOULD** use profiles supporting a higher level of data inclusion requirements (i.e., whereas *[IDI Patient L0]* may be suitable for use cases in which returning multiple match results is acceptable, *[IDI Patient L1]* indicates an input weight threshold that is expected to only result in matches on the individual whose identity was verified at the minimum level required by this IG for consumer-facing match requests (IAL1.8/AAL2) and that attributes provided in the match request are confirmed to be consistent with). 

Trust communities may have specific requirements about minimum attributes, but in the absence of such requirements, the minimum attribute requirements of the L0 invariant are intended to reflect what may be appropriate for probabilistic searches in which requestors are HIPAA Covered Entities, and the minimum attribute requirements of the L1 invariant are intended to reflect what may be appropriate for deterministic searches in which requestors are potentially returning PHI to the consumer/patient who is the subject of a query (or their authorized representative).  

This IG does not intend to set requirements on the use of HumanName.family and HumanName.given in lieu of HumanName.text, though for purposes of clarity we generally refer to First name and Last name (Surname) since some requirements depend on that level of granularity. Systems compliant with this IG **SHALL** recognize that [HumanName.text](https://www.hl7.org/fhir/datatypes-definitions.html#HumanName.text) may be provided instead of or in lieu of HumanName.family and HumanName.given. 

<font color="Black"><b>NOTE:</b> It is important to remember that this weighted information guidance is ONLY applicable to the Patient resource instance provided as input to the $match operation and does not pertain in any way to the matching process or results returned from it. Data elements with weight indicated as "TBD" are known to be valuable in matching but were not identified as contributors to the defined example weight input tiers.</font>  

&emsp;    

### Golden Records 

The concept of matching Identities is best kept separate from the notion of a [Golden Record](glossary.html). Many organizations use a Golden Record to capture all the correct and current information for a Patient while suppressing information that is thought to be out-of-date or incorrect. Often, such a Golden Record simply omits older inconsistent information such as an address. While the FHIR Patient resource can represent both current and old names, addresses and telecoms, its restriction on birthDate limits the representation to only one. A record partitioning system behind Patient Match may decide that two records with different birthDates represent the same person, but may not be able to know which of the birthDates is correct. Ideally, Patient Match would be able to find and appropriately evaluate such a candidate, regardless of which birthDate appears on the Golden Record. 

At this time, we are not expecting match responders to organize identities according to the same standards match requestors are today, though in a future version of this IG we do expect responding systems to organize records on unique individual identities as established in the Guidance on Identity Assurance and Patient Matching sections of this guide. 

- Matching and searching **SHOULD** be identity-to-identity, not Record-to-Record. 
- Match output **SHOULD** contain every record of every candidate identity, subject to volume limits 
- Linkage between records **SHOULD** be indicated by the Patient.link field 
- Records **SHOULD** be ordered first by identity, then by score vs. the input 
- Identities (sets of records) **SHOULD** be ordered by score vs. the input as per: "The response from an 'mpi' query is a bundle containing patient records, ordered from most likely to least likely."   

If a match implementation supports creating a Golden Record to summarize the identity, match output **SHOULD** contain that record as well. 

- For example, it may have an opinion on the patient's current address and consolidate demographics that were distributed across records. 

A match implementation **SHOULD** enable [Manual Stewardship](glossary.html) of the partitioning based on identity. 

- This involves specifying not just the current state, but constraints on future states of the partitioning as records arrive or are updated. 
- While this document does not describe the form or process for such manual stewardship, it is suggested that the output of [$IDI-match] should support such contribution by providing the information on the records such that the doctor (or other authenticated user trusted with PII for specific people of interest) might spot the problem. 

Example: Suppose that a doctor at a clinic looks up a new patient in their regional health information exchange (HIE) to get a more complete medical record and sees a surprising diagnosis. This could arise due to several possibilities: 1) the patient has a diagnosis that was unknown to the doctor, 2) the HIE has another patient’s record mixed into the identity of the patient of interest (an error in partitioning), 3) the clinician is simply looking at the wrong patient’s information. In all three cases, the patient’s care might be improved if the doctor reviews the set of records that constitute the identity. If the problem is the second case above, both the care of this patient and perhaps others might be improved if the doctor could contribute to how these records are partitioned. 

A match implementation **SHOULD** partition its records into identities in real time as they arrive. Doing so: 

- Enables manual stewardship 
- Improves the quality of matching  
- Improves the quality of searching 

This is especially helpful in regard to situations where only a single unambiguous match is desired via onlyCertainMatches. 

A match output **SHOULD** reveal a presence or lack of manual stewardship. 

- Currently this could be supported via extensions 
- The IG authors request feedback from implementers regarding future guidance that may be needed in the case of a FHIR system that contains both records from many sources and Golden Records from the match implementation itself, i.e., are both types of matches returned? 

&emsp;&emsp;   

### Scoring Matches & Responder's System Match Output Quality Score 
<div class="stu-note" markdown="1">

The information and values included here are a first published Standard for Trial Use. Feedback is invited on the quality levels themselves, on the combinations of matching elements included, and on whether this publicly available definition of a search quality score (note that this is not intended to be a match probability) should be returned by responders in lieu of a locally-computed match confidence. 
</div> 

Scoring **SHOULD** be as probabilistic as possible; however search scoring algorithms vary and stakeholders have expressed interest in better informing the score shared across organizational boundaries in a [$IDI-match] response. The group, therefore, seeks feedback on [$IDI-match] implementers' interest in using either the new Score indicated below or a similar option which would include attribute-specific match result information from the [$IDI-match] responder (exact match, partial match, soundex match, etc.) for each demographic element relevant to matching within the Patient resource.  

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
|           |            | First Name & Last Name & Insurance Member Identifier and Payer ID      |
|           |            | First Name & Last Name & Date of Birth & Insurance Subscriber Identifier and Payer ID      |
|           |            | First Name & Last Name & Date of Birth & Social Security Number       |
|Superior   |  .8        | First Name & Last Name & Insurance Subscriber Identifier and Payer ID       |
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

Recognizing and scoring identifier matches can be quite sophisticated in several ways. Our guidance above is geared toward simplistic scenarios where the system or assigner is specified, corresponds, and is recognized as a system that identifies individual people. However, in some cases, scoring an Identifier may depend on the type of system (from the Identifier.type field) without knowing or recognizing the exact system. Also, cross-system identifier scoring can be appropriate in some situations. While ostensibly unique identifiers such as a PPN should generally score higher, non-unique identifiers can be valuable as scoring lower. Note that some healthcare insurance identifiers identify the family as opposed to an individual. Scoring an identifier match where the system or type is not given or not recognized, or the identifier context is otherwise unknown, should be avoided due to the possibility that it identifies a broad group of unknown size such as all employees of a large organization, all members of an insurance plan, or when the assignor is unknown. 

The scoring system used may be validated by the organization using it to determine its accuracy so that the level of effort to manually close identity matching is known and scoring factors that are missing are added to the score based on experience to refine the score and reduce the level of manually matching that needs to be done--over time this process should result in minimal manual matching. 

This scoring system has not been widely implemented/tested. Implementers are encouraged to report suggestions to the Identity team via Jira tickets on ways to improve the scoring methodology over time based on their experience. The team will consider such input for updating the scoring match system for the next version. 

Future versions of this IG will include language about additional considerations regarding permitted transposition errors, edit distances, and the use of soundex and special characters. 
&emsp;    

&emsp;&emsp;   

### Exception Handling 

<div class="stu-note" markdown="1"> 

The group requests feedback on any specific exception handling conditions that might arise and should be communicated to requesters or responders. For example, conditions under which a "Match request not conformant", "Match request not sufficiently specific," "Match request not authorized," "ID expired or no longer valid," "ID elements inconsistent," or other exception MAY be used. 

</div>

&emsp;&emsp;

### Privacy Considerations

<div class="stu-note" markdown="1"> 

Applicable federal and state laws, as well as any relevant community agreements, may exist and provide some restrictions on the content included in a match request and in the patient results or error messages returned by a responder. The authors request feedback on any additional privacy considerations that should be included in this IG. 

</div> 
&emsp;&emsp;   

### Benchmarking 

<div class="stu-note" markdown="1"> 

Benchmarking of patient matching has been a suggestion made previously by stakeholders. The group requests specific suggestions related to industry-wide benchmarking of best practice matching, including what stakeholders find it relevant to measure in such an activity, how results are shared, and the resources such as synthesized or actual population data that may be used in benchmarking initiatives. Organizations benchmarking matching quality that implement this IG to enhance their performance are encouraged to report their findings via Jira tickets. The team will consider such input for exception handling guidance in the next version. 

</div> 

 

{% include link-list.md %} 
