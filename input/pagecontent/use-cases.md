This section provides a detailed description on identity workflows outlined in this IG. We have divided these workflows into two groups: Core Identity workflows and Use Case workflows. 

Although some use cases focus on scenarios where the Identity Provider is unrelated to the FHIR client or server, it is true in every one of these use cases that the Identity Provider role can be performed by an organziation or system that is distinct from that of the client, FHIR server and Authorization Server common to these transactions.

### Core Identity Workflows

#### Identity Proofing Workflow

Description: Verify individual identity according to requirements in the [Guidance on Identity Assurance](guidance-on-identity-assurance.html).

Actors: Individual, Identity Provider (native to the FHIR server or that is intended to be trusted by a relying party FHIR server)

Pre-Conditions: The individual is not known by the Identity Provider at the required level of assurance, for example because the organization's documented identity verification process was not used, or the process was not completed by an individual in the organization's workforce.

Workflow (refer to the [Guidance on Identity Assurance](guidance-on-identity-assurance.html) section for complete details:

1.	Establish the level of assurance required based on risk assessment and the sensitivity of the resources being accessed (specifically, identity **SHALL** be verified at IAL2 if the individual is a professional user at HIPAA Covered Entity organization who will engage in B2B transactions, at IDIAL1.5 if the individual is a patient whose demographics will be included in a match request to HIPAA Covered Entity organizations or whose medical record will be managed by a system, but for whom an HL7 Person Identifier will not be created, or at at least IDIAL1.8 if the individual is a patient or an authorized representative of a patient whose demographics will be included in a match request that results in sharing PII or PHI with anyone who is not a HIPAA Covered Entity, or if an HL7 Person Identifier will be created for the individual).
2.	Gather sufficient evidence to verify the identity of the individual.
3.	Confirm that the provided evidence is genuine and accurate by validating the authenticity of identity documents using trusted sources or databases and information on the evidence.
4.	Ensure the person presenting the identity evidence is the legitimate owner of that identity, according to [this guidance](guidance-on-identity-assurance.html#best-practices-for-identity-verification) and [NIST 800-63](https://pages.nist.gov/800-63-3/) Digital Identity Guidelines, and the intended level of assurance
5.	Consider [Digital Identifier](digital-identity.html#requirements-for-digital-identifiers-for-individuals) creation, including generating an HL7 Person Identifier and binding the identity to a credential that includes an authenticator, as part of this same encounter--this allows the individual to authenticate themselves without repeating the entire identity verification process.

Outcome: The individual's identity has been successfully verified. If Digital Identifier creation was performed, an HL7 Person Identifer now exists for the individual.

#### Digital Identifier Creation

Description: These steps can be layered on to an Identity Proofing Workflow to create a compliant HL7 Person Identifier 

Actors: Individual, Identity Provider

Workflow:

1.	Identity Provider **SHALL** work with Individual to complete an IDIAL1.8 or greater identity verification process per Identity Proofing Workflow.
2.	Identity Provider **SHALL** generate and bind Individual's Digital Identifier to an OpenID Connect credential (or equivalent) with AAL2 authentication assurance. 
3.	The resultant Digital Identifier **SHALL** then be associated with Individual in the Identity Provider's system as an HL7 Person Identifier; if the Identitiy Provider's system is a medical record the HL7 Person Identifier is persisted as a FHIR Patient.identifier with "http://hl7.org/fhir/us/identity-matching/ns/HL7PersonIdentifier" as its Identifier.system. The Digital Identifier **SHALL** be shared, when authorized by the individual, with other systems as the Individual's hl7_identifier when included as part of a Match Workflow.

#### Match Workflow

Description: This use case is invoked to determine whether an individual described by the Requesting system is known to the Receiving System. The Requesting System identifies in the match workflow, through methods beyond the scope of this guide, whether it is describing only a Patient whose medical records are sought and/or another User. 

Actors: Requesting System, Receiving System, and optionally an Individual User who may be a Patient or Authorized Representative (required in certain transaction types)

Pre-conditions:

- Requesting system can generate a FHIR Patient resource conformant to one of the IDI profiles (Base, L0, L1, L2) established in this guide (or equivalent, for non-FHIR transactions).
- Requesting System and Receiving System are capable of communication via FHIR API (or equivalent)
- Requesting System, or its individual user, is authenticated and authorized to perform the transaction
- Receiving system is able to run both weighting and scoring processes found on the [Patient Matching] page

Workflow:

1.	The requesting system initiates a match request to the receiving system’s FHIR endpoint (or equivalent). When data will be returned to a HIPAA Covered Entity, the L0 invariant, input weight score of at least 9, and attributes verified at IDIAL1.5, or higher quality match request **SHALL** be made. When the requester is not a HIPAA Covered Entity or a single high confidence match is otherwise required (because the system user is a Patient or their Authorized Representative), the L1 invariant with input weight score of at least 10, attributes verified at IDIAL1.8, and AAL2 authentication of the individual or higher quality match request **SHALL** be made (optimally the L2 invariant with input weight score of at least 10, attributes verified at IAL2/IDIAL2, matching on the HL7 Person Identifier as one of these attributes, and AAL2 authentication of the individual **SHOULD** be used for such a Consumer Match.)
2.	The receiving system runs a weighting algorithm to determine if the Patient resource found in the request meets the minimum value asserted in the IDI profile and required for the workflow. NOTE: If a Consumer Match is requested and the HL7 Identifier is used along with First Name, Last Name, and Date of Birth, and the receiving system can match on this information, this eliminates the need for additional verified demographics as required by [Patient Weighted Input Information](patient-matching.html#patient-weighted-input-information).
3.	The receiving system takes the match request and runs their own matching algorithm against the database of identities they manage to determine if there are one or more matches.
4.	The receiving system responds (if appropriate) to the requesting system with the relevant Patient resource(s) in a FHIR Bundle, or otherwise as per the match transaction specifics (whether FHIR or non-FHIR).

Outcome: Requesting system has obtained a valid FHIR Bundle (or equivalent) containing matched FHIR Patient resource(s) or a “No Match Found” response (if the receiving system was unable to locate any matching Patient resources), or an authentication response (if the match request was embedded into an authentication transaction).


&emsp;&emsp;

### Use Case Workflows  

#### Patient-Directed B2C (intrinsic OAuth service)

Actors: Patient or Authorized Representative (User), Patient-Chosen App, Authorization Server, FHIR Server, FHIR Server's Identity Provider (native to the system or contracted such that the system takes responsibility for the services of Identity Provider)

Description: Patient or their authorized representative authorizes action such as third-party application's access to a patient’s data as in the SMART App Launch Patient Access workflow (or equivalent) using their credentials issued by the data holder organization (or its tightly-coupled Identity Provider) to authenticate the user.  The use case is relevant in some TEFCA Individual Access Services contexts, but applies broadly when authentication of an individual is required, such as a request for restrictions (part of view, download, and transmit to 3rd party) or another transaction needing digital consent.

Pre-Conditions:
- The Patient (or Authorized Representative User) registered for an account and their identity was verified by a physician’s office (or their software system, or another organization sharing a system and identity management practices) as per the Core Identity Workflows.
- The Patient (or Authorized Representative User) identity is known to the Identity Provider.
- The patient’s HL7 Person Identifier (optional) was assigned by the Identity Provider

Workflow:
1.	A user wishes to access their health information through an app of their choice (Patient Chosen App).
2.	HL7 UDAP JWT-Based Authentication B2C is used to register and authenticate the Patient Chosen App in a way that is securely scaled (optional).
3.	User authorizes data flow to Patient Chosen App.
4.	User authenticates with their credentials issued by the Identity Provider for practice's system (following SMART, etc. as usual).
5.	User completes necessary prompts, creating a credential with the Identity Provider associated with the health record if it did not yet exist or resetting the authenticator(s) associated with the credential if needed and invoking the Identity Proofing Workflow, Match Workflow, and Digital Identity Creation Use Cases, as applicable.
6.	The usual requirements for a Consumer Match apply to establishing or reestablishing the authenticator for the account and assigning an HL7 Person Identifier to the identity of the patient and/or authorized representative by the system of record with which the FHIR server is associated. 

<div>
<figure class="figure">
    <img src="patient-directed-b2c.png" alt="Patient-Directed B2C" title="Patient-Directed B2C" class="img-responsive img-rounded center-block" width="75%">
    <figcaption class="figure-caption"><strong>Patient-Directed B2C</strong></figcaption>
</figure>
<p></p>
</div>



##### Patient-Directed B2C with Tiered OAuth

Actors: Authorized Representative (User) OR Patient, Patient-Chosen App, Authorization Server, FHIR Server, FHIR Server's Identity Provider, Additional Third-Party Identity Provider

Description: Patient or their authorized representative authorizes a third-party application to access patient's data as in the SMART App Launch workflow (or equivalent) using trusted credentials from a third-party Identity Provider (in this example, as per Unified Data Access Profiles (UDAP) Tiered OAuth for User Authentication) to authenticate the user.

Pre-Conditions:
- The Patient (or Authorized Representative User) registered for an account and their identity was verified by a physician’s office (or their software system, or another organization sharing a system and identity management practices) AND by a third-party Identity Provider as per the Core Identity Workflows
- The Patient (or Authorized Representative User) identity is known to both Identity Providers
- The patient’s HL7 Person Identifier (optional) was assigned by either or both Identity Providers

Workflow:
1.	A user wishes to access their health information through an app of their choice (Patient-Chosen App).
2.	HL7 UDAP JWT-Based Authentication B2C is used to register and authenticate the Patient-Chosen App in a way that is securely scaled (optional).
3.	User authorizes data flow to Patient-Chosen App.
4.	User authenticates with their credentials issued by the third-party Identity Provider (following SMART, etc. as usual).
5.	User completes necessary prompts, creating a credential with the thrid-party Identity Provider if it did not yet exist or resetting the authenticator(s) associated with the credential if needed and invoking the Identity Proofing Workflow, Match Workflow, and Digital Identity Creation Use Cases, as applicable.
6.	The usual requirements for a Consumer Match apply to establishing or reestablishing the authenticator for the account, assigning an HL7 Person Identifier to the identity of the patient and/or authorized representative by the third-party Identity Provider AND the system of record with which the FHIR server is associated (optional), and confirming that the user authenticated by the third-party Identity Provider is the expected authorized representative or patient according to identity management practices of the system of record that conform with this IG. 

<div>
<figure class="figure">
    <img src="patient-directed-b2c.png" alt="Patient-Directed B2C" title="Patient-Directed B2C" class="img-responsive img-rounded center-block" width="75%">
    <figcaption class="figure-caption"><strong>Patient-Directed B2C</strong></figcaption>
</figure>
<p></p>
</div>

##### Patient-Directed B2C with mDL

Actors: Authorized Representative (User) OR Patient, Patient-Chosen App, Authorization Server, FHIR Server, Identity Provider supporting OpenID4VP and WebauthN

Description: Patient or their authorized representative authorizes a third-party application to access patient's data as in the SMART App Launch workflow (or equivalent) using their mDL to authenticate themselves. This use case leverages mDLs along with OpenID4VP and WebauthN, consistent with current NIST NCCoE Mobile Driver's License Project Draft Use Case Criteria (https://pages.nist.gov/nccoe-mdl-project-static-website/criteria.html) or future published NIST guidance

Pre-Conditions:
- The Patient (or Authorized Representative User) registered for an account and their identity was verified by a physician’s office (or their software system, or another organization sharing a system and identity management practices) AND by a third-party Identity Provider as per the Core Identity Workflows
- The Patient (or Authorized Representative User) posesses a state-issused mDL in a compliant digital wallet

Workflow:
1.	A user wishes to access their health information through an app of their choice (Patient-Chosen App).
2.	HL7 UDAP JWT-Based Authentication B2C is used to register and authenticate the Patient-Chosen App in a way that is securely scaled (optional).
3.	User authorizes data flow to Patient-Chosen App.
4.	User authenticates with their mDL.
5.	User completes necessary prompts, invoking the Identity Proofing Workflow, Match Workflow, and Digital Identity Creation Use Cases, as applicable.
6.	The usual requirements for a Consumer Match apply to confirming that the user authenticated per NIST guidance is the expected authorized representative or patient according to identity management practices of the system of record that conform with this IG. 

#### Patient-Directed B2C Using Digital Identity from External Identity Provider and Optional HL7 Person Identifier

Description: This is a special case of Patient-Directed exchange that is also based on SMART App Launch workflow (or equivalent) in which a Digital Identifier assigned by a third-party Identity Provider is optionally used along with credentials from that Identity Provider (for example, as in HL7 UDAP FAST Tiered OAuth for User Authentication, publicly-available standards-based identity APIs such as OpenID Connect or authenticator APIs such as FIDO, or a NIST NCCoE-supported mDL workflow, as appropriate). The use case involves health data access such as in TEFCA Individual Access Services or other Patient Access workflow, but applies whenever authentication of an individual within the transaction is required, such as individual data access, consent management, credential step-up, or request for restrictions (part of view, download, and transmit to 3rd party).

Actors: Patient (User), Patient Chosen App (for example, FHIR client application operated by Insurance Company), Authorization Server and FHIR Server (Healthcare Organization), Identity Provider

Pre-Conditions:
- The patient registered for an account and their identity was verified by the Identity Provider at IDIAL1.8 or higher.
- The patient’s HL7 Person Identifier (optional) was assigned by the Identity Provider.
- The Identity Provider **SHALL** make publicly available their standards-based APIs, a conformant identity verification policy (for example, a Registration Practices Statement), and a Relying Party Agreement (such that private contracting with the Identity Provider is not required).
- The Identity Provider is trusted by any additional policies required by Healthcare Organization’s system.

Workflow:

1.	The patient, a user of Insurance Company’s app, authenticates to Healthcare Organization with the credential assigned by Identity Provider and bound to their Digital Identity, authorizes Identity Provider to share identity claims about them--conformant with this IG and optionally including their HL7 Person Identifier--with Healthcare Organization, and authorizes Healthcare Organization to share their health data with Insurance Company.
2.	If needed (because the HL7 Person Identifier is not yet known to Healthcare Organization and/or insufficient demographics are included in the Identity Provider’s claims), Healthcare Organization can contact the individual out of band for additional information or can request information, including real-time identity verification, through their intrinsic OAuth authentication prompt or equivalent.
3.	Because this strong identity assurance credential has been used to authenticate the individual, so long as sufficient demographics are included in the Identity Provider’s claims and based on its trust of Identity Provider, Healthcare Organization can confidently share the correct patient data with Insurance Company.

In another variation of this use case, the User is an Authorized Representative of the Patient.

&emsp;&emsp;   

#### App-Mediated B2B with Individual User (includes B2B Patient Request workflows)

Actors: User (Authorized Representative or Patient), B2B App, Authorization Server, FHIR Server

Description: This is a Business-to-Business use case, though ultimately health data is shared with a consumer. In this use case, a patient or their authorized representative uses a consumer-facing app, not necessarily operated by a HIPAA Covered Entity or Business Associate, to exercise their HIPAA Right of Access. When performed by a trusted participant under TEFCA, this use case is also referred to as an Individual Access Services. The identity of the patient or their authorized representative is verified at IDIAL1.8 or higher in accordance with this guide, and they are authenticated at AAL2 or higher prior, to capturing the consent or allowing their access to data. This use case relies on [UDAP Business-to-Business](https://hl7.org/fhir/us/udap-security/b2b.html) security model if health data is exchanged via FHIR. It is similar to Patient-Directed B2C Using Digital Identity from External Identity Provider and Optional HL7 Person Identifier, except that instead of explicitly authenticating the User as part of the transaction, an attestation from the Business initiating the query provides verified demographics about the User they have authenticated.

The workflow may be limited to a match with or without endpoint lookup (record location) or may also or instead be a health data request. Since the user's app is attempting to access patient id(s) and/or the patient’s health data without using a credential accepted by the data creator to authenticate themselves, the degree to which the organization operating the responding FHIR server trusts the B2B App is essential to their confidence in the B2B App's assertions about the User's identity, as is the quality of those identity claims, given that this is ultimately a B2C transaction. Note that this use case can be implemented for record location at one or more endpoints and a different use case employed for access to health data, or vice-versa.

Pre-conditions: 
- The Patient’s AND (if User is not Patient) the Authorized Representative’s identity **SHALL** be verified in accordance with this guide and at IDIAL1.8 or higher.
- The B2B App can themselves, or through a trusted Identity Provider, conform to Consumer Match requirements of this IG for the Patient AND (if User is not Patient) the Authorized Representative--sufficient match input demographics with input weight score of 10 or greater are available and were verified at IDIAL1.8 or greater; if the individual has a credential its authentication assurance is AAL2 or higher.

Workflow:
1.	A User would like to access a patient’s records via an app that is trusted by the responding system. The User authenticates themselves with a [Digital Identity](digital-identity.html#requirements-for-digital-identifiers-for-individuals) or equivalent (IDIAL1.8/AAL2) credentials.
2.	When the User initiates the query, the B2B App undergoes an [HL7 UDAP FAST Business-to-Business](https://hl7.org/fhir/us/udap-security/b2b.html) workflow, using its digital certificate or an equivalent method to authenticate to the responding system. The B2B App includes information about itself and its User within the B2B Authorization Extension Object and the B2B with User Authorization Extension Object included in its Authentication JWT (or for TEFCA IAS, the TEFCA IAS Authorization Extension Object), or in an equivalent manner if not an HL7 UDAP Business-to-Business workflow. Since this workflow involves a Consumer Match request, the user_person, user_information, or any OIDC ID Token elements within these Authorization Extension Objects SHALL contain only demographics that have been verified at IDIAL1.8 or higher or are consistent with other evidence used in the identity verification process performed by the party(ies) making identity claims, as per this IG’s [Consumer Match](patient-matching.html#consumer-match) requirements and other [Match Requirements](patient-matching.html#match-requirements). To reach the match input quality score minimum of 10, this generally means First Name, Last Name, Date of Birth, and two other demographics such as home address, email, mobile number, HL7 Person Identifier, or previous address. When OIDC ID Token elements signed by a third party are included in a transaction, the acr value SHALL be included to indicate the minimum level at which any included demographics have been verified (if in a SMART Health card or link, the level of identity assurance is included as per SMART). HL7 UDAP JWT-Based Authentication B2C with Tiered OAuth may be considered by implementers, to verify trust with and securely scale the use of third party Identity Providers while including the User explicitly within the transaction. 
3.	The identity of the B2B App and its User is evaluated by the Authorization Server by comparing the identity claims about the User (and Patient, if different) against the patients and authorized representatives whose identities they previously verified at IDIAL1.5 or higher to determine, if a Consumer Match exists and the B2B App and any included claims are trusted, which patient's or patients’ data the User is authorized to access. 
4.	When authentication is complete, an $IDI-match or equivalent request is made to the FHIR Server, again meeting Consumer Match requirements--match input weight score of 10 or greater, demographic attributes each verified at IDIAL1.8 or higher, and using the L1 invariant.
5.	The responder will undergo a weighting adjudication to determine the strength of the match request.
6.	If sufficient, the responder will then complete a Consumer Match against their patient database that includes identities responder has verified at IDIAL1.5 or higher.
7.	If there is a Consumer Match on the patient, and the User is authorized to access that patient's health data, the resultant Patient resource will be returned in a FHIR Bundle as per $IDI-match; otherwise, the bundle is empty. If an alternative workflow is used ($IDI-match, the appropriate patient data or “no match found” is returned.

OIDC ID Token Example

{ 
   "alg":"RS256", 
   "kid":"...", 
   "typ":"JWT" 
} 
{ 
   "aud":"...", 
   "iat":1666280632, 
   "iss":"https://generalhospital.example.com/as", 
   "sub":"328473298643", 
   "hl7_person_identifier":"123e4567-e89b-12d3-a456-426614174000a", 
   "amr":"http://udap.org/code/auth/aal2", 
   "acr":"http://udap.org/code/id/idial1.8", 
   "name": "Jane Doe", 
   "given_name": "Jane", 
   "family_name": "Doe", 
   "birthdate": "1979-01-01", 
   "address": { 
     "street_address": "1234 Hollywood Blvd.", 
     "locality": "Los Angeles", 
     "region": "CA", 
     "postal_code": "90210", 
     "country": "US"}, 
   "phone_number": "+1 (555) 777-1234", 
   "email": "janedoe@example.com" 
} 

<div>
<figure class="figure">
    <img src="b2b-with-patient-user.png" alt="B2B with Patient User" title="B2B with Patient User" class="img-responsive img-rounded center-block" width="75%">
    <figcaption class="figure-caption"><strong>B2B with Patient User</strong></figcaption>
</figure>
<p></p>
</div>

&emsp;&emsp;   

#### B2B Treatment Payment Operations (TPO) / Coverage Determination / etc.

Actors: B2B App, Authorization Server, FHIR Server

Description: The workflow between these use cases is similar, except for the purpose of use: 

-	a covered entity with an exchange purpose of treatment, healthcare payment, or healthcare operations
-	a covered entity with an exchange purpose of eligibility determination

Examples of Business-to-Business ("B2B") exchange relevant to this IG include patient matching for record location, health data queries, and messaging about patients that is enabled for trusted organizations within a community or point-to-point access. Relevant B2B exchanges also include TEFCA Facilitated FHIR, TEFCA Broadcast Query, TEFCA Targeted Query, TEFCA Message Delivery, TEFCA Population-Level Data Exchange, and associated patient discovery and matching services.

Pre-conditions: The requester and the responder have established trust and are able to exchange information securely. Requester and Responder have patient demographics for use in matching that were verified by each system at IDIAL1.5 or higher. Requester has verified demographics for the desired patient that meet the minimum requirements (input weight score of 9 or greater).

Workflow:
1.	The requesting system authenticates itself to the responding system via HL7 UDAP FAST B2B Authentication and Authorization steps.
2.	The requesting system sends a match request per the Match Workflow including an L0 patient resource with attributes verified at IDIAL1.5 at minimum – Step 1
3.	The responding system receives, matches, and returns a FHIR Bundle per the Match Workflow – Steps 2-4

<div>
<figure class="figure">
    <img src="b2b.png" alt="B2B Treatment Payment Operations (TPO) / Coverage Determination / etc." title="B2B Treatment Payment Operations (TPO) / Coverage Determination / etc." class="img-responsive img-rounded center-block" width="75%">
    <figcaption class="figure-caption"><strong>B2B Treatment Payment Operations (TPO) / Coverage Determination / etc.</strong></figcaption>
</figure>
<p></p>
</div>

&emsp;&emsp;   

#### Patient-Mediated B2C

Actors: User (individual or third-party system), Patient or Authorized Representative, Patient PHR App, App’s Authorization Server, App’s FHIR Server, Identity Provider

Description: A patient or their authorized representative authorizes access to their data by a third party when the data are under the patient’s management and not the data creator’s (e.g., a consumer app enables the patient to manage their own data).

Workflow:
1.	Digital Identity Creation is performed by the PHR App for the individual. In addition or instead, the individual may use a Digital Identity managed by a trusted Identity Provider to authenticate themselves to the PHR App.   
2.	When the individual attempts to authorize User's access to the patient’s health data, they do so using SMART App Launch, including an explicit authorization, and either a Digital Identity managed by a trusted Identity Provider or credentials of equivalent identity and authentication assurance managed by the PHR App itself.
3.	Whether the PHR App's own or a trusted, third-party Identity Provider’s assertions are used to authenticate the individual, the requirements for a Consumer Match apply and the responding PHR App matches either the Digital Identifier or a combination of demographics with input weight score of 10 or greater, consistent with this guidance, against the identities they manage. If a successful Consumer Match is found, the PHR App may provision a credential, reset an authenticator, or know which individual is being authenticated when relying on a trusted Identity Provider.
4.	If an appropriate individual was authenticated and consents to information sharing, health data can be returned to the User.

<div>
<figure class="figure">
    <img src="patient-mediated-b2c.png" alt="Patient-Mediated B2C" title="Patient-Mediated B2C" class="img-responsive img-rounded center-block" width="75%">
    <figcaption class="figure-caption"><strong>Patient-Mediated B2C</strong></figcaption>
</figure>
<p></p>
</div>

&emsp;&emsp;   

#### Patient-Directed B2C Using Digital Identity

Actors: User (individual or third-party system), Patient or Authorized Representative, Patient PHR App, App’s Authorization Server, App’s FHIR Server, Identity Provider

Description: A patient or their authorized representative authorizes access to their data by a third-party app when the data are under the patient’s management, and the patient’s authentication is delegated to a trusted Identity Provider (IdP). The data holder’s authorization server initiates authentication with the IdP, which incorporates user-supplied input into its authentication decision. The resulting verified digital identity is used by the data holder to perform a Consumer Match, ensuring the correct individual’s records are accessed before data are shared.

Workflow:
1. Client App requests authorization from the Data Holder’s Authorization Server, specifying the preferred Identity Provider.

2. Data Holder contacts IdP to discover configuration and register if needed.

3. User is redirected to IdP for authentication, where the IdP may use demographic or other inputs to confirm identity.

4. IdP returns authentication results (including an ID Token) to the Data Holder’s Authorization Server.

5. Data Holder performs Consumer Match using the ID Token and/or user input to identify the correct patient record.

6. If match and consent are successful, the Data Holder issues an authorization response to the Client App.

7. Client App uses access token to retrieve authorized FHIR data from the Data Holder.

<div>
<figure class="figure">
    <img src="idp.png" alt="Patient-Directed B2C Using Digital Identity" title="Patient-Directed B2C Using Digital Identity" class="img-responsive img-rounded center-block" width="75%">
    <figcaption class="figure-caption"><strong>Patient-Directed B2C Using Digital Identity</strong></figcaption>
</figure>
<p>*See ID Token Examples in [Artifacts](artifacts.html)</p>
</div>

&emsp;&emsp;   

{% include link-list.md %} 
