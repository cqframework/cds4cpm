### Introduction


### FHIR to CDSConnect mapping

#### PlanDefinition

|FHIR Element|CDS Connect Artifact Element|Notes|
---|---|---|
|id|meta.properties.node_id|Unique ID|
|version|version|Version of the artifact|
|name|N/A|Computer friendly name - no matching element|
|title|title|Human friendly name|
|type|artifact_type|Type of the artifact - fixed value: "Event-Condition-Action (ECA) rule"|
|status|status|Status of the artifact - draft or active or retired or unknown|
|experimental|experimental|Experimental flag indicating draft state|
|date|creation_date|Date the artifact was created - PlanDefinition.date represents the date the artifact was last updated, not created|
|publisher|creation_and_usage.publisher|Publisher of the artifact - should be name of org entity found on CDS Connect|
|description|description|Narrative description of the artifact - FHIR may be represented in markdown|
|purpose|purpose_and_usage.purpose|Purpose of the artifact - FHIR may be represented in markdown|
|usage|purpose_and_usage.usage|The clinical usage context in which the artifact is applicable or should be used|
|approvalDate|repository_information.approvalDate|The date the artifact was approved by the publisher|
|lastReviewDate|repository_information.last_review_date|The date the artifact was last reviewed|
|effectivePeriod|N/A|Period that the artifact is expected to be used - start: creation_date, end: repository_information.expiration_date|
|topic|supporting_evidence.references|Topics related to the content of the artifact|
|contributor|creation_and_usage.contributors|Content contributors|
|relatedArtifact|organization.related_artifacts|Artifacts related to the artifact|
|library|artifact_representation.logic_files|Logic used by the artifact - FHIR reference to list of strings|
|action|||
{: .list}
