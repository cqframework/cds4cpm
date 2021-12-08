library ChronicPainConcepts version '2.0.0'

// ## Value Sets ##

// [Conditions associated with chronic pain](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.95/expansion)
// replaces F2C valueset Conditions associated with chronic pain: 2.16.840.1.113762.1.4.1032.37
valueset "Conditions associated with chronic pain": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.95'

// [Opioids](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-opioids.html)
// Replaces the "Opioid Pain Medications" value set from F2C (2.16.840.1.113762.1.4.1032.34)
valueset "Opioid Pain Medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioids'

// Empty
// Replaces the "Adjuvant Analgesic Medications" value set from F2C (2.16.840.1.113762.1.4.1032.54)
valueset "Adjuvant Analgesic Medications": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// [Major Depression](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.464.1003.105.12.1007/expansion)
// This is the same as the "Major Depression" value set from F2C (2.16.840.1.113883.3.464.1003.105.12.1007)
// Note however, that PainManager does not use the "Depression Diagnosis ICD9": '2.16.840.1.113883.3.600.143' from F2C
valueset "Major Depression": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.105.12.1007'

// Empty
// Replaces the "Depression Diagnosis ICD9" value set from F2C (2.16.840.1.113883.3.600.143/expansion)
valueset "Depression Diagnosis ICD9": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// [Anxiety](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.94/expansion)
// replaces F2C valueset Anxiety: 2.16.840.1.113762.1.4.1032.52
// Note also that PainManager does not use the F2C valueset Anxiety disorders ICD9: 2.16.840.1.113883.3.1240.2017.3.2.1015
valueset "Anxiety": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.94'

// Empty
// Replaces the "Anxiety Disorders ICD9" value set from F2C (2.16.840.1.113883.3.1240.2017.3.2.1015/expansion)
valueset "Anxiety Disorders ICD9": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// Empty
// Replaces the "Substance use disorder" value set from F2C (2.16.840.1.113883.3.464.1003.106.12.1004)
valueset "Substance use disorder": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// [Substance Abuse](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-substance-abuse.html)
// Replaces the "Substance Abuse" value set from F2C (2.16.840.1.113883.3.464.1003.106.11.1010)
valueset "Substance Abuse": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/substance-abuse'

// Empty
// [See value set in VSAC](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1032.102/expansion)
// Replaces the "Suicide Attempt" value set from F2C (2.16.840.1.113762.1.4.1032.102)
valueset "Suicide Attempt": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// [Sleep disordered breathing](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.93/expansion)
// replaces F2C valueset Sleep disordered breathing: 2.16.840.1.113762.1.4.1032.53
valueset "Sleep-disordered breathing": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.93'

// [Kidney Failure](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.464.1003.109.12.1028/expansion)
// This is the same as the "Kidney failure" value set from F2C (2.16.840.1.113883.3.464.1003.109.12.1028)
valueset "Kidney Failure": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.109.12.1028'

// [Chronic liver disease](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.464.1003.199.12.1035/expansion)
// This is the same as the "Chronic liver disease" value set from F2C (2.16.840.1.113883.3.464.1003.199.12.1035)
valueset "Chronic Liver Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.199.12.1035'

// [Liver disease](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1047.42/expansion)
// This is the same as the "Liver disease" value set from F2C (2.16.840.1.113762.1.4.1047.42)
valueset "Liver Disease": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1047.42'

// [Pregnancy](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113883.3.526.3.378/expansion)
// This is the same as the Pregnancy value set from F2C (2.16.840.1.113883.3.526.3.378)
valueset "Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.378'

// [Pregnancy (New ICD10 codes published between 2018 and 2020)](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.74/expansion)
// replaces F2C valueset Pregnancy (New ICD10 codes published between 2018 and 2019): 2.16.840.1.113762.1.4.1032.80
valueset "Pregnancy (New ICD10 codes published in 2018 or later)": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.74'

// [Non opioid pain medications](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.73/expansion)
// replaces F2C valueset Non opioid pain medications: 2.16.840.1.113762.1.4.1032.26
valueset "Non opioid pain medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.73'

// Empty
// Replaces the "Non pharmacologic treatments for chronic pain": '2.16.840.1.113762.1.4.1032.36' from F2C
valueset "Non pharmacologic treatments for chronic pain": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// Empty
// Replaces the "Risk assessments relevant to pain management": '2.16.840.1.113762.1.4.1032.55' from F2C
valueset "Risk assessments relevant to pain management": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

// [Benzodiazepine medications](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-benzodiazepine-medications.html)
// Replaces the "Benzodiazepine medications" value set from F2C (2.16.840.1.113762.1.4.1032.43)
valueset "Benzodiazepine medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/benzodiazepine-medications'

// [Naloxone medications](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-naloxone-medications.html)
// Replaces the "Naloxone medications" value set from F2C (2.16.840.1.113762.1.4.1032.42)
valueset "Naloxone medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/naloxone-medications'

// [Drug Urine Screening](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-drug-urine-screening.html)
// Replaces the "Urine drug screen for pain management" value set from F2C ('2.16.840.1.113762.1.4.1032.28')
// NOTE: This is valueset is defined as a compose of these two valuesets, and is not available yet at the Opioid IG site
// [Non-opioid Illicit Drug Urine Screening](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-non-opioid-illicit-drug-urine-screening.html)
// [Opioid Drug Urine Screening](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-opioid-drug-urine-screening.html)
// NOTE: Concept is still called "Urine drug screen for pain management", is that okay, or does this need refactoring at the F2C level?
valueset "Urine drug screen for pain management": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/drug-urine-screening'

// Empty
// Replaces the "Stool softeners and laxatives": '2.16.840.1.113762.1.4.1032.44' from F2C
valueset "Stool softeners and laxatives": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'
