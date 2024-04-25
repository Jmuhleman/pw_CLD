---
title: Cloud Computing - Lab 04
subject: 
author: Butty Vicky & Mühlemann Julien
group: L2GrT
date: 18.04.2024
---

<div style="page-break-after: always; break-after: page;"></div>


## TASK 1: DEPLOYMENT OF A SIMPLE WEB APPLICATION

> DELIVERABLE
>
> Copy the Maven command to the report.

```bash
$ ./mvnw clean package --batch-mode -DskipTests -Dhttp.keepAlive=false -f=pom.xml --quiet
```



## TASK 2: ADD A CONTROLLER THAT WRITES TO THE DATASTORE



> DELIVERABLE
>
> Copy a screenshot of Datastore Studio with the written entity into the report.

![image](john_steinbeck.png)