## MyPain and PainManager Capability Statement

* Implementation Guide Version: 1.0.0
* FHIR Version: 4.0.1
* Supported formats: xml, json
* Published: 2020-04-27

This Section describes the expected capabilities of the MyPain and Pain Manager Dashboard 
which are responsible for......... 
The complete list of FHIR profiles, RESTful operations, and search parameters supported by 
US Core Servers are defined. Systems implementing this capability statement should meet 




## MyPain Data Elements
#### Passed In Data

Data that MyPain uses that it receives from the calling application.  MyPain will not be able to correctly display not save the data collected without this information.
  

|    Element    |    FHIR Resource    |    FHIR Link    |    Terminology    |
|-----------|-----------|-----------|-----------|
|    Patient    |    Patient    | https://hl7.org/fhir/us/core/StructureDefinition-us-core-patient.html	   |       |
|    appointment    |    Schedule    |    http://www.fhir.org/guides/argonaut/scheduling/StructureDefinition-argo-appt.html    |       |
|    clinician name    |    Schedule.actor    |    http://www.fhir.org/guides/argonaut/scheduling/StructureDefinition-argo-appt.html    |    |
|    date and time    |    Schedule.start    |    http://www.fhir.org/guides/argonaut/scheduling/StructureDefinition-argo-appt.html    |   |
|    patient invited to MyPain    |        |        |   |

#### Data Collected Within MyPain

These data elements represent the information and responses to the questionnaire that the patient fills out.  This collected data is submitted at the end of the questionnaire to a designated location and later used in the Pain Manager Dashboard.    

|    Element    |    FHIR Resource    |    FHIR Link    |    Terminology    |
|-----------|-----------|-----------|-----------|
| pain location | Condition.bodySite | http://hl7.org/fhir/us/core/STU3.1/StructureDefinition-us-core-condition.html | http://hl7.org/fhir/ValueSet-body-site.html | 
| pain at worst | Condition.severity | http://hl7.org/fhir/us/core/STU3.1/StructureDefinition-us-core-condition.html | http://hl7.org/fhir/ValueSet-condition-severity.html |
| pain severity | Condition.severity | http://hl7.org/fhir/us/core/STU3.1/StructureDefinition-us-core-condition.html | http://hl7.org/fhir/ValueSet-condition-severity.html |
| current pain level | Condition.severity | http://hl7.org/fhir/us/core/STU3.1/StructureDefinition-us-core-condition.html | http://hl7.org/fhir/ValueSet-condition-severity.html |
| daily activities pain interference ||||
| work pain interference ||||
| social pain interference ||||		
| household chore pain interference ||||
| methods to help with pain non-pharmacological ||||
| OTC pain treatments | MedicationStatement | http://hl7.org/fhir/us/core/STU3/StructureDefinition-us-core-medicationstatement.html |  | 
| prescription pain treatments | MedicationStatement | http://hl7.org/fhir/us/core/STU3/StructureDefinition-us-core-medicationstatement.html |  | 
| mind-body pain treatments | | |  |
| non-traditional pain treatments | | |  |
| activity goals | Goal | http://hl7.org/fhir/us/core/StructureDefinition-us-core-goal.html ||
| goal barriers ||||

