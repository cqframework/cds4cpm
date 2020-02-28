library InitialQualifyingQueryR4 version '1.0'

using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0' called FHIRHelpers

codesystem "Common Languages": 'urn:ietf:bcp:47'

valueset "Fibromyalgia": 'todo'
valueset "Hip Osteoarthritis": 'todo'
valueset "Knee Osteoarthritis": 'todo'
valueset "Lower Back Pain": 'todo'
valueset "Office Visit": 'todo'

code "English Language": 'en' from "Common Languages"

context Patient

define "Timeframe":
  Interval["Lookback Date", Today()]

define "Lookback Date":
  @2019-01-01T00:00:00

define "Qualifying Query":
  AgeInYearsAt( start of "Timeframe" ) >= 18
    and "English Speaking Patient"
    and exists ( "Office Visits During Timeframe" )
    and (
      "Has Qualifying Fibromyalgia Diagnosis"
        or "Has Qualifying Hip Osteoarthritis Diagnosis"
        or "Has Qualifying Knee Osteoarthritis Diagnosis"
        or "Has Qualifying Lower Back Pain Diagnosis"
    )

define "English Speaking Patient":
  exists (
    Patient.communication Comm
      where exists (
        Comm.language.coding Language
          where FHIRHelpers.ToCode( Language ) ~ "English Language"
      )
  )

define "Fibromyalgia Diagnosis":
  [Condition: "Fibromyalgia"]

define "Has Qualifying Fibromyalgia Diagnosis":
  exists (
    "Outpatient Encounter Diagnosis During Timeframe"( "Fibromyalgia Diagnosis" )
  )
  or exists (
    "Active Problem During Timeframe"( "Fibromyalgia Diagnosis" )
  )

define "Hip Osteoarthritis Diagnosis":
  [Condition: "Hip Osteoarthritis"]

define "Has Qualifying Hip Osteoarthritis Diagnosis":
  exists (
    "Outpatient Encounter Diagnosis During Timeframe"( "Hip Osteoarthritis Diagnosis" )
  )
  or exists (
    "Active Problem During Timeframe"( "Hip Osteoarthritis Diagnosis" )
  )

define "Knee Osteoarthritis Diagnosis":
  [Condition: "Knee Osteoarthritis"]

define "Has Qualifying Knee Osteoarthritis Diagnosis":
  exists (
    "Outpatient Encounter Diagnosis During Timeframe"( "Knee Osteoarthritis Diagnosis" )
  )
  or exists (
    "Active Problem During Timeframe"( "Knee Osteoarthritis Diagnosis" )
  )

define "Lower Back Pain Diagnosis":
  [Condition: "Lower Back Pain"]

define "Has Qualifying Lower Back Pain Diagnosis":
  exists (
    "Outpatient Encounter Diagnosis During Timeframe"( "Lower Back Pain Diagnosis" )
  )
  or exists (
    "Active Problem During Timeframe"( "Lower Back Pain Diagnosis" )
  )

define "Office Visits During Timeframe":
  [Encounter: "Office Visit"] OfficeVisit
    where OfficeVisit.period during "Timeframe"

define function "Active Problem During Timeframe"(conditions List<Condition>):
  conditions Diagnosis
    where "Valid Clinical And Verification Status"( Diagnosis )
      and Diagnosis.onset during "Timeframe"

define function "Outpatient Encounter Diagnosis During Timeframe"(conditions List<Condition>):
  conditions Diagnosis
    with "Office Visits During Timeframe" OfficeVisit
      such that exists (
          OfficeVisit.diagnosis Diagnosis
            where Last( Split( Diagnosis.condition.reference, '/' ) ) ~ Diagnosis.id
        )

define function "Valid Clinical And Verification Status"(condition FHIR.Condition):
  exists (
    condition.clinicalStatus.coding ClinicalStatus
      where ClinicalStatus.code ~ 'active'
  ) and
  exists (
    condition.verificationStatus.coding VerificationStatus
      where VerificationStatus.code ~ 'confirmed'
  )
