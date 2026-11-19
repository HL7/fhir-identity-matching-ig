This section provides a high level overview of identity workflows outlined in this IG. 

<div>
<img src="identity-venn.svg" alt="Identity Venn Diagram" width="350"/>
</div>

| Use-Case | Description | Interop Solution | Identity Container |Assurance Solution |
| ---------- | ------------- | ------------------- | ----------------- | ----------------- |
| Patient Golden Identity | A high assurance identity for a patient that serves as the foundation for accurate record matching and access control. | OAuth | JWT | TBD |
| Patient Record Matching | Finding a patient Golden Identity when the Patient can't provide their Identity Verification (e.g. unconscious, not yet verified, etc). | FHIR Operation | Patient | IDI-Match |
| User Authentication and Authorization | Managing access to healthcare resources based on user identity and roles, founded on a High Assurance Identity. These may be patients, clinicians, payer agents, or other authorized agents. | OAuth | JWT | TBD |
| Clinician Identity | a subset of User Identity focused on clinicians. Verified at a High Assurance identity of a clinician to ensure accurate access control and record management. | OAuth | JWT | TBD |
| Payer Identity | a subset of User Identity focused on payers. Verified at a High Assurance identity of a payer professional to ensure accurate access control and claims management. | OAuth | JWT | TBD |
| Health System Identity Verification | Verifying the High Assurance identity of a health system organization to ensure accurate access control and record management. | FAST Security | LEI / vLEI | TBD |
| Payer Identity Verification | Verifying the High Assurance identity of a payer organization to ensure accurate access control and claims management. | FAST Security | LEI / vLEI | TBD |
{: .grid}

### Breakdown to use-cases

Golden Identity and User Identity are the two main categories of identity management covered in this IG. The Golden Identity focuses on the unique and consistent identifier for a data subject (such as a patient or client) across different healthcare systems and organizations, while the User Identity focuses on the identity management for clinical users, patients as users, and other authorized agents such as relatives or caregivers.

Organization Identity are used by organizations to uniquely identify themselves and establish trust in interactions with other entities, such as healthcare systems, payers, and regulatory bodies. This ensures accurate access control, record management, and claims processing.

Human and Organization Actors:

- **Patient / Client**: The individual seeking healthcare services or accessing their own medical records.
- **Credential Service Provider** (**CSP**): The nationwide commercial entity responsible for High Assurance identity verification, verifying the patient's identity and issuing a Golden Identifier. The CSP may use various methods such as document verification, biometric verification, and other identity assurance techniques.
- **IDP Service** (**IDP**): The service responsible for High Assurance Identity verifying the identity of individuals or organizations, which includes payers, and health systems. The IDP may use various methods such as document verification, biometric verification, and other identity assurance techniques.
- **Healthcare System**: The organization providing healthcare services and managing patient interactions, including the use of Golden and User Identities for accurate record matching and access.
- **Clinical Practitioner**: The healthcare professional providing care to the patient and accessing their medical records for clinical decision-making. Practitioners include clinical, and other healthcare users.
- **Payer Organization**: The organization responsible for managing healthcare claims, authorizations, and other payer-related activities for the patient.
- **Payer Practitioner**: The healthcare professional associated with a payer organization, responsible for managing claims, authorizations, and other payer-related activities for the patient.

Technical Actors:

- **Credential Service Provider** (**CSP**): The entity responsible for verifying the patient's identity and issuing a Golden Identifier. The CSP may use various identity assurance methods, such as document verification. The CSP may use various authentication methods, such as biometric verification, to ensure the accuracy of the identity verification process.
- **Authorization Server** (**AS**): The system responsible for making authorization decisions based on the User Identity tokens provided by the CSP. The Authorization Server may use role-based access control (RBAC) or attribute-based access control (ABAC) to determine the appropriate level of access for each user. The Authorization Server may also provide Consent enforcement (see FAST Consent Management)
- **Relying Party** (**RP**): The healthcare system or application that relies on the User Identity tokens provided by the CSP for authentication and authorization. The RP may use the tokens to grant access to specific resources or perform actions on behalf of the user.
- **Requesting Party** (**RQ**): The entity requesting access to a patient's medical records or other healthcare resources. The RQ is a system that may be used by a practitioner, patient, or other authorized agent. .
- **Match Client**: The system responsible for requesting a match given some demographics information.
- **Match Service**: The system responsible for performing the matching of patient records based on the provided demographics information. The Match Service may use probabilistic matching algorithms to determine the likelihood of a match and return the results to the Match Client.

**The Prime interactions**

The following are illustrative of the prime interactions between the Technical Actors in the identity workflows:

The RQ is accessing the RP, the RP redirects (OAuth) to the AS, the AS redirects to the CSP for authentication, the CSP returns a token to the AS, the AS returns a token to the RP, and the RP returns a token to the RQ. The RQ then uses the token to access resources on behalf of the patient.

```mermaid
graph LR
    RQ["Requesting Party<br/>(RQ)"]
    RP["Relying Party<br/>(RP)"]
    AS["Authorization<br/>Server (AS)"]
    CSP["Credential Service<br/>Provider (CSP)"]
    
    RQ <--> RP
    RP <--> AS
    AS <--> CSP
```

The Match Client does not have a Golden Identifier, so uses Match Service to find the Patient's Golden Identifier.

```mermaid
graph LR
    MatchClient["Match Client"]
    MatchService["Match Service"]
    
    MatchClient <--> MatchService
```

### Patient presents with a Golden Identity

When a patient presents with a Golden Identity, the healthcare system can use this identifier to accurately find the patient across different systems and organizations. The Golden Identity allows for seamless access to the patient's medical records, ensuring that the correct information is retrieved and used for clinical decision-making. The Golden Identity includes current and accurate demographics and other attributes. The Golden Identity has been identity assurance proofed.

This workflow the Patient is not a user (see next use-case), but is the subject of healthcare workflows such as treatment, payment, or other healthcare services. The Golden Identity is used to find the patient in the healthcare system, and the healthcare system may use the Golden Identity to retrieve the patient's medical records, update their information, or perform other actions related to their care.

The Golden Identifier is used to link all of the patient's medical records across different healthcare systems and organizations, ensuring that the patient's medical history is accurately maintained and accessible. The healthcare system may also use the Golden Identity to facilitate communication and coordination of care among different providers involved in the patient's treatment. The Golden Identity is also used to support patient privacy consent, patient preferences, and other patient-centered workflows that require accurate identification of the patient.

#### Patient presents as a User

When a patient presents as a User, they may be accessing their own medical records or interacting with the healthcare system through a patient portal or other digital platform. In this case, the User Identity is derived off of the Golden Identifier. The CSP authenticates the User Identity, providing User Identity tokens (i.e., OpenId-Connect) to support authorization workflows at the healthcare system. The User Identity token includes current and accurate demographics and other attributes. The User Identity has been identity assurance proofed, and authenticated to the level of assurance required by the healthcare system.

The Patient is a user of the healthcare system, and the User Identity is used to access their own medical records, update their information, or perform other actions related to their care. For example: setup appointments, request prescription refills, update Consent provisions, review lab results, and communicate with their healthcare providers.

### Patient presents without a Golden Identity

There are two scenarios when a patient presents without a Golden Identity depending on the urgency of the situation. Ultimately the Patient will need to obtain a Golden Identity to ensure accurate matching and access to their medical records in the future, but the immediate healthcare need will be accomplished with the available demographic information.

#### Patient is not able to get a Golden Identifier at this time

Such as when the patient is not healthy in an urgent or emergent setting.

When a patient presents without a Golden Identity, the healthcare system must rely on other demographic information to match the patient. This may include name, date of birth, address, and other identifying information. The system may use probabilistic matching algorithms to determine the likelihood of a match based on the available information. In cases where a match cannot be confidently established, the system may prompt for additional information or verification from the patient or their authorized representative.

The Match Client can ask for only certain matches, or only the best ONE match be returned, or all matches.

#### Patient is asked to get a Golden Identifier

In this case the Patient has not been issued a Golden Identifier, so is assisted with obtaining one. The verification process is handled by the Credential Service Provider (CSP) which is outside the scope of this IG. The CSP will verify the patient's identity and issue a Golden Identifier, which can then be used for future interactions with the healthcare system.

The CSP will interact with the Data custodians to align the new Golden Identifier with the existing patient records, ensuring that the patient's medical history is accurately linked to their new identifier. This process may involve matching demographic information, such as name, date of birth, and address, to ensure that the correct records are associated with the new Golden Identifier.

CSP -> Match Service -> Data Custodian

### Resource Locator

Match Client may have a Golden Identifier or may only have demographics information. The Match Client wants to know where (i.e. Organizations) the patient has records. The Match Client will use the Golden Identifier or demographics information to request a list of organizations where the patient has records. The Match Service will return a list of organizations where the patient has records, along with any relevant metadata about the records, such as the type of record, date of service, and other relevant information.

TODO: This is a new feature not previously supported by the IDI-Match Operation.

### Maintenance of Golden Identifier

over time Patients change their demographics, such as name, address, and phone number. The healthcare system must ensure that the Golden Identifier associated details are updated to reflect these changes, so that the patient's medical records remain accurate and accessible. The CSP may provide a process for patients to update their demographics information, which will then be used to update the Golden Identifier in the healthcare system. Relying Parties may also have a process for updating the Golden Identifier associated details, which will then be used to update the Golden Identifier in the healthcare system. The healthcare system may also have a process for verifying and validating the updated information to ensure that it is accurate and complete.

A specific example is when two Golden Identifiers are found to be associated with the same patient. The healthcare system must have a process for merging the two Golden Identifiers into a single identifier, ensuring that all of the patient's medical records are accurately linked to the correct identifier. This may involve verifying the patient's identity and demographics information, as well as reviewing the medical records associated with each identifier to ensure that they are accurate and complete. This process might not be automated due to the sensitive nature of changing medical records and identities that had previously been used as high assurance identities. 

### Organization Identity

Organization Identity refers to the high assurance identity of an organization within the healthcare ecosystem. This includes health systems, payers, and other healthcare-related organizations. Verifying the identity of an organization ensures accurate access control, record management, and compliance with regulatory requirements. The identity verification process may involve validating legal entity identifiers (LEI), organizational structure, and other relevant credentials to establish the organization's authenticity and trustworthiness.    

### Consumer to Organization

Consumer to Organization refers to the interactions and relationships between individual consumers (patients) and healthcare organizations. This includes scenarios where consumers access services, share their health information, or engage with organizations for care management. Ensuring the accurate identification and verification of both consumers and organizations is crucial for maintaining data integrity, privacy, and security within the healthcare ecosystem. This process may involve authenticating the consumer's identity, verifying the organization's credentials, and managing consent for data sharing and access.

### Business to Business

Business to Business refers to the interactions and relationships between different healthcare organizations. This includes scenarios where organizations exchange data, collaborate on patient care, or engage in joint initiatives. Ensuring the accurate identification and verification of both parties is essential for maintaining data integrity, security, and compliance with regulatory requirements. This process may involve authenticating the identities of the organizations, verifying their credentials, and managing consent and access controls for shared data.

This includes Healthcare Provider to Payer, Payer to Payer, and Healthcare Provider to Healthcare Provider interactions.

The Identities use must be high assurance to ensure the accuracy, security, and trustworthiness of the interactions and data exchanges between healthcare organizations. High assurance identities help mitigate risks related to data breaches, unauthorized access, and compliance violations, thereby supporting the overall integrity and reliability of the healthcare ecosystem.

The B2B interactions will be initiated by an individual, but that interaction will be conducted on behalf of the organization they represent. This ensures that the organization is accurately identified and authenticated, and that the appropriate access controls and consent mechanisms are applied to the data being exchanged. High assurance identities for both the individual and the organization are critical to maintaining the security, integrity, and trustworthiness of these interactions within the healthcare ecosystem.

