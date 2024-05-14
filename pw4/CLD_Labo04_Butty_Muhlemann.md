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



## TASK 3: 

> DELIVERABLE
>
> Copy a code listing of your app into the report.


We have tested out application. We can see the application is recording the value as given in url. More specifically the key has been recoded as given.
![image](given_key.png)

In case of missing key, we can see that the app is generating automatically an ID for us.
![image](auto_gen_key.png)

And in case of missing _kind field the error is turning up.
![image](kind_missing.png)


Here is the code of the app:
```java

package com.example.appengine.springboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.cloud.datastore.Datastore;
import com.google.cloud.datastore.DatastoreOptions;
import com.google.cloud.datastore.Entity;
import com.google.cloud.datastore.Key;
import com.google.cloud.datastore.KeyFactory;

import java.util.Map;

@SpringBootApplication
@RestController
public class DemoApplication {

    private final Datastore datastore = DatastoreOptions.getDefaultInstance().getService();


    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/")
    public String hello() {
        return "Hello, world!";
    }


    @GetMapping("/dswritesimple")
    public String writeEntityToDatastoreSimple(@RequestParam Map<String, String> queryParameters) {
        StringBuilder message = new StringBuilder();

        KeyFactory keyFactory = datastore.newKeyFactory().setKind("book");
        Key key = datastore.allocateId(keyFactory.newKey());
        Entity entity = Entity.newBuilder(key)
                .set("title", "The grapes of wrath")
                .set("author", "John Steinbeck")
                .build();
        message.append("Writing entity to Datastore\n");
        datastore.put(entity);
        Entity retrievedEntity = datastore.get(key);
        message.append("Entity retrieved from Datastore: "
                + retrievedEntity.getString("title")
                + " " + retrievedEntity.getString("author")
                + "\n");
        return message.toString();
    }

    @GetMapping("/dswrite")
    public String WriteEntryToDataStore(@RequestParam Map<String, String> queryParameters) {
        if (!queryParameters.containsKey("_kind")) {
            return "Error: The '_kind' field is required.";
        }

        String kind = queryParameters.get("_kind");
        KeyFactory keyFactory = datastore.newKeyFactory().setKind(kind);

        Key key;
        if (queryParameters.containsKey("_key")) {
            key = keyFactory.newKey(queryParameters.get("_key"));
        } else {
            key = datastore.allocateId(keyFactory.newKey());
        }

        Entity.Builder entityBuilder = Entity.newBuilder(key);

        for (Map.Entry<String, String> entry : queryParameters.entrySet()) {
            String fieldName = entry.getKey();
            if (!fieldName.startsWith("_")) { // Exclude special fields like _kind, _key
                entityBuilder.set(fieldName, entry.getValue());
            }
        }

        Entity entity = entityBuilder.build();
        datastore.put(entity);

        return "Entity written with kind '" + kind + "' and key '" + key.getName() + "'.";
    }


}

```


## TASK 4: TEST THE PERFORMANCE OF DATASTORE WRITES

> Deliverables:

>1. For each performance test include a graph of the load testing tool and copy three screenshots of the >App Engine instances view (graph of requests by type, graph of number of instances, graph of latency) >into the report.


* At 14:10 We launch a first burst of requests on the simple controller(hello world). duration=50'' rate=70

* Then at 14:20 we kicked off our second test on the second controller interacting with the datastore duration=50'' and rate=70.

**Number of instances**

We notice an increase of the number of active instances at 14:10 for the first attack on the simple controller.

We observe the number of instances increasing at 14:25 at the start of our second test.
![images](assets/instances.png)

**Latency of requests**

We don't see any significant latency worsening for the simple controller at 14:10

We can see at 14:25 the time to respond increase dramatically. Probably because of the controller that needs to write data into the datastore.
![images](assets/latency.png)

**Requests by type**

We can observe that even though we performed the same duration and same frequency of requests I.E. 50'' and 70 r/sec, the app can handle more requests on the first burst (peak at 14:12).

When the app needs to write data into the datastore it needs significantly more time to do so. Therefore we peaked at 50 req/sec for the second test.
![images](assets/requests_type.png)

**Plot of the load with the hello world controller**

Here we probably experience the 'cold start'. Since we had 0 instances active (see first plot at 14:10), Google had to instantiate some machines to execute our requests. Therefore we observe that descending slope form 0 to 5 seconds.

![image](assets/hello_w.png)

**Plot of the load with the dswrite controller**

Here we observe probably once more the cold start from 0 to 5. Conversely we notice that ou app needs significantly more time to handle the load. It needs to interact with the datastore every time.
![image](assets/dswrite.png)



>2. What average response times do you observe in the test tool for each controller?


We can see we got an average response time of 424 ms for the simple controller. Whereas we get 8 seconds for the dswrite controller.
![image](assets/vegets_stats.png)



>3. Compare the response times shown by the test tool and the App Engine console. Explain the difference.

We got 20s for the second burst with the dswrite controller.
And 20.46 seconds for the test tools for 95% of the requests.

The network latency may impair the results between both performance analysis tools. Vegeta is measuring the response time from the clients perspective. That includes network latency from local network. Whereas Google metrics may measure the latency closer to the server PaaS.



>4. How much resources have you used running these tests? From the Quota Details view of the console >determine the non-zero resource quotas (Daily quota different from 0%). Explain each with a sentence. >To get a sense of everything that is measured click on Show resources not in use.





>5. Let’s suppose you become suspicious that the algorithm for the automatic scaling of instances is not >working correctly. Imagine a way in which the algorithm could be broken. Which measures shown in the >console would you use to detect this failure?

The measures we could use to suspect a failure in the algorithm could be :

TODO Reformat that stuff


Instance Group Metrics: Navigate to the "Instance Groups" section in the Google Cloud Console and monitor metrics such as CPU utilization, memory usage, and request count for your instance group. Spikes or drops in these metrics can indicate potential issues with scaling.

Autoscaler Logs: Check the logs related to autoscaling events in the Logging section of the console. Look for any errors or warnings indicating failed scaling actions, delays, or unexpected behavior.

Autoscaler Policy: Review the autoscaling policy configured for your instance group. Ensure that the scaling triggers, such as CPU utilization or HTTP load balancing utilization, are set appropriately. You can adjust these triggers based on your application's requirements and traffic patterns.

Resource Utilization: Monitor overall resource utilization across your project, including CPU, memory, and network usage. Anomalies in resource utilization may indicate scaling issues or inefficiencies.

Stackdriver Monitoring: Utilize Stackdriver Monitoring to create custom dashboards and charts for tracking relevant metrics, such as instance count, CPU utilization, and request latency. Set up alerting policies to notify you of abnormal behavior or threshold breaches.

Cost Analysis: Analyze the cost breakdown for your project to identify any unexpected increases in costs associated with instances or other resources. Over-provisioning or inefficient scaling can lead to higher-than-expected costs.

Health Checks: Ensure that health checks are configured correctly for your instance group. Monitor the health status of individual instances and check for any instances that are failing health checks, which may impact scaling decisions.



