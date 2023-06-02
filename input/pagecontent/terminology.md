### Terminology

This page provides a summary of all terminology used by the CDS4CPM MyPAIN
and PainManager applications and details how these value sets are processed and prepared for
inclusion and usage in the applications.

#### Value Sets

The CQL library ChronicPainConcepts, version 2.0.0 defines the complete set of terminology concepts
used by the Pain Manager logic. It is completely aligned with the terminology concepts used
by the original AHRQ Pain Management Summary (Factors To Consider, or F2C) to maximize reuse of the content from that application.

Note that several of the concepts defined and used by the Pain Management Summary are not
used by Pain Manager. These concepts use the Empty value set.

[Conditions associated with chronic pain](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.95/expansion)
replaces the "Conditions associated with chronic pain" value set from F2C (2.16.840.1.113762.1.4.1032.37).

```
valueset "Conditions associated with chronic pain": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.95'
```

[Opioids](http://build.fhir.org/ig/cqframework/opioid-cds-r4/ValueSet-opioid-analgesics-with-ambulatory-misuse-potential.html)
Replaces the "Opioid Pain Medications" value set from F2C (2.16.840.1.113762.1.4.1032.34)

```
valueset "Opioid Pain Medications": 'https://build.fhir.org/ig/cqframework/opioid-cds-r4/ValueSet-conditions-documenting-substance-misuse.html'
```

Empty
Replaces the "Adjuvant Analgesic Medications" value set from F2C (2.16.840.1.113762.1.4.1032.54)

```
valueset "Adjuvant Analgesic Medications": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

[Major Depression](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.464.1003.105.12.1007/expansion)
This is the same as the "Major Depression" value set from F2C (2.16.840.1.113883.3.464.1003.105.12.1007)
```
valueset "Major Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1007'
```

Empty
Replaces the "Depression Diagnosis ICD9" value set from F2C (2.16.840.1.113883.3.600.143/expansion)
```
valueset "Depression Diagnosis ICD9": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

[Anxiety](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.94/expansion)
Replaces F2C valueset Anxiety: 2.16.840.1.113762.1.4.1032.52
```
valueset "Anxiety": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.94'
```

// Empty
Replaces the "Anxiety Disorders ICD9" value set from F2C (2.16.840.1.113883.3.1240.2017.3.2.1015/expansion)
```
valueset "Anxiety Disorders ICD9": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

// Empty
Replaces the "Substance use disorder" value set from F2C (2.16.840.1.113883.3.464.1003.106.12.1004)
```
valueset "Substance use disorder": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

[Substance Abuse](https://build.fhir.org/ig/cqframework/opioid-cds-r4/ValueSet-conditions-documenting-substance-misuse.html)
Replaces the "Substance Abuse" value set from F2C (2.16.840.1.113883.3.464.1003.106.11.1010)
```
valueset "Substance Abuse": 'https://build.fhir.org/ig/cqframework/opioid-cds-r4/ValueSet-conditions-documenting-substance-misuse.html'
```

Empty
Replaces the "Suicide Attempt" value set from F2C (2.16.840.1.113762.1.4.1032.102)
```
valueset "Suicide Attempt": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

[Sleep disordered breathing](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.93/expansion)
Replaces F2C valueset Sleep disordered breathing: 2.16.840.1.113762.1.4.1032.53
```
valueset "Sleep-disordered breathing": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.93'
```

[Kidney Failure](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.464.1003.109.12.1028/expansion)
This is the same as the "Kidney failure" value set from F2C (2.16.840.1.113883.3.464.1003.109.12.1028)
```
valueset "Kidney Failure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1028'
```

[Chronic liver disease](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.464.1003.199.12.1035/expansion)
This is the same as the "Chronic liver disease" value set from F2C (2.16.840.1.113883.3.464.1003.199.12.1035)
```
valueset "Chronic Liver Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.199.12.1035'
```

[Liver disease](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1047.42/expansion)
This is the same as the "Liver disease" value set from F2C (2.16.840.1.113762.1.4.1047.42)
```
valueset "Liver Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.42'
```

[Pregnancy](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.526.3.378/expansion)
This is the same as the Pregnancy value set from F2C (2.16.840.1.113883.3.526.3.378)
```
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'
```

[Pregnancy (New ICD10 codes published between 2018 and 2020)](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.74/expansion)
Replaces F2C valueset Pregnancy (New ICD10 codes published between 2018 and 2019): 2.16.840.1.113762.1.4.1032.80
```
valueset "Pregnancy (New ICD10 codes published in 2018 or later)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.74'
```

[Non opioid pain medications](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.73/expansion)
Replaces F2C valueset Non opioid pain medications: 2.16.840.1.113762.1.4.1032.26
```
valueset "Non opioid pain medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.73'
```

Empty
Replaces the "Non pharmacologic treatments for chronic pain": '2.16.840.1.113762.1.4.1032.36' from F2C
```
valueset "Non pharmacologic treatments for chronic pain": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

Empty
Replaces the "Risk assessments relevant to pain management": '2.16.840.1.113762.1.4.1032.55' from F2C
```
valueset "Risk assessments relevant to pain management": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

[Benzodiazepine medications](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-benzodiazepine-medications.html)
Replaces the "Benzodiazepine medications" value set from F2C (2.16.840.1.113762.1.4.1032.43)
```
valueset "Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'
```

[Naloxone medications](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-naloxone-medications.html)
Replaces the "Naloxone medications" value set from F2C (2.16.840.1.113762.1.4.1032.42)
```
valueset "Naloxone medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/naloxone-medications'
```

[Drug Urine Screening](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-drug-urine-screening.html)
Replaces the "Urine drug screen for pain management" value set from F2C ('2.16.840.1.113762.1.4.1032.28')
NOTE: This valueset is defined as a compose of these two value sets, and is not available yet at the Opioid Prescribing Support  IG site
[Non-opioid Illicit Drug Urine Screening](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-non-opioid-drug-urine-screening.html)
[Opioid Drug Urine Screening](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-opioid-drug-urine-screening.html)

```
valueset "Urine drug screen for pain management": http://fhir.org/guides/cqf/cds4cpm/ValueSet/drug-urine-screening'
```

Empty
Replaces the "Stool softeners and laxatives": '2.16.840.1.113762.1.4.1032.44' from F2C
```
valueset "Stool softeners and laxatives": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
```

#### Terminology Processing

There are three sources for value set definitions used by the MyPAIN and PainManager applications:

1. Value sets defined in and available from the Value Set Authority Center (VSAC)
2. Value sets defined in and available as part of the CDC Guideline for Prescribing Opioids implementation guide
3. Value sets defined in and available as part of this implementation guide (IG)

All these value sets need to be available in at least three places:

1. As part of the published content made available in this IG
2. As part of the testing capabilities used to validate content in the IG development environment
3. As part of the valueset-db.json file in the PainManager application

NOTE: As an architectural decision, we are specifically avoiding any run-time use of the value sets
in the FHIR Facade. If that decision changes, it would add a 4th location where these value sets
would need to be deployed, the FHIR Facade.

##### Gather

The first step in the processing pipeline is to gather the source for all value sets.

For value sets defined in the VSAC:

1. Download the VSAC spreadsheet for the latest expansion.
2. Use CQF Tooling to produce the FHIR ValueSet resource, conforming to the CPGExecutableValueSet profile.
3. Include the resulting ValueSet resource in the vocabulary/ValueSet folder for inclusion in the IG.

```
java -jar CQFTooling.jar -VsacXlsxToValueSetBatch -ptsd="C:\Users\Bryn\Documents\Src\RTI\cds4cpm\input\vocabulary\valueset\spreadsheets" -burl="http://cts.nlm.nih.gov/fhir/ValueSet/"
```

For value sets defined in the Opioid IG,

1. Copy the published FHIR ValueSet resource from the Opioid IG site into the vocabulary/ValueSet folder.

For value sets defined locally,

1. Include the source of the ValueSet in the vocabulary/ValueSet folder.

##### Ensure Executable

The next step is to ensure that all the input value sets are Executable (i.e., have an expansion). For
each published value set,

1. If the ValueSet does not have an `expansion` element, use the `compose` element to produce the expansion.

Note that this will only work for ValueSets with simple `compose` definitions. If a value set has a complex
compose, the expansion will need to be included in the expression of the ValueSet used in the Gather step.

```
java -jar CQFTooling.jar -EnsureExecutableValueSet -path="C:\Users\Bryn\Documents\Src\RTI\cds4cpm\input\vocabulary\valueset"
```

##### Publish

The next step is to run the IG publisher to publish all value sets in the CDS4CPM IG.

##### ToSVSJson

The PainManager application uses a JSON representation of the Sharing Value Set (SVS) profile ValueSetResponse obtained from the SVS API endpoint provided by the VSAC. To make the value sets available to the PainManager, the published value sets from this IG need to be transformed to that format and the resulting format provided to PainManager.

The structure of this valueset-db.json file is as follows:

```
{
  "<value-set-id-or-url>": {
    "<value-set-version>": [
      {
        "code": "<code-1>",
        "system": "<code-1-system-url>",
        "version": "<code-1-system-version>"
      },
      {
        "code": "<code-2>",
        "system": "<code-2-system-url>",
        "version": "<code-2-system-version>"
      },
      ...
    ]
  },
  "<value-set-id-or-url>": {
    "<value-set-version>": [
      ...
    ]
  },
  ...
}
```

Where `<value-set-id-or-url>` is the value set ID (as an OID) or the URL of the value set,
and `<value-set-version>` is the value set version,

```
java -jar CQFTooling.jar -ToJsonValueSetDb -path="C:\Users\Bryn\Documents\Src\RTI\cds4cpm\output"
```
