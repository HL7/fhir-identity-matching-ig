### Overview 

This section of the guide extends the existing HL7 FHIR patient [$match](https://www.hl7.org/fhir/patient-operation-match.html) for cross-organizational use by authorized, trusted parties. The IG profiles the operation [$IDI-match] to account for these additional constraints.

The best practices and suggested weights are based on this team's original research which included the sources cited on the [Home](index.html) tab as well as FAST webinar feedback, FAST subject matter expert (SME) sessions, HL7 FHIR Connectathon events, and FAST Identity team participants' additional suggestions made to the FAST Identity solution document; this work has been ongoing since spring 2018.   

This guidance also applies to other matching workflows and to non-FHIR transactions. This guidance does not intend to prohibit the use of matching methods that produce comparable or higher matching rates. Realizing that a better-formed match request produces the most reliable results, this implementation guide (IG) also includes a [Guidance on Identity Assurance] section as a companion resource to this best practice patient matching. 

> **NOTE:** As security is generally out of scope for this guide, the conditions required to share personally identifiable information (PII) or to authorize an organization's or an individual’s, including the patient’s own, access to the results of a match request are not specified completely in this guide, nor should they be inferred.  However, patient-initiated workflows (for example, "patient request" purpose of use) **SHALL** always include explicit end-user authorization.
>
> Examples:
>
> -Patient authorizes access, as in SMART App Launch, such that clicking a button to authorize the transaction is the mechanism for capturing and carrying consent in an OAuth authorization code flow transaction
> 
> -Tiered OAuth Use Case - similar to the nominal SMART App Launch described above, except that OIDC user profile data includes demographics with sufficiently strong (IDIAL1.8 or higher) identity assurance and AAL2 or higher authentication assurance, that the demographics from the trusted identity service can be used to match on the user in real time and make an authorization decision
> 
> -B2B with Individual User Use Case - include consent as in the [Consumer Match](patient-matching.html#consumer-match) section, and demographics in the FHIR Person resource consistent with IDIAL1.8 or higher identity verification, and the user is authenticated at AAL2 or higher authentication assurance

With a desire to address this guidance in a way that is mindful of health equity considerations, the group has spent a substantial amount of time contemplating sensitive populations such as pediatric patients and patients experiencing homelessness or housing instability; this guidance therefore reflects an understanding of the prevalence of shared home addresses (when shelters and last known hospitalization are used for this) and other cases where identity evidence typically needed for IAL2 remote may not be available. Since many patients experiencing homelessness or housing instability have cell phones and may have email addresses that are used in both identity verification and multi-factor authentication, these identifiers should be used for that population to enhance their healthcare experience and communication with healthcare providers.

### Match Requirements 

When transmitting identity attributes to third parties with whom sharing PII is permitted, such as:  

- within an OpenID Connect user profile, another user information request to an Identity Provider, or the resultant assertion/claim,  
- within an HL7 B2B with User Authorization Extension Object, or  
- as part of a match or search request,

and a level of identity assurance is indicated, each included identity attribute **SHALL** either have been [verified](glossary.html) at the identity assurance level asserted by the transmitting party (for example, the match requester) or be consistent with other evidence used in the identity verification process completed by that party. If a level of assurance is not explicitly asserted, the combination of identity attributes submitted **SHOULD** be consistent with, and sufficient to on their own resolve to the identity of a unique person in the real world. Specifically, identity verification **SHALL** be performed at IDIAL1.5 or higher level of identity assurance per this IG's [Guidance on Identity Assurance] (e.g., a first name, last name, date of birth, mobile number, email address, and home street address have been verified as belonging to the individual OR a first name, last name, and Digital Identifier compliant with this IG have been verified as belonging to the individual), consistent with the practices of NIST 800-63A using Fair or stronger evidence and/or authoritative sources such as credit bureau type records (or equivalent), and consistent with the [Guidance on Identity Assurance].  

As a best practice, identity verification **SHOULD** be at a minimum of IAL2 or [LoA-3](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-63-2.pdf) for professionals who are end users of health IT systems and for an implementer's overall operations.  

Individual Access (or if protected health information [PHI] or PII will be shared with someone other than a HIPAA Covered Entity in a Treatment, Payment, or Operations workflow--for example, a Patient Request) requires a higher minimum identity assurance of IDIAL1.8 for the user and (if different) the patient whose health data is sought, as stipulated in the [Consumer Match](patient-matching.html#consumer-match) section and related [Use Cases](use-cases.html), since responders to such queries **SHALL** authenticate the individual before returning PHI or PII. 

Security best practices, including transaction authorization, are generally out of scope for this IG; however implementers also **SHALL NOT** allow patients to request a match directly. A trusted system may request a match on a patient’s behalf and use it to inform the patient, especially to:  

- Recognize that the patient already has an account (when a record represents an account) and allow them to authenticate when the credentials are sufficiently strong (at least IDIAL1.8/AAL2) and the patient can be matched based on best-practice matching
- Recognize that a patient may have multiple identities within the system, leading to a fragmented medical record 
- Recognize that a patient’s identity might have spurious records from other people mixed in 
- Help remediate these situations without exposing PHI/PII. 

For sharing immunization records only, patient matching **MAY** be performed using identity attributes verified at IDIAL1.2 or higher by both requesting party and responder. 

The expectation for the use of the "IDI" profiles is:

The system making the call to [$IDI-match] ("the client") **SHALL** assert their intent and ability to supply valuable input information to support the searching algorithm by specifying, and conforming to, a particular level of data inclusion identified by one of the profiles. A Master Patient Index (MPI) (i.e., a "server" system providing the match capability) will leverage the client's assertion by validating conformance and providing a warning(s) or throwing a full exception if invariant-level testing fails. In addition, the server may potentially direct the logical code flow for matching based on the verified assurance of data quality input, as well as possible assistance in internal match scoring processes. While any designs of the server are outside the scope of this IG, the profiles of the Patient resource are intended to communicate the claimed data quality between the client and server that may be used in a variety of ways.

Historical address information is known to be useful to matching; the same requirements and guidance for the verification of current demographics **SHALL** apply to historical demographics.

#### Match on Identities 

While FHIR systems are often expected to contain only one Patient Resource per actual patient, some systems may contain many records for the same patient, typically originating from many disparate systems such as clinics, insurance companies, labs, etc. In this scenario, the Patient resources are typically already linked via automatic matching into sets of Patient Resources using [Patient.link](https://www.hl7.org/fhir/patient-definitions.html#Patient.link), where each set represents a specific patient from the perspective of the MPI system. In such a system, the patient match **SHOULD** be performed against the sets of records as opposed to the individual records. For example, if five records are currently believed to represent the same patient, a search for that patient would find the set of five and consider that as one candidate as opposed to five candidates. Moreover, that search would benefit from all of the information in the set. For example, consider a set of five linked Patient records currently in the system and Patient information input to a match request that includes a first name and last name, date of birth, telephone and [MBI](glossary.html) such that the match input information about the Patient: 

- first name and last name match Patient 1 but are somewhat different from Patients 2-5 
- date of birth matches all five of them 
- telephone matches Patient 3 and is not present in Patients 1,2,4, and 5 
- MBI matches Patient 5 and is absent in patients 1-4 

Then the strength of the match for that single candidate should consider all the matching information as opposed to either each record individually or some aggregation of the information in the records that tries to subset it to the “correct” information only (a “golden” record). 

Asking for at most four results to be returned in a match request may mean more than four actual Patient resources returned, if the responding system has not mapped one identity to one record. This results in two options: 

1. In this case, only the requested number of identities are returned and the requester can ask for all resources or some subset, as needed.  
2. All applicable records are returned; a different threshold on number of records returned could be considered instead. 

Note that a collection of records together can make them more valuable than one of the records may appear on its own.  *Feedback is welcome on the use of MatchGrade extension to help provide additional detail.*   

> **NOTE:** Although some systems may employ referential matching capabilities or other industry-established practices, methods for determining match and the use of any specific algorithms to produce results in which a responder is sufficiently confident to appropriately return results are out of scope for this IG. 

#### Consumer Match 

The term "match" used in this Implementation Guide always involves matching demographics and/or an identifier to a unique person; usually that person is the patient a transaction is about (the person whose data is being requested). In workflows where health data is not being released to a HIPAA Covered Entity, this guidance involves matching on demographics for the requester who is the patient, their authorized representative, or another third party who may as well be an unknown consumer. Under those conditions, the match confidence must meet a higher minimum bar and the additional requirements in this section **SHALL** apply. 

The quality of the match, along with the user's consent, verified demographics stored by responder for the authorized representative(s) of the patient, and identity and authentication assurance levels, inform the responder's decision about whether to authorize access to data subsequent to this Consumer Match and is based on verified attributes provided by the requester who, for example via OIDC on the wire, **SHALL** also be evaluated by the responder to confirm it is trusted to have authenticated the individual corresponding to those demographics. 

In an even more specific workflow, the patient whose data is being requested is different from the user who is the requester; in this case a high-confidence match on the patient's demographics is required in addition to user-level matching on the authorized representative as described in the previous paragraph. This second Consumer Match **SHALL** meet the same recommended minimum bar as the match performed on the user's demographics--in both cases match input weight of at least 10, including L1 invariant data (or equivalent), and IDIAL1.8/AAL2 identity and authentication assurance. 

The B2B with User Authorization Extension Object **SHALL** be used by client apps following client credentials grant to provide additional information regarding the context under which the client is requesting authorization. The client app constructs a JSON object containing the following keys and values and includes this object in the extensions object of the Authentication JSON Web Token (JWT), as per [UDAP Security 5.2.1.1](http://hl7.org/fhir/us/udap-security/STU1/b2b.html#b2b-authorization-extension-object), as the value associated with the key name hl7-b2b-user. The same requirements for use of hl7-b2b apply in the use of hl7-b2b-user.

<table class="table">
  <thead>
    <th colspan="3">B2B with User Authorization Extension Object<br>Key Name: "hl7-b2b-user"</th>
  </thead>
  <tbody>
    <tr>
      <td><code>version</code></td>
      <td><span class="label label-success">required</span></td>
      <td>
        String with fixed value: <code>"1"</code>
      </td>
    </tr>
    <tr>
      <td><code>purpose_of_use</code></td>
      <td><span class="label label-success">required</span></td>
      <td>
        An array of one or more strings, each containing a code identifying a purpose for which the data is being requested. For US Realm, trust communities <strong>SHOULD</strong> constrain the allowed values, and are encouraged to draw from the HL7 <a href="http://terminology.hl7.org/ValueSet/v3-PurposeOfUse">PurposeOfUse</a> value set, but are not required to do so to be considered conformant. See <a href="http://hl7.org/fhir/us/udap-security/STU1/b2b.html#preferred-format-for-identifiers-and-codes">UDAP Security 5.2.1.2</a> for the preferred format of each code value string array element.
      </td>
    </tr>
    <tr>
      <td><code>user_person</code></td>
      <td><span class="label label-success">required</span></td>
      <td>
        FHIR Person resource with all required fields populated as per Person Resource Profile for FAST ID
      </td>
    </tr>
    <tr>
      <td><code>consent_policy</code></td>
      <td><span class="label label-warning">optional</span></td>
      <td>
        An array of one or more strings, each containing a URI identifiying a privacy consent directive policy or other policy consistent with the value of the <code>purpose_of_use</code> parameter.
      </td>
    </tr>
    <tr>
      <td><code>consent_reference</code></td>
      <td><span class="label label-warning">conditional</span></td>
      <td>
        An array of one or more strings, each containing an absolute URL consistent with a <a href="https://www.hl7.org/fhir/R4/references.html#literal">literal reference</a> to a FHIR <a href="https://www.hl7.org/fhir/R4/consent.html">Consent</a> or <a href="https://www.hl7.org/fhir/R4/documentreference.html">DocumentReference</a> resource containing or referencing a privacy consent directive relevant to a purpose identified by the <code>purpose_of_use</code> parameter and the policy or policies identified by the <code>consent_policy</code> parameter. The issuer of this Authorization Extension Object <strong>SHALL</strong> only include URLs that are resolvable by the receiving party. If a referenced resource does not include the raw document data inline in the resource or as a contained resource, then it <strong>SHALL</strong> include a URL to the attachment data that is resolvable by the receiving party. Omit if <code>consent_policy</code> is not present.
      </td>
    </tr>
  </tbody>
</table>

Example [Person Resource Profile for FAST ID](StructureDefinition-FASTIDUDAPPerson.html).

&emsp;   

### Verification 

It is helpful to know the date that attributes were verified, particularly in the case of address and mobile number since those attributes change over time. Future versions of this IG will likely include a grammar for indicating verification date in match transactions, as well as the evidence that may be used to verify individual demographic attributes or entire identities. This information may also be applied to Patient Weighted Input Information. 

The identity verification level performed to establish matching attributes is another meaningful piece of information to convey in a transaction; for an example of how to include the level of identity and authentication assurance in an OpenID Connect user profile, see the section on [Digital Identity]. 

When attributes like email address and telephone number are verified as associated with a patient, that information helps to bootstrap new account creation and (if needed) account recovery.  

An API from USPS may be helpful in verifying individual street addresses in future versions of this IG.  

Currently, National Provider Identifier (NPI) records can be used to verify provider names, addresses, and telephone numbers. 

&emsp;     

### Recommended Best Practices 

It is a best practice to include all known (required + optional) patient matching attributes in a match request (e.g., USCDI Patient Demographics); the table below indicates examples of attributes and levels of verification for consideration in different use cases: 

| **Minimum Included Attributes**                     | **Attribute Verification in B2B TPO  Workflow**               | **Attribute Verification in App-Mediated B2B with Patient User Workflow**      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ((First Name and Last Name) or DOB) and unique Enterprise Identifier | IDIAL1.5; onlyCertainMatches and count=1  required for patient care delivery, coverage determination, or  billing/operations | N/A; see below instead                              |
| First, Last, DOB, full (normalized as a best practice) street address | Same as above | N/A; see below instead |
| First, Last, DOB, Digital Identifier      | Same as above    | Identifier is established based on [IDIAL1.8  requirements](guidance-on-identity-assurance.html#best-practices-for-identity-verification) and First, Last are consistent with evidence |
| First, Last, DOB, Current Address, City, State, Medical Record Number and Assigner    | Same as above             | Verifiable patient attributes within a match request are consistent with the IDIAL1.8 or greater  identity verification event |
| First, Last, DOB, Current Address, Zip, Insurance Member ID, Payer ID             | Same as above       | Verifiable patient attributes within a match request are consistent with the IDIAL1.8 or greater  identity verification event |
| First, Last, DOB, mobile number and email address          | Same as above      | Verifiable patient attributes within a match request are consistent with the IDIAL1.8 or greater identity verification event (confirming control of a mobile number satisfies the verification requirement in this example, if mobile number was not one of the two Fair pieces of evidence used to meet identity verification requirements) |

Patient Match is not expected to enforce the minimum included attributes listed above. However, when a minimum combination of attributes is supplied, Patient Match **SHOULD** find matching candidates if they exist. Under the hood, this is a requirement on the indexing capability for Patient Match to locate candidates before evaluating them. When something less than the minimum is supplied, Patient Match **MAY** return no candidates, even if matching candidates exist.  

- For example, a bare name might theoretically match no candidates or an overwhelming number of candidates. In this case, Patient Match may return no candidates, even if matching data exists. A simple phone number may or may not be enough for Patient Match to find candidates - that is left up to the implementation. 

Patient Match is expected to supply a Patient resource conforming to the Patient profile(s) defined within this IG to [$IDI-match] and entering as much information as possible is encouraged. However, requesters **SHOULD NOT** include elements whose value is unknown, since that may eliminate potential matches where the responder's system contains that information. More information helps find the right candidate and disambiguate cases where there are several candidates. This implies that Patient Match is not simply a matter of finding a candidate that exactly matches all the given demographics.  Requiring a match on every included attribute tends to discourage entering more information because the user cannot know exactly which demographics will appear in the existing Identities.  

- For example, a user should enter an address even if they are worried the patient has moved and the search will fail to find the patient at the old address. 

When onlyCertainMatches are requested, responders **SHOULD** return only results which are an exact match on Last Name and First Name, where exact means there is at most a single character or two character (for example, a transposition error) difference between the Name in the match request and the name associated with the Identity(ies) or the set of records identified as matches in the responding system. Ideally the industry will work toward developing a reliable, publicly-available list of nickname associations and common misspellings that, combined with stepped up best practices in identity verification by both requesters and responders, would support requiring such exact matches in future versions of this IG. 

Patient Match **SHOULD** be in terms of groups of records that have been partitioned prior to the Patient Match call into Identities -- groups of records that are thought to represent people.  

- For example, a candidate Identity that has the right address in one record, the right name in another, and the right telephone in another could be a strong candidate, even though no single record contains all the given information.   

Names are verified at a point in time and previous names are often useful in matching. However, best practices include periodic reverification, and it is generally expected that First and Last names reflect current names. Best practice data stewardship expects previous names to be designated as such within the Patient resource. Appropriate use of Patient.name.use and Patient.name.period are expected for use of previous names. 

Although it is possible to request a match with only First or only Last Name and still be compliant with this IG, the example [Invariants](artifacts.html) highlight minimum thresholds for the primary use cases where this is expected to occur. 

To request a match on a patient with a single legal name, known as a mononymous individual, requesters **SHOULD** use that name in the Last name field and leave the First name NULL. 

When it is permitted by [$IDI-match] or other match transaction types, and if the requester is using a profile that includes these, additional matching information can be included as input extensions or contained resources within the Patient resource. For example, current occupation data for health attributes from Resource Profile: Past Or Present Job as per the [Occupational Data for Health (ODH)](http://hl7.org/fhir/us/odh/) set of profiles on Observation resource, **SHOULD** be included by requesters since this information is useful to matching. 

Patient Match need not support wildcards, unlike the usual FHIR search mechanism. 
 
The section below provides example weight values that a match requester can use along with specialized patient resource profiles to indicate their intent to follow pre-defined minimum match input requirements.  

<div class="stu-note" markdown="1"> 
The workgroup invites suggestions from commenters regarding the use of Artificial Intelligence and Referential Matching in identity and matching. For example, should attributes not claimed by an individual be added to a record, match input request, and/or match result based on identity management resources even if those attributes were not part of a Declaration of Identity assertion by the individual? In what cases would this be acceptable? Is the guidance different when resources are authoritative or are derived from authoritative sources (such as credit bureau type records)? Are there other generative workflows or types of intelligent systems for which guidance would be helpful?
</div> 

&emsp; 


### Patient Weighted Input Information 

&emsp;&emsp;*(The information and values included here serve as an example of weights that may be adopted to achieve various threshold levels responders' systems may choose to require when performing person matching with a desired degree of certainty.)* 

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
| 4          | Address (including line plus zip or city and state), telecom email, telecom phone, identifier (other than Passport Number, DL, other State ID, or Digital Identifier--for example, last 4 of SSN, Insurance Member Identifier along with Payer Identifier, or Medical Record Number along with Assigner) or [Individual Profile Photo](guidance-on-identity-assurance.html#individual-profile-photo) (max weight of 5 for inclusion of 2 or more of these) |
| 3          | First Name and Last Name       |
| 2          | Date of Birth       |
|0          | SSN (complete) |
|0          | Insurance Member Identifier |
|0          | SSN (last 5) |
|0          | Insurance Subscriber Identifier |
|0          | Previous First Name & Last Name       |
|0          | Nickname or Alias       |
|0          | First Name       |
|0          | Last Name       |
|0          | Middle Name (Including initial)       |
|0          | Address City and State       |
|0          | Address Zip        |
|0          | Sex (Assigned at Birth)       |
|0          | Sexual Orientation       |

&emsp;&emsp;

In cases where Address is not a single-family residence–for example, an apartment building without unit number, hospital, or homeless shelter–the alternative inputs are particularly important. 

This guide provides multiple profiles of the Patient resource to support varying levels of information to be provided to the [$IDI-match] operation.  Patient Match **SHALL** support a minimum requirement that the *[IDI Patient]* profile be used (base level with no information "weighting" included).  More robust matching quality will necessitate stricter data inclusion requirements and, as such, Patient Match **SHOULD** use profiles supporting a higher level of data inclusion requirements (i.e., whereas *[IDI Patient L0]* may be suitable for use cases in which returning multiple match results is acceptable, *[IDI Patient L1]* indicates an input weight threshold that is expected to only result in matches on the individual whose identity was verified at the minimum level required by this IG for consumer-facing match requests (IDIAL1.8/AAL2) and that attributes provided in the match request are confirmed to be consistent with). 

Trust communities may have specific requirements about minimum attributes, but in the absence of such requirements, the minimum attribute requirements of the L0 invariant are intended to reflect what may be appropriate for probabilistic searches in which requesters are HIPAA Covered Entities, and the minimum attribute requirements of the L1 invariant are intended to reflect what may be appropriate for deterministic searches in which requesters are potentially returning PHI to the consumer/patient who is the subject of a query (or their authorized representative).  

This IG does not intend to set requirements on the use of HumanName.family and HumanName.given in lieu of HumanName.text, though for purposes of clarity we generally refer to First name and Last name (Surname) since some requirements depend on that level of granularity. Systems compliant with this IG **SHALL** recognize that [HumanName.text](https://www.hl7.org/fhir/datatypes-definitions.html#HumanName.text) may be provided instead of or in lieu of HumanName.family and HumanName.given. 

<font color="Black"><b>NOTE:</b> It is important to remember that this weighted information guidance is ONLY applicable to the Patient resource instance provided as input to a match request and does not pertain in any way to the matching process or results returned from it. Data elements with weight indicated as "0" are known to be valuable in matching but were not identified as contributors to the defined example weight input tiers.</font>  

&emsp;    

### Golden Records 

The concept of matching Identities is best kept separate from the notion of a [Golden Record](glossary.html). Many organizations use a Golden Record to capture all the correct and current information for a Patient while suppressing information that is thought to be out-of-date or incorrect. Often, such a Golden Record simply omits older inconsistent information such as an address. While the FHIR Patient resource can represent both current and old names, addresses and telecoms, its restriction on birthDate limits the representation to only one. A record partitioning system behind Patient Match may decide that two records with different birthDates represent the same person, but may not be able to know which of the birthDates is correct. Ideally, Patient Match would be able to find and appropriately evaluate such a candidate, regardless of which birthDate appears on the Golden Record. 

At this time, we are not expecting match responders to organize identities according to the same standards match requesters are held to today, though at a minimum, unless noted otherwise, responding systems SHALL organize records on unique individual identities verified at IDIAL1.5 or higher and SHOULD match only on attributes verified at that level or higher, as established in the Guidance on Identity Assurance and Patient Matching sections of this guide. 

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

Common correlations such as families **SHALL** be modeled (specific recommendations are invited). 

Scores **SHOULD** be computed, not guessed, whenever possible. 

The table below which designates a grading of match quality **SHOULD** be used to inform responder's search quality scoring algorithm, so that the search score returned by a responder is meaningful to the requester (This grading score **SHOULD** be conveyed within the Bundle.entry.search.score element); feedback is requested on the ability of a responder to compute and return such a score, as well as the potential value of such a quality score to requesters. The Good level generally corresponds to traits the [Sequoia Initiative](https://sequoiaproject.org/resources/patient-matching/) estimates to be 95-98% unique, and Very Good corresponds to traits that are 98-99.7% unique. Superior matches include matching information that is even more likely to indicate a unique individual, while Best matches involve a match on a government- or industry-assigned identifier.  

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
|Best       |  .99       | (First name & Last Name OR Date of Birth) & (Responder's MRN/MPI or known Digital Identifier)       |
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

### Attribute Applicability
The table below provides guidance to assist in determining whether attributes from a requestor or responder are applicable to requirements of this IG, for example, as may be designated using FHIR code systems. These attribute types and per-field matches directly influence the scoring rubrics outlined in this IG.

Implementers evaluate the information in a requestor's Patient resource (or other match input attributes) and/or in responder's system to determine whether the specific conditions for [match output scoring](patient-matching.html#scoring-matches--responders-system-match-output-quality-score) or [match input weight](patient-matching.html#patient-weighted-input-information) are met. This table is not intended to constitute a complete or exclusive list--for example, a responder may understand a given identifier.system as an MRN, even if the identifier does not have a type of 'MR'.

| **Attribute** | **FHIR Representation** |
| :----------: | ---------------------------- |
| MRN | Patient.identifier.type.coding.system == 'http://terminology.hl7.org/CodeSystem/v2-0203' and Patient.identifier.type.coding.code == 'MR' AND both identifiers have the same Patient.identifier.system |
| MBI | Patient.identifier.system == 'http://hl7.org/fhir/sid/us-mbi' |
| Digital Identifier (HL7Identifier) | Patient.identifier.system == 'http://hl7.org/fhir/us/identity-matching/ns/HL7Identifier' |
| Driver's License Number and Issuing US State | Patient.identifier.type.coding.system == 'http://terminology.hl7.org/CodeSystem/v2-0203' and Patient.identifier.type.coding.code == 'DL' and both identifiers have the same Patient.identifier.system, which specifies the Issuing US State, e.g. urn:oid:2.16.840.1.113883.4.3.12 ([more information in Identifier Registry](https://hl7.org/fhir/R4/identifier-registry.html)) |
| Other State ID and Issuing US State | Patient.identifier.type.coding.system == 'http://hl7.org/fhir/us/identity-matching/CodeSystem/Identity-Identifier-cs' and Patient.identifier.type.coding.code == 'STID'  AND both identifiers have the same Patient.identifier.system |
| Passport Number and Issuing Country | Patient.identifier.type.coding.system == 'http://terminology.hl7.org/CodeSystem/v2-0203' and Patient.identifier.type.coding.code == 'PPN' AND both identifiers have the same Patient.identifier.system, which specifies the Issuing Country, e.g. http://hl7.org/fhir/sid/passport-USA, from [External Identifier System](https://terminology.hl7.org/identifiers.html) |
| SSN | Patient.identifier.system == 'http://hl7.org/fhir/sid/us-ssn' |
| SSN (last 4) | Patient.identifier.type.coding.system == 'http://hl7.org/fhir/us/identity-matching/CodeSystem/Identity-Identifier-cs' and Patient.identifier.type.coding.code == 'SSN4' |
| Organization's NPI | Organization.identifier.system == 'http://hl7.org/fhir/sid/us-npi' |
| Practitioner's NPI | Practitioner.identifier.system == 'http://hl7.org/fhir/sid/us-npi' |
| Insurance Member ID | Patient.identifier.type.coding.system == 'http://terminology.hl7.org/CodeSystem/v2-0203' and Patient.identifier.type.coding.code == 'MB' AND both identifiers have the same Patient.identifier.system |
| Insurance Subscriber ID | Patient.identifier.type.coding.system == 'http://terminology.hl7.org/CodeSystem/v2-0203' and Patient.identifier.type.coding.code == 'SN' AND both identifiers have the same Patient.identifier.system |

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
