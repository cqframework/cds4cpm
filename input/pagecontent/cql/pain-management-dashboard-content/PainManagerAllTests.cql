library PainManagerAllTests

using FHIR version '4.0.1'

include PainManagerAll called PMA
include MMECalculator version '3.0.0' called MMECalculator

define Test1: PMA.Summary

//define ReportCurrentDoseAndRateQuantity:
//({
//        MMECalculator.MME(PMA.ActiveOpioidMedications)
//})
