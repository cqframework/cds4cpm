library PainManagerAll version '0.1.0'
/*
This file is a manual flattening of the following libraries:

PainManager
Factors_to_Consider_in_Managing_Chronic_Pain_FHIRv400
ChronicPainConcepts-2.0.0.cql

This flattens all retrieve access into a single file to avoid the need to trace
retrieves into different libraries.
*/

// # Data model #

// The FHIR R4 model is used for testing purposes only. It has not been piloted.
using FHIR version '4.0.1'

// # Referenced libraries #

// The CDS Connect Commons for FHIRv400 library provides functions representing commonly used CDS logic and patterns.
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called C3F
// The FHIRHelpers library provides common functions for simplifying interaction w/ the FHIR R4 data model.
include FHIRHelpers version '4.0.1' called FHIRHelpers
include MMECalculator version '3.0.0' called MMECalculator

// # Value sets and codes #

// ## Code Systems ##

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'
codesystem "MyPAIN Questionnaire Codes": 'http://fhir.org/guides/cqf/cds4cpm/CodeSystem/mypain-questionnaire-codes'
codesystem "MyPAIN QuestionnaireResponse Codes": 'http://fhir.org/guides/cqf/cds4cpm/CodeSystem/mypain-questionnaireresponse-codes'
codesystem "Condition Category Codes": 'http://hl7.org/fhir/condition-category' // NOTE: This is the STU3 category, should really be the R4 category, but some systems still return this
//codesystem "Condition Category Codes": 'http://terminology.hl7.org/CodeSystem/condition-category'

// The CDS logic authors have registered new Logical Object Identifier Names and Codes (LOINC) codes, but they are
// Several concepts needed by the Pain Management Summary CDS do not yet have standardized codes associated with them.
// not yet available.  Once available, the CDS will be updated.  Until then, CDS implementors will need to map to
// local codes (signified by the LOCAL code system below) or replace them with their own codes.
codesystem "LOCAL": 'http://cds.ahrq.gov/cdsconnect/pms'

// ## Value Sets ##

// [Conditions associated with chronic pain](https://vsac.nlm.nih.gov/valueset/2.16.840.1.113762.1.4.1021.95/expansion)
// replaces F2C valueset Conditions associated with chronic pain: 2.16.840.1.113762.1.4.1032.37
valueset "Conditions associated with chronic pain": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.95'

// [Opioids](http://build.fhir.org/ig/cqframework/opioid-cds/ValueSet-opioids.html)
// Replaces the "Opioid Pain Medications" value set from F2C (2.16.840.1.113762.1.4.1032.34)
//valueset "Opioid Pain Medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioids'
valueset "Opioid Pain Medications": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/opioid-analgesics-with-ambulatory-misuse-potential'

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
valueset "Substance Abuse": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/conditions-documenting-substance-misuse'

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
//valueset "Non opioid pain medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.73'
valueset "Non opioid pain medications": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/2.16.840.1.113762.1.4.1021.73'

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
//valueset "Urine drug screen for pain management": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/drug-urine-screening'
//valueset "Urine drug screen for pain management": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/non-opioid-illicit-drug-urine-screening'
valueset "Urine drug screen for pain management": 'http://fhir.org/guides/cdc/opioid-cds/ValueSet/non-opioid-drug-urine-screening'

// Empty
// Replaces the "Stool softeners and laxatives": '2.16.840.1.113762.1.4.1032.44' from F2C
valueset "Stool softeners and laxatives": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/empty'

valueset "MyPAIN All Questionnaire Codes": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/mypain-all-questionnaire-codes'
valueset "MyPAIN All QuestionnaireResponse Codes": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/mypain-all-questionnaireresponse-codes'

// ## Individual codes ##

// list individual codes from code systems used directly in the CQL logic. Individual codes are used when there is
// a single code from a particular vocabulary standard used to represent a clinical concept. It is considered
// best-practice not to create value sets containing a single code.

code "Pregnancy status code": '82810-3' from "LOINC" display 'Pregnancy status'
code "Pregnant code": '77386006' from "SNOMED-CT" display 'Patient currently pregnant (finding)'
code "Patient Health Questionnaire 2 item (PHQ-2) total score [Reported] code":
  '55758-7' from "LOINC" display 'Patient Health Questionnaire 2 item (PHQ-2) total score [Reported]'
code "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported] code":
  '44261-6' from "LOINC" display 'Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]'
code "Generalized anxiety disorder 7 item (GAD-7) total score [Reported.PHQ] code":
  '70274-6' from "LOINC" display 'Generalized anxiety disorder 7 item (GAD-7) total score [Reported.PHQ]'
code "Total score [AUDIT] code": '75624-7' from "LOINC" display 'Total score [AUDIT]'
code "Total score [AUDIT-C] code": '75626-2' from "LOINC" display 'Total score [AUDIT-C]'
code "Total score [DAST-10] code": '82667-7' from "LOINC" display 'Total score [DAST-10]'
code "Total score ORT code": '91392-1' from "LOINC" display 'Total score ORT'
code "Pain severity Wong-Baker FACES Scale code": '38221-8' from "LOINC" display 'Pain severity Wong-Baker FACES Scale'

// The Pain intensity, Enjoyment of life, General activity scale [PEG] now has standardized LOINC codes available.
// These LOINC codes were not available when the initial version of the Pain Management Summary was developed.
// New systems implementing the Pain Management Summary should use the standardized codes, but the legacy local codes
// are also retained in order to allow existing systems to continue to function. Existing systems, however, are
// strongly encouraged to adopt the standardized LOINC codes.

code "Mean score [PEG] code": '91147-9' from "LOINC" display 'Mean score [PEG]'
code "Pain severity in the past week - 0-10 numeric rating [Reported] code":
  '75893-8' from "LOINC" display 'Pain severity in the past week - 0-10 numeric rating [Reported]'
code "What number best describes how pain has interfered with your enjoyment of life during the past week code":
  '91145-3' from "LOINC" display 'What number best describes how pain has interfered with your enjoyment of life during the past week'
code "What number best describes how pain has interfered with your general activity during the past week code":
  '91146-1' from "LOINC" display 'What number best describes how pain has interfered with your general activity during the past week'

// Legacy local codes for the Pain intensity, Enjoyment of life, General activity scale [PEG].
// New systems should use the LOINC codes above instead.

code "Pain Enjoyment General Activity (PEG) Assessment LEGACY code":
  'PEGASSESSMENT' from "LOCAL" display 'Pain Enjoyment General Activity (PEG) Assessment'
code "Pain LEGACY code": 'PEGPAIN' from "LOCAL" display 'Pain'
code "Enjoyment of life LEGACY code": 'PEGENJOYMENT' from "LOCAL" display 'Enjoyment of life'
code "General activity LEGACY code": 'PEGGENERALACTIVITY' from "LOCAL" display 'General activity'

// The STarT Back Screening Tool now has a standardized LOINC code available. This LOINC code was not available
// when the initial version of the Pain Management Summary was developed. New systems implementing the Pain Management
// Summary should use the standardized code, but the legacy local code is also retained in order to allow existing
// systems to continue to function. Existing systems, however, are strongly encouraged to adopt the standardized LOINC
// code.

code "Total score [STarT Back] code": '91351-7' from "LOINC" display 'Total score [STarT Back]'

// Legacy local code for the STarT Back Screening Tool. New systems should use the LOINC codes above instead.

code "STarT Back Screening Tool LEGACY code": 'STARTBACK' from "LOCAL" display 'STarT Back Screening Tool'

// The following codes do not yet have standardized codes associated with them so are expressed as LOCAL codes.
// As standardized codes become available, this CDS will be updated to use standard codes rather than LOCAL codes.

code "Single question r/t ETOH use code": 'SQETOHUSE' from "LOCAL" display 'Single question r/t ETOH use'
code "Single question r/t drug use code": 'SQDRUGUSE' from "LOCAL" display 'Single question r/t drug use'
code "Morphine Milligram Equivalent (MME) code": 'MME' from "LOCAL" display 'Morphine Milligram Equivalent (MME)'

code "Questionnaire response Document code": '74465-6' from "LOINC" display 'Questionnaire response Document'
code "painLocationHead": 'mpq-1038' from "MyPAIN Questionnaire Codes" display 'Head pain location'
code "painLocationNeck": 'mpq-1039' from "MyPAIN Questionnaire Codes" display 'Neck pain location'
code "painLocationShoulders": 'mpq-1040' from "MyPAIN Questionnaire Codes" display 'Shoulder pain location'
code "painLocationArms": 'mpq-1041' from "MyPAIN Questionnaire Codes" display 'Arm pain location'
code "painLocationUpperBack": 'mpq-1042' from "MyPAIN Questionnaire Codes" display 'Upper back pain location'
code "painLocationLowerBack": 'mpq-1043' from "MyPAIN Questionnaire Codes" display 'Lower back pain location'
code "painLocationHands": 'mpq-1044' from "MyPAIN Questionnaire Codes" display 'Hand pain location'
code "painLocationAbdomen": 'mpq-1045' from "MyPAIN Questionnaire Codes" display 'Abdominal pain location'
code "painLocationPelvis": 'mpq-1046' from "MyPAIN Questionnaire Codes" display 'Pelvic pain location'
code "painLocationHips": 'mpq-1047' from "MyPAIN Questionnaire Codes" display 'Hip pain location'
code "painLocationUpperLegs": 'mpq-1048' from "MyPAIN Questionnaire Codes" display 'Upper leg pain location'
code "painLocationKnees": 'mpq-1049' from "MyPAIN Questionnaire Codes" display 'Knee pain location'
code "painLocationLowerLegs": 'mpq-1050' from "MyPAIN Questionnaire Codes" display 'Lower leg pain location'
code "painLocationFeet": 'mpq-1051' from "MyPAIN Questionnaire Codes" display 'Foot pain location'
code "painLocationEverywhere": 'mpq-1052' from "MyPAIN Questionnaire Codes" display 'Everywhere pain location'
code "painLocationOther": 'mpq-1053' from "MyPAIN Questionnaire Codes" display 'Other pain location'
code "painLocationBack": 'mpq-1066' from "MyPAIN Questionnaire Codes" display 'Back pain location'
code "painLocationHandsWrist": 'mpq-1067' from "MyPAIN Questionnaire Codes" display 'Hands/Wrist pain location'
code "painLocationAbdomenPelvis": 'mpq-1068' from "MyPAIN Questionnaire Codes" display 'Abdomen/Pelvis pain location'
code "painLocationFeetAnkles": 'mpq-1069' from "MyPAIN Questionnaire Codes" display 'Feet/Ankles pain location'

code "flatTiresVideo": 'mpq-1061' from "MyPAIN Questionnaire Codes" display 'Did the patient view the 4 flat tires video'
code "cdcLink": 'mpq-1062' from "MyPAIN Questionnaire Codes" display 'Did the patient access the US Chronic Pain website'

code "worstPain": '75262-6' from "LOINC" display 'How intense was your pain at its worse in the past 7 days?'
code "averagePain": '75261-8' from "LOINC" display 'How intense was your average pain in the past 7 days'
code "painRightNow": '75260-0' from "LOINC" display 'What is your level of pain right now'

code "dayToDay": '61758-9' from "LOINC" display 'How much did pain interfere with your day to day activities in past 7 days'
code "homeWork": '61769-6' from "LOINC" display 'How much did pain interfere with work around the home in past 7 days'
code "socialActivities": '61773-8' from "LOINC" display 'How much did pain interfere with your ability to participate in social activities'
code "householdChores": '61775-3' from "LOINC" display 'How much did pain interfere with your household chores in past 7 days'
code "funActivities": '61761-3' from "LOINC" display 'How much did pain interfere with the things you usually do for fun in past 7 days'
code "enjoySocial": '61777-9' from "LOINC" display 'How much did pain interfere with your enjoyment of social activities'
code "enjoyLife": '61794-4' from "LOINC" display 'How much did pain interfere with your enjoyment of life in past 7 days'
code "enjoyFamily": '61762-1' from "LOINC" display 'How much did pain interfere with your family life'

code "exercises": 'mpq-1008' from "MyPAIN Questionnaire Codes" display 'How often have Exercises worked'
code "sleepPositioners": 'mpq-1009' from "MyPAIN Questionnaire Codes" display 'How often have Sleep positioners worked'
code "stretching": 'mpq-1010' from "MyPAIN Questionnaire Codes" display 'How often has Stretching worked'
code "weightLoss": 'mpq-1011' from "MyPAIN Questionnaire Codes" display 'How often has Weight loss worked'
code "reachingGoals": 'mpq-1012' from "MyPAIN Questionnaire Codes" display 'How often has Setting and reaching activity goals worked'
code "iceOrHeat": 'mpq-1013' from "MyPAIN Questionnaire Codes" display 'How often has Ice or heat therapy worked'
code "physicalTherapy": 'mpq-1014' from "MyPAIN Questionnaire Codes" display 'How often has Physical therapy worked'
code "acupuncture": 'mpq-1015' from "MyPAIN Questionnaire Codes" display 'How often has Acupuncture worked'
code "chiropracticTx": 'mpq-1016' from "MyPAIN Questionnaire Codes" display 'How often has Chiropractic treatment worked'
code "painRelievers": 'mpq-1017' from "MyPAIN Questionnaire Codes" display 'How often have Pain relievers worked'
code "herbTx": 'mpq-1018' from "MyPAIN Questionnaire Codes" display 'How often have Herbal txs worked'
code "cremes": 'mpq-1019' from "MyPAIN Questionnaire Codes" display 'How often have Cremes, lotions, gels or patches worked'
code "otherOTC": 'mpq-1055' from "MyPAIN Questionnaire Codes" display 'Have you used any Other items you can buy without a prescription'
code "opioidMeds": 'mpq-1020' from "MyPAIN Questionnaire Codes" display 'How often have prescription Opioid medications worked'
code "cortisone": 'mpq-1021' from "MyPAIN Questionnaire Codes" display 'How often have prescription Cortisone injections worked'
code "nonOpioidMeds": 'mpq-1022' from "MyPAIN Questionnaire Codes" display 'How often have prescription Non-opioid medications worked'
code "medMarijuana": 'mpq-1056' from "MyPAIN Questionnaire Codes" display 'How often has Medical marijuana worked'
code "yogo": 'mpq-1023' from "MyPAIN Questionnaire Codes" display 'How often has Yoga worked'
code "massage": 'mpq-1024' from "MyPAIN Questionnaire Codes" display 'How often has Massage worked'
code "meditation": 'mpq-1025' from "MyPAIN Questionnaire Codes" display 'How often has Meditation worked'
code "relaxation": 'mpq-1026' from "MyPAIN Questionnaire Codes" display 'How often has Relaxation worked'
code "groupIndividualTherapy": 'mpq-1027' from "MyPAIN Questionnaire Codes" display 'How often has Group or individual therapy'
code "cognitiveTherapy": 'mpq-1058' from "MyPAIN Questionnaire Codes" display 'How often has Cognitive behavioral therapy worked'
code "acceptanceTherapy": 'mpq-1028' from "MyPAIN Questionnaire Codes" display 'How often has Acceptance and commitment therapy worked'
code "sleepManagement": 'mpq-1029' from "MyPAIN Questionnaire Codes" display 'How often has Sleep management worked'
code "aromatherapy": 'mpq-1030' from "MyPAIN Questionnaire Codes" display 'How often has Aromatherapy  worked'
code "crystals": 'mpq-1031' from "MyPAIN Questionnaire Codes" display 'How often have Crystals worked'
code "essentialOils": 'mpq-1032' from "MyPAIN Questionnaire Codes" display 'How often have Essential oils worked'
code "cbdOil": 'mpq-1060' from "MyPAIN Questionnaire Codes" display 'How often has CBD oil helped'
code "musicTherapy": 'mpq-1033' from "MyPAIN Questionnaire Codes" display 'How often has Music therapy helped'
code "otherNewTreatments": 'mpq-1034' from "MyPAIN Questionnaire Codes" display 'Have you tried any Other new treatments'

code "otcMedications": 'mpq-1070' from "MyPAIN Questionnaire Codes" display 'Over-the-counter pain reliever (such as Advil, Aleve, Aspirin, Ibuprofen, Motrin, or Tylenol)'
code "prescriptionNonsteroidal": 'mpq-1071' from "MyPAIN Questionnaire Codes" display 'display": "Prescription nonsteroidal anti-inflammatory (such as Celebrex)'
code "prescriptionNervePainMed": 'mpq-1072' from "MyPAIN Questionnaire Codes" display 'Prescription nerve pain medication (such as Lyrica, Neurontin, or Cymbalta)'
code "prescriptionMuscleRelaxantMed": 'mpq-1073' from "MyPAIN Questionnaire Codes" display 'Prescription muscle relaxant (such as Soma or Baclofen)'
code "prescriptionOpioidMed": 'mpq-1074' from "MyPAIN Questionnaire Codes" display 'Prescription opioid medication (such as Vicodin, hydrocodone, oxycodone, codeine, morphine, or tramadol)'
code "otherMedicationTried": 'mpq-1075' from "MyPAIN Questionnaire Codes" display 'Other: describe other medications youve tried for pain'
code "noMedicationsTried": 'mpq-1076' from "MyPAIN Questionnaire Codes" display 'I havent tried any medications for pain.'
code "noSpecialistsSeen": 'mpq-1077' from "MyPAIN Questionnaire Codes" display 'I havent seen any specialists for pain'
code "dryNeedling": 'mpq-1078' from "MyPAIN Questionnaire Codes" display 'Dry needling or cupping'
code "acupunctureTx": 'mpq-1079' from "MyPAIN Questionnaire Codes" display 'Acupuncture'
code "noTreatmentsTried": 'mpq-1080' from "MyPAIN Questionnaire Codes" display 'I havent tried any procedures or physical treatments for pain.'
code "noTopicalTxTried": 'mpq-1081' from "MyPAIN Questionnaire Codes" display 'I havent tried any topical treatments or devices for pain.'
code "noLifestyleChanges": 'mpq-1082' from "MyPAIN Questionnaire Codes" display 'I havent tried any lifestyle changes for pain.'
code "topicalTxTried": 'mpq-1083' from "MyPAIN Questionnaire Codes" display 'What topical treatments or devices have you tried for pain?'
code "alternativeTxTried": 'mpq-1084' from "MyPAIN Questionnaire Codes" display 'What alternative treatments have you tried for pain?'
code "noALternativeTxTried": 'mpq-1085' from "MyPAIN Questionnaire Codes" display 'I havent tried any alternative treatments for pain'
code "specialistsSeen": 'mpq-1086' from "MyPAIN Questionnaire Codes" display 'What specialists have you seen for pain?'
code "chiropractorSpecialist": 'mpq-1087' from "MyPAIN Questionnaire Codes" display 'Chiropractor'
code "physicalTherapist": 'mpq-1088' from "MyPAIN Questionnaire Codes" display 'Physical therapist'
code "painManagementSpecialist": 'mpq-1089' from "MyPAIN Questionnaire Codes" display 'Pain management specialist'
code "orthopedist": 'mpq-1090' from "MyPAIN Questionnaire Codes" display 'Orthopedist'
code "psychologist": 'mpq-1091' from "MyPAIN Questionnaire Codes" display 'Psychologist or counselor'
code "integrativeMedicineSpecialist": 'mpq-1092' from "MyPAIN Questionnaire Codes" display 'Integrative medicine specialist'
code "otherSpecialists": 'mpq-1093' from "MyPAIN Questionnaire Codes" display 'Other: describe other specialists you have seen for pain (such as neurologist, spine doctor rheumatologist, or physiatrist)'
code "surgery": 'mpq-1094' from "MyPAIN Questionnaire Codes" display 'Surgery'
code "injection": 'mpq-1095' from "MyPAIN Questionnaire Codes" display 'Injection (such as a shot to relieve inflammation)'
code "massageTx": 'mpq-1096' from "MyPAIN Questionnaire Codes" display 'Massage'
code "otherTreatments": 'mpq-1097' from "MyPAIN Questionnaire Codes" display 'Other: describe other procedures or physical treatments youve tried for pain'
code "heatOrIceTx": 'mpq-1' from "MyPAIN Questionnaire Codes" display 'Heat and/or ice'
code "topicalMedications": 'mpq-1100' from "MyPAIN Questionnaire Codes" display 'Topical medications (such as creams, lotions, gel, patches, Bengay, Tiger Balm, Salonpas, Biofreeze, or Lidoderm)'
code "tensUnit": 'mpq-1101' from "MyPAIN Questionnaire Codes" display 'TENs unit'
code "bracing": 'mpq-1102' from "MyPAIN Questionnaire Codes" display 'Bracing'
code "otherTopicalTx": 'mpq-1103' from "MyPAIN Questionnaire Codes" display 'Other: describe other topical treatments or devices youve tried for pain'
code "exerciseOrStretching": 'mpq-1104' from "MyPAIN Questionnaire Codes" display 'Exercises or stretching (such as walking, yoga, water aerobics)'
code "dietOrHydration": 'mpq-1105' from "MyPAIN Questionnaire Codes" display 'Diet or hydration (such as an anti-inflammatory diet or drinking enough water)'
code "weightLossTx": 'mpq-1106' from "MyPAIN Questionnaire Codes" display 'Weight loss'
code "stressReduction": 'mpq-1107' from "MyPAIN Questionnaire Codes" display 'Stress reduction (such as relaxation, meditation, mindfulness, laughter)'
code "postureOrErgonomics": 'mpq-1108' from "MyPAIN Questionnaire Codes" display 'Posture or ergonomics'
code "otherLifestyleChanges": 'mpq-1109' from "MyPAIN Questionnaire Codes" display 'Other: describe other lifestyle changes youve tried for pain'
code "herbalTx": 'mpq-1110' from "MyPAIN Questionnaire Codes" display 'Herbal treatments or supplements (such as ginseng or kava kava)'
code "aromatherapyTx": 'mpq-1111' from "MyPAIN Questionnaire Codes" display 'Aromatherapy'
code "cbdOilTx": 'mpq-1112' from "MyPAIN Questionnaire Codes" display 'CBD oil'
code "marijuana": 'mpq-1113' from "MyPAIN Questionnaire Codes" display 'Marijuana used for medical purposes'
code "otherAlternativeTx": 'mpq-1114' from "MyPAIN Questionnaire Codes" display 'Other: describe other alternative treatments youve tried for pain'
code "activityGoals": 'mpq-1115' from "MyPAIN Questionnaire Codes" display 'Activity Goals: what goals do you have for your daily activities?'
code "barriersActivityGoals": 'mpq-1116' from "MyPAIN Questionnaire Codes" display 'Activity Barriers: what are the biggest barriers to achieving your daily activity goals?'

code "physicalTreatmentsOther": 'mpq-1054' from "MyPAIN Questionnaire Codes" display 'Other physical treatment'
code "prescriptionOther": 'mpq-1057' from "MyPAIN Questionnaire Codes" display 'Other prescription treatment'
code "newTreatmentOther": 'mpq-1059' from "MyPAIN Questionnaire Codes" display 'Other new treatment'
code "painGoal": 'mpq-1035' from "MyPAIN Questionnaire Codes" display 'Pain Goal'
code "goalBarriers": 'mpq-1036' from "MyPAIN Questionnaire Codes" display 'Goal Barriers'

code "Encounter Diagnosis code": 'encounter-diagnosis' from "Condition Category Codes" display 'Encounter Diagnosis'

  // Codes from MyPAIN QuestionnaireResponse Codes
code "notAtAllEffective": 'mpqr-1019' from "MyPAIN QuestionnaireResponse Codes" display 'Not at all'
code "slightlyEffective": 'mpqr-1020' from "MyPAIN QuestionnaireResponse Codes" display 'Slightly'
code "moderatelyEffective": 'mpqr-1021' from "MyPAIN QuestionnaireResponse Codes" display 'Moderately'
code "greatlyEffective": 'mpqr-1022' from "MyPAIN QuestionnaireResponse Codes" display 'Greatly'

// CQL currently requires concept declarations to contain references to code declarations.

// NOTE: This shouldn't be required but there is an unimplemented evaluator in the Java Engine (ConceptRef)
// An issue has been logged to correct this: https://github.com/DBCG/cql_engine/issues/421
// Commenting these out until that issue is resolved
//concept "Pregnancy status": { "Pregnancy status code" } display 'Pregnancy status'
//concept "Pregnant": { "Pregnant code" } display 'Patient currently pregnant (finding)'
//concept "Patient Health Questionnaire 2 item (PHQ-2) total score [Reported]":
//  { "Patient Health Questionnaire 2 item (PHQ-2) total score [Reported] code" }
//  display 'Patient Health Questionnaire 2 item (PHQ-2) total score [Reported]'
//concept "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]":
//  { "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported] code" }
//  display 'Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]'
//concept "Generalized anxiety disorder 7 item (GAD-7) total score [Reported.PHQ]":
//  { "Generalized anxiety disorder 7 item (GAD-7) total score [Reported.PHQ] code" }
//  display 'Generalized anxiety disorder 7 item (GAD-7) total score [Reported.PHQ]'
//concept "Total score [AUDIT]": { "Total score [AUDIT] code" } display 'Total score [AUDIT]'
//concept "Total score [AUDIT-C]": { "Total score [AUDIT-C] code" } display 'Total score [AUDIT-C]'
//concept "Total score [DAST-10]": { "Total score [DAST-10] code" } display 'Total score [DAST-10]'
//concept "Total score ORT": { "Total score ORT code" } display 'Total score ORT'
//concept "Pain severity Wong-Baker FACES Scale":
//  { "Pain severity Wong-Baker FACES Scale code" } display 'Pain severity Wong-Baker FACES Scale'
//concept "Pain severity in the past week - 0-10 numeric rating [Reported]":
//  { "Pain severity in the past week - 0-10 numeric rating [Reported] code" }
//  display 'Pain severity in the past week - 0-10 numeric rating [Reported]'
//concept "What number best describes how pain has interfered with your enjoyment of life during the past week":
//  { "What number best describes how pain has interfered with your enjoyment of life during the past week code" }
//  display 'What number best describes how pain has interfered with your enjoyment of life during the past week'
//concept "What number best describes how pain has interfered with your general activity during the past week":
//  { "What number best describes how pain has interfered with your general activity during the past week code" }
//  display 'What number best describes how pain has interfered with your general activity during the past week'
//concept "Mean score [PEG]": { "Mean score [PEG] code" } display 'Mean score [PEG]'
//concept "Pain Enjoyment General Activity (PEG) Assessment LEGACY":
//  { "Pain Enjoyment General Activity (PEG) Assessment LEGACY code" } display 'Pain Enjoyment General Activity (PEG) Assessment'
//concept "Pain LEGACY": { "Pain LEGACY code" } display 'Pain'
//concept "Enjoyment of life LEGACY": { "Enjoyment of life LEGACY code" } display 'Enjoyment of life'
//concept "General activity LEGACY": { "General activity LEGACY code" } display 'General activity'
//concept "Total score [STarT Back]": { "Total score [STarT Back] code" } display 'Total score [STarT Back]'
//concept "STarT Back Screening Tool LEGACY": { "STarT Back Screening Tool LEGACY code" } display 'STarT Back Screening Tool'
//concept "Single question r/t ETOH use": { "Single question r/t ETOH use code" } display 'Single question r/t ETOH use'
//concept "Single question r/t drug use": { "Single question r/t drug use code" } display 'Single question r/t drug use'
//concept "Morphine Milligram Equivalent (MME)":
//  { "Morphine Milligram Equivalent (MME) code" } display 'Morphine Milligram Equivalent (MME)'
//concept "Questionnaire response Document":
//  { "Questionnaire response Document code" } display 'Questionnaire response Document'

// # Parameters #

// The InclusionMedicationsLookbackPeriod allows CDS implementors to specify how far the inclusion logic should look
// back for qualifying active medications. By default, the inclusion logic will look back 180 days.
parameter InclusionMedicationsLookbackPeriod default 180 days

// # CDS logic #

context Patient

// ## Condition Behavior Changes ##

// The following condition functions are used here to address the difference in behavior
// between a "problem-list-item" condition and other categories of conditions.
// Specifically, problem-list-items typically have clinicalStatus and verificationStatus
// where encounter-diagnoses in particular would not be expected to have those items
// For the PainManager use case, encounter-diagnoses can be included.
// NOTE: Encounter-diagnoses should be filter by a lookback, but that is not handled by these functions

/**
 * Returns true if the Condition has a category of "encounter-diagnosis"
 */
define function IsEncounterDiagnosis(Condition Condition):
  exists (Condition.category C where C ~ "Encounter Diagnosis code")
    and (Condition.recordedDate is null or Condition.recordedDate after Today() - 1 year)

/**
 * Conditions that are confirmed. In FHIR R4, this is reflected by verificationStatus: 'confirmed'.
 * @see http://hl7.org/fhir/R4/valueset-condition-ver-status.html
 * @param CondList - a list of Conditions
 * @returns {List<Condition>} a list of confirmed Conditions, or null if null was passed in
 */
define function Confirmed(CondList List<Condition>):
  CondList C where IsEncounterDiagnosis(C) xor C.verificationStatus ~ C3F."Condition Confirmed code"

/**
 * Conditions that are active. In FHIR R4, this is reflected by clinicalStatus: 'active' and the absence of any
 * abatement information (i.e., if it abated, it is no longer active).
 * TODO: Rename to Active once the execution engine supports overloaded functions.
 * @see http://hl7.org/fhir/R4/valueset-condition-clinical.html
 * @param CondList - a list of Conditions
 * @returns {List<Condition>} a list of active Conditions, or null if null was passed in
 */
define function ActiveCondition(CondList List<Condition>):
  CondList C
    where (IsEncounterDiagnosis(C) xor C.clinicalStatus ~ C3F."Condition Active code")
      and C.abatement is null

/**
 * Conditions that are active or recurring. In FHIR R4, this is reflected by clinicalStatus: 'active', 'recurrence', or
 * 'relapse'.  We do not check for null abatement information because it may have dates from when the now recurring
 * condition initially went into remission.
 * @see http://hl7.org/fhir/R4/valueset-condition-clinical.html
 * @param CondList - a list of Conditions
 * @returns {List<Condition>} a list of active or recurring Conditions, or null if null was passed in
 */
define function ActiveOrRecurring(CondList List<Condition>):
  CondList C
    where IsEncounterDiagnosis(C)
      xor (C.clinicalStatus ~ C3F."Condition Active code"
      or C.clinicalStatus ~ C3F."Condition Recurrence code"
      or C.clinicalStatus ~ C3F."Condition Relapse code")

// ## Re-usable functions ##

// The summary logic contains many constructs that are needed throughout the logic. Where possible, these constructs
// have been developed as re-usable functions that can be invoked wherever they are needed.

define function AgeToQuantity(age FHIR.Age):
  if age is null then
    null as System.Quantity
  else
    FHIRHelpers.ToQuantity(age)

define function QuantityToQuantity(quantity FHIR.Quantity):
  if quantity is null then
    null as System.Quantity
  else
    FHIRHelpers.ToQuantity(quantity)

// Returns the first-found display text for a CodeableConcept, looking first at the `text` attribute, then the
// `display` on each `coding` until it finds a non-null value.  Some PEG codes are normalized due to length.
// @param c - a FHIR CodeableConcept to get text from
// @returns {System.String} the display text or null if none is found

define function ConceptText(c FHIR.CodeableConcept):
  if c ~ "Mean score [PEG] code" or c ~ "Pain Enjoyment General Activity (PEG) Assessment LEGACY code"
    then 'Mean score [PEG]'
  else if c ~ "Pain severity in the past week - 0-10 numeric rating [Reported] code" or c ~ "Pain LEGACY code"
    then 'Pain'
  else if c ~ "What number best describes how pain has interfered with your enjoyment of life during the past week code"
       or c ~ "Enjoyment of life LEGACY code"
    then 'Enjoyment of life'
  else if c ~ "What number best describes how pain has interfered with your general activity during the past week code"
       or c ~ "General activity LEGACY code"
    then 'General activity'
  else
    Coalesce(c.text.value, Coalesce((c.coding) c2 return c2.display.value))

// We do not reliably get ranges back from EHR data, but ranges are important to understanding assessment scores in
// the summary.  This function adds ranges to the name for known assessments.
// @param c - a FHIR CodeableConcept to get the updated text for
// @returns {System.String} the display text with range information appended
define function ConceptTextWithRange(c FHIR.CodeableConcept):
  if c ~ "Patient Health Questionnaire 2 item (PHQ-2) total score [Reported] code"
    then ConceptText(c) + ' [Range: 0-6]'
  else if c ~ "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported] code"
    then ConceptText(c) + ' [Range: 0-27]'
  else if c ~ "Generalized anxiety disorder 7 item (GAD-7) total score [Reported.PHQ] code"
    then ConceptText(c) + ' [Range: 0-21]'
  else if c ~ "Total score [AUDIT] code"
    then ConceptText(c) + ' [Range: 0-40]'
  else if c ~ "Total score [AUDIT-C] code"
    then ConceptText(c) + ' [Range: 0-12]'
  else if c ~ "Total score [DAST-10] code"
    then ConceptText(c) + ' [Range: 0-10]'
  else if c ~ "Total score ORT code"
    then ConceptText(c) + ' [Range: 0-26]'
  else if c ~ "Pain severity Wong-Baker FACES Scale code"
    then ConceptText(c) + ' [Range: 0-10]'
  else if c ~ "Mean score [PEG] code"
       or c ~ "Pain Enjoyment General Activity (PEG) Assessment LEGACY code"
    then ConceptText(c) + ' [Range: 0-10]'
  else if c ~ "Total score [STarT Back] code"
       or c ~ "STarT Back Screening Tool LEGACY code"
    then ConceptText(c) + ' [Range: 0-9]'
  else
    ConceptText(c)

// Returns a text representation of a date using the CQL `ToString` function.
// @param d - a FHIR date to get text for
// @returns {System.String} the text representation of the date
define function DateText(d FHIR.date):
  ToString(d.value)

// Returns a text representation of a dateTime using the CQL `ToString` function.
// @param d - a FHIR dateTime to get text for
// @returns {System.String} the text representation of the dateTime
define function DateTimeText(d FHIR.dateTime):
  ToString(d.value)

// Returns a text representation of an instant using the CQL `ToString` function.
// @param i - a FHIR instant to get text for
// @returns {System.String} the text representation of the instant
define function InstantText(i FHIR.instant):
  ToString(i.value)

// Returns a text representation of a Quantity with the Quantity's value and unit.
// If the unit is {score}, then omit it (as it is not useful to display)
// @param q - a FHIR Quantity to get text for
// @returns {System.String} the text representation of the Quantity
define function QuantityText(q FHIR.Quantity):
  if (q is null) then null
  else if (q.unit is not null and q.unit.value != '{score}') then ToString(q.value.value) + ' ' + q.unit.value
  else if (q.code is not null and q.code.value != '{score}') then ToString(q.value.value) + ' ' + q.code.value
  else ToString(q.value.value)

// Returns a text representation of an MME Quantity with the Quantity's value and unit in as a user-friendly display.
// If the unit is {MME}/d, display it as MME/Day, otherwise, just return the ToString of the given quantity.
// @param quantity - MME as a System Quantity to get text for
// @returns {System.String} a user-friendly text representation of the MME
define function MMEText(quantity System.Quantity):
  if quantity.unit = '{MME}/d' then
    ToString(quantity.value) + ' MME/Day'
  else
    ToString(quantity)

// Returns a tuple containing a Period's start and end as text representations.
// @param p - a FHIR Period to get a tuple for
// @returns {Tuple<Start System.String, End System.String>} the tuple representation of the Period
define function PeriodObject(p FHIR.Period):
  if p is null then null
  else
    {
      Start: DateTimeText(p."start"),
End: DateTimeText(p."end")
    }

// Returns a tuple containing a Range's low and high as text representations.
// @param r - a FHIR Range to get a tuple for
// @returns {Tuple<Low System.String, High System.String>} the tuple representation of the Range
define function RangeObject(r FHIR.Range):
  if r is null then null
  else
    {
      Low: QuantityText(r.low),
      High: QuantityText(r.high)
    }

// Returns a text representation of a date associated with an Observation, preferring `effectiveDateTime`, then
// `effectivePeriod.start`, then `issued`.
// @param o - a FHIR Observation to get the text date from
// @returns {System.String} the text representation of a relevant date from the Observation
define function ObservationDate(o FHIR.Observation):
  Coalesce(
    DateTimeText(o.effective as FHIR.dateTime),
    InstantText(o.effective as FHIR.instant),
    DateTimeText((o.effective as FHIR.Period)."start"),
    InstantText(o.issued)
  )

// Returns a text representation of a date associated with a MedicationStatement, preferring `effectiveDateTime`, then
// `.start`.
// @param s - a FHIR MedicationStatement to get the text date from
// @returns {System.String} the text representation of a relevant date from the MedicationStatement
define function MedicationStatementDate(s FHIR.MedicationStatement):
  Coalesce(
    DateTimeText(s.effective as FHIR.dateTime),
    DateTimeText((s.effective as FHIR.Period)."start"),
    DateTimeText(s.dateAsserted)
  )

// Returns a text representation of a Condition's onset, whether represented as a dateTime, Period, Quantity (Age),
// Range (Age), or string.
// @param c - a FHIR Condition to get the text representation of the onset from
// @returns {System.String} the text representation of the Condition's onset
define function Onset(c FHIR.Condition):
  Coalesce( List{
    DateTimeText(c.onset as FHIR.dateTime),
    QuantityText(c.onset as FHIR.Age),
    PeriodObject(c.onset as FHIR.Period),
    RangeObject(c.onset as FHIR.Range),
    (c.onset as FHIR.string).value
  })

// Returns the date of a Condition's onset, whether represented as a dateTime, Period, Quantity (Age),
// Range (Age), or the recordedDate if no onset is available
// @param c - a FHIR Condition to get the text representation of the onset from
// @returns {System.DateTime} the date of the Condition's onset or when it was recorded
define function OnsetOrRecordedDate(c FHIR.Condition):
  Coalesce( List{
    DateTimeText(c.onset as FHIR.dateTime),
    //DateTimeText(Patient.birthDate + AgeToQuantity(c.onset as FHIR.Age)),
    DateTimeText((c.onset as FHIR.Period)."start"),
    //DateTimeText(Patient.birthDate + QuantityToQuantity((c.onset as FHIR.Range)."low")),
    DateTimeText(c.recordedDate),
    'unknown'
  }) as String

// Returns a text representation of a Condition's abatement, whether represented as a dateTime, Period, Quantity (Age),
// Range (Age), string, or boolean.
// @param c - a FHIR Condition to get the text representation of the abatement from
// @returns {System.String} the text representation of the Condition's abatement
define function Abatement(c FHIR.Condition):
  Coalesce( List{
    DateTimeText(c.abatement as FHIR.dateTime),
    QuantityText(c.abatement as FHIR.Age),
    PeriodObject(c.abatement as FHIR.Period),
    RangeObject(c.abatement as FHIR.Range),
    (c.abatement as FHIR.string).value
  })

// ## Target population ##

// INCLUSIONS

// Determines if patient's age, in years, at the time CQL is run, is at least 18 years old
define Is18orOlder:
  AgeInYears() >= 18

// Conditions associated with chronic pain
define ConditionsAssociatedWithChronicPain:
  Confirmed(ActiveOrRecurring([Condition: "Conditions associated with chronic pain"]))

// Determines if the patient has any of the conditions associated with chronic pain
define HasConditionAssociatedWithChronicPain:
  exists(ConditionsAssociatedWithChronicPain)

// Determines if the patient has any record of opioid pain medications in the lookback period
//       - Medication Request within past 180 days (lookback can be made a parameter)
//       - Medication Statement by patient within past 180 days (lookback can be made a parameter)
define HasRecentOpioidPainMedication:
  exists(C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Opioid Pain Medications"],
    InclusionMedicationsLookbackPeriod)
  ))
  or exists(C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: "Opioid Pain Medications"],
    InclusionMedicationsLookbackPeriod)
  ))

// Determines if the patient has any record of adjuvant analgesic medications in the lookback period
//       - Medication Request within past 180 days (lookback can be made a parameter)
//       - Medication Statement by patient within past 180 days (lookback can be made a parameter)
define HasRecentAdjuvantAnalgesicMedication:
  exists(C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Adjuvant Analgesic Medications"],
    InclusionMedicationsLookbackPeriod)
  ))
  or exists(C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: "Adjuvant Analgesic Medications"],
    InclusionMedicationsLookbackPeriod)
  ))

// Determines if the patient meets the inclusion criteria for the CDS. Inclusion criteria is:
// - Age >=18 years
// - AND
//   - OR Conditions associated with chronic pain
//   - OR Opioid pain medication
//   - OR Adjuvant analgesic medication
define MeetsInclusionCriteria:
    if "Use Inclusion Criteria"
        then
  Is18orOlder
  and (
    HasConditionAssociatedWithChronicPain
    or HasRecentOpioidPainMedication
            or HasRecentAdjuvantAnalgesicMedication)
        else
            true

// EXCLUSIONS

// TAKE NOTICE: This CDS is not intended for patients who meet any of the following criteria:
// 1. Younger than 18 years of age
// 2. Undergoing end-of-life care (hospice or palliative)
// 3. Undergoing active cancer treatment
//
// The first exclusion is explicitly accounted for under INCLUSIONS.
// The second and third exclusions cannot be realiably detected for all patients using just EHR data. For that reason
// they are not implemented in this CDS. Care providers should use their judgement when applying this CDS to their
// patients.

// ## Intervention(s) ##

// DISPLAY and POPULATE a Pain Management Summary of the following items:

// PERTINENT MEDICAL HISTORY

define function UniqueConditionReports(reports List<Tuple{Name System.String, Status System.String, Onset System.Any, DateRecorded System.String, Date System.String}>):
  (reports R return R.Name) U
    return First(reports R where R.Name = U sort by Date desc)

// Conditions associated with chronic pain and their dates of onset
define ReportConditionsAssociatedWithChronicPain:
  (UniqueConditionReports(
    ConditionsAssociatedWithChronicPain C
      return {
        Name:   ConceptText(C.code),
        Status: C.clinicalStatus.coding[0].code.value,
        Onset:  Onset(C),
        DateRecorded: DateTimeText(C.recordedDate),
        Date: OnsetOrRecordedDate(C)
      }
  )) R
    sort by Date desc

// Conditions that are risk factors for opioid-related harms and their dates of onset
// This is a union of nine value sets (w/ different filtering criteria)

define DepressionConditions:
  Confirmed(ActiveOrRecurring([Condition: "Major Depression"]))
  union Confirmed(ActiveOrRecurring([Condition: "Depression Diagnosis ICD9"]))

define AnxietyConditions:
  Confirmed(ActiveOrRecurring([Condition: "Anxiety"]))
  union Confirmed(ActiveOrRecurring([Condition: "Anxiety Disorders ICD9"]))

define SubstanceUseDisorderConditions:
  Confirmed([Condition: "Substance use disorder"])
  union Confirmed([Condition: "Substance Abuse"])

define SuicideAttemptConditions:
  Confirmed([Condition: "Suicide Attempt"])

define SleepDisorderedBreathingConditions:
  Confirmed(ActiveOrRecurring([Condition: "Sleep-disordered breathing"]))

define RenalDysfunctionConditions:
  Confirmed(ActiveOrRecurring([Condition: "Kidney Failure"]))

define HepaticDysfunctionConditions:
  Confirmed(ActiveOrRecurring([Condition: "Chronic Liver Disease"]))
  union Confirmed(ActiveOrRecurring([Condition: "Liver Disease"]))

define PregnancyConditions:
  Confirmed(C3F.ConditionLookBack(ActiveOrRecurring(
    [Condition: "Pregnancy"])
      union [Condition: "Pregnancy (New ICD10 codes published in 2018 or later)"],
    42 weeks
  ))

define PregnancyObservations:
  C3F.Verified(C3F.ObservationLookBack([Observation: "Pregnancy status code"], 42 weeks))

define MostRecentPregnancyObservation:
  C3F.MostRecent(PregnancyObservations)

define MostRecentPregnancyObservationIsPositive:
  C3F.ConceptValue(MostRecentPregnancyObservation) ~ "Pregnant code"

define Is65orOlder:
  AgeInYears() >= 65

define ConditionRiskFactorsForOpioidRelatedHarms:
  DepressionConditions
  union AnxietyConditions
  union SubstanceUseDisorderConditions
  union SuicideAttemptConditions
  union SleepDisorderedBreathingConditions
  union RenalDysfunctionConditions
  union HepaticDysfunctionConditions
  union PregnancyConditions

// Encounter diagnoses that are risk factors for opioid-related harms and their dates of onset. Some risk factors may
// not exist on the problem list, and therefore may not be represented as Conditions (depending on EHR implementation).
// For this, the logic also looks at the patient's encounters, trying to find risk factors recorded as encounter
// diagnosis codes. We do not look at the reasonReference field because the Conditions referred to would already be
// reflected in the expression that queries over Conditions.

define EncounterRiskFactorsForOpioidRelatedHarms:
  [Encounter] E where exists(
    E.reasonCode R where
      FHIRHelpers.ToConcept(R) in "Major Depression"
      or FHIRHelpers.ToConcept(R) in "Depression Diagnosis ICD9"
      or FHIRHelpers.ToConcept(R) in "Anxiety"
      or FHIRHelpers.ToConcept(R) in "Anxiety Disorders ICD9"
      or FHIRHelpers.ToConcept(R) in "Substance use disorder"
      or FHIRHelpers.ToConcept(R) in "Substance Abuse"
      or FHIRHelpers.ToConcept(R) in "Suicide Attempt"
      or FHIRHelpers.ToConcept(R) in "Sleep-disordered breathing"
      or FHIRHelpers.ToConcept(R) in "Kidney Failure"
      or FHIRHelpers.ToConcept(R) in "Chronic Liver Disease"
      or FHIRHelpers.ToConcept(R) in "Liver Disease"
      // Pregnancy not considered in Encounter diagnoses because this is an unrestricted lookback.
  )

// NOTE: As a convention, if an expression's name starts with "Report", its purpose is to format data for the purpose
// of building the final summary object.

define function UniqueRiskFactorReports(reports List<Tuple{Name System.String, Status System.String, Onset System.Any, DateRecorded System.String, Abatement System.Any, Visit Tuple { Start System.String, End System.String }, Date System.String}>):
  (reports R return R.Name) U
    return First(reports R where R.Name = U sort by Date desc)

// Format the risk factors in a uniform way despite the different sources of the data (conditions, encounter diagnoses,
// etc.). Note that conditions do not have a "Visit" date and encounter diagnoses do not have a status, onset date,
// recorded date, or abatement date.

define ReportConditionRiskFactorsForOpioidRelatedHarms:
  (ConditionRiskFactorsForOpioidRelatedHarms) C
  return {
    Name:      ConceptText(C.code),
    Status:    C.clinicalStatus.coding[0].code.value,
    Onset:     Onset(C),
    DateRecorded: DateTimeText(C.recordedDate),
    Abatement: Abatement(C),
    Visit:     null as Tuple{ Start String, End String },
    Date: OnsetOrRecordedDate(C)
  }

define function GetEncounterDiagnosesRiskFactorsForOpioidRelatedHarms(enc Encounter):
  (enc.reasonCode) R
    where FHIRHelpers.ToConcept(R) in "Major Depression"
      or FHIRHelpers.ToConcept(R) in "Depression Diagnosis ICD9"
      or FHIRHelpers.ToConcept(R) in "Anxiety"
      or FHIRHelpers.ToConcept(R) in "Anxiety Disorders ICD9"
      or FHIRHelpers.ToConcept(R) in "Substance use disorder"
      or FHIRHelpers.ToConcept(R) in "Substance Abuse"
      or FHIRHelpers.ToConcept(R) in "Suicide Attempt"
      or FHIRHelpers.ToConcept(R) in "Sleep-disordered breathing"
      or FHIRHelpers.ToConcept(R) in "Kidney Failure"
      or FHIRHelpers.ToConcept(R) in "Chronic Liver Disease"
      or FHIRHelpers.ToConcept(R) in "Liver Disease"
      // Pregnancy not considered in Encounter diagnoses because this is an unrestricted lookback.
    return {
      Name:      ConceptText(R),
      Status:    null as String,
      Onset:     null as String,
      DateRecorded: null as String,
      Abatement: null as String,
      Visit:     PeriodObject(enc.period),
      Date: enc.period."start".value
    }

define ReportEncounterRiskFactorsForOpioidRelatedHarms:
  (flatten((EncounterRiskFactorsForOpioidRelatedHarms) E
  return GetEncounterDiagnosesRiskFactorsForOpioidRelatedHarms(E))) D

// Shape the pregnancy Observation as a Condition, since this is the backup approach for detecting a pregnancy in case
// there are no active Conditions found.
define ReportMostRecentPositivePregnancyObservation:
({
  {
    Name: ConceptText(MostRecentPregnancyObservation.code),
    Status: ConceptText(MostRecentPregnancyObservation.value as FHIR.CodeableConcept),
    Onset: ToString(Coalesce(
      (MostRecentPregnancyObservation.effective as FHIR.dateTime).value,
      (MostRecentPregnancyObservation.effective as FHIR.instant).value,
      (MostRecentPregnancyObservation.effective as FHIR.Period)."start".value
    )),
    DateRecorded: ToString(MostRecentPregnancyObservation.issued.value),
    Abatement: null as String,
    Visit: null as Tuple { Start String, End String },
    Date: Coalesce(
      (MostRecentPregnancyObservation.effective as FHIR.dateTime).value,
      (MostRecentPregnancyObservation.effective as FHIR.instant).value,
      (MostRecentPregnancyObservation.effective as FHIR.Period)."start".value,
      MostRecentPregnancyObservation.issued.value
    )
  }
}) C
  where MostRecentPregnancyObservationIsPositive

// Shape the case of being 65 or older as a Condition for the purposes of building the summary.
define ReportOlderThan65:
({
  {
    Name: '65 years or older',
    Status: 'active',
    Onset: null as String,
    DateRecorded: null as String,
    Abatement: null as String,
    Visit: null as Tuple { Start String, End String },
    Date: ToDateTime(Patient.birthDate + 65 years)
  }
}) C
  where Is65orOlder

define ReportRiskFactorsForOpioidRelatedHarms:
  (UniqueRiskFactorReports(
    // If a pregnancy Condition is present, use that.
    if Exists(PregnancyConditions) then
      (ReportConditionRiskFactorsForOpioidRelatedHarms
        union ReportEncounterRiskFactorsForOpioidRelatedHarms
        union ReportOlderThan65
      )
    // Otherwise, try to find a positive pregnancy status in an Observation.
    else
      (ReportConditionRiskFactorsForOpioidRelatedHarms
        union ReportEncounterRiskFactorsForOpioidRelatedHarms
        union ReportOlderThan65
        union ReportMostRecentPositivePregnancyObservation
      )
  )) C
    sort by Date desc

// PAIN ASSESSMENT

// Numeric pain intensity assessment - scores and dates (lookback 2 years)

define NumericPainIntensityAssessments:
  C3F.Verified(C3F.ObservationLookBack([Observation: "Pain severity Wong-Baker FACES Scale code"], 2 years))

define ReportNumericPainIntensityAssessments:
  (NumericPainIntensityAssessments) A
  return {
    Name:           ConceptTextWithRange(A.code),
    Score:          QuantityText(A.value as FHIR.Quantity),
    Interpretation: Coalesce( ConceptText(First(A.interpretation)),  ConceptText(A.value as FHIR.CodeableConcept) ),
    Date:           ObservationDate(A)
  }
  sort by Date desc

// Pain Enjoyment General Activity (PEG) Assessment - scores and dates (lookback 2 years)
// Note: this includes listing the response to each of the 3 questions, plus the total score.  The Pain Management
// Sumnmary currently supports both the LOINC representations and the legacy local code representations.
//
// 1. Observation w/ LOINC mean score as primary code and mean score as valueQuantity
//    * code: LOINC 91147-9 "Mean score [PEG]"
//    * valueQuantity: (mean score)
//    * component:
//      -
//        * code: LOINC 75893-8 "What number best describes your pain on average in the past week?"
//        * valueQuantity: (pain score)
//      -
//        * code: LOINC 91145-3 "What number best describes how, during the past week, pain has interfered with your enjoyment of life?"
//        * valueQuantity: (enjoyment of life score)
//      -
//        * code: LOINC 91146-1 "What number best describes how, during the past week, pain has interfered with your general activity?"
//        * valueQuantity: (general activity score)
//
// 2. LEGACY: Observation w/ LOCAL code as primary code and mean score as valueQuantity
//    * code: LOCAL PEGASSESSMENT "Pain Enjoyment General Activity (PEG) Assessment"
//    * valueQuantity: (mean score)
//    * component:
//      -
//        * code: LOCAL PEGPAIN "Pain"
//        * valueQuantity: (pain score)
//      -
//        * code: LOCAL PEGENJOYMENT "Enjoyment of life"
//        * valueQuantity: (enjoyment of life score)
//      -
//        * code: LOCAL PEGGENERALACTIVITY "General activity"
//        * valueQuantity: (general activity score)

define PainEnjoymentGeneralActivityAssessments:
  C3F.Verified(C3F.ObservationLookBack(
    [Observation: "Mean score [PEG] code"]
      union [Observation: "Pain Enjoyment General Activity (PEG) Assessment LEGACY code"],
    2 years
  ))

define ReportPainEnjoymentGeneralActivityAssessments:
  (PainEnjoymentGeneralActivityAssessments) A
  let
    Pain: (A.component) C
      where C.code ~ "Pain severity in the past week - 0-10 numeric rating [Reported] code"
      or C.code ~ "Pain LEGACY code",
    Enjoyment: (A.component) C
      where C.code ~ "What number best describes how pain has interfered with your enjoyment of life during the past week code"
      or C.code ~ "Enjoyment of life LEGACY code",
    GeneralActivity: (A.component) C
      where C.code ~ "What number best describes how pain has interfered with your general activity during the past week code"
      or C.code ~ "General activity LEGACY code"
  where true // grammar needs a where statement to separate the "let" from the "return"
  return {
    // NOTE: Hard-code in names because the real LOINC code displays are quite long
    Name:           ConceptTextWithRange(A.code),
    Score:          QuantityText(A.value as FHIR.Quantity),
    Interpretation: Coalesce( ConceptText(First(A.interpretation)),  ConceptText(A.value as FHIR.CodeableConcept) ),
    Questions:      ({ First(Pain), First(Enjoyment), First(GeneralActivity) }) C
                      where C is not null
                      return { "Name": ConceptText(C.code), "Score": QuantityText(C.value as FHIR.Quantity) },
    Date:           ObservationDate(A)
  }
  sort by Date desc

// STarT Back Screening Tool - Overall score and dates (lookback 2 years)

define STarTBackAssessments:
  C3F.Verified(C3F.ObservationLookBack(
    [Observation: "Total score [STarT Back] code"]
      union [Observation: "STarT Back Screening Tool LEGACY code"],
    2 years
  ))

define ReportSTarTBackAssessments:
  (STarTBackAssessments) A
  return {
    Name:           ConceptTextWithRange(A.code),
    Score:          QuantityText(A.value as FHIR.Quantity),
    Interpretation: Coalesce( ConceptText(First(A.interpretation)),  ConceptText(A.value as FHIR.CodeableConcept) ),
    Date:           ObservationDate(A)
  }
  sort by Date desc

// HISTORICAL TREATMENTS

// Opioid medication orders and statements with dates (lookback 2 years)
        //ActiveMedicationRequest
/*
define ActiveOpioidMedicationRequests:
  C3F.ActiveMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Opioid Pain Medications"],
    2 years
  ))

    ActiveOpioidMedications: ReportActiveOpioidMedications,
    ActiveNonOpioidMedications: ReportActiveNonOpioidMedications,
    ActiveBenzodiazepineMedications: ReportActiveBenzodiazepineMedications,
    ActiveNaloxoneMedications: ReportActiveNaloxoneMedications,

define ActiveOpioidMedicationStatements:
  C3F.ActiveMedicationStatement(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Opioid Pain Medications"],
    2 years
  ))

define ReportUrineDrugScreens:
  (UrineDrugScreens) S
  return {
    Name:           ConceptText(S.code),
    Result:         UrineDrugScreenResult(S),
    Interpretation: if (S.interpretation is null) then UrineDrugScreenResult(S)
        else ConceptText(First(S.interpretation)),
    Date:           ObservationDate(S)
  }
  sort by Date desc



*/

define OpioidMedicationRequests:
if "Only Active Medications" then C3F.ActiveMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Opioid Pain Medications"],
     2 years
   ))
    else
      C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
      [MedicationRequest: "Opioid Pain Medications"],
      2 years
    ))

define OpioidMedicationStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: "Opioid Pain Medications"],
    2 years
  ))) MS
    without [MedicationRequest] MR such that
      exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))

define ReportOpioidMedicationRequests:
  (OpioidMedicationRequests) O
  return {
    Type:  'Request',
    Name:  ConceptText(O.medication as FHIR.CodeableConcept),
    Start: DateTimeText(O.authoredOn),
End: null as String, // MedicationRequest end date not supported in R4,
    MME: if "Use MMECalculator" then MMEText(MMECalculator.TotalMME(List{O})) else null,
    Sig: (singleton from (O.dosageInstruction)).text,
    Status: O.status.value
  }
  sort by Start desc, End desc

define ReportOpioidMedicationStatements:
  (OpioidMedicationStatements) S
  return {
    Type:  'Statement',
    Name:  ConceptText(S.medication as FHIR.CodeableConcept),
    Start: MedicationStatementDate(S),
End:   DateTimeText((S.effective as FHIR.Period)."end"),
    MME: 'Not calculated',
    Sig: (singleton from (S.dosage)).text,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportOpioidMedications:
    if "Add Naloxone to Opioid Medications" then
  (ReportOpioidMedicationRequests
   union ReportOpioidMedicationStatements
   union ReportNaloxoneMedications) M
  sort by Start desc, End desc
    else
      (ReportOpioidMedicationRequests
       union ReportOpioidMedicationStatements) M
      sort by Start desc, End desc


// Non-opioid medication orders and statements with dates (lookback 2 years)

define NonOpioidMedicationRequests:
  if "Only Active Medications" then C3F.ActiveMedicationRequest(C3F.MedicationRequestLookBack(
      [MedicationRequest: "Non opioid pain medications"],
    2 years
  )) else
      C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Non opioid pain medications"],
    2 years
  ))

define NonOpioidMedicationStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: "Non opioid pain medications"],
    2 years
  ))) MS
    without [MedicationRequest] MR such that
      exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))

define ReportNonOpioidMedicationRequests:
  (NonOpioidMedicationRequests) O
  return {
    Type:  'Request',
    Name:  ConceptText(O.medication as FHIR.CodeableConcept),
    Start: DateTimeText(O.authoredOn),
End:   null as String, // MedicationRequest end date not supported in R4,'
    MME: 'N/A',
    Sig: (singleton from (O.dosageInstruction)).text,
    Status: O.status.value
  }
  sort by Start desc, End desc

define ReportNonOpioidMedicationStatements:
  (NonOpioidMedicationStatements) S
  return {
    Type:  'Statement',
    Name:  ConceptText(S.medication as FHIR.CodeableConcept),
    Start: MedicationStatementDate(S),
    End:   DateTimeText((S.effective as FHIR.Period)."end"),
    MME: 'N/A',
    Sig: (singleton from (S.dosage)).text,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportNonOpioidMedications:
    if "Add Benzodiazepine to NonOpioid Medications" then
  (ReportNonOpioidMedicationRequests
    union ReportNonOpioidMedicationStatements
    union ReportBenzodiazepineMedications) M
  sort by Start desc, End desc
    else
      (ReportNonOpioidMedicationRequests
        union ReportNonOpioidMedicationStatements) M
      sort by Start desc, End desc

// Non-pharmacologic treatments, orders, and referrals with dates (lookback 2 years)

define NonPharmacologicTreatmentProcedures:
  C3F.ProcedurePerformance(C3F.ProcedureLookBack([Procedure: "Non pharmacologic treatments for chronic pain"], 2 years))

define ReportNonPharmacologicTreatmentProcedures:
  (NonPharmacologicTreatmentProcedures) P
  return {
    Type: 'Procedure',
    Name: ConceptText(P.code),
    Date: Coalesce(
      DateTimeText(P.performed as FHIR.dateTime),
      DateTimeText((P.performed as FHIR.Period)."start")
    )
  }
  sort by Date desc

define NonPharmacologicTreatmentServiceRequests:
  C3F.ServiceRequestActiveOrCompleted(
    C3F.ServiceRequestLookBack([ServiceRequest: "Non pharmacologic treatments for chronic pain"], 2 years)
  )

define ReportNonPharmacologicTreatmentServiceRequests:
  (NonPharmacologicTreatmentServiceRequests) P
  return {
    Type: 'ServiceRequest',
    Name: ConceptText(P.code),
    Date: DateTimeText(P.authoredOn)
  }
  sort by Date desc

define ReportNonPharmacologicTreatments:
  (ReportNonPharmacologicTreatmentProcedures
    union ReportNonPharmacologicTreatmentServiceRequests) M
  sort by Date desc

// Stool softeners and laxatives - orders and statements with dates (lookback 6 months)

define StoolSoftenersAndLaxativesRequests:
  C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Stool softeners and laxatives"],
    6 months
  ))

define StoolSoftenersAndLaxativesStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: "Stool softeners and laxatives"],
    6 months
  ))) MS
    without [MedicationRequest] MR such that
      exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))

define ReportStoolSoftenersAndLaxativesRequests:
  (StoolSoftenersAndLaxativesRequests) O
  return {
    Type:  'Request',
    Name:  ConceptText(O.medication as FHIR.CodeableConcept),
    Start: DateTimeText(O.authoredOn),
    End:   null as String, // MedicationRequest end date not supported in R4,
    Status: O.status.value
  }
  sort by Start desc, End desc

define ReportStoolSoftenersAndLaxativesStatements:
  (StoolSoftenersAndLaxativesStatements) S
  return {
    Type:  'Statement',
    Name:  ConceptText(S.medication as FHIR.CodeableConcept),
    Start: MedicationStatementDate(S),
    End:   DateTimeText((S.effective as FHIR.Period)."end"),
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportStoolSoftenersAndLaxatives:
  (ReportStoolSoftenersAndLaxativesRequests union ReportStoolSoftenersAndLaxativesStatements) M
  sort by Start desc, End desc

// RISK CONSIDERATIONS

// MME (MOST RECENT w/ lookback 6 months) - amount and date

define MostRecentMME:
  C3F.MostRecent(C3F.Verified(C3F.ObservationLookBack([Observation: "Morphine Milligram Equivalent (MME) code"], 6 months)))

define ReportMostRecentMME:
({
  (MostRecentMME) M
    return {
      Name:   ConceptText(M.code),
      Result: QuantityText(M.value as FHIR.Quantity),
      Date:   ObservationDate(M)
    }
}) C
  where C is not null

// Urine drug screen - dates and results (all screens w/ lookback of 1 year)

define UrineDrugScreens:
  C3F.Verified(C3F.ObservationLookBack([Observation: "Urine drug screen for pain management"], 1 year))

define function UrineDrugScreenResult(uds FHIR.Observation):
Coalesce(
  QuantityText(uds.value as FHIR.Quantity),
  (uds.value as FHIR.string).value,
  ConceptText(uds.value as FHIR.CodeableConcept)
)

define ReportUrineDrugScreens:
  (UrineDrugScreens) S
  return {
    Name:           ConceptText(S.code),
    Result:         UrineDrugScreenResult(S),
    Interpretation: if (S.interpretation is null) then UrineDrugScreenResult(S)
        else ConceptText(First(S.interpretation)),
    Date:           ObservationDate(S)
  }
  sort by Date desc

// Benzodiazepine Medications (lookback of 2 years)-  orders and statements with dates

define BenzodiazepineMedicationRequests:
 if "Only Active Medications" then C3F.ActiveMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Benzodiazepine medications"],
    2 years
  )) else
  C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: "Benzodiazepine medications"],
    2 years
  ))

define BenzodiazepineMedicationStatements:
 if "Only Active Medications" then (C3F.ActiveMedicationStatement(C3F.MedicationStatementLookBack(
        [MedicationStatement: "Benzodiazepine medications"],
        2 years
      ))) MS
        without [MedicationRequest] MR such that
          exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))
    else
      (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
        [MedicationStatement: "Benzodiazepine medications"],
        2 years
      ))) MS
        without [MedicationRequest] MR such that
          exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))

define ReportBenzodiazepineMedicationRequests:
  (BenzodiazepineMedicationRequests) O
  return {
    Type:  'Request',
    Name:  ConceptText(O.medication as FHIR.CodeableConcept),
    Start: DateTimeText(O.authoredOn),
    End:   null as String, // MedicationRequest end date not supported in R4
    MME: 'N/A',
    Sig: (singleton from (O.dosageInstruction)).text,
    Status: O.status.value
  }
  sort by Start desc, End desc

define ReportBenzodiazepineMedicationStatements:
  (BenzodiazepineMedicationStatements) S
  return {
    Type:  'Statement',
    Name:  ConceptText(S.medication as FHIR.CodeableConcept),
    Start: MedicationStatementDate(S),
    End:   DateTimeText((S.effective as FHIR.Period)."end"),
    MME: 'N/A',
    Sig: (singleton from (S.dosage)).text,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportBenzodiazepineMedications:
  (ReportBenzodiazepineMedicationRequests union ReportBenzodiazepineMedicationStatements) M
  sort by Start desc, End desc

// Naloxone Medications (unrestricted lookback) - orders and statements with dates

define NaloxoneMedicationRequests:
 if "Only Active Medications" then C3F.ActiveMedicationRequest([MedicationRequest: "Naloxone medications"])
    else
    C3F.ActiveCompletedOrStoppedMedicationRequest([MedicationRequest: "Naloxone medications"])

define NaloxoneMedicationStatements:
 if "Only Active Medications" then (C3F.ActiveMedicationStatement([MedicationStatement: "Naloxone medications"])) MS
    without [MedicationRequest] MR such that
      exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))
    else
  (C3F.ActiveOrCompletedMedicationStatement([MedicationStatement: "Naloxone medications"])) MS
    without [MedicationRequest] MR such that
      exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))

define ReportNaloxoneMedicationRequests:
  (NaloxoneMedicationRequests) O
  return {
    Type:  'Request',
    Name:  ConceptText(O.medication as FHIR.CodeableConcept),
    Start: DateTimeText(O.authoredOn),
    End:   null as String, // MedicationRequest end date not supported in R4,
    MME: if "Use MMECalculator" then MMEText(MMECalculator.TotalMME(List{O})) else null,
    Sig: (singleton from (O.dosageInstruction)).text,
    Status: O.status.value
  }
  sort by Start desc, End desc

define ReportNaloxoneMedicationStatements:
  (NaloxoneMedicationStatements) S
  return {
    Type:  'Statement',
    Name:  ConceptText(S.medication as FHIR.CodeableConcept),
    Start: MedicationStatementDate(S),
    End:   DateTimeText((S.effective as FHIR.Period)."end"),
    MME: 'Not calculated',
    Sig: (singleton from (S.dosage)).text,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportNaloxoneMedications:
  (ReportNaloxoneMedicationRequests union ReportNaloxoneMedicationStatements) M
  sort by Start desc, End desc

// Risk screenings relevant to pain management - overall scores and dates (MOST RECENT w/ lookback 1 year)

define RiskScreeningsRelevantToPainManagement:
  C3F.Verified(C3F.ObservationLookBack(
    [Observation: "Risk assessments relevant to pain management"]
    union [Observation: "Single question r/t ETOH use code"]
    union [Observation: "Single question r/t drug use code"]
  , 1 year))

define ReportRiskScreeningsRelevantToPainManagement:
  (RiskScreeningsRelevantToPainManagement) S
  return {
    Name:           ConceptTextWithRange(S.code),
    Score:          Coalesce(
      QuantityText(S.value as FHIR.Quantity),
      (S.value as FHIR.string).value
    ),
    Interpretation: Coalesce(
      ConceptText(First(S.interpretation)),
      ConceptText(S.value as FHIR.CodeableConcept)
    ),
    Date:           ObservationDate(S)
  }
  sort by Date desc

// SUMMARY

// The Summary object represents the full Pain Management Summary to be displayed to the clinician.  All values are
// returned as user-friendly text representations, but a robust user interface (UI) should be implemented to
// display the data to the user in a friendly manner.  See the Pain Management Summary SMART on FHIR application as
// an example of how to integrate this summary into an EHR using modern web UI technologies.

//****************************************************************************************

//*************************** MME Calculation **********************************

define ActiveOpioidMedications:
  C3F.ActiveMedicationRequest([MedicationRequest: "Opioid Pain Medications"])

/*
TESTING Expressions:
define ActiveOpioidPrescriptions:
  MMECalculator.Prescriptions(ActiveOpioidMedications)

define ActiveOpioidPrescriptionsInput:
  ActiveOpioidMedications O
    let
      // NOTE: Assuming a single dosage instruction element
      dosageInstruction: O.dosageInstruction[0],
      // NOTE: Assuming a single dose and rate element
      doseAndRate: dosageInstruction.doseAndRate[0],
      repeat: dosageInstruction.timing.repeat,
      frequency: Coalesce(repeat.frequencyMax.value, repeat.frequency.value),
      doseRange: MMECalculator.ToFHIRRange(doseAndRate.dose),
      doseQuantity: MMECalculator.ToFHIRQuantity(doseAndRate.dose),
      doseDescription:
        Coalesce(
          // There should be a conversion from FHIR.SimpleQuantity to System.Quantity
          if doseRange is not null
            then ToString(doseRange.low)
                + '-' + ToString(doseRange.high)
                + doseRange.high.unit.value
            else ToString(MMECalculator.ToQuantity(doseQuantity)),
            ''
        ),
      frequencyDescription:
        ToString(dosageInstruction.timing.repeat.frequency.value) +
          Coalesce(
            '-' + ToString(dosageInstruction.timing.repeat.frequencyMax.value),
            ''
          )
    return {
      id: O.id,
      isDraft: O.status.value = 'draft',
      // NOTE: Assuming asNeeded is expressed as a boolean
      isPRN: dosageInstruction.asNeeded,
      doseQuantity: doseQuantity,
      doseRange: doseRange,
      dose: Coalesce(doseQuantity, doseRange.high)
    }


define ActiveOpioidMME:
  MMECalculator.MME(ActiveOpioidMedications)

define TestActiveOpioidMedications1:
  ActiveOpioidMedications M return M.dosageInstruction[0].doseAndRate[0].dose

define TestActiveOpioidMedications2:
  ActiveOpioidMedications M return M.dosageInstruction[0].timing.repeat
*/

define CurrentMME:
  if "Use MMECalculator" then MMECalculator.TotalMME(ActiveOpioidMedications) else null

define ReportCurrentMME:
({
  (CurrentMME) M
    return {
      Name: 'Current Milligram Morphine Equivalent',
      Result: MMEText(M),
      Date: ToString(Today())
    }
}) C
  where C is not null

//********************  MyPAIN Questionnaire Observations  ********************************
define function ConceptTextOrCode(c FHIR.CodeableConcept):
  Coalesce(
    Coalesce((c.coding) c2 return c2.code.value),
    c.text.value)

define function ObservationValue(Obs FHIR.Observation):
  Coalesce(
    QuantityText(Obs.value as FHIR.Quantity),
    ToString((Obs.value as FHIR.boolean)),
    (Obs.value as FHIR.string),
//    ConceptTextOrCode(Obs.value as FHIR.CodeableConcept)  // for just the code
    ConceptText(Obs.value as FHIR.CodeableConcept)  // for just the text
  )

define function GetLinkId(Obs FHIR.Observation):
    if Obs is null then 'Obs is null'
    else if Obs.extension[0] is null then 'Obs.extension is null'
    else if Obs.extension[0].url is null then 'Obs.extension.url is null'
    else if Obs.extension[0].extension is null then 'Obs.extension.extension is null'
    else Obs.extension[0].extension[0].value.value

define QuestionnaireObservations:
  C3F.Verified(C3F.ObservationLookBack([Observation: "MyPAIN Questionnaire Codes"], 1 year))

//TODO - eventually this needs to walk thru nested items beyond 2
define function QuestionTextByLinkId(Obs FHIR.Observation):
  ([Questionnaire] Q where Q.id = 'mypain-questionnaire-ufl') singleQ
return (Coalesce(singleQ.item.item, singleQ.item)) QItem
    where QItem.linkId = Obs.extension[0].extension[0].value as FHIR.string
      return QItem.prefix

/*
MyPAINSubmitDate: ReportMyPAINSubmitDate,
ActivityGoals: ReportActivityGoals,
ActivityBarriers: ReportActivityBarriers,
PainLocations: ReportPainLocations,
PainIntensityAndInterference: ReportPainIntensityAndInterference,
ResourcesProvidedInMyPAIN: ReportResourcesProvidedInMyPAIN
*/

// NOTE: This should NOT use the QuestionnaireResponse, it should use the MyPAINSubmitDate Observation
define ReportMyPAINSubmitDate:
(QuestionnaireObservations) qrOb
    return ObservationDate(qrOb) sort desc

define function DateMatchesMyPainDate(Obs FHIR.Observation):
if ReportMyPAINSubmitDate[0] ~ Obs.effective.value.toString()
    then
        true
    else
        false


define ReportActivityGoals:
  (QuestionnaireObservations) qrOb where qrOb.code.coding[0].code.value = 'mpq-1035' and DateMatchesMyPainDate(qrOb)
    return qrOb.value

define ReportActivityBarriers:
(QuestionnaireObservations) qrOb where qrOb.code.coding[0].code.value = 'mpq-1036'
  return qrOb.value

define function GetSimpleText(qrOb FHIR.Observation):
  case
    when qrOb.code ~ painLocationHead then 'Head'
    when qrOb.code ~ painLocationNeck then 'Neck'
    when qrOb.code ~ painLocationShoulders then 'Shoulders'
    when qrOb.code ~ painLocationArms then 'Arms'
    when qrOb.code ~ painLocationUpperBack then 'Upper Back'
    when qrOb.code ~ painLocationLowerBack  then 'Lower Back'
    when qrOb.code ~ painLocationHands then 'Hands'
    when qrOb.code ~ painLocationAbdomen then 'Abdomen'
    when qrOb.code ~ painLocationPelvis then 'Pelvis'
    when qrOb.code ~ painLocationHips then 'Hips'
    when qrOb.code ~ painLocationUpperLegs then 'Upper Legs'
    when qrOb.code ~ painLocationKnees then 'Knees'
    when qrOb.code ~ painLocationLowerLegs then 'Lower Legs'
    when qrOb.code ~ painLocationFeet then 'Feet'
    when qrOb.code ~ painLocationEverywhere then 'Everywhere'
    when qrOb.code ~ painLocationBack then 'Back'
    when qrOb.code ~ painLocationHandsWrist then 'Hands/Wrist'
    when qrOb.code ~ painLocationAbdomenPelvis then 'Abdoment/Pelvis'
    when qrOb.code ~ painLocationFeetAnkles then 'Feet/Ankles'
    when qrOb.code ~ worstPain then 'At its worst (past 7 days)'
    when qrOb.code ~ averagePain then 'Average Pain (past 7 days)'
    when qrOb.code ~ painRightNow then 'Current Pain'
    when qrOb.code ~ dayToDay then 'Day to day activities'
    when qrOb.code ~ homeWork then 'Work around the home'
    when qrOb.code ~ socialActivities then 'Ability to participate in social activities'
    when qrOb.code ~ householdChores then 'Household chores'
    when qrOb.code ~ funActivities then 'Things you usually do for fun'
    when qrOb.code ~ enjoySocial then 'Enjoyment of social activities'
    when qrOb.code ~ enjoyLife then 'Enjoyment of life'
    when qrOb.code ~ enjoyFamily then 'Family life'
    when qrOb.code ~ noMedicationsTried then 'Medications'
    when qrOb.code ~ noSpecialistsSeen then 'Specialists'
    when qrOb.code ~ noTreatmentsTried then 'Procedures or physical treatments'
    when qrOb.code ~ noTopicalTxTried then 'Topical treatments or devices'
    when qrOb.code ~ noLifestyleChanges then 'Lifestyle changes'
    when qrOb.code ~ noALternativeTxTried then 'Alternative treatments'
    else ''
  end

// Data from the most recent PainLocation Observations
define ReportPainLocations:
    (QuestionnaireObservations) qrOb where
        (qrOb.code ~ painLocationHead
        or qrOb.code ~ painLocationNeck
        or qrOb.code ~ painLocationShoulders
        or qrOb.code ~ painLocationArms
        or qrOb.code ~ painLocationUpperBack
        or qrOb.code ~ painLocationLowerBack
        or qrOb.code ~ painLocationHands
        or qrOb.code ~ painLocationAbdomen
        or qrOb.code ~ painLocationPelvis
        or qrOb.code ~ painLocationHips
        or qrOb.code ~ painLocationUpperLegs
        or qrOb.code ~ painLocationKnees
        or qrOb.code ~ painLocationLowerLegs
        or qrOb.code ~ painLocationFeet
        or qrOb.code ~ painLocationEverywhere
        or qrOb.code ~ painLocationBack
        or qrOb.code ~ painLocationHandsWrist
        or qrOb.code ~ painLocationAbdomenPelvis
        or qrOb.code ~ painLocationFeetAnkles
        )and(DateMatchesMyPainDate(qrOb))
    return
      {
        Location: qrOb.code.coding[0].display.value,
        SimpleLocation: GetSimpleText(qrOb),
        PainYesNo: true,
        Description: Combine(qrOb.value.coding.display, ', ')
      }

// Data from the most recent PainIntensityAndInteference Observations
define ReportPainIntensityAndInterference:
    (QuestionnaireObservations) qrOb where
        (qrOb.code ~ worstPain
        or qrOb.code ~ averagePain
        or qrOb.code ~ painRightNow
        or qrOb.code ~ dayToDay
        or qrOb.code ~ homeWork
        or qrOb.code ~ socialActivities
        or qrOb.code ~ householdChores
        or qrOb.code ~ funActivities
        or qrOb.code ~ enjoySocial
        or qrOb.code ~ enjoyLife
        or qrOb.code ~ enjoyFamily)
        and(DateMatchesMyPainDate(qrOb))
  return
  {
    Question: qrOb.code.coding[0].display.value,
    Response: ObservationValue(qrOb)
  }

define ReportPainIntensity:
    (QuestionnaireObservations) qrOb where
        (qrOb.code ~ worstPain
        or qrOb.code ~ averagePain
        or qrOb.code ~ painRightNow)
        and(DateMatchesMyPainDate(qrOb))
    return
    {
        Question: qrOb.code.coding[0].display.value,
        Response: ObservationValue(qrOb),
        SimpleText: GetSimpleText(qrOb)
    }

    define ReportPainInterference:
    (QuestionnaireObservations) qrOb where
        (qrOb.code ~ dayToDay
        or qrOb.code ~ homeWork
        or qrOb.code ~ socialActivities
        or qrOb.code ~ householdChores
        or qrOb.code ~ funActivities
        or qrOb.code ~ enjoySocial
        or qrOb.code ~ enjoyLife
        or qrOb.code ~ enjoyFamily)
  return
  {
    Question: qrOb.code.coding[0].display.value,
    Response: ObservationValue(qrOb),
    SimpleText: GetSimpleText(qrOb)
  }

  define function GetResourceURL(qrOb Observation):
    if qrOb.code ~ cdcLink then 'https://uspainfoundation.org/living-with-pain/'
    else if qrOb.code ~ flatTiresVideo then 'https://www.youtube.com/embed/QWcr9J3MLfo'
    else null

// Data from the most recent "resources viewed" Observations
define ReportResourcesProvidedInMyPAIN:
(QuestionnaireObservations) qrOb where
    qrOb.code ~ flatTiresVideo
    or qrOb.code ~ cdcLink
    and(DateMatchesMyPainDate(qrOb))
  return
  {
      Resource: qrOb.value.value,
      ResourceUrl: GetResourceURL(qrOb),
//      ResourceUrl: GetResourceURL(qrOb.extension[0].extension[0].value as FHIR.string),
      ViewedOn: ObservationValue(qrOb)
  }

// Data from the most recent self reported MyPAIN observations
define ReportSelfReportedTreatmentsFromMyPAIN:
    (QuestionnaireObservations) qrOb where
        (qrOb.code ~ physicalTreatmentsOther
        or qrOb.code ~ prescriptionOther
        or qrOb.code ~ newTreatmentOther
        or qrOb.code ~ exercises
        or qrOb.code ~ sleepPositioners
        or qrOb.code ~ stretching
        or qrOb.code ~ weightLoss
        or qrOb.code ~ reachingGoals
        or qrOb.code ~ iceOrHeat
        or qrOb.code ~ physicalTherapy
        or qrOb.code ~ acupuncture
        or qrOb.code ~ chiropracticTx
        or qrOb.code ~ painRelievers
        or qrOb.code ~ herbTx
        or qrOb.code ~ cremes
        or qrOb.code ~ otherOTC
        or qrOb.code ~ opioidMeds
        or qrOb.code ~ cortisone
        or qrOb.code ~ nonOpioidMeds
        or qrOb.code ~ medMarijuana
        or qrOb.code ~ yogo
        or qrOb.code ~ massage
        or qrOb.code ~ meditation
        or qrOb.code ~ relaxation
        or qrOb.code ~ groupIndividualTherapy
        or qrOb.code ~ cognitiveTherapy
        or qrOb.code ~ acceptanceTherapy
        or qrOb.code ~ sleepManagement
        or qrOb.code ~ aromatherapy
        or qrOb.code ~ crystals
        or qrOb.code ~ essentialOils
        or qrOb.code ~ cbdOil
        or qrOb.code ~ musicTherapy
        or qrOb.code ~ otherNewTreatments)
        and(DateMatchesMyPainDate(qrOb))
    return
    {
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0],
        Effectiveness: ObservationValue(qrOb),
        QRCode: qrOb.code,
        mpqrValue: qrOb.value.coding[0].code
    }

    // Data from the most recent self reported MyPAIN observations that are self reported treatments
define TreatmentObservationsFromMyPain:
  (QuestionnaireObservations) qrOb where
        (qrOb.code ~ otcMedications
        )and(DateMatchesMyPainDate(qrOb))
  return{
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0],
        Effectiveness: ObservationValue(qrOb)
    }


    // Data from the most recent self reported MyPAIN observations - treatments not tried
define ReportNotTriedTx:
    (QuestionnaireObservations) qrOb where
      ((qrOb.code ~ noMedicationsTried and qrOb.value = true)
      or (qrOb.code ~ noSpecialistsSeen and qrOb.value = true)
      or (qrOb.code ~ noTreatmentsTried and qrOb.value = true)
      or (qrOb.code ~ noTopicalTxTried and qrOb.value = true)
      or (qrOb.code ~ noLifestyleChanges and qrOb.value = true)
      or (qrOb.code~ noALternativeTxTried and qrOb.value = true)
      and(DateMatchesMyPainDate(qrOb)))
      return{
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0],
        SimpleText: GetSimpleText(qrOb)
      }

define ReportGreatlyEffectiveTx:
    (QuestionnaireObservations) qrOb where
    ((qrOb.value as CodeableConcept) ~ greatlyEffective
    and(DateMatchesMyPainDate(qrOb)))
      return{
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0]
      }

define ReportModeratelyEffectiveTx:
    (QuestionnaireObservations) qrOb where
    ((qrOb.value as CodeableConcept) ~ moderatelyEffective
    and(DateMatchesMyPainDate(qrOb)))
      return{
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0]
      }

define ReportSlightlyEffectiveTx:
    (QuestionnaireObservations) qrOb where
    ((qrOb.value as CodeableConcept) ~ slightlyEffective
    and(DateMatchesMyPainDate(qrOb)))
      return{
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0]
      }
define ReportNotEffectiveTx:
    (QuestionnaireObservations) qrOb where
      ((qrOb.value as CodeableConcept) ~ notAtAllEffective
      and(DateMatchesMyPainDate(qrOb)))
      return{
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0]
      }

define ReportOtherTx:
    (QuestionnaireObservations) qrOb where
      (qrOb.code ~ otherMedicationTried
      or qrOb.code ~ otherSpecialists
      or qrOb.code ~ otherTreatments
      or qrOb.code ~ otherTopicalTx
      or qrOb.code ~ otherLifestyleChanges
      or qrOb.code ~ otherAlternativeTx
      or qrOb.code ~ otherOTC
      or qrOb.code ~ otherNewTreatments
      or qrOb.code ~ newTreatmentOther
      and(DateMatchesMyPainDate(qrOb)))
      return{
        Response: ObservationValue(qrOb)
      }


// ******************************* Decision Logic ******************************

/*
# Recommendation #3
In Active Prescriptions|Opioids, provide the following text as an info flyover:

For 2016 CDC Guidelines:
'Per CDC guidelines, before starting, and periodically during opioid therapy,
clinicians should discuss with patients known risks and realistic benefits of
opioid therapy and patient and clinician responsibilities for managing therapy
(recommendation category: A, evidence type: 3).
[CDC Opioid Prescribing Guideline, Recommendation #3](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'

For 2022 CDC Guidelines:
'Per CDC guidelines, when starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe
immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids
(<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down">recommendation category: A; evidence type: 4</a>).'
*/
define ReportRecommendation3Text:
    if "Use 2022 CDC Guidelines" then
        'Per CDC guidelines, when starting opioid therapy for acute, subacute, or chronic pain, clinicians should prescribe immediate-release opioids instead of extended-release and long-acting (ER/LA) opioids (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: A; evidence type: 4</a>).'
    else
        'Per CDC guidelines, before starting, and periodically during opioid therapy, clinicians should discuss with patients known risks and realistic benefits of opioid therapy and patient and clinician responsibilities for managing therapy (recommendation category: A, evidence type: 3).  [CDC Opioid Prescribing Guideline, Recommendation #3](<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm#Recommendation3" rel="noopener noreferrer"/>)'

/*
# Recommendation #5
In Active Prescriptions|Opioids|Total MME/Day, provide the following text as an Exclamation flyover when MME/day >= 50:
"Per CDC guidelines, when opioids are started, clinicians should prescribe the
lowest effective dosage. Clinicians should use caution when prescribing opioids
at any dosage, should carefully reassess evidence of individual benefits and risks
when considering increasing dosage to ≥50 morphine milligram equivalents (MME)/day,
and should avoid increasing dosage to ≥90 MME/day or carefully justify a decision
to titrate dosage to ≥90 MME/day (recommendation category: A, evidence type: 3).

For MME/day of ≥ 50, CDC guidelines recommend incorporating into the management
plan strategies to mitigate risk, including considering offering naloxone
(recommendation category: A, evidence type: 4).
[CDC Opioid Prescribing Guideline, Recommendation #5 and #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)"
*/
define ReportRecommendation5Text:
  if CurrentMME >= 50 '{MME}/d' then
    if "Use 2022 CDC Guidelines" then
        'Per CDC guidelines, When opioids are initiated for opioid-naïve patients with acute, subacute, or chronic pain, clinicians should prescribe the lowest effective dosage. If opioids are continued for subacute or chronic pain, clinicians should use caution when prescribing opioids at any dosage, should carefully evaluate individual benefits and risks when considering increasing dosage, and should avoid increasing dosage above levels likely to yield diminishing returns in benefits relative to risks to patients (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: A; evidence type: 3</a>)<br/><br/><br/>For patients already receiving opioid therapy, clinicians should carefully weigh benefits and risks and exercise care when changing opioid dosage. If benefits outweigh risks of continued opioid therapy, clinicians should work closely with patients to optimize nonopioid therapies while continuing opioid therapy. If benefits do not outweigh risks of continued opioid therapy, clinicians should optimize other therapies and work closely with patients to gradually taper to lower dosages or, if warranted based on the individual circumstances of the patient, appropriately taper and discontinue opioids. Unless there are indications of a life-threatening issue such as warning signs of impending overdose (e.g., confusion, sedation, or slurred speech), opioid therapy should not be discontinued abruptly, and clinicians should not rapidly reduce opioid dosages from higher dosages (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: B; evidence type: 4</a>)'
    else
        'Per CDC guidelines, when opioids are started, clinicians should prescribe the lowest effective dosage. Clinicians should use caution when prescribing opioids at any dosage, should carefully reassess evidence of individual benefits and risks when considering increasing dosage to ≥50 morphine milligram equivalents (MME)/day, and should avoid increasing dosage to ≥90 MME/day or carefully justify a decision to titrate dosage to ≥90 MME/day (recommendation category: A, evidence type: 3).\n\nFor MME/day of ≥ 50, CDC guidelines recommend incorporating into the management plan strategies to mitigate risk, including considering offering naloxone (recommendation category: A, evidence type: 4). [CDC Opioid Prescribing Guideline, Recommendation #5 and #8](<a href="https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm" target="_blank" rel="noopener noreferrer"/>)'
  else
    null

/*
# Recommendation #8
In Pertinent Conditions|Co-Morbid Conditions Increasing Risk When Using Opioids, provide the following text as an info flyover:

For 2016 CDC Guidelines:
"Per CDC guidelines, before starting, and periodically during continuation of
opioid therapy, clinicians should evaluate risk factors for opioid-related harms.
Clinicians should incorporate into the management plan strategies to mitigate risk,
including considering offering naloxone when factors that increase risk for opioid
overdose, such as history of overdose, history of substance use disorder,
higher opioid dosages (greater than or equal to [≥] 50 morphine milligram equivalents [MME]/day),
or concurrent benzodiazepine use, are present (recommendation category: A, evidence type: 4).
[CDC Opioid Prescribing Guideline, Recommendation #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)"

For 2022 CDC Guidelines:
'Per CDC guidelines, before starting, and periodically during continuation of opioid therapy, clinicians
should evaluate risk factors for opioid-related harms. Clinicians should incorporate into the management
plan strategies to mitigate risk, including considering offering naloxone when factors that increase risk
for opioid overdose, such as history of overdose, history of substance use disorder, higher opioid dosages
(greater than or equal to [≥] 50 morphine milligram equivalents [MME]/day), or concurrent benzodiazepine use,
are present (recommendation category: A, evidence type: 4). [CDC Opioid Prescribing Guideline, Recommendation #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'*/
define ReportRecommendation8Text:
      if "Use 2022 CDC Guidelines" then
        'Per CDC guidelines, before starting and periodically during continuation of opioid therapy, clinicians should evaluate risk for opioid-related harms and discuss risk with patients. Clinicians should work with patients to incorporate into the management plan strategies to mitigate risk, including offering naloxone (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: A; evidence type: 4</a>)'
      else
  'Per CDC guidelines, before starting, and periodically during continuation of opioid therapy, clinicians should evaluate risk factors for opioid-related harms. Clinicians should incorporate into the management plan strategies to mitigate risk, including considering offering naloxone when factors that increase risk for opioid overdose, such as history of overdose, history of substance use disorder, higher opioid dosages (greater than or equal to [≥] 50 morphine milligram equivalents [MME]/day), or concurrent benzodiazepine use, are present (recommendation category: A, evidence type: 4). [CDC Opioid Prescribing Guideline, Recommendation #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'

/*
# Recommendation #10
In Urine Drug Screening, provide the following text with an Exclamation icon when no Uring drug screen is present in the past year:
"No urine drug screen within the past year
For 2016 CDC Guidelines:
Patient’s active medications include an opioid. Per CDC guidelines, when prescribing
opioids for chronic pain, clinicians should use urine drug testing before starting
opioid therapy and consider urine drug testing at least annually to assess for prescribed
medications as well as other controlled prescription drugs and illicit drugs
(recommendation category: B, evidence type: 4)
[CDC Opioid Prescribing Guideline, Recommendation #10](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)."

For 2022 CDC Guidelines:
'Patient’s active medications include an opioid. Per CDC guidelines, when prescribing opioids for subacute or chronic pain,
clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other
prescribed and nonprescribed controlled substances (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down">
recommendation category: B; evidence type: 4</a>)'
*/
define ReportRecommendation10Text:
  if not exists ReportUrineDrugScreens then
     if "Use 2022 CDC Guidelines" then
        '**No urine drug screen within the past year**\n\nPatient’s active medications include an opioid. Per CDC guidelines, When prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: B; evidence type: 4</a>).'
     else
    '**No urine drug screen within the past year**\n\nPatient’s active medications include an opioid. Per CDC guidelines, when prescribing opioids for chronic pain, clinicians should use urine drug testing before starting opioid therapy and consider urine drug testing at least annually to assess for prescribed medications as well as other controlled prescription drugs and illicit drugs (recommendation category: B, evidence type: 4) [CDC Opioid Prescribing Guideline, Recommendation #10](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm).'
  else
     if "Use 2022 CDC Guidelines" then
        'Patient’s active medications include an opioid. Per CDC guidelines, when prescribing opioids for subacute or chronic pain, clinicians should consider the benefits and risks of toxicology testing to assess for prescribed medications as well as other prescribed and nonprescribed controlled substances (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: B; evidence type: 4</a>)'
     else
        'Patient’s active medications include an opioid. Per CDC guidelines, when prescribing opioids for chronic pain, clinicians should use urine drug testing before starting opioid therapy and consider urine drug testing at least annually to assess for prescribed medications as well as other controlled prescription drugs and illicit drugs (recommendation category: B, evidence type: 4) [CDC Opioid Prescribing Guideline, Recommendation #10](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm).'
/*
# Recommendation #11
In Active Prescriptions|Non-Opioids, provide the following text as an Exclamation flyover when Benzodiazepines and Opioids are present:

For 2016 CDC Guidelines:
"Per CDC guidelines, avoid prescribing opioid pain medication and benzodiazepines
concurrently whenever possible (recommendation category: A, evidence type: 3)
[CDC Opioid Prescribing Guideline, Recommendation #11](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)"

For 2022 CDC Guidelines:
'Per CDC guidelines, clinicians should use particular caution when prescribing opioid pain medication and benzodiazepines concurrently and
consider whether benefits outweigh risks of concurrent prescribing of opioids and other central nervous system depressants
(<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down">recommendation category: B; evidence type: 3</a>)'
*/
define ReportRecommendation11Text:
  if exists (ReportOpioidMedications) and exists (ReportBenzodiazepineMedications) then
      if "Use 2022 CDC Guidelines" then
            'Per CDC guidelines, clinicians should use particular caution when prescribing opioid pain medication and benzodiazepines concurrently and consider whether benefits outweigh risks of concurrent prescribing of opioids and other central nervous system depressants (<a href="https://www.cdc.gov/mmwr/volumes/71/rr/rr7103a1.htm?s_cid=rr7103a1.htm_w#B3_down" target="_blank" rel="noopener noreferrer">recommendation category: B; evidence type: 3</a>)'
          else
    'Per CDC guidelines, avoid prescribing opioid pain medication and benzodiazepines concurrently whenever possible (recommendation category: A, evidence type: 3) [CDC Opioid Prescribing Guideline, Recommendation #11](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'
  else
    null

/*
Test Cases:
1. A patient that does not meet inclusion criteria
  Expected outcome: Pain Manager displays that the patient does not meet inclusion criteria
2. A patient that has opioids at < 50 MME/d, no benzodiazepines, a urine drug screen within a year, and no MyPAIN questionnaire data
  Expected outcome: Pain Manager displays info icon for Recommendation #3 in Active Prescriptions and Recommendation #8 in CoMorbid Conditions, and No MyPain Questionnaire Data message
3. A patient that has opioids at < 50 MME/d, no benzodiazepines, a urine drug screen within a year, and MyPAIN questionnaire data
  Expected outcome: Pain Manager displays info icon for Recommendation #3 in Active Prescriptions and Recommendation #8 in CoMorbid Conditions, and appropriate MyPAIN Questionnaire data in Shared Decision Making and Self-Reported Treatments (and the Shared Decision Making element is expanded by default)
4. A patient that has opioids at < 50 MME/d, no benzodiazepines, and no urine drug screen within a year
  Expected outcome: Pain Manager displays recommendation text for Recommendation #10 in Urine Drug Screening (and the element is expanded by default)
5. A patient that has opioids at < 50 MME/d and a concurrent benzodiazepine
  Expected outcome: Pain Manager displays exclamation icon for Recommendation #11 in Active Prescriptions
6. A patient that has opioids at >= 50 MME/d
  Expected outcome: Pain Manager displays exclamation icon for Recommendation #5 in Active Prescriptions
*/

//***************************** Summary ****************************************
/*
Pain Manager Summary Object

# Pertinent Conditions
## Chronic Pain Conditions (past 12 months)
| Name |

## Co-Morbid Conditions Increasing Risk When Using Opioids (past 12 months unless otherwise noted)
| Name |

# Current Pain Treatments
## Active Prescriptions
### Non-opioids
| Medication | Date Prescribed | Sig
### Opioids
Total MME/Day:
| Medication | MME/Day | Date Prescribed | Sig
## Self-Reported Treatments From MyPAIN (past 6 months)
| Treatment | Effectiveness

# Urine Drug Screening
TODO: This is confusing because the note says Lookback period: past 12 months, but the
dates in the headers represent two years?
| Test | Past 6 Months | Past Year | Past 18 Months | Past 24 Months |

# Shared Decision Making
MyPAIN submit date
Activity Goals
Activity Barriers
## PAIN Locations
| Location | Pain Y/N | Description
## Pain Intensity and Interference
| Question | Response |
## Resources Provided in MyPAIN
| Resource | Viewed On |

*/
// Control flags -- These actually belong in a Config.cql file (similar to the config file in opioid-cds-r4 IG), but this app is not processing it correctly.
define "Only Active Medications":
    true

define "Use MMECalculator":
    true

define "Add Benzodiazepine to NonOpioid Medications":
    false

define "Add Naloxone to Opioid Medications":
    false

define "Use 2022 CDC Guidelines":
    true

define "Use Inclusion Criteria":
    false

// Return results for use in application
define Summary: {
   Patient: {
    Name: Combine(Patient.name.given G return G.value, ' ') + ' ' + Combine(Patient.name.family F return F.value, ' '),
    Gender: Patient.gender.value,
    Age: AgeInYears(),
    MeetsInclusionCriteria: MeetsInclusionCriteria
  },
  PertinentConditions: {
    ConditionsAssociatedWithChronicPain: ReportConditionsAssociatedWithChronicPain,
    CoMorbidConditionsIncreasingRiskWhenUsingOpioids: ReportRiskFactorsForOpioidRelatedHarms,
    Recommendation8Text: ReportRecommendation8Text
  },
  CurrentPertinentTreatments: {
    CurrentMME: ReportCurrentMME,
    MostRecentMME: ReportMostRecentMME,
    OpioidMedications: ReportOpioidMedications,
    NonOpioidMedications: ReportNonOpioidMedications,
    BenzodiazepineMedications: ReportBenzodiazepineMedications,
    NaloxoneMedications: ReportNaloxoneMedications,
    SelfReportedTreatmentsFromMyPAIN: ReportSelfReportedTreatmentsFromMyPAIN,
    Recommendation3Text: ReportRecommendation3Text,
    Recommendation5Text: ReportRecommendation5Text,
    Recommendation8Text: ReportRecommendation8Text,
    Recommendation11Text: ReportRecommendation11Text
  },
  TreatmentEffectiveness: {
    NotTriedTx: ReportNotTriedTx,
    GreatlyEffectiveTx: ReportGreatlyEffectiveTx,
    ModeratelyEffectiveTx: ReportModeratelyEffectiveTx,
    SlightlyEffectiveTx: ReportSlightlyEffectiveTx,
    NotEffectiveTx: ReportNotEffectiveTx,
    OtherTx: ReportOtherTx
  },
  UrineDrugScreening: {
    UrineDrugScreens: ReportUrineDrugScreens,
    Recommendation10Text: ReportRecommendation10Text
  },
  SharedDecisionMaking: {
    MyPAINSubmitDate: ReportMyPAINSubmitDate[0],
    ActivityGoals: ReportActivityGoals,
    ActivityBarriers: ReportActivityBarriers,
    PainLocations: ReportPainLocations,
    PainIntensity: ReportPainIntensity,
    PainInterference: ReportPainInterference,
    PainIntensityAndInterference: ReportPainIntensityAndInterference,
    ResourcesProvidedInMyPAIN: ReportResourcesProvidedInMyPAIN
  }
}
