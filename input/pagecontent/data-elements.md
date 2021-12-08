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

|    Element    |    FHIR Resource    | Observation Code |    FHIR Profile    |    Terminology    |
|-----------|-----------|-----------|-----------|-----------|
| pain location | Observation.value | `mpq-1000` | TextAssessmentObservation | Captured as text |
| pain intensity at worst | Observation.value | `mpq-1001` | CodeableAssessmentObservation profile | [PainAssessmentsIntensity](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-intensity) |
| average pain intensity | Observation.value | `mpq-1002` | CodeableAssessmentObservation profile | [PainAssessmentsIntensity](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-intensity) |
| current pain level | Observation.value | `mpq-1003` | CodeableAssessmentObservation | [PainAssessmentsIntensity](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-intensity) |
| daily activities pain interference | Observation.value | `mpq-1004` | CodeableAssessmentObservation profile | [PainAssessmentsInterference](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-interference) |
| work pain interference | Observation.value | `mpq-1005` | CodeableAssessmentObservation profile | [PainAssessmentsInterference](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-interference) |
| social pain interference | Observation.value | `mpq-1006` | CodeableAssessmentObservation profile | [PainAssessmentsInterference](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-interference) |
| household chore pain interference | Observation.value | `mpq-1007` | CodeableAssessmentObservation profile | [PainAssessmentsInterference](http://fhir.org/guides/cqf/cds4cpm/ValueSet/pain-assessments-interference) |
| methods to help with pain non-pharmacological | Observation.value | `mpq-1008` - `mpq-1016` | CodeableAssessmentObservation profile | PainTherapies |
| OTC pain treatments | Observation.value | `mpq-1017` - `mpq-1019` | CodeableAssessmentObservation profile | PainTherapies |
| prescription pain treatments | Observation.value | `mpq-1020` - `mpq-1022` | CodeableAssessmentObservation profile | PainTherapies |
| mind-body pain treatments | Observation.value | `mpq-1023` - `mpq-1029` | CodeableAssessmentObservation profile | PainTherapies |
| non-traditional pain treatments | Observation.value | `mpq-1030` - `mpq-1034` | CodeableAssessmentObservation profile | PainTherapies |
| activity goals | Observation.value | `mpq-1035` | TextAssessmentObservation profile | Captured as text |
| goal barriers | Observation.value | `mpq-1036` | TextAssessmentObservation profile |  Captured as text |
| completed questionnaire | QuestionnaireResponse | NA | [http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse](http://hl7.org/fhir/uv/sdc/2019May/sdc-questionnaireresponse.html) | |

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

|    Element    |    FHIR Resource    |    FHIR Profile    |    Terminology    |
|-----------|-----------|-----------|-----------|
| patient    |    Patient    | [http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient](https://hl7.org/fhir/us/core/StructureDefinition-us-core-patient.html)	   |       |
| pain location | Observation.valueString | `mpq-1000` | TextAssessment |
| pain intensity at worst | Observation.valueCodeableConcept | `mpq-1001` | CodeableAssessment |
| average pain intensity | Observation.valueCodeableConcept | `mpq-1002` | CodeableAssessment |
| current pain level | Observation.valueCodeableConcept | `mpq-1003` | CodeableAssessment |
| daily activities pain interference | Observation.valueCodeableConcept | `mpq-1004` | CodeableAssessment |
| work pain interference | Observation.valueCodeableConcept | `mpq-1005` | CodeableAssessment |
| social pain interference | Observation.valueCodeableConcept | `mpq-1006` | CodeableAssessment |
| household chore pain interference | Observation.valueCodeableConcept | `mpq-1007` | CodeableAssessment |
| methods to help with pain non-pharmacological | Observation.valueCodeableConcept | `mpq-1008` - `mpq-1016` | CodeableAssessment |
| OTC pain treatments | Observation.valueCodeableConcept | `mpq-1017` - `mpq-1019` | CodeableAssessment |
| prescription pain treatments | Observation.valueCodeableConcept | `mpq-1020` - `mpq-1022` | CodeableAssessment |
| mind-body pain treatments | Observation.valueCodeableConcept | `mpq-1023` - `mpq-1029` | CodeableAssessment |
| non-traditional pain treatments | Observation.valueCodeableConcept | `mpq-1030` - `mpq-1034` | CodeableAssessment |
| activity goals | Observation.valueString | `mpq-1035` | TextAssessment |
| goal barriers |Observation.value | `mpq-1036` | TextAssessment |
| completed questionnaire | QuestionnaireResponse | N/A | [http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse](http://hl7.org/fhir/uv/sdc/2019May/sdc-questionnaireresponse.html) |
| other pain assessments | Observation | AssessmentObservation | PROMIS coding |
| pertinent medical history conditions | Condition | [US Core Condition](https://hl7.org/fhir/us/core/StructureDefinition-us-core-condition.html) | (condition terminologies) |
| encounters with relevant diagnoses | Encounter | [US Core Encounter](https://hl7.org/fhir/us/core/StructureDefinition-us-core-encounter.html) | (encounter diagnosis terminologies) |

#### Observations

Implementations SHALL support searching for Observation by patient, category, and, optionally, date:

`GET [base]/Observation?patient=1234&category=http://terminology.hl7.org/CodeSystem/observation-category|survey`

`GET [base]/Observation?patient=1234&category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory`

`GET [base]/Observation?patient=1234&date=ge2019-01-01`

Implementations SHALL support searching for Observation by patient and code:

`GET [base]/Observation?patient=1234&code=http://fhir.org/guides/cqf/cds4cpm/CodeSystem/MyPAIN-questionnaire-codes|mpq-1000`

The PainManager application will then use Observations with the following terminologies:

**Recommendation 10**

```
"Non-opioid illicit drug urine screening": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/non-opioid-illicit-drug-urine-screening'
"Opioid drug urine screening": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-drug-urine-screening'
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

```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
```

**Recommendation 8**

```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
"Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'
"Naloxone medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/naloxone-medications'
```

**Recommendation 11**

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

```
"Limited life expectancy conditions": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/limited-life-expectancy-conditions-enum'
"Conditions likely terminal for opioid prescribing": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/conditions-likely-terminal-for-opioid-prescribing-enum'
```

**Active Cancer Treatment (Recommendations 3, 8, 10, and 11)**

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

**Recommendation 3**

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

**Recommendation 3**

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
