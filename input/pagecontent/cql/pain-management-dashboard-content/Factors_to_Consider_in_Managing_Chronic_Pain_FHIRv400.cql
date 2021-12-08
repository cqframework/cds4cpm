// # Introduction

// The Pain Management Summary artifact provides relevant information to consider when managing a patient’s pain.
// This CDS logic was informed by the Centers for Disease Control and Prevention (CDC) Guideline for Opioid Prescribing
// for Chronic Pain. The CDS is not a direct representation of any one recommendation statement within the guideline.
// Instead, the CDS compiles clinical concepts mentioned throughout the guideline in one consolidated summary for
// clinician review.
//
// In the process of authoring the logic, certain assumptions were made and details developed when the guideline did
// not provide enough specificity.  These decisions were made in the context of the CDS Connect Workgroup and CDC
// stakeholders, and are documented in the logic and/or in the CDS Connect artifact metadata.
//
// NOTE: This is a FHIR R4 port of the original FHIR DSTU2 CQL piloted for CDS Connect.  In addition to the changes
// to support FHIR R4, it contains the following changes from the artifact that was piloted:
// - Added the following value sets for identifying Risk Factors for Opiod-Related Harms (in addition to existing ones)
//   - Depression Diagnosis ICD9 (2.16.840.1.113883.3.600.143)
//   - Anxiety Disorders ICD9 (2.16.840.1.113883.3.1240.2017.3.2.1015)
//   - Substance Abuse (2.16.840.1.113883.3.464.1003.106.11.1010)
//   - Pregnancy (New ICD10 codes published in 2018 and 2019)": '2.16.840.1.113762.1.4.1032.80'
// - Changed the Suicide Attempt value set to 2.16.840.1.113762.1.4.1032.102
// - Removed specific inclusion of SNOMED-CT 86849004 since it is now in the Suicide Attempt value set
// - Added LOINC codes for the Pain intensity, Enjoyment of life, General activity scale [PEG]
//   - Previous local codes are still supported (but discouraged)
// - Added logic to normalize long LOINC display text for PEG codes to shorter names
// - Added LOINC code for the STarT Back Screening Tool
//   - Previous local code is still supported (but discouraged)
// - Added logic to display range for Opioid Risk Tool (ORT)
// - Updated QuantityText logic to not include '{score}' units (since scalar number is enough in those cases)
//
// In addition to the changes above, the R4 representation contains the following changes related to the movement from
// FHIR DSTU2 to FHIR R4:
//
// - MedicationOrder is replaced by MedicationRequest, and as a result, the reported type has changed from
//   "Order" to "Request"
// - MedicationOrder dateWritten is replaced by MedicationRequest authoredOn
// - MedicationRequest no longer supports the dateEnded property, so end dates will always be blank
//   for MedicationRequests
// - MedicationStatement no longer supports the wasNotTaken property
// - Observation adds an "instant" variant of the effective time
// - Observation's interpretation changed from single-value to multi-value, so the FHIR R4-based CQL only looks at the
//   first interpretation value
// - Observations now check for verificationStatus "corrected", in addition to "final" and "amended"
// - Condition no longer supports the abatementBoolean property
// - Condition's clinicalStatus was changed from a code to a CodeableConcept
// - Condition's dateRecorded (Date) is replaced by recordedDate (DateTime)
// - ActiveOrRecurring Conditions now check for clinicalStatus "recurrence" in addition to "active" and "relapse"
// - ProcedureRequest is replaced by ServiceRequest
// - ProcedureRequest's orderedOn is replaced by ServiceRequest's authoredOn
// - ReferralRequest is replaced by ServiceRequest
// - ProcedureRequest's dateSent is replaced by ServiceRequest's authoredOn
// - NonPharmacologicTreatmentServiceRequests now queries for active or completed ServiceRequests rather than
//   accepted, in-progress, or completed ProcedureRequests and accepted, active, or completed ReferralRequests
// - Procedure no longer supports the notDone property
// - ProcedurePerformance now excludes statuses: preparation, not-done, entered-in-error, and unknown
// - Due to changes in the CQL model representation of FHIR, choices are now accessed via CQL casts rather than
//   explicit properties
//
// ##Source guideline: [CDC Guideline for Opioid Prescribing for Chronic Pain](https://www.cdc.gov/drugoverdose/prescribing/guideline.html)

// Changes for version 1.0.1
// - Updated to FHIR 4.0.1
// - Minor changes in list usage (wasn't translating the union with the latest CQL translator)
// - Introduced ChronicPainConcepts terminology library to allow value sets to be redirected by versioning
//     NOTE: This isn't ideal, it's not really a version, but in the absence of some other mechanism
//     (like a concept mapping of value sets?) this is the best approach with existing machinery
//     To use the original chronic pain value sets, use version 1.0.0
//     To use the pain manager value sets, use version 2.0.0
library Factors_to_Consider_in_Managing_Chronic_Pain_FHIRv400 version '1.0.1'

// # Data model #

// The FHIR R4 model is used for testing purposes only.  It has not been piloted.
using FHIR version '4.0.1'

// # Referenced libraries #

// The CDS Connect Commons for FHIRv400 library provides functions representing commonly used CDS logic and patterns.
include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called C3F
// The FHIRHelpers library provides common functions for simplifying interaction w/ the FHIR R4 data model.
include FHIRHelpers version '4.0.1' called FHIRHelpers
// The ChronicPainConcepts library provides terminology concepts used to identify data elements throughout the artifact.
include ChronicPainConcepts version '2.0.0' called Cx

include MMECalculator version '3.0.0' called MMECalculator

// # Value sets and codes #

// ## Code Systems ##

codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMED-CT": 'http://snomed.info/sct'

// Several concepts needed by the Pain Management Summary CDS do not yet have standardized codes associated with them.
// The CDS logic authors have registered new Logical Object Identifier Names and Codes (LOINC) codes, but they are
// not yet available.  Once available, the CDS will be updated.  Until then, CDS implementors will need to map to
// local codes (signified by the LOCAL code system below) or replace them with their own codes.
codesystem "LOCAL": 'http://cds.ahrq.gov/cdsconnect/pms'

codesystem "Condition Category Codes": 'http://hl7.org/fhir/condition-category' // NOTE: This is the STU3 category, should really be the R4 category, but some systems still return this
//codesystem "Condition Category Codes": 'http://terminology.hl7.org/CodeSystem/condition-category'

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

code "Encounter Diagnosis code": 'encounter-diagnosis' from "Condition Category Codes" display 'Encounter Diagnosis'

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
  Coalesce({
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
  Coalesce(
    (c.onset as FHIR.dateTime).value,
    //Patient.birthDate + AgeToQuantity(c.onset),
    (c.onset as FHIR.Period)."start".value,
    //Patient.birthDate + QuantityToQuantity((c.onset as FHIR.Range)."low"),
    c.recordedDate.value
  )

// Returns a text representation of a Condition's abatement, whether represented as a dateTime, Period, Quantity (Age),
// Range (Age), string, or boolean.
// @param c - a FHIR Condition to get the text representation of the abatement from
// @returns {System.String} the text representation of the Condition's abatement
define function Abatement(c FHIR.Condition):
  Coalesce({
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
  Confirmed(ActiveOrRecurring([Condition: Cx."Conditions associated with chronic pain"]))

// Determines if the patient has any of the conditions associated with chronic pain
define HasConditionAssociatedWithChronicPain:
  exists(ConditionsAssociatedWithChronicPain)

// Determines if the patient has any record of opioid pain medications in the lookback period
//       - Medication Request within past 180 days (lookback can be made a parameter)
//       - Medication Statement by patient within past 180 days (lookback can be made a parameter)
define HasRecentOpioidPainMedication:
  exists(C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: Cx."Opioid Pain Medications"],
    InclusionMedicationsLookbackPeriod)
  ))
  or exists(C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: Cx."Opioid Pain Medications"],
    InclusionMedicationsLookbackPeriod)
  ))

// Determines if the patient has any record of adjuvant analgesic medications in the lookback period
//       - Medication Request within past 180 days (lookback can be made a parameter)
//       - Medication Statement by patient within past 180 days (lookback can be made a parameter)
define HasRecentAdjuvantAnalgesicMedication:
  exists(C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: Cx."Adjuvant Analgesic Medications"],
    InclusionMedicationsLookbackPeriod)
  ))
  or exists(C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: Cx."Adjuvant Analgesic Medications"],
    InclusionMedicationsLookbackPeriod)
  ))

// Determines if the patient meets the inclusion criteria for the CDS. Inclusion criteria is:
// - Age >=18 years
// - AND
//   - OR Conditions associated with chronic pain
//   - OR Opioid pain medication
//   - OR Adjuvant analgesic medication
define MeetsInclusionCriteria:
  Is18orOlder
  and (
    HasConditionAssociatedWithChronicPain
    or HasRecentOpioidPainMedication
    or HasRecentAdjuvantAnalgesicMedication
  )

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

define function UniqueConditionReports(reports List<Tuple{Name System.String, Status System.String, Onset System.Any, DateRecorded System.String, Date System.DateTime}>):
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
  Confirmed(ActiveOrRecurring([Condition: Cx."Major Depression"]))
  union Confirmed(ActiveOrRecurring([Condition: Cx."Depression Diagnosis ICD9"]))

define AnxietyConditions:
  Confirmed(ActiveOrRecurring([Condition: Cx."Anxiety"]))
  union Confirmed(ActiveOrRecurring([Condition: Cx."Anxiety Disorders ICD9"]))

define SubstanceUseDisorderConditions:
  Confirmed([Condition: Cx."Substance use disorder"])
  union Confirmed([Condition: Cx."Substance Abuse"])

define SuicideAttemptConditions:
  Confirmed([Condition: Cx."Suicide Attempt"])

define SleepDisorderedBreathingConditions:
  Confirmed(ActiveOrRecurring([Condition: Cx."Sleep-disordered breathing"]))

define RenalDysfunctionConditions:
  Confirmed(ActiveOrRecurring([Condition: Cx."Kidney Failure"]))

define HepaticDysfunctionConditions:
  Confirmed(ActiveOrRecurring([Condition: Cx."Chronic Liver Disease"]))
  union Confirmed(ActiveOrRecurring([Condition: Cx."Liver Disease"]))

define PregnancyConditions:
  Confirmed(C3F.ConditionLookBack(ActiveOrRecurring(
    [Condition: Cx."Pregnancy"])
      union [Condition: Cx."Pregnancy (New ICD10 codes published in 2018 or later)"],
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
      FHIRHelpers.ToConcept(R) in Cx."Major Depression"
      or FHIRHelpers.ToConcept(R) in Cx."Depression Diagnosis ICD9"
      or FHIRHelpers.ToConcept(R) in Cx."Anxiety"
      or FHIRHelpers.ToConcept(R) in Cx."Anxiety Disorders ICD9"
      or FHIRHelpers.ToConcept(R) in Cx."Substance use disorder"
      or FHIRHelpers.ToConcept(R) in Cx."Substance Abuse"
      or FHIRHelpers.ToConcept(R) in Cx."Suicide Attempt"
      or FHIRHelpers.ToConcept(R) in Cx."Sleep-disordered breathing"
      or FHIRHelpers.ToConcept(R) in Cx."Kidney Failure"
      or FHIRHelpers.ToConcept(R) in Cx."Chronic Liver Disease"
      or FHIRHelpers.ToConcept(R) in Cx."Liver Disease"
      // Pregnancy not considered in Encounter diagnoses because this is an unrestricted lookback.
  )

// NOTE: As a convention, if an expression's name starts with "Report", its purpose is to format data for the purpose
// of building the final summary object.

define function UniqueRiskFactorReports(reports List<Tuple{Name System.String, Status System.String, Onset System.Any, DateRecorded System.String, Abatement System.Any, Visit Tuple { Start System.String, End System.String }, Date System.DateTime}>):
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
    Visit:     null as Tuple { Start String, End String },
    Date: OnsetOrRecordedDate(C)
  }

define function GetEncounterDiagnosesRiskFactorsForOpioidRelatedHarms(enc Encounter):
  (enc.reasonCode) R
    where FHIRHelpers.ToConcept(R) in Cx."Major Depression"
      or FHIRHelpers.ToConcept(R) in Cx."Depression Diagnosis ICD9"
      or FHIRHelpers.ToConcept(R) in Cx."Anxiety"
      or FHIRHelpers.ToConcept(R) in Cx."Anxiety Disorders ICD9"
      or FHIRHelpers.ToConcept(R) in Cx."Substance use disorder"
      or FHIRHelpers.ToConcept(R) in Cx."Substance Abuse"
      or FHIRHelpers.ToConcept(R) in Cx."Suicide Attempt"
      or FHIRHelpers.ToConcept(R) in Cx."Sleep-disordered breathing"
      or FHIRHelpers.ToConcept(R) in Cx."Kidney Failure"
      or FHIRHelpers.ToConcept(R) in Cx."Chronic Liver Disease"
      or FHIRHelpers.ToConcept(R) in Cx."Liver Disease"
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

define OpioidMedicationRequests:
  C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: Cx."Opioid Pain Medications"],
    2 years
  ))

define OpioidMedicationStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: Cx."Opioid Pain Medications"],
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
    End:   null as String, // MedicationRequest end date not supported in R4,
    MME: MMEText(MMECalculator.TotalMME(List{O})),
    Sig: (singleton from (O.dosageInstruction)).text.value,
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
    Sig: (singleton from (S.dosage)).text.value,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportOpioidMedications:
  (ReportOpioidMedicationRequests
    union ReportOpioidMedicationStatements
    union ReportNaloxoneMedications) M
  sort by Start desc, End desc

// Non-opioid medication orders and statements with dates (lookback 2 years)

define NonOpioidMedicationRequests:
  C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: Cx."Non opioid pain medications"],
    2 years
  ))

define NonOpioidMedicationStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: Cx."Non opioid pain medications"],
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
    End:   null as String, // MedicationRequest end date not supported in R4,
    MME: 'N/A',
    Sig: (singleton from (O.dosageInstruction)).text.value,
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
    Sig: (singleton from (S.dosage)).text.value,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportNonOpioidMedications:
  (ReportNonOpioidMedicationRequests
    union ReportNonOpioidMedicationStatements
    union ReportBenzodiazepineMedications) M
  sort by Start desc, End desc

// Non-pharmacologic treatments, orders, and referrals with dates (lookback 2 years)

define NonPharmacologicTreatmentProcedures:
  C3F.ProcedurePerformance(C3F.ProcedureLookBack([Procedure: Cx."Non pharmacologic treatments for chronic pain"], 2 years))

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
    C3F.ServiceRequestLookBack([ServiceRequest: Cx."Non pharmacologic treatments for chronic pain"], 2 years)
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
    [MedicationRequest: Cx."Stool softeners and laxatives"],
    6 months
  ))

define StoolSoftenersAndLaxativesStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: Cx."Stool softeners and laxatives"],
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
  C3F.Verified(C3F.ObservationLookBack([Observation: Cx."Urine drug screen for pain management"], 1 year))

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
  C3F.ActiveCompletedOrStoppedMedicationRequest(C3F.MedicationRequestLookBack(
    [MedicationRequest: Cx."Benzodiazepine medications"],
    2 years
  ))

define BenzodiazepineMedicationStatements:
  (C3F.ActiveOrCompletedMedicationStatement(C3F.MedicationStatementLookBack(
    [MedicationStatement: Cx."Benzodiazepine medications"],
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
    End:   null as String, // MedicationRequest end date not supported in R4,
    MME: 'N/A',
    Sig: (singleton from (O.dosageInstruction)).text.value,
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
    Sig: (singleton from (S.dosage)).text.value,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportBenzodiazepineMedications:
  (ReportBenzodiazepineMedicationRequests union ReportBenzodiazepineMedicationStatements) M
  sort by Start desc, End desc

// Naloxone Medications (unrestricted lookback) - orders and statements with dates

define NaloxoneMedicationRequests:
  C3F.ActiveCompletedOrStoppedMedicationRequest([MedicationRequest: Cx."Naloxone medications"])

define NaloxoneMedicationStatements:
  (C3F.ActiveOrCompletedMedicationStatement([MedicationStatement: Cx."Naloxone medications"])) MS
    without [MedicationRequest] MR such that
      exists (MS.basedOn b where b.reference.endsWith('MedicationRequest/' + MR.id))

define ReportNaloxoneMedicationRequests:
  (NaloxoneMedicationRequests) O
  return {
    Type:  'Request',
    Name:  ConceptText(O.medication as FHIR.CodeableConcept),
    Start: DateTimeText(O.authoredOn),
    End:   null as String, // MedicationRequest end date not supported in R4,
    MME: MMEText(MMECalculator.TotalMME(List{O})),
    Sig: (singleton from (O.dosageInstruction)).text.value,
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
    Sig: (singleton from (S.dosage)).text.value,
    Status: S.status.value
  }
  sort by Start desc, End desc

define ReportNaloxoneMedications:
  (ReportNaloxoneMedicationRequests union ReportNaloxoneMedicationStatements) M
  sort by Start desc, End desc

// Risk screenings relevant to pain management - overall scores and dates (MOST RECENT w/ lookback 1 year)

define RiskScreeningsRelevantToPainManagement:
  C3F.Verified(C3F.ObservationLookBack(
    [Observation: Cx."Risk assessments relevant to pain management"]
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

define Summary: {
  Patient: {
    Name: Combine(Patient.name.given G return G.value, ' ') + ' ' + Combine(Patient.name.family F return F.value, ' '),
    Gender: Patient.gender.value,
    Age: AgeInYears(),
    MeetsInclusionCriteria: MeetsInclusionCriteria
  },
  PertinentMedicalHistory: {
    ConditionsAssociatedWithChronicPain: ReportConditionsAssociatedWithChronicPain,
    RiskFactorsForOpioidRelatedHarms: ReportRiskFactorsForOpioidRelatedHarms
  },
  PainAssessments: {
    NumericPainIntensityAssessments: ReportNumericPainIntensityAssessments,
    PainEnjoymentGeneralActivityAssessments: ReportPainEnjoymentGeneralActivityAssessments,
    STarTBackAssessments: ReportSTarTBackAssessments
  },
  HistoricalTreatments: {
    OpioidMedications: ReportOpioidMedications,
    NonOpioidMedications: ReportNonOpioidMedications,
    NonPharmacologicTreatments: ReportNonPharmacologicTreatments,
    StoolSoftenersAndLaxatives: ReportStoolSoftenersAndLaxatives
  },
  RiskConsiderations: {
    MostRecentMME: ReportMostRecentMME,
    UrineDrugScreens: ReportUrineDrugScreens,
    BenzodiazepineMedications: ReportBenzodiazepineMedications,
    NaloxoneMedications: ReportNaloxoneMedications,
    RiskScreeningsRelevantToPainManagement: ReportRiskScreeningsRelevantToPainManagement
  }
}
