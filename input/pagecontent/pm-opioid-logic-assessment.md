## Related CDS Content for Pain Management

The development of the CDS4CPM artifacts included a review and assessment of related CDS content for pain management. The review below details the differences between the CDS content
found in the [AHRQ CDS Pain Management Summary tool](https://github.com/AHRQ-CDS/AHRQ-CDS-Connect-PAIN-MANAGEMENT-SUMMARY)
and the [Opioid Prescribing Support Implementation Guide](https://github.com/cqframework/opioid-cds).

### Opioid Prescribing Support Implementation Guide

The Opioid Prescribing Support Implementation Guide is a joint effort by the Centers for Disease Control and Prevention (CDC) and the Office of the National Coordinator for Health IT (ONC) focused on improving processes for the development of standardized, shareable, computable decision support artifacts using the [CDC Opioid Prescribing Guideline](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm?CDC_AA_refVal=https%3A%2F%2Fwww.cdc.gov%2Fmmwr%2Fvolumes%2F65%2Frr%2Frr6501e1er.htm) as a model case.

The guide currently includes artifacts to support all 12 recommendations contained in the CDC Opioid Guideline. However, only recommendations 3, 8, 10, and 11 are used for this review.

#### Opioid Review Useful
{: #opioid-review-useful}

Patient is 18 years old or older without the following:
- Findings of limited life expectancy conditions
- Orders for therapies indicating end-of-life care in past 90 days
- Active cancer treatment or conditions that are likely terminal for opioid prescribing

**Data Elements**

```
[Condition: "Limited life expectancy conditions"] where clinicalStatus is 'active'
[ProcedureRequest: "Therapies indicating end of life care"] where status is 'active' or 'completed' in past 90 days
[Condition: "Conditions likely terminal for opioid prescribing"] where clinicalStatus is 'active'
```

**Terminology Elements**

```
"Limited life expectancy conditions": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/limited-life-expectancy-conditions-enum'
"Therapies indicating end of life care": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/therapies-indicating-end-of-life-care-enum'
"Conditions likely terminal for opioid prescribing": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/conditions-likely-terminal-for-opioid-prescribing-enum'
```

#### Active Cancer Treatment
{: #active-cancer-treatment}

Patient has not had two distinct encounters within a year of the current visit with a diagnosis in the CDC Malignant Cancer Conditions value set.

**Data Elements**

```
[Encounter: "Office Visit"] in past year with diagnosis of ([Condition: "CDC malignant cancer conditions"]) and participant (performed by) is ([PractitionerRole] where specialty is "Oncology specialty designations (NUCC)")
```

**Terminology Elements**

```
"Office Visit": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/office-visit'
"CDC malignant cancer conditions": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/cdc-malignant-cancer-conditions-enum'
"Oncology specialty designations (NUCC)": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/oncology-specialty-designations-enum'
```

#### Chronic Pain
{: #chronic-pain}
Determining whether a patient is being prescribed opioids for chronic pain is difficult to determine by examination of the medical record alone. The project team identified the following proxies for chronic pain, used throughout the recommendations:

1. A medication is considered for chronic pain if it is being prescribed for 28 days or more.

1. A medication is considered for acute pain if it is being prescribed for less than 28 days.

**Data Elements**

```
[MedicationRequest: "Opioid analgesics with ambulatory misuse potential"] where status is 'active' and category is "Community" and dispenseRequest.expectedSupplyDuration >= 28 days
```

**Terminology Elements**

```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
"Community": 'community' from http://hl7.org/fhir/medication-request-category
```

#### Recommendation 3
Before starting and periodically during opioid therapy, clinicians should
discuss with patients known risks and realistic benefits of opioid therapy
and patient and clinician responsibilities for managing therapy
(recommendation category: A, evidence type: 3).

Active Subroutines:
- [Chronic Pain](#chronic-pain)
- [Opioid Review Useful](#opioid-review-useful)

**Data Elements**

```
[Procedure: "Opioid counseling procedure"] where status is 'completed' in past 90 days
[ProcedureRequest: "Opioid counseling procedure"] in past 90 days
```

**Terminology Elements**

```
"Opioid counseling procedure": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-counseling-procedure'
```

#### Recommendation 8
Before starting and periodically during continuation of opioid therapy, clinicians should evaluate risk factors for opioid-related harms. Clinicians should incorporate into the management plan strategies to mitigate risk, including considering offering naloxone when factors that increase risk for opioid overdose, such as history of overdose, history of substance use disorder, higher opioid dosages (≥50 MME/day), or concurrent benzodiazepine use, are present (recommendation category: A, evidence type: 4).

Active Subroutines:
- [Chronic Pain](#chronic-pain)
- [Opioid Review Useful](#opioid-review-useful)

**Data Elements**

```
[MedicationRequest: "Opioid analgesics with ambulatory misuse potential"] where status is 'active' and category is "Community"
[MedicationRequest: "Benzodiazepine medications"] where status is 'active' and category is "Community"
[MedicationRequest: "Naloxone medications"] where status is 'active' and category is "Community"
```

**Terminology Elements**

```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
"Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'
"Naloxone medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/naloxone-medications'
"Community": 'community' from http://hl7.org/fhir/medication-request-category
```

#### Recommendation 10
When prescribing opioids for chronic pain, providers should use urine drug testing before starting opioid therapy and consider urine drug testing at least annually to assess for prescribed medications as well as other controlled prescription drugs and illicit drugs (recommendation category: B, evidence type: 4).

Active Subroutines:
- [Chronic Pain](#chronic-pain)
- [Opioid Review Useful](#opioid-review-useful)

**Data Elements:**
```
[Observation: "Non-opioid illicit drug urine screening"] in past year
[Observation: "Opioid drug urine screening"] in past year
```

**Terminology Elements**

```
"Non-opioid illicit drug urine screening": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/non-opioid-illicit-drug-urine-screening'
"Opioid drug urine screening": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-drug-urine-screening'
```

#### Recommendation 11
Clinicians should avoid prescribing opioid pain medication and benzodiazepines concurrently whenever possible (recommendation category: A, evidence type: 3).

Active Subroutine:
- [Opioid Review Useful](#opioid-review-useful)

**Data Elements**

```
[MedicationRequest: "Opioid analgesics with ambulatory misuse potential"] where status is 'active' and category is "Community"
[MedicationRequest: "Benzodiazepine medications"] where status is 'active' and category is "Community"
```

**Terminology Elements**

```
"Opioid analgesics with ambulatory misuse potential": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'
"Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'
```

### AHRQ CDS Pain Management Summary Tool

The Pain Management Summary artifact provides relevant information to consider when managing a patient's pain. This CDS logic was informed by the CDC Guideline for Prescribing Opioids for Chronic Pain. The CDS is not a direct representation of any one recommendation statement within the guideline. Instead, the CDS compiles clinical concepts mentioned throughout the guideline in one consolidated summary for clinician review.

This tool returns a "summary" object, which represents the full Pain Management Summary to be displayed to the clinician. All values are returned as user-friendly text representations.

#### Pertinent Medical History

**Data Elements**

```
[Condition: "Conditions associated with chronic pain"] where verificationStatus is 'confirmed'
[Condition: "Pregnancy"] where status is 'final' or 'corrected' or 'amended' and clinicalStatus is 'active' or 'recurrence' or 'relapse' in past 42 weeks
[Condition: "Pregnancy (New ICD10 codes published in 2018 and 2019)"] where status is 'final' or 'corrected' or 'amended' and clinicalStatus is 'active' or 'recurrence' or 'relapse' in past 42 weeks
[Condition: "Major Depression"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Condition: "Depression Diagnosis ICD9"] where verificationStatus is 'confirmed'
[Condition: "Anxiety"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Condition: "Anxiety Disorders ICD9"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Condition: "Substance use disorder"] where verificationStatus is 'confirmed'
[Condition: "Substance Abuse"] where verificationStatus is 'confirmed'
[Condition: "Suicide Attempt"] where verificationStatus is 'confirmed'
[Condition: "Sleep-disordered breathing"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Condition: "Kidney Failure"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Condition: "Chronic Liver Disease"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Condition: "Liver Disease"] where verificationStatus is 'confirmed' and clinicalStatus is 'active' or 'recurrence' or 'relapse'
[Encounter: reasonCode in "Major Depression"]
[Encounter: reasonCode in "Depression Diagnosis ICD9"]
[Encounter: reasonCode in "Anxiety"]
[Encounter: reasonCode in "Anxiety Disorders ICD9"]
[Encounter: reasonCode in "Substance use disorder"]
[Encounter: reasonCode in "Substance Abuse"]
[Encounter: reasonCode in "Suicide Attempt"]
[Encounter: reasonCode in "Sleep-disordered breathing"]
[Encounter: reasonCode in "Kidney Failure"]
[Encounter: reasonCode in "Chronic Liver Disease"]
[Encounter: reasonCode in "Liver Disease"]
```

**Terminology Elements**

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

#### Pain Assessments

**Data Elements**

```
[Observation: "Pain severity Wong-Baker FACES Scale"] where status is 'final' or 'corrected' or 'amended' in past 2 years,
[Observation: "Mean score [PEG]"] where status is 'final' or 'corrected' or 'amended' in past 2 years,
[Observation: "Pain Enjoyment General Activity (PEG) Assessment LEGACY"] where status is 'final' or 'corrected' or 'amended' in past 2 years,
[Observation: "Total score [STarT Back]"] where status is 'final' or 'corrected' or 'amended' in past 2 years,
[Observation: "STarT Back Screening Tool LEGACY"] where status is 'final' or 'corrected' or 'amended' in past 2 years
```

**Terminology Elements**

```
"Pain severity Wong-Baker FACES Scale": '38221-8' from http://loinc.org
"Mean score [PEG]": '91147-9' from http://loinc.org
"Pain Enjoyment General Activity (PEG) Assessment LEGACY": 'PEGASSESSMENT' from http://cds.ahrq.gov/cdsconnect/pms
"Total score [STarT Back]": '91351-7' from http://loinc.org
"STarT Back Screening Tool LEGACY": 'STARTBACK' from http://cds.ahrq.gov/cdsconnect/pms
```

#### Historical Treatments

**Data Elements**

```
[MedicationRequest: "Opioid Pain Medications"] where status is 'active' or 'completed' or 'stopped' in past 2 years,
[MedicationStatement: "Opioid Pain Medications"] where status is 'active' or 'completed' in past 2 years,
[MedicationRequest: "Non opioid pain medications"] where status is 'active' or 'completed' or 'stopped' in past 2 years,
[MedicationStatement: "Non opioid pain medications"] where status is 'active' or 'completed' in past 2 years,
[ProcedureRequest: "Non pharmacologic treatments for chronic pain"] where status is 'active' or 'completed' in past 2 years,
[MedicationRequest: "Stool softeners and laxatives"] where status is 'active' or 'completed' or 'stopped' in past 6 months,
[MedicationStatement: "Stool softeners and laxatives"] where status is 'active' or 'completed' in past 6 months
```

**Terminology Elements**

```
"Opioid Pain Medications": '2.16.840.1.113762.1.4.1032.34'
"Non opioid pain medications": '2.16.840.1.113762.1.4.1032.26'
"Non pharmacologic treatments for chronic pain": '2.16.840.1.113762.1.4.1032.36'
"Stool softeners and laxatives": '2.16.840.1.113762.1.4.1032.44'
```

#### Risk Considerations

**Data Elements**

```
[Observation: "Morphine Milligram Equivalent (MME)"] where status is 'final' or 'corrected' or 'amended' in past 6 months,
[Observation: "Urine drug screen for pain management"] where status is 'final' or 'corrected' or 'amended' in past year,
[MedicationRequest: "Benzodiazepine medications"] where status is 'active' or 'completed' or 'stopped' in past 2 years,
[MedicationStatement: "Benzodiazepine medications"] where status is 'active' or 'completed' in past 2 years,
[MedicationRequest: "Naloxone medications"] where status is 'active' or 'completed' or 'stopped',
[MedicationStatement: "Naloxone medications"] where status is 'active' or 'completed',
[Observation: "Risk assessments relevant to pain management"] where status is 'final' or 'corrected' or 'amended' in past year,
[Observation: "Single question r/t ETOH use"] where status is 'final' or 'corrected' or 'amended' in past year,
[Observation: "Single question r/t drug use"] where status is 'final' or 'corrected' or 'amended' in past year
```

**Terminology Elements**

```
"Morphine Milligram Equivalent (MME)": 'MME' from http://cds.ahrq.gov/cdsconnect/pms
"Urine drug screen for pain management": '2.16.840.1.113762.1.4.1032.28'
"Benzodiazepine medications": '2.16.840.1.113762.1.4.1032.43'
"Naloxone medications": '2.16.840.1.113762.1.4.1032.42'
"Risk assessments relevant to pain management": '2.16.840.1.113762.1.4.1032.55'
"Single question r/t ETOH use": 'SQETOHUSE' from http://cds.ahrq.gov/cdsconnect/pms
"Single question r/t drug use": 'SQDRUGUSE' from http://cds.ahrq.gov/cdsconnect/pms
```
