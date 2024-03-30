Refactor everything see screenshots attached



# TASK 1: CREATE A DATABASE USING THE RELATIONAL DATABASE SERVICE (RDS)
## credentials
```shell
master: neiluj
pwd: 536966a994e04ae3a56e1744bf36690d
endpoint RDS address: grt-muhlemann-wordpress-db.crsk2uw660uhus-east-1.rds.amazonaws.com
load balancer: GrT-Muhlemann-LoadBalancer-1001427955.us-east-1.elb.amazonaws.com
```

> DELIVERABLE 1: Copy the estimated monthly cost for the database and add it to your report.
```text
in the N. Virginia region a db.t3.micro instance costs $0.017 per hour. Storage type gp2 costs $0.115 per GB-month.

Cost for EC2 instance: 0.0116$ /heure
```

> Compare the costs of your RDS instance to a continuously running EC2 instance of the same instance type to see how much AWS charges for the extra functionality.

> In a two-tier architecture the web application and the database are kept separate and run on different hosts. Imagine that for the second tier instead of using RDS to store the data you would create a virtual machine in EC2 and install and run yourself a database on it. If you were the Head of IT of a medium-size business, how would you argue in favor of using a database as a service instead of running your own database on an EC2 instance? How would you argue against it?

> Copy the endpoint address of the database into the report.


> DELIVERABLE 2:
```bash
// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'rds_db_name' );

/** Database username */
define( 'DB_USER', 'neiluj' );

/** Database password */
define( 'DB_PASSWORD', '536966a994e04ae3a56e1744bf36690d' );

/** Database hostname */
define( 'DB_HOST', 'grt-muhlemann-wordpress-db.crsk2uw660uh.us-east-1.rds.amazonaws.com' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );
```



> DELIVERABLE 3:

![image](ami_params.png)



> DELIVERABLE 4:
```bash
nslookup GrT-Muhlemann-LoadBalancer-1578369946.us-east-1.elb.amazonaws.com
Server:  internetbox.home
Address:  192.168.1.1

Non-authoritative answer:
Name:    GrT-Muhlemann-LoadBalancer-1578369946.us-east-1.elb.amazonaws.com
Addresses:  34.194.59.123
          34.231.114.29





172.31.28.120 - - [21/Mar/2024:13:14:48 +0000] "GET / HTTP/1.1" 200 14905 "-" "ELB-HealthChecker/2.0"
172.31.28.120 - - [21/Mar/2024:13:14:58 +0000] "GET / HTTP/1.1" 200 14905 "-" "ELB-HealthChecker/2.0"
172.31.28.120 - - [21/Mar/2024:13:15:08 +0000] "GET / HTTP/1.1" 200 14905 "-" "ELB-HealthChecker/2.0"
```





creation d'une image
aws ec2 run-instances --image-id ami-0c7217cdde317cfec --count 1 --instance-type t2.micro --key-name GrX_Muhlemann --security-group-ids sg-09af380c34ef9eca1 --subnet-id subnet-0a2ab628966261f50

terminaison de l'image
aws ec2 run-instances --image-id ami-0c7217cdde317cfec --count 1 --instance-type t2.micro --key-name GrX_Muhlemann --security-group-ids sg-09af380c34ef9eca1 --subnet-id subnet-0a2ab628966261f50

lister les instances
aws ec2 describe-instances --filters "Name=tag:Name,Values=GrX_Muhlemann" --query "Reservations[].Instances[].InstanceId"




load balancer describe
 aws elbv2 describe-load-balancers | jq '.LoadBalancers[] | select(.LoadBalancerName | contains(\"GrT-Muhlemann-LoadBalancer\"))'

sortie:

{
  "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/93451ddd1c0fb442",
  "DNSName": "GrT-Muhlemann-LoadBalancer-1001427955.us-east-1.elb.amazonaws.com",
  "CanonicalHostedZoneId": "Z35SXDOTRQ7X7K",
  "CreatedTime": "2024-03-21T13:11:11.180000+00:00",
  "LoadBalancerName": "GrT-Muhlemann-LoadBalancer",
  "Scheme": "internet-facing",
  "VpcId": "vpc-049e2f8e56e0bafef",
  "State": {
    "Code": "active"
  },
  "Type": "application",
  "AvailabilityZones": [
    {
      "ZoneName": "us-east-1c",
      "SubnetId": "subnet-07f74df2f9ca79cef",
      "LoadBalancerAddresses": []
    },
    {
      "ZoneName": "us-east-1d",
      "SubnetId": "subnet-0a2ab628966261f50",
      "LoadBalancerAddresses": []
    }
  ],
  "SecurityGroups": [
    "sg-09af380c34ef9eca1"
  ],
  "IpAddressType": "ipv4"
}



aws elbv2 describe-listeners --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/93451ddd1c0fb442 | jq '.Listeners'

listeners



[
  {
    "ListenerArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:listener/app/GrT-Muhlemann-LoadBalancer/93451ddd1c0fb442/1a0555af7d2589cb",
    "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/93451ddd1c0fb442",
    "Port": 80,
    "Protocol": "HTTP",
    "DefaultActions": [
      {
        "Type": "forward",
        "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:targetgroup/GrT-Muhlemann-TargetGroup/70f34336204362ac",
        "ForwardConfig": {
          "TargetGroups": [
            {
              "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:targetgroup/GrT-Muhlemann-TargetGroup/70f34336204362ac",
              "Weight": 1
            }
          ],
          "TargetGroupStickinessConfig": {
            "Enabled": false
          }
        }
      }
    ]
  }
]





delete load balancer 


aws elbv2 delete-load-balancer --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/93451ddd1c0fb442



recreate load balancer 

aws elbv2 create-load-balancer --name GrT-Muhlemann-LoadBalancer --subnets subnet-07f74df2f9ca79cef subnet-0a2ab628966261f50 --security-groups sg-09af380c34ef9eca1 --scheme internet-facing --type application --ip-address-type ipv4


{
    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/ff2820a6c04138eb",
            "DNSName": "GrT-Muhlemann-LoadBalancer-1578369946.us-east-1.elb.amazonaws.com",
            "CanonicalHostedZoneId": "Z35SXDOTRQ7X7K",
            "CreatedTime": "2024-03-30T09:52:41.920000+00:00",
            "LoadBalancerName": "GrT-Muhlemann-LoadBalancer",
            "Scheme": "internet-facing",
            "VpcId": "vpc-049e2f8e56e0bafef",
            "State": {
                "Code": "provisioning"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "us-east-1c",
                    "SubnetId": "subnet-07f74df2f9ca79cef",
                    "LoadBalancerAddresses": []
                },
                {
                    "ZoneName": "us-east-1d",
                    "SubnetId": "subnet-0a2ab628966261f50",
                    "LoadBalancerAddresses": []
                }
            ],
            "SecurityGroups": [
                "sg-09af380c34ef9eca1"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}

Recreate listener

aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/ff2820a6c04138eb --protocol HTTP --port 80 --default-action Type=forward,TargetGroupArn=arn:aws:elasticloadba
lancing:us-east-1:851725581851:targetgroup/GrT-Muhlemann-TargetGroup/70f34336204362ac
{
    "Listeners": [
        {
            "ListenerArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:listener/app/GrT-Muhlemann-LoadBalancer/ff2820a6c04138eb/8cc8205128b7f28d",
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:loadbalancer/app/GrT-Muhlemann-LoadBalancer/ff2820a6c04138eb",
            "Port": 80,
            "Protocol": "HTTP",
            "DefaultActions": [
                {
                    "Type": "forward",
                    "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:targetgroup/GrT-Muhlemann-TargetGroup/70f34336204362ac",
                    "ForwardConfig": {
                        "TargetGroups": [
                            {
                                "TargetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:851725581851:targetgroup/GrT-Muhlemann-TargetGroup/70f34336204362ac",
                                "Weight": 1
                            }
                        ],
                        "TargetGroupStickinessConfig": {
                            "Enabled": false
                        }
                    }
                }
            ]
        }
    ]
}




echo "GET http://GrT-Muhlemann-LoadBalancer-1578369946.us-east-1.elb.amazonaws.com:80/wp-admin" | ./v attack -rate 5 -duration=60s | tee results.bin | ./v report

cat results.bin | ./v plot -title='Results of medium load' > results-plot.html







