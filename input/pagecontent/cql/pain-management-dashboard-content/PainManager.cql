// PainManager - Clinical Decision Support For Chronic Pain Management
// This is the primary library in support of the CDS4CPM shared decision making
// provider-facing tool, Pain Manager. The tool is based on the AHRQ CDS Connect
// Factors to Consider in Managing Chronic Pain, but diverges in important ways,
// documented here.
//
// From a CQL artifact perspective, the artifact shares CQL content with
// the Factors to Consider in Managing Chronic Pain artifact by referencing
// it as an included library. This required upgrading the library, as well
// the library it depends on (CDS_Connect_Commons) to FHIR 4.0.1.
//
// The primary focus of the Pain Manager application is on enabling shared
// decision making for patients with chronic pain. This focus led to several
// primary differences between the Pain Management Summary, and the Pain Manager:
// 1. Differences in terminology and grouping of displayed information
// 2. Inclusion of Opioid CDS content for recommendations 3, 8, 10, and 11
// 3. Inclusion of the MME calculator (recommendation 5)
//
// As a result of these changes, several of the sections in the pain management
// summary are replaced entirely in the PainManager summary object, and several
// new sections have been added. Where possible, content from the Pain Management
// summary was reused, and references to definitions in that library are referenced
// with the local alias F2C.

library PainManager version '0.1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called C3F
include Factors_to_Consider_in_Managing_Chronic_Pain_FHIRv400 version '1.0.1' called F2C
include ChronicPainConcepts version '2.0.0' called Cx
include MMECalculator version '3.0.0' called MMECalculator

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

codesystem "MyPAIN Questionnaire Codes": 'http://fhir.org/guides/cqf/cds4cpm/CodeSystem/mypain-questionnaire-codes'

valueset "MyPAIN All Questionnaire Codes": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/mypain-all-questionnaire-codes'
valueset "MyPAIN All QuestionnaireResponse Codes": 'http://fhir.org/guides/cqf/cds4cpm/ValueSet/mypain-all-questionnaireresponse-codes'

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

code "physicalTreatmentsOther": 'mpq-1054' from "MyPAIN Questionnaire Codes" display 'Other physical treatment'
code "prescriptionOther": 'mpq-1057' from "MyPAIN Questionnaire Codes" display 'Other prescription treatment'
code "newTreatmentOther": 'mpq-1059' from "MyPAIN Questionnaire Codes" display 'Other new treatment'
code "painGoal": 'mpq-1035' from "MyPAIN Questionnaire Codes" display 'Pain Goal'
code "goalBarriers": 'mpq-1036' from "MyPAIN Questionnaire Codes" display 'Goal Barriers'

concept "Questionnaire response Document":
  { "Questionnaire response Document code" } display 'Questionnaire response Document'

context Patient

//*************************** MME Calculation **********************************

define ActiveOpioidMedications:
  C3F.ActiveMedicationRequest([MedicationRequest: Cx."Opioid Pain Medications"])

define CurrentMME:
  MMECalculator.TotalMME(ActiveOpioidMedications)

define ReportCurrentMME:
({
  (CurrentMME) M
    return {
      Name: 'Current Milligram Morphine Equivalent',
      Result: F2C.MMEText(M),
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
    F2C.QuantityText(Obs.value as FHIR.Quantity),
    ToString((Obs.value as FHIR.boolean)),
    (Obs.value as FHIR.string),
//    ConceptTextOrCode(Obs.value as FHIR.CodeableConcept)  // for just the code
    F2C.ConceptText(Obs.value as FHIR.CodeableConcept)  // for just the text
  )

define function GetLinkId(Obs FHIR.Observation):
    if Obs is null then 'Obs is null'
    else if Obs.extension[0] is null then 'Obs.extension is null'
    else if Obs.extension[0].url is null then 'Obs.extension.url is null'
    else if Obs.extension[0].extension is null then 'Obs.extension.extension is null'
    else Obs.extension[0].extension[0].value.value

define QuestionnaireObservations:
  C3F.Verified(C3F.ObservationLookBack([Observation: "MyPAIN All Questionnaire Codes"], 1 year))
//  C3F.Verified(C3F.ObservationLookBack([Observation], 1 year))

/* define ReportQuestionnaireObservations:
  QuestionnaireObservations qo
    return {
      Answer: ObservationValue(qo),
      DateText: F2C.ObservationDate(qo),
      LinkId: qo.extension[0].extension[0].value.value
    } */

//TODO - eventually this needs to walk thru nested items beyond 2
define function QuestionTextByLinkId(Obs FHIR.Observation):
  ([Questionnaire] Q where Q.id = 'mypain-questionnaire') singleQ
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
  return F2C.DateTimeText(qrOb.effective as FHIR.dateTime)

define ReportActivityGoals:
  (QuestionnaireObservations) qrOb where qrOb.code.coding[0].code.value = 'mpq-1035'
    return qrOb.value

define ReportActivityBarriers:
(QuestionnaireObservations) qrOb where qrOb.code.coding[0].code.value = 'mpq-1036'
  return qrOb.value

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
        or qrOb.code ~ painLocationOther)
    return
      {
        Location: qrOb.code.coding[0].display.value,
        PainYesNo: true,
        Description: ObservationValue(qrOb)
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
  return
  {
    Question: qrOb.code.coding[0].display.value,
    Response: ObservationValue(qrOb)
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
    return
    {
        Treatment: QuestionTextByLinkId(qrOb)[0].value[0],
        Effectiveness: ObservationValue(qrOb)
    }

// ******************************* Decision Logic ******************************

/*
# Recommendation #3
In Active Prescriptions|Opioids, provide the following text as an info flyover:
"Per CDC guidelines, before starting, and periodically during opioid therapy,
clinicians should discuss with patients known risks and realistic benefits of
opioid therapy and patient and clinician responsibilities for managing therapy
(recommendation category: A, evidence type: 3).
[CDC Opioid Prescribing Guideline, Recommendation #3](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)"
*/
define ReportRecommendation3Text:
  'Per CDC guidelines, before starting, and periodically during opioid therapy, clinicians should discuss with patients known risks and realistic benefits of opioid therapy and patient and clinician responsibilities for managing therapy (recommendation category: A, evidence type: 3).  [CDC Opioid Prescribing Guideline, Recommendation #3](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'

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
    'Per CDC guidelines, when opioids are started, clinicians should prescribe the lowest effective dosage. Clinicians should use caution when prescribing opioids at any dosage, should carefully reassess evidence of individual benefits and risks when considering increasing dosage to ≥50 morphine milligram equivalents (MME)/day, and should avoid increasing dosage to ≥90 MME/day or carefully justify a decision to titrate dosage to ≥90 MME/day (recommendation category: A, evidence type: 3).\n\nFor MME/day of ≥ 50, CDC guidelines recommend incorporating into the management plan strategies to mitigate risk, including considering offering naloxone (recommendation category: A, evidence type: 4). [CDC Opioid Prescribing Guideline, Recommendation #5 and #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'
  else
    null

/*
# Recommendation #8
In Pertinent Conditions|Co-Morbid Conditions Increasing Risk When Using Opioids, provide the following text as an info flyover:
"Per CDC guidelines, before starting, and periodically during continuation of
opioid therapy, clinicians should evaluate risk factors for opioid-related harms.
Clinicians should incorporate into the management plan strategies to mitigate risk,
including considering offering naloxone when factors that increase risk for opioid
overdose, such as history of overdose, history of substance use disorder,
higher opioid dosages (greater than or equal to [≥] 50 morphine milligram equivalents [MME]/day),
or concurrent benzodiazepine use, are present (recommendation category: A, evidence type: 4).
[CDC Opioid Prescribing Guideline, Recommendation #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)"
*/
define ReportRecommendation8Text:
  'Per CDC guidelines, before starting, and periodically during continuation of opioid therapy, clinicians should evaluate risk factors for opioid-related harms. Clinicians should incorporate into the management plan strategies to mitigate risk, including considering offering naloxone when factors that increase risk for opioid overdose, such as history of overdose, history of substance use disorder, higher opioid dosages (greater than or equal to [≥] 50 morphine milligram equivalents [MME]/day), or concurrent benzodiazepine use, are present (recommendation category: A, evidence type: 4). [CDC Opioid Prescribing Guideline, Recommendation #8](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)'

/*
# Recommendation #10
In Urine Drug Screening, provide the following text with an Exclamation icon when no Uring drug screen is present in the past year:
"No urine drug screen within the past year

Patient’s active medications include an opioid. Per CDC guidelines, when prescribing
opioids for chronic pain, clinicians should use urine drug testing before starting
opioid therapy and consider urine drug testing at least annually to assess for prescribed
medications as well as other controlled prescription drugs and illicit drugs
(recommendation category: B, evidence type: 4)
[CDC Opioid Prescribing Guideline, Recommendation #10](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)."
*/
define ReportRecommendation10Text:
  if not exists F2C.ReportUrineDrugScreens then
    '**No urine drug screen within the past year**\n\nPatient’s active medications include an opioid. Per CDC guidelines, when prescribing opioids for chronic pain, clinicians should use urine drug testing before starting opioid therapy and consider urine drug testing at least annually to assess for prescribed medications as well as other controlled prescription drugs and illicit drugs (recommendation category: B, evidence type: 4) [CDC Opioid Prescribing Guideline, Recommendation #10](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm).'
  else
    null

/*
# Recommendation #11
In Active Prescriptions|Non-Opioids, provide the following text as an Exclamation flyover when Benzodiazepines and Opioids are present:
"Per CDC guidelines, avoid prescribing opioid pain medication and benzodiazepines
concurrently whenever possible (recommendation category: A, evidence type: 3)
[CDC Opioid Prescribing Guideline, Recommendation #11](https://www.cdc.gov/mmwr/volumes/65/rr/rr6501e1.htm)"
*/
define ReportRecommendation11Text:
  if exists (F2C.ReportOpioidMedications) and exists (F2C.ReportBenzodiazepineMedications) then
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

define Summary: {
   Patient: {
    Name: Combine(Patient.name.given G return G.value, ' ') + ' ' + Combine(Patient.name.family F return F.value, ' '),
    Gender: Patient.gender.value,
    Age: AgeInYears(),
    MeetsInclusionCriteria: F2C.MeetsInclusionCriteria
  },
  PertinentConditions: {
    ConditionsAssociatedWithChronicPain: F2C.ReportConditionsAssociatedWithChronicPain,
    CoMorbidConditionsIncreasingRiskWhenUsingOpioids: F2C.ReportRiskFactorsForOpioidRelatedHarms,
    Recommendation8Text: ReportRecommendation8Text
  },
  CurrentPertinentTreatments: {
    CurrentMME: ReportCurrentMME,
    MostRecentMME: F2C.ReportMostRecentMME,
    OpioidMedications: F2C.ReportOpioidMedications,
    NonOpioidMedications: F2C.ReportNonOpioidMedications,
    BenzodiazepineMedications: F2C.ReportBenzodiazepineMedications,
    NaloxoneMedications: F2C.ReportNaloxoneMedications,
    SelfReportedTreatmentsFromMyPAIN: ReportSelfReportedTreatmentsFromMyPAIN,
    Recommendation3Text: ReportRecommendation3Text,
    Recommendation5Text: ReportRecommendation5Text,
    Recommendation11Text: ReportRecommendation11Text
  },
  UrineDrugScreening: {
    UrineDrugScreens: F2C.ReportUrineDrugScreens,
    Recommendation10Text: ReportRecommendation10Text
  },
  SharedDecisionMaking: {
    MyPAINSubmitDate: ReportMyPAINSubmitDate,
    ActivityGoals: ReportActivityGoals,
    ActivityBarriers: ReportActivityBarriers,
    PainLocations: ReportPainLocations,
    PainIntensityAndInterference: ReportPainIntensityAndInterference,
    ResourcesProvidedInMyPAIN: ReportResourcesProvidedInMyPAIN
  }
}
