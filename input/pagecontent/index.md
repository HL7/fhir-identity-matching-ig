<div class="stu-note" markdown="1"> 

This Identity-focused FHIR implementation guide (IG) has been established upon the recommendations of ONC's FHIR at Scale Task Force (FAST) Identity Team and has been adapted from solution documents previously published by the team. The IG’s primary objective is to provide guidance on identity verification and patient matching as used in workflows pertinent to FHIR exchange and to facilitate cross-organizational and cross-network interoperability. 

 

The IG may provide a foundation for future digital identity management requirements. 
</div> 

 

&emsp;&emsp;   
### About This Guide 

This IG describes how to extend the FHIR patient $match operation for use in cross-organizational workflows and serves as a set of best practices for matching in similar FHIR transactions not specifically invoking $match, as well as in other transaction types. 

The requirements described in this guide are intended to align with the proposed solutions, including the security model, of the ONC FHIR at Scale Task Force’s Identity Team. 
{:.bg-info} 

This guide is divided into several pages which are listed in the menu bar. 

- [Home]\: The home page provides the introduction and background for this project and general requirements that apply to all workflows described in this guide. 
- [Industry Initiatives]\: This page includes a compilation of industry-wide digital identity and patient matching projects. 
- [Guidance on Identity Assurance]\: This page describes best practices for patient identity verification in the most common workflows necessary to support healthcare-related transactions. 
- [User Authentication Matching]\: This page describes user matching guidance during authentication
- [Patient Matching]\: This page describes the appropriate usage of the patient $match operation for cross-organizational exchange. 
- [Digital Identity]\: This page provides best practices for individual identity management in a healthcare context. 
- [Use Cases]\: This page provides workflows around core Identity concepts, as well as Use Case workflows. 
- [FHIR Artifacts]\: This page provides additional conformance artifacts for FHIR resources. 

{% include link-list.md %} 

&emsp;&emsp;   
### Executive Summary 

This IG provides guidance to enhance current workflows that support patient matching and digital identity and envisions a path for both providing more specific guidance and incorporating emerging identity concepts over time. This specification contributes to a long-term goal of establishing Digital Identity by providing guidance on identity assurance best practices for attribute and evidence verification. The guide
extends the patient $match operation for cross-organizational use by highlighting best practices in using matching attributes and their verification prior to responding to a patient match request or interpreting match results. 

This guide will address the two concepts of patient matching and Digital Identity with care to differentiate between the two distinct disciplines and the workflows usually unique to one concept or the other:   

> **Identity.**  Digital health identity refers to the technology and processes that support personal identity as it pertains to electronic health information. Digital health identity includes identifiers as well as components such as matching, identity vetting (also referred to as proofing or verification), identity authentication, authorization and access control, and other technologies and processes.  

> **Patient Matching.**  Patient matching and record linkage help address interoperability by determining whether records—both those held within a single facility and those in different healthcare organizations—correctly refer to a specific individual. Matching methods use demographic information, such as name and date of birth. 

Research has shown that matching is improved when higher-quality demographics are provided in the match request; verifying the identity of an individual at a specific identity assurance level (IAL1, IAL2, etc.), and that any match input data is consistent with the identity verification event, helps measure the quality of data included in a match request. For this reason, this IG will provide both guidance on how to improve identity assurance and how to leverage identity assurance in matching. 

When the identity of the person who is authenticated in a transaction is known with high confidence, this information can be used in an access decision, e.g., Patient-Directed Exchange. This allows implementers to rely on user authentication in this workflow instead of probabilistic matching, which becomes increasingly convenient as federated identity services proliferate. This also reduces the number of credentials an individual needs to maintain. 

As a secondary effect, digital credentials with high confidence identity assurance and a globally unique identifier associated with the individual, even in Business to Business matching (where the patient is not authenticated as being present in the transaction), emulate the perfect matching described in the paragraph above. Attempting to match on such a unique identifier is a preferred best practice over matching with a combination of demographics. 

When identity proofing has been completed for an individual, the process of verifying that demographic attributes are consistent with a unique individual in the real world makes the attributes more meaningful in match requests and improves match quality when probabilistic matching must be used.

&emsp;&emsp; 

### Testing 

For readers that are looking to test an implementation of this guide, additional testing resource can be found on the [Implementer Support page](https://confluence.hl7.org/display/FAST/FAST+Implementer+Support) of the HL7 FAST Confluence site.

### Use Cases and Roles 

This IG provides identity management and person matching guidance to support the use cases listed below, with a focus on FHIR transactions. However, the guidance also applies to any transaction type. Roles such as Identity Provider, patient, authorized representative, application, data holder, and intermediary are highlighted within the use case descriptions. 

**Patient-Mediated B2C:** Patient or their authorized representative authorizes access to their data by a third party when the data are under the patient's management and not the data creator’s (e.g., a consumer app enables the patient to manage their own data).   

**Patient-Directed B2C:** Patient or their authorized representative authorizes a third-party application to access patient's data as in the SMART App Launch workflow (or equivalent) using their credentials at the data holder organization or other trusted credentials from a third-party Identity Provider (for example, as in Unified Data Access Profiles ([UDAP](glossary.html)) [Tiered OAuth for User Authentication](https://build.fhir.org/ig/HL7/fhir-udap-security-ig/branches/main/user.html) to authenticate the user.   

Examples of this use case include: 

1. A patient using an app of their choice along with FHIR APIs required by ONC or CMS 
2. TEFCA Individual Access or other Patient Request via federated identity with UDAP Tiered OAuth, as outlined in the TEFCA FHIR Roadmap. 

**App-Mediated B2B with Patient User:** This type of individual access lets a patient or their authorized representative use a patient-facing app, not necessarily operated by a covered entity or business associate, to exercise their HIPAA Right of Access. The user’s identity is verified in accordance with this guide, and the app appropriately restricts the information made available to the user, verify the identity of the patient or their authorized rep at IAL1.8 and authenticate them at AAL2 prior to capturing the consent or allowing their access to data.. This use case which relies on [UDAP Business-to-Business](https://build.fhir.org/ig/HL7/fhir-udap-security-ig/branches/main/b2b.html) security model in FHIR transactions may be limited to a match with or without endpoint lookup (record location) or may also include a health data request. In other words, the user is attempting to access patient id(s) corresponding to one or more endpoints and/or the patient’s health data at those endpoints without using a credential they obtained from the data creator or intermediary data holder. Note that this use case can be implemented for record location at one or more endpoints and a different use case employed for access to health data. Ultimately this is a B2C transaction. 

Along with additional stipulations, one example of the above use case is TEFCA Individual Access Services.  

**B2B Treatment Payment Operations (TPO):** This business-to-business workflow involves a covered entity with an exchange purpose of treatment, healthcare payment, or healthcare operations.   

**B2B Coverage Determination:** This business-to-business workflow involves a non-covered entity with an exchange purpose of eligibility determination.   

**B2B Patient Request:** This business-to-business workflow involves an entity with an exchange purpose of patient requested (when patient may not have access to data).   

Examples of B2B exchange relevant to this IG include record location and other patient matching use cases for queries and messaging enabled for trusted organizations by community or point to point access. Relevant B2B exchanges also include TEFCA Facilitated FHIR, TEFCA Brokered FHIR, TEFCA Broadcast Query, TEFCA Targeted Query, TEFCA Message Delivery, TEFCA Population-Level Data Exchange, and associated patient discovery and matching services.  

(1)  <a href="https://www.justassociates.com/application/files/1414/9134/1517/PIIWhitePaper.pdf">Patient Identity Integrity White Paper</a>  HIMSS, December 2009   
(2)  <a href="https://www.gao.gov/assets/gao-19-197.pdf">Approaches and Challenges to Electronically Matching Patients’ Records across Providers</a>  GAO, January 2019   
(3)  <a href="https://sequoiaproject.org/resources/patient-matching/">The Sequoia Project</a>     
(4)  <a href="https://www.rand.org/content/dam/rand/pubs/research_reports/RR2200/RR2275/RAND_RR2275.pdf">Defining and Evaluating Patient-Empowered Approaches to Improving Record Matching</a>  RAND, 2018 

&emsp;&emsp;   

### Credits   
<style> 
table, th, td  
{ 
  border: 1px solid White;  
  padding: 2px 
} 
</style> 
|  |    |    | 
| <u><b>Primary Authors:</b></u>&emsp; |Julie Maas  | EMR Direct        | 
|   |Carmen Smiley  | ONC        | 
|   |Aaron Nusstein  | Lantana Consulting Group 
|   |Jeff Brown  | Lantana Consulting Group 
|   |         |  | 
| <u><b>Contributors:</b></u>&emsp;  |Paul Vaughan  | Optum        | 
|   | Vijey Kris Sridharan | United Healthcare | 
|   | Jim St. Clair | Linux Foundation | 
|   | Catherine Schulten | Walmart | 
|   | Ryan Howells | Leavitt Partners | 
|   | Rita Torkzadeh | Independent Consultant | 

&emsp;&emsp;   
This IG was made possible by the thoughtful contributions and feedback of the following additional people and organizations: 

The members of the ONC FHIR at Scale Taskforce (FAST) Identity Team 

The members of the HL7 Patient Administration Work Group 

 

 

 