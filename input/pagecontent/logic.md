### Introduction

This page provides a summary of the logic used by the CDS4CPM PainManager application and 
details how the Clinical Quality Language (CQL) is processed and prepared for inclusion and usage in the applications.

#### PainManagerAll.cql

[PainManagerAll.cql](https://github.com/cqframework/AHRQ-CDS-Connect-PAIN-MANAGEMENT-SUMMARY/blob/master/src/cql/r4/PainManagerAll.cql) 
is the main CQL logic in the Pain Manager application. PainManagerAll uses the other CQL files to gather and process the necessary information to enable Pain Manager to display results for the patient, including answers to MyPAIN questions. 

#### Translating CQL to ELM for Use in Pain Manager
Pain Manager uses Expression Logical Model (ELM) files to process the resources retrieved from the FHIR server. The ELM files that do this already exist in the Pain Manager repository, but changes may be made and the ELM files regenerated. To prepare the CQL files for use in Pain Manager requires translating them into ELM. This is done using the [clinical_quality_language](https://github.com/cqframework/clinical_quality_language.git) cql-to-elm translator. 
Download and set up the translator by following the instructions in the repository. Once the clinical_quality_language has been set up, it can be utilized by calling the translator as follows:

```
cd /mnt/d/Projects/clinical_quality_language/Src/java
./cql-to-elm/build/install/cql-to-elm/bin/cql-to-elm --input /mnt/d/Projects/pain/src/cql/r4/PainManagerAll.cql -f JSON
```
This puts the ELM results (PainManagerAll.json) in the same directory as the CQL file. If a different location for the output is desired, just use the output option.
```
--output /mnt/d/file/location
```
There are other options available that can be discovered by reading the [OVERVIEW.MD file](
https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md).

