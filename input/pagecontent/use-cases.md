This section provides a detailed description on identity workflows outlined in this IG. We have divided these workflows into two groups: Core Identity workflows and Use Case workflows. 

### Core Identity Workflows

#### Identity Proofing Workflow

Pre-Conditions: The individual is not known by the healthcare provider at the required level of assurance, after having completed a documented process.

1.	Establish the level of assurance required based on risk assessment and the sensitivity of the resources being accessed. (IAL2 if this individual is a provider engaging in B2B transactions, IAL1.5 if the individual is a patient or authorized representative of a patient whose demographics will be matched for sharing with Covered Entity organizations, or IAL1.8 if this individual is a patient or authorized representative of a patient whose demographics will be matched for sharing with the patient or their authorized reprentative
2.	Gather sufficient evidence to verify the identity of the individual.
3.	Confirm that the provided evidence is genuine and accurate by validating the authenticity of identity documents using trusted sources or databases.
4.	Ensure the person presenting the identity evidence is the legitimate owner of that identity. Use multiple factors to verify the individual’s identity (e.g., in-person verification, remote identity proofing methods, knowledge-based authentication (KBA)).
5.	Review all evidence collected and verification results. Determine if the proofing process meets the required level of assurance (IAL) based on the guidelines.
6.	Assign appropriate credentials (e.g., usernames, passwords, cryptographic keys) to the verified individual.
7.	A Digital Identifier is created and associated with the individual and their health record within the EHR (if a health system is the identity provider) or after demonstrating control of the credential (if assigned by a third party identity service).

Outcome: The individual has been successfully verified, a digital identifier is associated with the individual, and they may obtain a credential for use in authenticating themselves subsequently.

#### Match Workflow

Pre-conditions: 
- Requesting system can generate a FHIR Patient resource conformant to one of the IDI profiles (Base, L0, L1) established in this guide.
- Requesting and receiving systems are capable of communication via FHIR API
- Requester, either a human or a system, is authenticated and authorized to perform the action
- Receiving system may run both weighting and scoring processes found on the [Patient Matching] page

1.	The requesting system initiates a $match request to the receiving system’s FHIR endpoint.
2.	The receiving system runs a weighting algorithm to determine if the Patient resource found in the request meets the minimum value asserted in the IDI profile and required for the workflow (slightly imperfect matching is permitted when data will be returned to a covered entity; consumer-facing matching requires a single high confidence match according to the increased match input requirements of this IG as well as authentication of the individual.
3.	The receiving system intakes the $match request and runs their own matching algorithm against their patient database to determine if there are one or more matches. We may want to add identity assurance mention here, and a second case of single high confidence match if the $match is being invoked by a trusted B2B app for data sharing with a consumer.
4.	The receiving system replies to the requesting system with the relevant Patient resource(s) in a FHIR Bundle.

Outcome: Requesting system has obtained a valid FHIR Bundle containing either a matched FHIR Patient resource or resources or received a “No Match Found” response if the receiving system was unable to complete the request.


#### Digital Identifier Creation
Actors: patient (or authorized representative), Identity Provider

1.	Patient completes an IAL1.8 or greater identity verification process per Identity Proofing workflow
2.	The Identity Provider binds the Digital Identifier to an OpenID Connect credential with AAL2 authentication assurance. 
3.	The resultant Digital Identifier is then associated with the patient’s record in that organization’s electronic health record (EHR) (if healthcare organization is the identity provider) or after the patient authenticates themselves using the credential (if a third party identity provider).


&emsp;&emsp;   

### Use Case Workflows

#### Patient-Mediated B2C

Actors: User (third-party system), Patient, Patient PHR App, App’s Authorization Server, App’s FHIR Server

Description: A patient or their authorized representative authorizes access to their data by a third party when the data are under the patient’s management and not the data creator’s (e.g., a consumer app enables the patient to manage their own data).

Workflow:
1.	Patient is seen by a provider in person or virtually. The provider’s office verifies the individual’s identity at IAL1.8. If an Authorized Representative is involved, they would need to be verified as well at IAL1.8
2.	After being seen at the office, the patient or their authorized representative attempts to log into their patient portal via app.

{% include img-med.html img="patient-mediated-b2c.png" %}


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
3.	User authenticates with credentials issued by the practice OR The user is prompted to log into the physician’s data source through authentication process of a different identity provider (SMART, etc.)
4.	User completes necessary prompts, creating a credential with the identity Provider if it did not exist or resetting the credential if needed. This credential will be used with the physician’s EMR to all access into the patient app.

{% include img-med.html img="patient-directed-b2c.png" %}


&emsp;&emsp;   

#### App-Mediated B2B with Patient User (includes B2B Patient Request workflows)

Actors: Authorized Representative (User) (optionally) Patient, B2B App, Authorization Server, FHIR Server

Description: This type of individual access lets a patient or their authorized representative use a patient-facing app, not necessarily operated by a covered entity or business associate, to exercise their HIPAA Right of Access. The user’s identity is verified in accordance with this guide, and the app appropriately restricts the information made available to the user, though the requirements on how data are restricted are beyond this guide’s scope. This use case which relies on UDAP Business-to-Business security model in FHIR transactions may be limited to a match with or without endpoint lookup (record location) or may also include a health data request. In other words, the user is attempting to access patient id(s) corresponding to one or more endpoints and/or the patient’s health data at those endpoints without using a credential they obtained from the data creator or intermediary data holder. Note that this use case can be implemented for record location at one or more endpoints and a different use case employed for access to health data. Ultimately this is a B2C transaction.

Pre-conditions: Requestor has sufficient patient demographics (input weight score of 10 or greater) available for match input that were verified at IAL1.8 or higher.

Workflow:
1.	A user would like to access a patient’s records via an app that is trusted by the responder. The user logs into the application to do so, with IAL1.8/AAL2 credentials.
2.	When the user initiates the query, the application undergoes a UDAP B2B with User Authentication process, using a B2B credential to establish trust with the responder.
3.	The identity of the user is evaluated by the Authorization Server to determine what patients’ data this individual may access. Demographics in the Authorization Extension Object are evaluated according to match input weight of 10 or greater and attributes verified at IAL1.8 or greater. 
4.	When authentication is complete, the application creates a $match request with the demographics available for the patient in the query, again meeting match input weight score of 10 or greater, IAL1.8 and L1.
5.	The responder will undergo a weighting adjudication to determine the strength of the of the match request.
6.	If sufficient, the responder will then run an MPI against their patient database
7.	If a match results and responder’s internally-computed match confidence is not too low, the resultant Patient resource will be returned in a FHIR Bundle


{% include img-med.html img="b2b-with-patient-user.png" %}

&emsp;&emsp;   

#### B2B Treatment Payment Operations (TPO) / Coverage Determination / etc.

Actors: B2B App, Authorization Server, FHIR Server

Note: The workflow between these three use cases is similar, except for the type of entity is being transacted with by the client: 

-	a covered entity with an exchange purpose of treatment, healthcare payment, or healthcare operations
-	a non-covered entity with an exchange purpose of eligibility determination
Pre-conditions: The requestor and the responder have established trust and are able to exchange communication. Requestor and Responder have patient demographics for use in matching that were verified at IAL1.5 or higher. Requestor has sufficient verified demographics (input weight score of 8 or greater).

Workflow:
1.	The requesting system authenticates itself with the responding system via UDAP B2B Authentication and Authorization steps.
2.	The requesting sends a $match per the $match workflow including L0 patient resource at minimum– Step 1
3.	The responding system receives, matches, and returns a FHIR Bundle per the $match workflow – Steps 2-4

{% include img-med.html img="b2b.png" %}

#### B2B Using Digital Identity

Actors: patient (or authorized representative), provider, Identity Provider

1.	The patient authenticates to their insurance company’s system using the credential associated with their Digital Identifier
2.	The insurance company uses the Digital Identifier in a match request to the healthcare organization.
3.	Because this strong identity assurance credential has been used to authenticate the individual to both systems, and the patient authorizes sharing of PII from the Identity Provider to the healthcare organization for identity resolution, the healthcare organization can confidently share the correct patient data with the requesting party.
4.	If needed, the health system can contact the account holder out of band for additional information or can request real-time identity verification if the Digital Identity is not yet known to them.

&emsp;&emsp;   
