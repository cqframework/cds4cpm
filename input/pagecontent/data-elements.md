# Data Elements

This page details data elements used throughout the CDS4CPM Implementation Guide.

## MyPAIN Data Elements and Terminology

Summary of MyPAIN minimum API usage (SHALL support data elements):

MyPAIN:
`GET [base]/Patient/1234`
`GET [base]/Questionnaire/MyPAIN-questionnaire`
`POST [base]/QuestionnaireResponse`

### Input Data

MyPAIN uses input data that it receives from the calling application.  MyPAIN will not be able to correctly display or save the data collected without this information.


|    Element    |    FHIR Resource    |    FHIR Profile    |    Terminology    | Conformance |
|-----------|-----------|-----------|-----------|-----------|
|    patient    |    Patient    | [http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient](https://hl7.org/fhir/us/core/StructureDefinition-us-core-patient.html)	   |       | SHALL |
|    appointment    |    Appointment    |    [http://fhir.org/guides/argonaut-scheduling/StructureDefinition/argo-appt](http://www.fhir.org/guides/argonaut/scheduling/StructureDefinition-argo-appt.html)    |       | SHOULD |
|    clinician name    |    (Appointment.participant.actor.resolve() as Practitioner).name    |  [http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner](http://hl7.org/fhir/us/core/StructureDefinition-us-core-practitioner.html)    |    | SHOULD |
|    date and time    |    Appointment.start    |    [http://fhir.org/guides/argonaut-scheduling/StructureDefinition/argo-appt](http://www.fhir.org/guides/argonaut/scheduling/StructureDefinition-argo-appt.html)    |   | SHOULD |
|    questionnaire    | Questionnaire  |  [http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire](http://hl7.org/fhir/uv/sdc/2019May/sdc-questionnaire.html)  |    | SHOULD |
| partially completed questionnaire | QuestionnaireResponse | [http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse](http://hl7.org/fhir/uv/sdc/2019May/sdc-questionnaireresponse.html) | | SHOULD |

#### Patient Retrieval
Implementations SHALL support retrieval of a Patient conforming to the US Core Patient Profile by patient ID:
`GET [base]/Patient/1234`

#### MyPAIN Enrollment
CONSIDER: Implementations MAY support modeling patient enrollment as a Group resource, listing all patients explicitly. Searching would then be possible using the "member" search of the group, or we could define an $ismember operation if we want to ensure that users can only ask if a patient they know about is a member of the group (rather than having to retrieve the whole group).

#### Next Appointment
Implementations MAY support appointment searching as described by the [patient scheduling use case](http://www.fhir.org/guides/argonaut/scheduling/patient-scheduling.html#usage-13). Specifically, appointment search:

`GET [base]/Appointment?patient=[id]{&status=[status]}{&date=[date]{&date=[date]}}{&practitioner=[id]}`

`GET [base]/Appointment?patient=1234&status=booked&date=ge2020-05-01`

This would retrieve all appointments, therefore implementers may want to consider just defining a $next-appointment operation to simplify both implementation and usage.

#### Questionnaire Retrieval
Implementations SHOULD support retrieval of a Questionnaire resource conforming to the Structured Data Capture (SDC) Questionnaire profile to describe the contents of the MyPAIN questionnaire:

Questionnaire read:
`GET [base]/Questionnaire/MyPAIN-questionnaire`

Implementations MAY support retrieval of a Questionnaire by canonical URL and version:

Questionnaire search:
`GET [base]/Questionnaire?url=http://fhir.org/guides/cds4cpm/Questionnaire/MyPAIN-questionnaire`

### Output Data

These data elements represent the information and responses to the questionnaire that the patient fills out.  These data are submitted at the end of the questionnaire to a designated location and later used in the Pain Manager Dashboard.

| Element                             | FHIR Resource         | Observation Code                                                          | FHIR Profile                                                                                                                                  | Terminology             |
|-------------------------------------|-----------------------|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|-------------------------|
| pain locations                      | Observation.value     | `mpq-1038` - `mpq-1052`, `mpq-1066` - `mpq-1069`                          | CodeableAssessmentObservation profile                                                                                                         | PainAssessmentsLocation |
| other pain locations description    | Observation.value     | `mpq-1053`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| otc pain treatments                 | Observation.value     | `mpq-1017` - `mpq-1019`, `mpq-1070`                                       | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other otc treatments                | Observation.value     | `mpq-1055`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| pain strategies non-pharmacological | Observation.value     | `mpq-1008` - `mpq-1016`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other strategies                    | Observation.value     | `mpq-1054`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| prescription pain treatments        | Observation.value     | `mpq-1020` - `mpq-1022`, `mpq-1071` - `mpq-1074`                          | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other prescription medications      | Observation.value     | `mpq-1057`, `mpq-1075`                                                    | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| mind-body pain treatments           | Observation.value     | `mpq-1023` - `mpq-1029`, `mpq-1058`                                       | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other mind-body treatments          | Observation.value     | `mpq-1059`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| non-traditional treatments          | Observation.value     | `mpq-1030` - `mpq-1034`, `mpq-1056`, `mpq-1060`, `mpq-1110` -  `mpq-1113` | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other non-traditional treatments    | Observation.value     | `mpq-1114`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| not tried                           | Observation.value     | `mpq-1076` - `mpq-1077`, `mpq-1080` - `mpq-1082`, `mpq-1085`              | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| alternative treatments              | Observation.value     | `mpq-1078` - `mpq-1079`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| specialists seen                    | Observation.value     | `mpq-1086` - `mpq-1092`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other specialists seen              | Observation.value     | `mpq-1093`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| physical treatments                 | Observation.value     | `mpq-1094` - `mpq-1096`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other physical treatments           | Observation.value     | `mpq-1097`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| topical treatments                  | Observation.value     | `mpq-1098` - `mpq-1102`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other topical treatments            | Observation.value     | `mpq-1103`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| lifestyle changes                   | Observation.value     | `mpq-1104` - `mpq-1108`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other lifestyle changes             | Observation.value     | `mpq-1109`                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| goals                               | Observation.value     | `mpq-1035` -`mpq-1036`, `mpq-1115` -`mpq-1116`                            | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| external information accessed       | Observation.value     | `mpq-1061` - `mpq-1062`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| mypain feedback                     | Observation.value     | `mpq-1063` - `mpq-1064`                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| questionnaireresponse date-time     | Observation.value     | `mpq-1065`                                                                | CodeableAssessmentObservation profile                                                                                                         | Captured as text        |
| completed questionnaire             | QuestionnaireResponse | NA                                                                        | [http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse](http://hl7.org/fhir/uv/sdc/2019May/sdc-questionnaireresponse.html) |                         |

#### QuestionnaireResponse
Implementations SHALL support the creation of a QuestionnaireResponse, conforming to the SDC [form filler](http://hl7.org/fhir/uv/sdc/2019May/sdc-form-filler.html), containing patient answers to questions in the MyPAIN questionnaire:

`POST [base]/QuestionnaireResponse`

In addition, implementations MAY support update of a QuestionnaireResponse and retrieval of an in-progress questionnaire response:

QuestionnaireResponse update:
`PUT [base]/QuestionnaireResponse/1234`

QuestionnaireResponse search:
`GET [base]/QuestionnaireResponse?questionnaire=MyPAIN-questionnaire&patient=1234&status=in-progress`

## PainManager

Summary of PainManager minimum API usage (SHALL support data elements):

PainManager:
`GET [base]/Patient/1234`
`GET [base]/Observation?patient=1234&category=http://terminology.hl7.org/CodeSystem/observation-category|survey`
`GET [base]/Observation?patient=1234&category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`
`GET [base]/Observation?patient=1234&date=ge2019-09-19`
`GET [base]/Observation?patient=1234&code=http://fhir.org/guides/cqf/cds4cpm/CodeSystem/MyPAIN-questionnaire-codes|mpq-1000`
`GET [base]/MedicationRequest?patient=1234`
`GET [base]/MedicationRequest?patient=1234&authoredon=ge2019-09-19`
`GET [base]/Condition?patient=1234&category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item`
`GET [base]/Condition?patient=1234&category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis`
`GET [base]/Condition?patient=1234&category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis&onset-date=ge2019-09-19`

### Input Data

| Element                              | FHIR Resource         | FHIR Profile                                                                                                                              | Terminology                                                                                                                                   |
|--------------------------------------|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| patient                              | Patient               | [http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient](https://hl7.org/fhir/us/core/StructureDefinition-us-core-patient.html)	 |                                                                                                                                               |
| pain locations                       | Observation.value     | `mpq-1038` - `mpq-1052`, `mpq-1066` - `mpq-1069`                                                                                          | CodeableAssessmentObservation profile                                                                                                         | PainAssessmentsLocation |
| other pain locations description     | Observation.value     | `mpq-1053`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| otc pain treatments                  | Observation.value     | `mpq-1017` - `mpq-1019`, `mpq-1070`                                                                                                       | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other otc treatments                 | Observation.value     | `mpq-1055`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| pain strategies non-pharmacological  | Observation.value     | `mpq-1008` - `mpq-1016`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other strategies                     | Observation.value     | `mpq-1054`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| prescription pain treatments         | Observation.value     | `mpq-1020` - `mpq-1022`, `mpq-1071` - `mpq-1074`                                                                                          | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other prescription medications       | Observation.value     | `mpq-1057`, `mpq-1075`                                                                                                                    | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| mind-body pain treatments            | Observation.value     | `mpq-1023` - `mpq-1029`, `mpq-1058`                                                                                                       | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other mind-body treatments           | Observation.value     | `mpq-1059`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| non-traditional treatments           | Observation.value     | `mpq-1030` - `mpq-1034`, `mpq-1056`, `mpq-1060`, `mpq-1110` -  `mpq-1113`                                                                 | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other non-traditional treatments     | Observation.value     | `mpq-1114`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| not tried                            | Observation.value     | `mpq-1076` - `mpq-1077`, `mpq-1080` - `mpq-1082`, `mpq-1085`                                                                              | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| alternative treatments               | Observation.value     | `mpq-1078` - `mpq-1079`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| specialists seen                     | Observation.value     | `mpq-1086` - `mpq-1092`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other specialists seen               | Observation.value     | `mpq-1093`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| physical treatments                  | Observation.value     | `mpq-1094` - `mpq-1096`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other physical treatments            | Observation.value     | `mpq-1097`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| topical treatments                   | Observation.value     | `mpq-1098` - `mpq-1102`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other topical treatments             | Observation.value     | `mpq-1103`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| lifestyle changes                    | Observation.value     | `mpq-1104` - `mpq-1108`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| other lifestyle changes              | Observation.value     | `mpq-1109`                                                                                                                                | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| goals                                | Observation.value     | `mpq-1035` -`mpq-1036`, `mpq-1115` -`mpq-1116`                                                                                            | TextAssessmentObservation profile                                                                                                             | Captured as text        |
| external information accessed        | Observation.value     | `mpq-1061` - `mpq-1062`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| mypain feedback                      | Observation.value     | `mpq-1063` - `mpq-1064`                                                                                                                   | CodeableAssessmentObservation profile                                                                                                         | PainTherapies           |
| questionnaireresponse date-time      | Observation.value     | `mpq-1065`                                                                                                                                | CodeableAssessmentObservation profile                                                                                                         | Captured as text        |
| completed questionnaire              | QuestionnaireResponse | N/A                                                                                                                                       | [http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse](http://hl7.org/fhir/uv/sdc/2019May/sdc-questionnaireresponse.html) |
| other pain assessments               | Observation           | AssessmentObservation                                                                                                                     | PROMIS coding                                                                                                                                 |
| pertinent medical history conditions | Condition             | [US Core Condition](https://hl7.org/fhir/us/core/StructureDefinition-us-core-condition.html)                                              | (condition terminologies)                                                                                                                     |
| encounters with relevant diagnoses   | Encounter             | [US Core Encounter](https://hl7.org/fhir/us/core/StructureDefinition-us-core-encounter.html)                                              | (encounter diagnosis terminologies)                                                                                                           |

#### Observations

Implementations SHALL support searching for Observation by patient, category, and, optionally, date:

`GET [base]/Observation?patient=1234&category=http://terminology.hl7.org/CodeSystem/observation-category|survey`

`GET [base]/Observation?patient=1234&category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`

`GET [base]/Observation?patient=1234&date=ge2019-01-01`

Implementations SHALL support searching for Observation by patient and code:

`GET [base]/Observation?patient=1234&code=http://fhir.org/guides/cqf/cds4cpm/CodeSystem/MyPAIN-questionnaire-codes|mpq-1000`

The PainManager application will then use Observations with the following terminologies:

**[Recommendation 10](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-10-order-sign.html){:target="_blank"}**


When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (recommendation category: B; evidence type: 4).

```
"Urine drug screen for pain management": 'http://fhir.org/guides/cdc/opioid-cds-r4/ValueSet/non-opioid-drug-urine-screening'
"Urine drug screen for pain management": 'http://fhir.org/guides/cdc/opioid-cds-r4/ValueSet/drug-urine-screening'
```

**Pain Assessments**

```
"Pain severity Wong-Baker FACES Scale": '38221-8' from http://loinc.org
"Mean score [PEG]": '91147-9' from http://loinc.org
"Pain Enjoyment General Activity (PEG) Assessment LEGACY": 'PEGASSESSMENT' from http://cds.ahrq.gov/cdsconnect/pms
"Total score [STarT Back]": '91351-7' from http://loinc.org
"STarT Back Screening Tool LEGACY": 'STARTBACK' from http://cds.ahrq.gov/cdsconnect/pms
"MyPAIN Questionnaire Codes": 'http://fhir.org/guides/cqf/cds4cpm/CodeSystem/MyPAIN-questionnaire-codes'
```

**Risk Considerations**

```
"Morphine Milligram Equivalent (MME)": 'MME' from http://cds.ahrq.gov/cdsconnect/pms
"Urine drug screen for pain management": '2.16.840.1.113762.1.4.1032.28'
"Risk assessments relevant to pain management": '2.16.840.1.113762.1.4.1032.55'
"Single question r/t ETOH use": 'SQETOHUSE' from http://cds.ahrq.gov/cdsconnect/pms
"Single question r/t drug use": 'SQDRUGUSE' from http://cds.ahrq.gov/cdsconnect/pms
```

#### MedicationRequest

Implementations SHALL support search for MedicationRequest by patient, returning medication requests conformant to the US Core MedicationRequest profile:

`GET [base]/MedicationRequest?patient=1234`

Implementations SHOULD support search for MedicationRequest by patient, filtered with authoredOn, returning medication requests conformant to the US Core MedicationRequest profile:

`GET [base]/MedicationRequest?patient=1234&authoredon=ge2019`

For implementations that want to support Morphine Milligram Equivalents (MME) calculation using MedicationRequest resources, the MMEMedicationRequest profile is required.

The PainManager application will then use MedicationRequest information for medications in the following value sets:

**Chronic Pain (Recommendations 3, 8, and 10)**


***[Recommendation 3](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-03-order-sign.html){:target="_blank"}***

When starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids (recommendation category: A; evidence type: 4).

***[Recommendation 8](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-08.html){:target="_blank"}***

Before starting and periodically during continuation of opioid therapy, clinicians should evaluate risk for opioid-related harms and discuss risk with patients. Clinicians should work with patients to incorporate into the management plan strategies to mitigate risk, including offering naloxone (recommendation category: A; evidence type: 4).
```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
"Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'
"Naloxone medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/naloxone-medications'
```

***[Recommendation 11](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-11-order-select.html){:target="_blank"}***

When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (recommendation category: B; evidence type: 4).

```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
"Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'
```

**Historical Treatments**
```
"Opioid Pain Medications": '2.16.840.1.113762.1.4.1032.34'
"Non opioid pain medications": '2.16.840.1.113762.1.4.1032.26'
"Stool softeners and laxatives": '2.16.840.1.113762.1.4.1032.44'
```

**Risk Considerations**

```
"Benzodiazepine medications": '2.16.840.1.113762.1.4.1032.43'
"Naloxone medications": '2.16.840.1.113762.1.4.1032.42'
```

#### Conditions

Clinical intent is to look for conditions that may be risk factors or to provide relevant information about pain management for the patient.

Implementations SHALL support searching for Condition by patient and category, returning conditions conformant to the US Core Condition profile.

Condition search by patient, and category of problem-list-item:

`GET [base]/Condition?patient=1234&category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item`

Condition search by patient, and category of encounter-diagnosis:

`GET [base]/Condition?patient=1234&category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis`

Condition search by patient, category, and onset-date:

`GET [base]/Condition?patient=1234&category=http://terminology.hl7.org/CodeSystem/condition-category|encounter-diagnosis&onset-date=ge2019`

The PainManager application will then use Conditions with `code` values in the following value sets:

**Opioid Review Useful (Recommendations 3, 8, 10, and 11)**


[Recommendation 3:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-03-order-sign.html){:target="_blank"}

When starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids (recommendation category: A; evidence type: 4).

[Recommendation 8:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-08.html){:target="_blank"}

Before starting and periodically during continuation of opioid therapy, clinicians should evaluate risk for opioid-related harms and discuss risk with patients. Clinicians should work with patients to incorporate into the management plan strategies to mitigate risk, including offering naloxone (recommendation category: A; evidence type: 4).

[Recommendation 10:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-10-order-sign.html){:target="_blank"}

When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (recommendation category: B; evidence type: 4).

[Recommendation 11:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-11-order-select.html){:target="_blank"}

When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (recommendation category: B; evidence type: 4).

```
"Limited life expectancy conditions": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/limited-life-expectancy-conditions-enum'
"Conditions likely terminal for opioid prescribing": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/conditions-likely-terminal-for-opioid-prescribing-enum'
```

**Active Cancer Treatment (Recommendations 3, 8, 10, and 11)**


[Recommendation 3:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-03-order-sign.html){:target="_blank"}

When starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids (recommendation category: A; evidence type: 4).

[Recommendation 8:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-08.html){:target="_blank"}

Before starting and periodically during continuation of opioid therapy, clinicians should evaluate risk for opioid-related harms and discuss risk with patients. Clinicians should work with patients to incorporate into the management plan strategies to mitigate risk, including offering naloxone (recommendation category: A; evidence type: 4).

[Recommendation 10:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-10-order-sign.html){:target="_blank"}

When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (recommendation category: B; evidence type: 4).

[Recommendation 11:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-11-order-select.html){:target="_blank"}

When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (recommendation category: B; evidence type: 4).

```
"CDC malignant cancer conditions": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/cdc-malignant-cancer-conditions-enum'
```

**Pertinent Medical History**

```
"Conditions associated with chronic pain": '2.16.840.1.113762.1.4.1032.37'
"Pregnancy": '2.16.840.1.113883.3.526.3.378'
"Pregnancy (New ICD10 codes published in 2018 and 2019)": '2.16.840.1.113762.1.4.1032.80'
"Major Depression": '2.16.840.1.113883.3.464.1003.105.12.1007'
"Depression Diagnosis ICD9": '2.16.840.1.113883.3.600.143'
"Anxiety": '2.16.840.1.113762.1.4.1032.52'
"Anxiety Disorders ICD9": '2.16.840.1.113883.3.1240.2017.3.2.1015'
"Substance use disorder": '2.16.840.1.113883.3.464.1003.106.11.1010'
"Suicide Attempt": '2.16.840.1.113762.1.4.1032.102'
"Sleep-disordered breathing": '2.16.840.1.113762.1.4.1032.53'
"Kidney Failure": '2.16.840.1.113883.3.464.1003.109.12.1028'
"Chronic Liver Disease": '2.16.840.1.113883.3.464.1003.199.12.1035'
"Liver Disease": '2.16.840.1.113762.1.4.1047.42'
```

#### Encounters
In addition to condition resources, some systems may support the use of the `reasonCode` element of an `Encounter` to indicate the reason for the visit, and these may be exposed using standard condition terminologies.

Implementations MAY support encounter reason codes, using the US Core Encounter profile.

`GET [base]/Encounter?patient-1234&status=finished`

**Active Cancer Treatment (Recommendations 3, 8, 10, and 11)**

```
"Office Visit": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/office-visit'
```

**Pertinent Medical History**

```
"Conditions associated with chronic pain": '2.16.840.1.113762.1.4.1032.37'
"Pregnancy": '2.16.840.1.113883.3.526.3.378'
"Pregnancy (New ICD10 codes published in 2018 and 2019)": '2.16.840.1.113762.1.4.1032.80'
"Major Depression": '2.16.840.1.113883.3.464.1003.105.12.1007'
"Depression Diagnosis ICD9": '2.16.840.1.113883.3.600.143'
"Anxiety": '2.16.840.1.113762.1.4.1032.52'
"Anxiety Disorders ICD9": '2.16.840.1.113883.3.1240.2017.3.2.1015'
"Substance use disorder": '2.16.840.1.113883.3.464.1003.106.11.1010'
"Suicide Attempt": '2.16.840.1.113762.1.4.1032.102'
"Sleep-disordered breathing": '2.16.840.1.113762.1.4.1032.53'
"Kidney Failure": '2.16.840.1.113883.3.464.1003.109.12.1028'
"Chronic Liver Disease": '2.16.840.1.113883.3.464.1003.199.12.1035'
"Liver Disease": '2.16.840.1.113762.1.4.1047.42'
```

NOTE: The PainManager application does not use this approach, so it does not require this capability to be supported at this time. We retain the documentation here for completeness.

#### Procedure

Implementations SHOULD support searching for Procedures by Patient and code, returning Procedures conformant to the US Core Procedure profile:

`GET [base]/Procedure?patient=123&code=http://snomed.info/sct|35637008`

***[Recommendation 3:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-03-order-sign.html){:target="_blank"}***

When starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids (recommendation category: A; evidence type: 4).

```
"Opioid counseling procedure": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-counseling-procedure'
```

#### ServiceRequest

Implementations MAY support searching for ServiceRequests by Patient and code:

`GET [base]ServiceRequest?patient=123&code=http://snomed.info/sct|35637008`

NOTE: There is no US Core profile for the ServiceRequest resource at this time.

**Opioid Review Useful (Recommendations 3, 8, 10, and 11)**

```
"Therapies indicating end of life care": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/therapies-indicating-end-of-life-care-enum'
```

***[Recommendation 3:](http://build.fhir.org/ig/cqframework/opioid-cds-r4/recommendation-03-order-sign.html){:target="_blank"}***

When starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids (recommendation category: A; evidence type: 4).

```
"Opioid counseling procedure": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-counseling-procedure'
```

**Historical Treatments**
```
"Non pharmacologic treatments for chronic pain": '2.16.840.1.113762.1.4.1032.36'
```

#### PractitionerRole

Implementations SHOULD support read of PractitionerRole.

`GET [base]/PractitionerRole/123`

The Pain Manager application will use the following terminologies for PractitionerRole:

```
"Oncology specialty designations (NUCC)": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/oncology-specialty-designations-enum'
```
