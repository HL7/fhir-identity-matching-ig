<div class="stu-note" markdown="1"> 

STU3 is moving to a model where nationwide commercial credential issuers play a fundamental role in identity management. Providing a common method of identity lookup, verification, authentication, and referencing, with a service that assures the identity and provides authentication as necessary.

</div>

Creation of a Golden Record and linking that to a Digital Identity and Identity token can create a better age of care and reduced costs for Providers and Payers.  Working with private sector identity providers (IdPs)Common Data Model can create a method to critically reduce issues with patient matching and individual data breaches by creating an environment where trust is created through partnerships.

A possible workflow to create and use a Golden Record would be:

1. Clear/ID.Me/Login.gov/etc. signs a person up, either through the IdP’s portal or at point of care, and creates a digital identity and token identifier.  The IdP would use verified demographics and biometrics (e.g. photo, 3D scan, etc.) as part of the creation, in future, this could include mobile Drivers Licenses or other sources of trusted identification 
2. Each IdP shares that identity Common Data Model information with the other partnered IdPs creating a Golden Record common across all IdPs with one patient identifier that is used wherever that patient gets care. Each IdP may have separate internal identifiers but only the shared identifier is the Golden Record identifier.
3. On the Payer/Provider side, the organization signs up with one of the IdP partners for provision of identity verification.
  - Larger hospitals may have identity verification terminal (as in airports)
  - Smaller may have portal that brings up picture and PII that can be verified by the admitting clerk.
4. On initial or additional visit, user presents their phone app/card/etc. containing the token/QR Code or logs in with verification terminal.
  - In the case of a portal with PII and photo, a notification goes to the patient’s phone that their ID is being used and to agree/disagree with its use.
5. Once verified, the Payer/Provider uses the identifier code to query the Golden Record on IdP and ingest that patient’s/member’s information.
6. Once ingested, the Payer/Provider does TEFCA/etc. query using Golden Record identifier and gathers all patient records.

Demographic updates to a patient/member record are done either through IdP or Payer/Provider with validation.  These updates can be done at point of care or through an IdP portal. Updates from Payer/Provider without terminals are held until validated by IdP via a terminal or an on-line portal. 

- Updates to demographics can be pushed to the Payer/Provider when the record is accessed or may be pushed to their system at time of update, depending on design.
- The Payer/Provider would have the choice to only store Identifier and limited demographics (Name/DOB/etc.) locally and reply on the Golden Record when demographics needed.

This is done as a private sector initiative with Login.gov/VA/DOD/SSA/etc. participating but not owning. Once established, this identity could grow beyond healthcare to be used wherever identity is required.

### HL7

[HL7](http://hl7.org/), which stands for Health Level Seven, creates standards to help different healthcare computer systems talk to each other. These HL7 standards are a special language or set of rules that lets information be shared between hospitals, doctors’ offices (e.g. Electronic Health Record Systems), labs, patients (e.g. via patient portals), pharmacies, and insurers, among others.

One of the HL7 standards is HL7 FHIR (Fast Healthcare Interoperability Resources). It helps connect healthcare systems, making it easier for doctors, nurses, and other healthcare professionals to share important information about patients. For example, if you have a lab test at a hospital, HL7 FHIR helps send the results to your doctor’s office so they can provide the right care.

A goal of HL7 is to make sure everyone involved in your healthcare has the right information at the right time. Our standards help machines and people, including you, work together to make better decisions for your health. HL7 sets rules that computer systems follow, so they can understand and share information in a consistent and reliable way.

To learn more about HL7, you can visit the website [hl7.org](http://hl7.org/)

The people at HL7 make guides that explain how to use the rules (standards) for different things. These guides bring the rules together and show how to use them for specific purposes.

### This Guide

This IG focuses on a Golden Identity for data subjects (aka Patient, or Client), and user identity (a.k.a., healthcare professional, patient as user, relative or other authorized agent) and organizations (a.k.a., providers, payers, etc).  The IG provides guidance on APIs and workflows that support identity verification, patient matching, and digital identity management in the context of healthcare transactions. The IG also provides guidance on how to use FHIR resources to support these workflows. 

This Implementation Guide was designed with the goals of:

- Establishing a Digital Identifier standard that can be used along with limited demographics to deterministically match on an individual human or organizational identity including across different systems, and considering its relative accuracy matching with this identifier is the preferred matching method;
- Improving patient matching that continues to rely on demographics, so that matching is based on attributes verified at a high level of assurance along with rubrics determined through stakeholder consensus--giving implementers a framework that may be considered recognized security practices for patient matching and identity management;
- Establishing a well-defined 1) professional healthcare user and 2) consumer-facing identity management playbook that begins with the identity verification event and continues through a transaction with requirements of identity services, requesters, and responders, in order to provide measurable confidence in the identities of all parties to a healthcare transaction such that reliable health data results may be returned, results returned more often, with increased predictably, and at increasing scale;
- Establishing a reliable and unambiguous mechanism to identify organizations, proving their bona fides and their ownership through the existing Global Legal Entity Identifier Foundation (GLEIF) and the Legal Entity Identifier (LEI);
- Utilize a verifiable credential bound to the LEI called a Verifiable Legal Entity Identifier (vLEI) in order to provide a cryptographic capability to assert organizational and individual identity as an alternative to Digital Certificates;
- Make use of credentials that are chained to the vLEI for a legal entity that assert what authorizations the organization has obtained and who at the organization is delegating this authority.

This guide is divided into several pages which are listed in the menu bar.

- [Home](index.html): The home page provides the introduction and background for this project and general requirements that apply to all workflows described in this guide.
- [Use Cases](use-cases.html): This page provides workflows around core Identity concepts, as well as Use Case workflows that highlight different types of healthcare transactions.
- [Golden Identity](golden-identity.html): This page describes the appropriate usage of identity for associating with the subject's data (Patient or Client) for cross-organizational exchange.
- Identity
  - [LEI and vLEI Primer](LEI_vLEI_primer.html): This page provides an introduction to LEI and vLEI concepts for organizational identity.
  - [LEI and vLEI Profiling](LEI_vLEI_Profiling.html): This page provides guidance on profiling LEI and vLEI for verifiable organizational identity.
  - [FHIR Identity](identity.html): This page provides best practices for individual and organizational identity management in the healthcare context.
- [Artifacts](artifacts.html): This page provides additional conformance artifacts for FHIR resources.
- [About](about.html): This page includes background, download details, industry initiatives, the glossary, and change log for this IG.
