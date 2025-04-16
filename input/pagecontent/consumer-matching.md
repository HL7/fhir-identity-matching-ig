### Overview   

This guidance is intended to apply to other consumer matching workflows including non-FHIR transactions. Use of other (non-FHIR, non $match) matching methods (implementations) that result in comparable or higher matching rates is not precluded by this guidance. Realizing that a better-formed match request produces the most reliable results, this implementation guide (IG) also includes a [Guidance on Identity Assurance] section as a companion resource to this best practice patient matching. 

> **NOTE:** As security is generally out of scope for this guide, the conditions required to share personally identifiable information (PII) or to authorize an organization's or an individual’s, including the patient’s own, access to the results of a match request are not specified completely in this guide, nor should they be inferred.  However, patient-initiated workflows (for example, "patient request" purpose of use) **SHALL** always include explicit end-user authorization.    

&emsp;    

### Match Requirements 

When transmitting identity attributes to third parties with whom sharing PII is permitted, such as:  

- within an OpenID Connect user profile, another user information request to an Identity Provider, or the resultant assertion/claim,  
- within an HL7 B2B with User Authorization Extension Object, or  
- as part of a match or search request, 

and a level of identity assurance is indicated, each included identity attribute **SHALL** either have been verified at the identity level of assurance asserted by the transmitting party (for example, the match requestor) or be consistent with other evidence used in that identity verification process completed by that party. If a level of assurance is not explicitly asserted, the combination of identity attributes submitted **SHOULD** be consistent with, and sufficient to on their own  resolve to the identity of a unique person in the real world. Specifically, identity verification **SHALL** be performed at IDIAL1.5 or higher level of identity assurance per this IG's [Guidance on Identity Assurance] (e.g., a first name, last name, date of birth [DOB], mobile number, and home street address have been verified as belonging to the individual OR a first name, last name, and a Digital Identifier compliant with this IG have been verified as belonging to the individual), consistent with the practices of NIST 800-63A using Fair or stronger evidence and/or credit bureau type records (or equivalent), and consistent with [Guidance on Identity Assurance].  

As a best practice, identity verification **SHOULD** be at a minimum of IDIAL2 or  [LoA-3](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-63-2.pdf) for professionals who are end users of health IT systems and for an implementer's overall operations.  

Individual Access (or if protected health information [PHI] or PII will be returned, other than to a Covered Entity in a Treatment, Payment, or Operations workflow) is outside the scope of this IG's Patient Matching requirements. Instead, responders to such queries **SHALL** authenticate the individual before returning PHI or PII. 

Security best practices, including transaction authorization, are generally out of scope for this IG; however implementers also **SHALL NOT** allow patients to request a match directly. A trusted system may request a match on a patient’s behalf and use it to inform the patient, especially to:  

- Recognize that the patient already has an account (when a record represents an account) 
- Recognize that a patient may have multiple identities within the system, leading to a fragmented medical record 
- Recognize that a patient’s identity might have spurious records from other people mixed in 
- Help remediate these situations without exposing PHI/PII 

For sharing immunization records only, patient matching **MAY** be performed using identity attributes verified at IDIAL1.2 or higher by both requesting party and responder. 

#### Match on Identities 

While FHIR systems often expect to have only one Patient Resource per actual patient, some systems may normally have many records for the same patient, typically originating from many disparate systems such as clinics, insurance companies, labs, etc. In this scenario, the Patient resources are typically already linked via automatic matching into sets of Patient Resources using [Patient.link](https://www.hl7.org/fhir/patient-definitions.html#Patient.link), where each set represents a specific patient in the opinion of the MPI system. In such a system, the patient match **should** be performed against the sets of records as opposed to the individual records. For example, if five records are currently believed to represent the same patient, a search for that patient would find the set of five and consider that as one candidate as opposed to five candidates. Moreover, that search would benefit from all of the information in the set. For example, consider a set of five linked Patient records currently in the system and a Patient input to a $match operation that includes a name, birthdate, telephone and [MBI](https://build.fhir.org/ig/HL7/fhir-identity-matching-ig/glossary.html) such that the $match input Patient: 

- name matches Patient 1 but is somewhat different from Patients 2-5 
- birthdate matches all five of them 
- telephone matches Patient 3 and is not present in Patients 1,2,4,5 
- MBI matches Patient 5 and is absent in patients 1-4 

Then the strength of the match for that single candidate should consider all the matching information as opposed to either each record individually or some aggregation of the information in the records that tries to subset it to the “correct” information only (a “golden” record). 

Asking for at most four results to be returned in a match request may mean more than four actual Patient resources returned, if the responding system has not mapped one identity to one record. This results in two options: 

1. In this case, only the requested number of identities are returned and the requester can ask for all resources or some subset, as needed.  
2. All applicable records are returned; a different threshold on number of records returned could be considered instead. 

    Note that a collection of records together can make them more valuable than one of the records may appear on its own.  *Feedback is welcome on the use of MatchGrade extension to help provide additional detail.*   

> **NOTE:** Although some systems may employ referential matching capabilities or other industry-established practices, methods for determining match and the use of any specific algorithms to produce results in which a responder is sufficiently confident to appropriately release are out of scope for this IG. 

#### B2B with User Authorization Extension Object 

The B2B with User Authorization Extension Object is used by client apps following the client_credentials flow to provide additional information regarding the context under which the request for data is authorized. The client app constructs a JSON object containing the following keys and values and includes this object in the extensions object of the Authentication  JSON Web Token (JWT), as per [UDAP Security 5.2.1.1](http://hl7.org/fhir/us/udap-security/STU1/b2b.html#b2b-authorization-extension-object), as the value associated with the key name hl7-b2b-user. The same requirements for use of hl7-b2b apply in the use of hl7-b2b-user.

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

Example Person Resource Profile for FAST ID:

&emsp;   

### Verification 

It is helpful to know the date verification of attributes was performed, in the case of address and mobile number since those attributes change. Future versions of this IG will likely include a grammar for indicating verification date in match transactions, as well the evidence used to verify individual demographic attributes or entire identities. This information may also be applied to Patient Weighted Input Information. 

The identity verification level performed to establish matching attributes is another meaningful piece of information to convey in a transaction; for an example of how to include level of identity and authentication assurance in an OpenID Connect user profile, see the section on [Digital Identity]. 

When attributes like email address and telephone number are verified as associated with a patient, that information helps to bootstrap new portal account creation and (later) account recovery.  

An API from USPS may be helpful in verifying individual street addresses in future versions of this IG.  

Currently, National Provider Identifier (NPI) records can be used to verify provider names, addresses, and telephone numbers. 

&emsp;&emsp; 

 

{% include link-list.md %} 
