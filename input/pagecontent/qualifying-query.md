### Introduction

The initial qualifying query defines a set of patients who qualify for chronic pain management with the following 
**diagnoses/problems** during a specified **time frame**:

- Fibromyalgia
- Hip osteoarthritis
- Knee osteoarthritis
- Lower back pain

### Functional Description

The **timeframe** is specified as an interval from January 1 of the prior year to the current day.

The patient must be 18 years or older at the beginning of the **time frame**.

The patient must be English speaking.

The patient must have an **Office Visit** during the **time frame**.

The patient must have an active **Problem** in the problem list **OR** a visit **Diagnosis** during the **time frame**.

### Functional Diagram

<div style="height: 600px;">
  ![](img/iqq-diagram.png "Initial Qualifying Query Functional Diagram")
</div>

### CQL Logic

<div>
{% highlight sql %}{% include_relative cql/initial-qualifying-query-stu3.cql %}{% endhighlight %}
</div>