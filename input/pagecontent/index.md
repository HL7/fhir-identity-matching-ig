<div class="stu-note" markdown="1"> 

STU3 is moving to a service model for the identity management. Providing a common method of identity lookup and referencing, with a service that assures the identity and provides authentication as necessary.

 </div> 

### HL7

[HL7](http://hl7.org/), which stands for Health Level Seven, creates standards to help different healthcare computer systems talk to each other. These HL7 standards are a special language or set of rules that lets information be shared between hospitals, doctors’ offices (e.g. Electronic Health Record Systems), labs, patients (e.g. via patient portals), pharmacies, and insurers, among others.

One of the HL7 standards is HL7 FHIR (Fast Healthcare Interoperability Resources). It helps connect healthcare systems, making it easier for doctors, nurses, and other healthcare professionals to share important information about patients. For example, if you have a lab test at a hospital, HL7 FHIR helps send the results to your doctor’s office so they can provide the right care.

A goal of HL7 is to make sure everyone involved in your healthcare has the right information at the right time. Our standards help machines and people, including you, work together to make better decisions for your health. HL7 sets rules that computer systems follow, so they can understand and share information in a consistent and reliable way.

To learn more about HL7, you can visit the website [hl7.org](http://hl7.org/)

The people at HL7 make guides that explain how to use the rules (standards) for different things. These guides bring the rules together and show how to use them for specific purposes.

### This Guide

This IG focuses on a Golden Identity for data subjects (aka Patient, or Client), and user identity (aka healthcare professional, patient as user, relative or other authorized agent).  The IG provides guidance on APIs and workflows that support identity verification, patient matching, and digital identity management in the context of healthcare transactions. The IG also provides guidance on how to use FHIR resources to support these workflows.

This Implementation Guide was designed with the goals of:

- Establishing a Digital Identifier standard that can be used along with limited demographics to deterministically match on an individual human or organizational identity including across different systems, and considering its relative accuracy matching with this identifier is the preferred matching method;
- Improving patient matching that continues to rely on demographics, so that matching is based on attributes verified at a high level of assurance along with rubrics determined through stakeholder consensus--giving implementers a framework that may be considered recognized security practices for patient matching and identity management; 
- Establishing a well-defined 1) professional healthcare user and 2) consumer-facing identity management playbook that begins with the identity verification event and continues through a transaction with requirements of identity services, requesters, and responders, in order to provide measurable confidence in the identities of all parties to a healthcare transaction such that reliable health data results may be returned, results returned more often, with increased predictably, and at increasing scale;

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
