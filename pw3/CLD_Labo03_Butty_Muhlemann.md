---
title: Cloud Computing - Lab 03
subject: 
author: Butty Vicky & Mühlemann Julien
group: L2GrT
date: 16.04.2024
---

<div style="page-break-after: always; break-after: page;"></div>


## TASK 1: ADD AUTO SCALING TO YOUR APPLICATION

> DELIVERABLE
>
> Document your observations of the Auto Scaling Group behavior.


After having terminated one instance we can see that the auto-scaler group re-create automatically another one
to keep the desired number up to date.

![image](capa_inst.png)




We have set everything up I.E. the cloudwatch alarm and the auto-scaler policies.
We have then simulated an load on the load-balancer endpoint with vegeta to visualize how the auto-scaler reacts:


The following command has been used to test the system:
```bash
$ echo "GET http://GrT-Muhlemann-LoadBalancer-1578369946.us-east-1.elb.amazonaws.com/wp-admin" | ./v attack -rate 5 -duration=60s | tee results.bin | ./v report

```

We can see after a certain time ~30" the auto-scaler has scaled out. We got a nice second instance in our infrastructure.

![image](2_inst.png)


Here are the results of the load test:

We have kicked off with a rate of 10 req/sec
we can see the system rects tremendously well to the attack
![image](r=10.png)


Another load test with a rate of 15 res/Sec. Here we begin to observe some errors I.E. success rate = ~90%


![image](r=25.png)


After a while as expected, we can see the auto-scaler scaling down.

![image](terminason.png)





