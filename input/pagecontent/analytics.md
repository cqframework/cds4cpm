### Introduction

In order to measure the effectiveness and usage of the MyPAIN and PainManager Summary during the CDS4CPM pilot site implementation, an analytical component was added to each of the applications. Two complicating factors of adding this component were: a) some sites did not want to opt into data collection because of concerns about compromising protected health information (PHI), and b) adding this functionality while minimizing the impact to the development timeline. 

### PainManager Dashboard Built-in Analytics 

The basic PainManager Dashboard application contains some basic analytic capabilities.  If an endpoint and an x_api_key exist, which can be altered at the site level, PainManager sends to that endpoint a report including whether or not the patient met the CDS inclusion criteria, lists each section and subsection of the summary (along with the number of entries in each subsection), and provides an overall count of entries.  No specific patient information is collected.  
For this functionality to be implemented, an endpoint for RTI and/or an endpoint for each site would need to be set up as a server and to handle and process the incoming data for storage and retrieval.

### Google Analytics

An alternative to the built-in analytics is to use Google Analytics.  It also can be turned on or off at the site  level.  It can collect information including but not limited to the following:
* conversion rate - how many finished the questionnaire and/or submitted it
* unique visitors
* demographics - if it is desired to collect these without IP addresses or other PHI
* how often each section was selected (percentage)
* time on site (how  long to complete questionnaire)
* how many users clicked on links (i.e., the ACPA car with four flat tires video)
* site speed - loading and processing

Google offers a free account and an enterprise-level account.  The free account should be adequate to collect the information needed.  The free account also allows [custom metrics](https://support.google.com/analytics/answer/2709828?hl=en) to be defined and harvested to be displayed in the Google Analytics Dashboard.

Each site that will implement local analytics will need to acquire its own Google Analytics account and include the tracking code in the application's config.json file.  The presence of that code will determine collection of the  data.  Flags can also be set to determine which events and data will be collected. 

#### PHI Risks

The built-in PMD analytics do not collect individual patient identifiers.
Google Analytics will have IP-address anonymization always enabled to ensure confidentiality as described at [IP Anonymization](https://support.google.com/analytics/answer/2763052?hl=en).  

### Additional Questions

In a second layer of the application's evaluation, additional questions could be added to the questionnaire to get additional user input for the assessment.
	

### Recommendation

We recommend implementing Google Analytics for MyPAIN and PainManager.  It is well-established technology, and Google handles data collection, minimizing development time.  It provides a wide variety of analysis data options with separate pieces that can be turned on or off through configuration.  Google Analytics also has the advantage of not requiring a data storage repository with a retrieval system.     