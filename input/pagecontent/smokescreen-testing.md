# Smokescreen Testing
Two pilot implementations have been completed, RTI, Chicago, and Vanderbilt (henceforth referred to as the RTI pilot), and the University of Florida (referred to as the UF pilot). Smoke screen testing for each of these was accomplished by creating test patients, with their FHIR resource bundles, based on the scenarios provided by the different organizations. The scenarios are outlined on the [Scenarios](scenarios.html) page. The bundles for the respective pilots were loaded into their FHIR servers and the PainManager application was run using those patients and comparing results with what was expected. An alternative testing mechanism was to run the 'Execute CQL' command from within [VSCode](https://code.visualstudio.com/download) that has the [CQL plugin](https://marketplace.visualstudio.com/items?itemName=cqframework.cql) installed, while editing the PainManagerAll.cql file from the [PainManager source code](https://github.com/cqframework/AHRQ-CDS-Connect-PAIN-MANAGEMENT-SUMMARY.git).



### RTI Pilot
The FHIR resource [bundles](https://github.com/cqframework/cds4cpm/tree/c2e970087bcf4eec95ba47850065dbcbf3059c81/input/bundles) were created for the scenarios for these patients:
  
    Mr. Delta
    Ms. Echo
    Ms. Bravo
    Mr. Ford
    Ms. Ellis
    Donnie Marks
These bundles contain MedicationRequest, Condition, Encounter, Patient, Observation and other FHIR resources to match the  scenarios for RTI. These bundles are loaded to the Sandbox [FHIR server](https://cloud.alphora.com/rti/r4/cqf-ruler/fhir) and accessed through the [Smartlauncher](https://cloud.alphora.com/rti/smart-launcher).   

### UF Pilot
The FHIR resource [bundles](https://github.com/cqframework/cds4cpm/tree/c2e970087bcf4eec95ba47850065dbcbf3059c81/input/bundles/UFLPatients) were created for the scenarios for these patients:

    Alpha Delta
    Sally Echo
    Tommy Jones
These bundles contain MedicationRequest, Condition, Encounter, Patient, Observation and other FHIR resources to match the  scenarios for UF. These bundles are loaded to the Sandbox [FHIR server](https://cloud.alphora.com/ufl/r4/cqf-ruler/fhir) and accessed through the [Smartlauncher](https://cloud.alphora.com/ufl/smart-launcher).


