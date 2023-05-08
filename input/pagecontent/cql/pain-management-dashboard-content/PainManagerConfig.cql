library PainManagerConfig version '0.1.0'

using FHIR version '4.0.1'

include CDS_Connect_Commons_for_FHIRv400 version '1.0.2' called C3F

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