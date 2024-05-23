---
title: Cloud Computing - Lab 06
subject: INFRASTRUCTURE-AS-CODE AND CONFIGURATION MANAGEMENT - TERRAFORM, ANSIBLE AND GITLAB
author: Butty Vicky & Mühlemann Julien
group: L2GrT
date: 23.05.2024
---

<div style="page-break-after: always; break-after: page;"></div>


## TASK 2: CREATE A CLOUD INFRASTRUCTURE ON GOOGLE COMPUTE ENGINE WITH TERRAFORM

> What files were created in the terraform directory? Make sure to look also at hidden files and directories (ls -a). What are they used for?




```bash
$ terraform apply -input=false .terraform/plan.cache
google_compute_instance.default: Creating...
google_compute_instance.default: Still creating... [10s elapsed]
google_compute_instance.default: Creation complete after 15s [id=projects/boxwood-spot-424211-j6/zones/europe-west6-a/instances/labcld]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

gce_instance_ip = "34.65.74.220"
```



> Deliverables:

> Explain the usage of each provided file and its contents by directly adding comments in the file as needed (we must ensure that you understood what you have done). In the file variables.tf fill the missing documentation parts and link to the online documentation. Copy the modified files to the report.

TODO

> Explain what the files created by Terraform are used for.
* terraform/plugin/ folder containing information about the providers and the version used.

* .terraform.lock.hcl a dependency lock file used to make sure the same provider versions are used each time the config is applied. This aid in maintaining consistent and reproductible deployments.

* .Identifier files used to uniquely identify the provider plugins. Each plugin will have a unique checksum to ensure integrity and authenticity of the plugin.

* terraform.tfstate keeps track of the current configuration

> Where is the Terraform state saved? Imagine you are working in a team and the other team members want to use Terraform, too, to manage the cloud infrastructure. Do you see any problems with this? Explain.

Normally Terraform saves the state file in the terraform.tfstate file in the local directory.

The challenge if used TF in a team is if multiple members run TF commands at the same time if can lead to inconsistencies in the state file. Each member shall ensure they work on the latest version before running any commands.
Moreover the state file can store potentially sensitive information e.g. IP addresses, ID, etc...


> What happens if you reapply the configuration (1) without changing main.tf (2) with a change in main.tf? Do you see any changes in Terraform’s output? Why? Can you think of exemples where Terraform needs to delete parts of the infrastructure to be able to reconfigure it?

If we do not make any changes in main.tf and re-apply the config TF will check if it sees any changes between the desired state and the current state. In case of no changes nothing will be performed.

no changes:
```bash
$ terraform apply -input=false .terraform/plan.cache

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

gce_instance_ip = "34.65.74.220"
```

There are scenarios where TF needs to destroy part of the configuration to update the desired state. For instance if we ask a new kind of resource e.g. to run on a t2.micro instead of t2.small TF will need to recreate the instance.

> Explain what you would need to do to manage multiple instances.

> Take a screenshot of the Google Cloud Console showing your Google Compute instance and put it in the report.