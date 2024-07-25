This section provides a detailed description on identity workflows outlined in this IG. We have divided these workflows into two groups: Core Identity workflows and Use Case workflows. 

### Core Identity Workflows

#### Identity Proofing Workflow

Pre-Conditions: The individual is not known by the healthcare provider at the required level of assurance, after having completed a documented process.

Workflow:

1.	Establish the level of assurance required based on risk assessment and the sensitivity of the resources being accessed. (IAL2 if this individual is a provider engaging in B2B transactions, IAL1.5 if the individual is a patient or authorized representative of a patient whose demographics will be matched for sharing with Covered Entity organizations, or IAL1.8 if this individual is a patient or authorized representative of a patient whose demographics will be matched for sharing with the patient or their authorized reprentative
2.	Gather sufficient evidence to verify the identity of the individual.
3.	Confirm that the provided evidence is genuine and accurate by validating the authenticity of identity documents using trusted sources or databases and information on the evidence.
4.	Ensure the person presenting the identity evidence is the legitimate owner of that identity, according to this guidance and [NIST 800-63] Digital Identity Guidelines, and the intended level of assurance
5.	Consider Digital Identity Creation, including binding the identity to a credential, as part of this same encounter--this allows the individual to authenticate themselves without repeating the entire identity verification process.

Outcome: The individual has been successfully verified

#### Match Workflow

Pre-conditions:

- Requesting system can generate a FHIR Patient resource conformant to one of the IDI profiles (Base, L0, L1) established in this guide.
- Requesting and receiving systems are capable of communication via FHIR API
- Requester, either a human or a system, is authenticated and authorized to perform the action
- Receiving system may run both weighting and scoring processes found on the [Patient Matching] page

Workflow:

1.	The requesting system initiates a $match request to the receiving system’s FHIR endpoint.
2.	The receiving system runs a weighting algorithm to determine if the Patient resource found in the request meets the minimum value asserted in the IDI profile and required for the workflow (imperfect matching with L0 invariant, input weight score of at least 9, and attributes verified at IAL1.5, is permitted when data will be returned to a HIPAA Covered Entity; when a single high confidence match is required, L1 invariant with input weight score of at least 10 and attributes verified at IAL1.8 may initiate a Consumer Match—consistent with the Digital Identity essential to securing individual health data from access other than between Covered Entities).
3.	The receiving system intakes the $match request and runs their own matching algorithm against their patient database to determine if there are one or more matches.
4.	The receiving system replies to the requesting system with the relevant Patient resource(s) in a FHIR Bundle.

Outcome: Requesting system has obtained a valid FHIR Bundle containing either a matched FHIR Patient resource or resources or received a “No Match Found” response if the receiving system was unable to complete the request.


#### Digital Identify Creation
Actors: patient (or authorized representative), Identity Provider

Workflow:

1.	Patient completes an IAL1.8 or greater identity verification process per Identity Proofing workflow
2.	The Identity Provider binds the Digital Identifier to an OpenID Connect credential with AAL2 authentication assurance. 
3.	The resultant Digital Identifier can then be associated with the patient in health IT system able to validate an Identity Provider assertion and successfully perform a Consumer Match.

&emsp;&emsp;

### Use Case Workflows

#### Patient-Mediated B2C

Actors: User (individual third party or third-party system), Patient, Patient PHR App, App’s Authorization Server, App’s FHIR Server, Identity Provider

Description: A patient or their authorized representative authorizes access to their data by a third party when the data are under the patient’s management and not the data creator’s (e.g., a consumer app enables the patient to manage their own data).

Workflow:
1.	Digital Identity Creation is performed by the PHR App for the patient or authorized representative. In addition or instead, the individual may use a Digital Identity managed by a trusted Identity Service to authenticate themselves to the PHR App.   
2.	When the patient or their authorized representative attempts to authorize a third party’s access to the patient’s health data, they do so using SMART App Launch, including an explicit authorization, and the Digital Identity managed by the trusted Identity Provider or credentials of equivalent identity and authentication assurance managed by the PHR Applog 
3.	Whether the PHR App itself or a trusted third party Identity Provider’s assertions are used to authenticate the Patient or Authorized Representative, the requirements for a Consumer Match apply and the PHR App matches either the Digital Identifier or a combination of demographics with input weight score of 10 or greater, consistent with this guidance, against the identities of patients and authorized representatives they manage. If a successful Consumer Match is found, the PHR App may provision a credential, reset an authenticator, or know which individual is being authenticated when relying on a trusted Identity Provider.

{% include img-med.html img="patient-mediated-b2c.png" %}

Patient-Directed B2C Using Digital Identity

Description: This is a special case of Patient-Directed exchange in which a third-party Identity Provider is used. The use case involves health data access such as in TEFCA Individual Access Services, but could also be used in different cases where patient authentication is required, such as consent management or request for restrictions (part of View, download, and transmit to 3rd party).

Actors: Patient or Authorized Representative, Third-Party Requestor (for example, Insurance Company), Healthcare Organization, Identity Provider

1. The patient authenticates to their insurance company’s system using the credential associated with their Digital Identifier and authorizes the Identity Provider to share their identifier with the insurance company as representative of their identity.
2. The insurance company uses the Digital Identifier in a match request to the healthcare organization.
3. Because this strong identity assurance credential has been used to authenticate the individual to both systems, the individual authorizes sharing of PII from the Identity Provider to the healthcare organization for identity resolution, and authorization to share health data with the insurance company is obtained, the health system can confidently share the correct patient data with the requesting party.
4. If needed, the health system can contact the account holder out of band for additional information or can request real-time identity verification if the Digital Identity is not yet known to them.


&emsp;&emsp;   

#### Patient-Directed B2C
Actors: Authorized Representative (User) OR Patient, Patient Chosen App, Authorization Server, FHIR Server, Identity Provider

Description: Patient or their authorized representative authorizes a third-party application to access patient’s data as in the SMART App Launch workflow (or equivalent) using their credentials at the data holder organization or other trusted credentials from a third-party Identity Provider (for example, as in Unified Data Access Profiles (UDAP) Tiered OAuth for User Authentication to authenticate the user.)

Pre-Conditions:
- The patient (and user) has been registered and verified by a physician’s office (or other provider)
- The patient (and user) is known by the Identity Provider
- The Identity Provider is trusted by the physician’s office

Workflow:
1.	A user wishes to access their accessible health information through an app of their choice
2.	User authorizes data flow to their chosen app
3.	User authenticates with credentials issued by the practice OR the user is prompted to log into the physician’s data sourceapp through authentication process of a different identity provider’s compliant Digital Identity (in either case following SMART, etc. as usual)
4.	User completes necessary prompts, creating a credential with the identity Provider if it did not exist or resetting the credential if needed.
5.	If a trusted third party Identity Provider is being used, the usual requirements for a Consumer Match exist and the data holder must match the Digital Identifier asserted by the Identity Provider, or another combination of demographics with input weight score of 10 or greater consistent with this guidance, against the identities of patients and authorized representatives they manage. 

{% include img-med.html img="patient-directed-b2c.png" %}

&emsp;&emsp;   

#### App-Mediated B2B with Patient User (includes B2B Patient Request workflows)

Actors: User (Authorized Representative or Patient), B2B App, Authorization Server, FHIR Server

Description: This type of individual access lets a patient or their authorized representative use a patient-facing app, not necessarily operated by a covered entity or business associate, to exercise their HIPAA Right of Access. The user’s identity is verified in accordance with this guide, and the app (if a Covered Entity) appropriately restricts the information made available to the user, though the requirements on how data are restricted are beyond this guide’s scope. This use case which relies on [UDAP Business-to-Business](https://hl7.org/fhir/us/udap-security/STU1/) security model in FHIR transactions may be limited to a match with or without endpoint lookup (record location) or may also include a health data request. In other words, the user is attempting to access patient id(s) corresponding to one or more endpoints and/or the patient’s health data at those endpoints without using a credential they obtained from the data creator or intermediary data holder. Note that this use case can be implemented for record location at one or more endpoints and a different use case employed for access to health data. Ultimately this is a B2C transaction.

Pre-conditions: Requestor can meet Consumer Match requirements for the Patient AND (if different individuals) the Authorized Representative.

Workflow:
1.	A user would like to access a patient’s records via an app that is trusted by the responder. The user logs into the application to do so, with a Digital Identity or equivalent credentials.
2.	When the user initiates the query, the application undergoes a UDAP B2B with User Authentication process, using a B2B credential to establish trust with the responderHIE.
3.	The identity of the user is evaluated by the Authorization Server against their database of patients and authorized representatives to determine, if a Consumer Match exists, what patient(s)’ data this individual may access. 
4.	When authentication is complete, the application creates a $match request with the demographics available for the patient in the query, again meeting Consumer Match requirements.
5.	The responder will undergo a weighting adjudication to determine the strength of the of the match request.
6.	If sufficient, the responder will then run an MPI against their patient database
7.	If a Consumer Match on the patient results, the resultant Patient resources will be returned in a FHIR Bundle

{% include img-med.html img="b2b-with-patient-user.png" %}

&emsp;&emsp;   

#### B2B Treatment Payment Operations (TPO) / Coverage Determination / etc.

Actors: B2B App, Authorization Server, FHIR Server

Note: The workflow between these three use cases is similar, except for the type of entity is being transacted with by the client: 

-	a covered entity with an exchange purpose of treatment, healthcare payment, or healthcare operations
-	a non-covered entity with an exchange purpose of eligibility determination

Pre-conditions: The requestor and the responder have established trust and are able to exchange communication. Requestor and Responder have patient demographics for use in matching that meet the matching minimum bar for this guidance.

Workflow:
1.	The requesting system authenticates itself with the responding system via UDAP B2B Authentication and Authorization steps.
2.	The requesting sends a $match per the Match Workflow including L0 patient resource with attributes verified at IAL1.5 at minimum – Step 1
3.	The responding system receives, matches, and returns a FHIR Bundle per the Match Workflow – Steps 2-4

{% include img-med.html img="b2b.png" %}

Examples of B2B exchange relevant to this IG include record location and other patient matching use cases for queries and messaging enabled for trusted organizations by community or point to point access. Relevant B2B exchanges also include TEFCA Facilitated FHIR, TEFCA Brokered FHIR, TEFCA Broadcast Query, TEFCA Targeted Query, TEFCA Message Delivery, TEFCA Population-Level Data Exchange, and associated patient discovery and matching services. 

&emsp;&emsp;   
