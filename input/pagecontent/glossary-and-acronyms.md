# Glossary

**Application (app)**: a program or group of programs designed for end users; typically, software that a user downloads, installs, and manages

**Batch testing**: conducting a large number of tests, such as unit tests, at once 

**Beta testing**: the release of a preliminary version of a software system to a limited set of users to obtain feedback

**CDS Connect**: a freely available web-based platform sponsored by AHRQ that enables the clinical decision support (CDS) community to identify evidence-based care, translate and codify information into an interoperable health IT standard, and leverage tooling to promote a collaborative model of CDS development

**CDS4CPM**: the acronym used to describe the solution that combines a patient-facing application (MyPAIN) with a clinician-facing application (PainManager) to utilize CDS to encourage and support shared decision making around chronic pain management

**Clinical decision support (CDS)**: provides clinicians, staff, patients, and other individuals with knowledge and person-specific information, intelligently filtered or presented at appropriate times, to enhance health and healthcare

**Clinical quality language (CQL):** a high-level, domain-specific language focused on clinical quality and targeted at measure and decision support artifact author

**Cloud hosting**: hosted by a third party in a “virtualized environment” (as distinct from a virtual machine within an institutional firewall) and managed by a cloud hosting company with a specified firewall and detailed security practices

**Code**: as part of the C4 model for visualizing software architecture, items that comprise a component

**Component**: as part of the C4 model for visualizing software architecture, elements of an individual container in the given project scope

**Container**: as part of the C4 model for visualizing software architecture, high-level building blocks of the software system in the given project scope

**Context**: as part of the C4 model for visualizing software architecture, a software system in the given project scope

**Edge case**: a rare use case scenario that would typically only occur under extreme conditions, intended to test the limits of a system

**End-to-end test**: a test of the entire software system from beginning to end to ensure that the application flow behaves as expected; can be completed in early phases and in final phases with different features being tested 

**Fast Healthcare Interoperability Resources (FHIR)**: a standard for exchanging healthcare information electronically

**Fast Healthcare Interoperability Resources (FHIR) façade**: an architectural pattern for implementing FHIR capabilities in a standards-compliant way, in the absence of that support from existing or installed EHR systems. Can also be described as a switchboard or wrapper or similar intended to supply the necessary FHIR responses to support a FHIR application; works with site-specific adapters to achieve this.

**Feature**: a set of related requirements that allow the user to satisfy a business objective or need

**Fix testing**: a process by which system implementers test to confirm the resolution of a reported issue

**Fork**: a strategy used by developers when developing a new application based on an existing one. Developers take a copy of source code from one software package and start independent development on it; sometimes the fork is necessitated by the degree to which changes need to be made to the original to support functions of a modified system.

**Function**: specification of behavior between outputs and inputs

**HAPI**: an open-source framework for building applications and services that enables developers to focus on writing reusable application logic

**HAPI FHIR**: a complete implementation of the Health Level Seven FHIR standard for healthcare interoperability in Java intended to provide a flexible way of adding FHIR capability to applications

**Health Level Seven International (HL7)**: a nonprofit, ANSI-accredited standards-developing organization founded in 1987, dedicated to providing a comprehensive framework and related standards for the exchange, integration, sharing, and retrieval of electronic health information that supports clinical practice and the management, delivery, and evaluation of health services

**Hello World**: a test confirming that the basic, established framework of an application or system is sufficient for continued development

**Interface requirement**: a system requirement that involves an interaction with another system

**Local hosting**: a site hosted on physical hardware solely used by that owner inside the existing firewall with internally managed security and other features

**Logic testing**: a process by which the logic of individual units within an application are tested to ensure they function as expected. In the case of clinical decision support with embedded logic modules (typically via cql), the logic should be tested as a component of the system. 

**Midpoint check**: a point at which one or both applications may be taken offline for any agreed-on or urgent fixes

**Minimum viable product (MVP)**: those features or functions of a system which, when built out, represent a core version of a functioning system

**MyPAIN**: a patient-facing shareable interoperable CDS Substitutable Medical Applications, Reusable Technologies (SMART) on FHIR application to support shared decision making around chronic pain management

**Open source**: source code that is made freely available for possible modification and redistribution

**PainManager**: a clinician-facing shareable interoperable CDS SMART on FHIR application to support shared decision making around chronic pain management

**Patient advocate feedback**: an opportunity for a panel of patient advocates to review and provide feedback on a production-level MyPAIN (version 1, release 1); the panel provided feedback on the app’s look and feel, which resulted in some adjustments to the app

**Patient population testing**: a method of testing a software system using a synthetic set of patient population data to verify that the system behaves as expected

**Pilot go-live (PGL)**: the date on which production-level applications are made available to patients and clinicians within live clinic workflows for the duration of the 2-month “pilot period”

**Pilot period**: the time during which the applications are available within live clinic workflows and data are collected to track applications’ use

**Plumbing test:** more commonly known as an “end-to-end” test

**Public good**: a commodity or service that is provided to all members of a society by the government or a private individual or organization; in many cases, these services are free, cost controlled, or obtainable at low cost

**REDCap**: a secure web application for building and managing online surveys and databases

**Regression testing**: testing that is done to verify that a code change in the software does not affect the product’s existing functionality

**Requirement**: a condition or capability needed by a user to solve a problem or achieve an objective

**Sandbox**: a testing environment that isolates untested code changes and outright experimentation from the production environment or repository, in the context of software development including web development and revision control

**Service**: centrally managed software that provides some logic or functionality to end users, which a user accesses (via application programming interface, website, etc.)

**Shareability**: the extent to which application artifacts, such as implementation guides, and lessons learned are made available to other clinicians or clinics interested in implementing the application in different geographic settings. This can be accomplished by posting to a repository which explicitly allows and/or supports sharing 

**Shared decision making (SDM)**: a model of patient-centered care that enables and encourages people to play a role in the medical decisions that affect their health

**Site-specific adapter**: an adapter at a site, implemented with proprietary mechanisms but exposed using standard FHIR application programming interfaces

**Smoke testing**: preliminary testing of important system functions to reveal simple failures that could prevent a prospective software release

**Soft go-live (SGL)**: an initial release of a production-level product or service to a limited audience before use by the final target audience

**Software as a service (SaaS)**: method of software delivery and licensing in which software is accessed online via a subscription rather than bought and installed on individual computers

**[Software] system**: a series of components working together to deliver services

**Sprint**: in agile development, a designated period during which a selected set of tasks is expected to be completed

**Stewardship**: the job of supervising or taking care of something, such as an organization or property

**Substitutable Medical Applications, Reusable Technologies (SMART)**: an open, standards-based technology platform that enables innovators to create apps that seamlessly and securely run across the healthcare system; originally developed in 2010 and now an HL7 standard

**Synthea**: an open-source, synthetic patient generator that models the medical history of real patients

**Tip sheet**: a document providing guidance for an end user to interact with a software system

**Unit testing**: the testing of individual components or containers to confirm that they are fit for use in a larger system

**United States Core Data for Interoperability (USCDI)**: a standardized set of health data classes and constituent data elements for nationwide, interoperable health information exchange

**US Core Implementation Guide**: based on FHIR version R4 and defines the minimum conformance requirements for accessing patient data

**US Med Implementation Guide**: based on the FHIR version 4.0.1 specification and promotes consistent implementation of the pharmacy FHIR resources in US Realm Electronic Health Record Systems to provide patient and clinician access to patient medications

**User acceptance testing**: a testing process designed to confirm that a software system functions as expected for its intended user bases

**User experience (UX)**: how a user interacts with and experiences a specific page on a website or screen within an application

**User interface (UI)**: the software designed to allow a user to interact with an application; also the point of human-computer interaction and communication in a device.

**Version**: a unique state of computer software

**Wireframe**: layout of a web page that demonstrates what interface elements will exist on key pages



# Acronyms and Abbreviations

**AHRQ**: Agency for Healthcare Research and Quality

**API**: application programming interface

**CDC**: Centers for Disease Control and Prevention

**CDS**: clinical decision support

**CDS4CPM**: Clinical Decision Support for Chronic Pain Management

**CFIR-PR**: Consolidated Framework for Implementation Research—Process Redesign

**COVID-19**: coronavirus disease 2019

**CQL**: Clinical Quality Language

**EHR**: electronic health record

**FDA**: Food and Drug Administration

**FHIR**: Fast Healthcare Interoperability Resources

**HL7**: Health Level Seven

**IG**: Implementation Guide

**IRB**: institutional review board

**IT**: information technology

**IRR**: interrater reliability

**MEDD**: maximum equivalent daily dose (see details on the Epic-specific calculation10) 

**MME/day**: morphine milligram equivalent per day11 (sometimes referred to as morphine equivalent daily dose [MEDD])

**MVP**: minimum viable product

**MyPAIN**: My Pain Assessment and Information Needs

**ONC**: Office of the National Coordinator

**PCCDS-LN**: Patient-Centered Clinical Decision Support Learning Network

**PDMP**: prescription drug monitoring program

**PGL**: pilot go-live or pilot period

**PRO**: patient-reported outcome

**PROMIS**: Patient-Reported Outcomes Measurement Information System

**RQ**: research question

**SDD**: system design document

**SDM**: shared decision making

**SGL**: soft go-live or soft go-live period

**SHARE**: Seek, Help, Assess, Reach, and Evaluate

**SMART**: Substitutable Medical Applications, Reusable Technologies

**TEP**: technical expert panel

**UAT**: user acceptance testing

**UCM**: University of Chicago Medicine

**UF**: University of Florida

**UI**: user interface

**USCDI**: United States Core Data for Interoperability

**UX**: user experience

**VUMC**: Vanderbilt University Medical Center