<div class="stu-note" markdown="1"> 

This Identity-focused FHIR implementation guide (IG) has been established upon the recommendations of ONC's FHIR at Scale Task Force (FAST) Identity Team and has been adapted from solution documents previously published by the team. The IG’s primary objective is to provide guidance on identity verification and patient matching as used in workflows pertinent to FHIR exchange and to facilitate cross-organizational and cross-network interoperability. 

 

The IG may provide a foundation for future digital identity management requirements. 
</div> 

 

&emsp;&emsp;   
### About This Guide 

This IG profiles the FHIR patient $match operation for use in cross-organizational workflows and serves as a set of best practices for person matching and identity management in similar FHIR transactions, as well as in other non-FHIR transaction types. 

The requirements described in this guide are intended to align with the solutions originally proposed by the ONC FHIR at Scale Task Force’s Identity Tiger Team. 
{:.bg-info} 

This guide is divided into several pages which are listed in the menu bar. 

- [Home]\: The home page provides the introduction and background for this project and general requirements that apply to all workflows described in this guide. 
- [Guidance on Identity Assurance]\: This page describes best practices for individual and organizational identity verification in the most common workflows necessary to support healthcare-related transactions. 
- [Patient Matching]\: This page describes the appropriate usage of person matching for cross-organizational exchange. 
- [Digital Identity]\: This page provides best practices for individual and organizational identity management in the healthcare context. 
- [Artifacts]\: This page provides additional conformance artifacts for FHIR resources.
- [Use Cases]\: This page provides workflows around core Identity concepts, as well as Use Case workflows that highlight different types of healthcare transactions. 
- [Industry Initiatives]\: This page includes a compilation of industry-wide digital identity and patient matching projects.

{% include link-list.md %} 

&emsp;&emsp;   
### Executive Summary 

This IG provides guidance to enhance current workflows that support person matching and digital identity, and envisions a path for both providing more specific guidance and incorporating emerging identity concepts over time. This specification contributes to a long-term goal of establishing Digital Identity that is suited for interoperable use by providing guidance on identity assurance so that these best practices for attribute and evidence verification can serve as a foundation for better person matching. The IG also profiles the patient $match operation for cross-organizational use and highlights best practices for using verified matching attributes (i.e., demographics and other personal information) when responding to a match request, managing and using Digital Identifiers, and interpreting match results. 

This guide will address the two concepts of patient matching and Digital Identity with care to differentiate between the two distinct disciplines and the workflows usually unique to one concept or the other:   

> **Identity.**  Digital health identity refers to the technology and processes that support personal identity as it pertains to electronic health information. Digital health identity includes identifiers as well as components such as matching, identity verification (also referred to as proofing or vetting), identity authentication, authorization and access control, and other technologies and processes.  

> **Patient Matching.**  Patient Matching and record linkage help address interoperability by determining whether records—both those held within a single facility and those in different healthcare organizations—correctly refer to a specific individual. Matching methods generally rely on demographic information, such as name and date of birth. 

Research has shown that matching is improved when higher-quality demographics are provided in the match request; verifying the identity of an individual at a specific identity assurance level (IAL1, IAL2, etc.), and that any match input data is consistent with the identity verification event, is a method that improves this quality so that we can measure in a standard way the data included in a match request. For this reason, this IG will provide both guidance on how to implement and improve identity assurance and how to leverage identity assurance in matching. 

When the identity of the person who is authenticated in a transaction is known with high confidence, this information can be used in an access decision, e.g., Patient-Directed Exchange. This allows implementers to rely on user authentication in this workflow instead of probabilistic matching, which becomes increasingly convenient as federated identity services proliferate. This also reduces the number of credentials an individual needs to maintain. 

As a secondary effect, digital credentials with high-confidence identity and authentication assurance and a globally unique identifier associated with the individual, even in Business-to-Business matching (where the patient is not authenticated as being present in the transaction), emulate the perfect matching described in the paragraph above. Attempting to match on such a unique identifier is a preferred best practice over matching with demographics alone. 

When identity verification has been completed for an individual, the process of verifying that demographic attributes are consistent with a unique individual in the real world makes the attributes more meaningful in match requests and improves match quality when probabilistic matching must be used.

&emsp;&emsp; 

### Testing 

For readers that are looking to test an implementation of this guide, additional testing resources can be found on the [Implementer Support page](https://confluence.hl7.org/display/FAST/FAST+Implementer+Support) of the HL7 FAST Confluence site.   

&emsp;&emsp; 


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
|   |   |   | 
| <u><b>Primary Authors:</b></u>&emsp; |Julie Maas | EMR Direct | 
|   | Carmen Smiley | HRSA | 
|   | Humberto Lee | Lantana Consulting Group | 
|   | Aaron Nusstein | Lantana Consulting Group | 
|   | Jeff Brown | Lantana Consulting Group |  | 
|   |   |   | 
| <u><b>Contributors:</b></u>&emsp; | Paul Vaughan | Optum | 
|   | Vijey Kris Sridharan | United Healthcare | 
|   | Jim St. Clair | MyLigo | 
|   | Catherine Schulten | Walmart | 
|   | Ryan Howells | Leavitt Partners | 
|   | Rita Torkzadeh | Independent Consultant | 

&emsp;&emsp;   
This IG was made possible by the thoughtful contributions and feedback of the following additional people and organizations: 

The members of the ONC FHIR at Scale Taskforce (FAST) Identity Team 

The members of the HL7 Patient Administration Work Group 

 

 

 
