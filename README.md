# Terraform Basics with MongoDB Atlas

## Introduction

This is a short guide on being able to deploy a MongoDB Atlas cluster using terraform. You would need to [Download](https://www.terraform.io/downloads.html) and [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) as a prerequisite.  You can then check out the official [MongoDB Atlas for Terraform Github Repo](https://github.com/mongodb/terraform-provider-mongodbatlas/issues).

You can also use the [Create an Atlas Cluster from a Template using Terraform for VSCode](https://docs.mongodb.com/mongodb-vscode/create-cluster-terraform/#create-an-service-cluster-from-a-template-using-terraform) as an alternative resource for deploying a shared-tier cluster on [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).

## Getting Started
You can create a folder where you'll place your terraform file(s).  In that directory, you can make a file called `main.tf`.  The content of the file will be broken down below.

### Setting up your variables

At this point, you should already have created a [Project on Atlas](https://docs.atlas.mongodb.com/tutorial/manage-projects/) in order to proceed.

For simply creating a cluster on a project, you would need to create a [Project API key](https://docs.atlas.mongodb.com/tutorial/configure-api-access/project/create-one-api-key/) and set it with the [Project Owner role](https://docs.atlas.mongodb.com/reference/user-roles/#mongodb-authrole-Project-Owner) on the provider section.
```terraform
provider "mongodbatlas" {
  public_key  = mongodb_atlas_api_pub_key
  private_key = mongodb_atlas_api_pri_key
}
```
### Resources for Cluster
To specify the cluster specifications, you can fill in the ```resource``` section broken down below.

You would need to obtain the [Project ID](https://docs.atlas.mongodb.com/reference/api/project-get-one/) and then provide the name of the cluster in the ```name``` section:
```terraform
resource "mongodbatlas_cluster" "my_cluster" {  
  project_id              = mongodb_atlas_project_id
  name                    = "test-deployment"
```

For shared-tier clusters such as **M2/M5**, set the ```provider_name``` as ```"TENANT"```, then set the ```backing_provider_name``` as any of the three cloud service provider options (AWS, GCP, AZURE).
```terraform
provider_name = "TENANT"
backing_provider_name = "AWS"
```

For **M10+** dedicated clusters, simply set ```provider_name``` with the Cloud Service Provider of choice (i.e. AWS, GCP, or Azure).
```terraform
provider_name = "AWS"
```

Select the region available for the ```provider_region_name``` variable.  For M2/M5, you have only a limited amount of selections as outlined in the comment section below.
```terraform
  # GCP - CENTRAL_US SOUTH_AMERICA_EAST_1 WESTERN_EUROPE EASTERN_ASIA_PACIFIC NORTHEASTERN_ASIA_PACIFIC ASIA_SOUTH_1
  # AZURE - US_EAST_2 US_WEST CANADA_CENTRAL EUROPE_NORTH
  # AWS - US_EAST_1 US_WEST_2 EU_WEST_1 EU_CENTRAL_1 AP_SOUTH_1 AP_SOUTHEAST_1 AP_SOUTHEAST_2
  provider_region_name = "US_EAST_1"
```

You can then select the [cluster tier](https://docs.atlas.mongodb.com/cluster-tier/) instance and the version of MongoDB available.  If you're selecting the M2/M5 shared-tier clusters, please note of the [limitations](https://docs.atlas.mongodb.com/reference/free-shared-limitations/#std-label-atlas-free-tier) when deploying such a cluster *(i.e. MongoDB version limitation, auto-scale unavailable, set disk storage)*.
```terraform
  provider_instance_size_name = "M2"
  mongo_db_major_version = "4.4"
```
For **M10+** dedicated clusters, you have more options available such as setting the cluster_type, default disk_size_gb, enable/disable cloud_backup, auto-scale disk size, etc.
```terraform
  cluster_type = "REPLICASET"
  cloud_backup = "TRUE"
  auto_scaling_disk_gb_enabled = "true"
```

### Output section
As a final entry, you can have terraform display the connection URI strings of the created cluster.
```terraform
output "connection_strings"
  value = mongodbatlas_cluster.my_cluster.connection_strings.0.standard_srv
```

## Running the main.tf file
On the folder where your ```main.tf``` file is located, you can then run the initialization command and install the appropriate providers
```
terraform init
```
where you would see the following output:
```
Initializing the backend...
 
Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "mongodbatlas" (terraform-providers/mongodbatlas) 0.5.1...
 
The following providers do not have any version constraints in configuration,
so the latest version was installed.
 
To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.
 
* provider.mongodbatlas: version = "~> 0.5"
 
Terraform has been successfully initialized!
```
Once done, you can then run the command below to see what the happens when the configuration file is applied
```
terraform plan
```
where you would see a similar output:
```
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
 
 
------------------------------------------------------------------------
 
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 
Terraform will perform the following actions:
 
  # mongodbatlas_cluster.my_cluster will be created
  + resource "mongodbatlas_cluster" "my_cluster" {
      + advanced_configuration       = (known after apply)
      + auto_scaling_disk_gb_enabled = false
      + backing_provider_name        = "AWS"
      + backup_enabled               = false
      + bi_connector                 = (known after apply)
      + cluster_id                   = (known after apply)
      + cluster_type                 = (known after apply)
      + connection_strings           = (known after apply)
      + disk_size_gb                 = 2
      + encryption_at_rest_provider  = (known after apply)
      + id                           = (known after apply)
      + mongo_db_major_version       = "4.2"
      + mongo_db_version             = (known after apply)
      + mongo_uri                    = (known after apply)
      + mongo_uri_updated            = (known after apply)
      + mongo_uri_with_options       = (known after apply)
      + name                         = "atlasClusterName"
      + num_shards                   = 1
      + paused                       = (known after apply)
      + pit_enabled                  = (known after apply)
      + project_id                   = (known after apply)
      + provider_backup_enabled      = false
      + provider_disk_iops           = (known after apply)
      + provider_disk_type_name      = (known after apply)
      + provider_encrypt_ebs_volume  = (known after apply)
      + provider_instance_size_name  = "M2"
      + provider_name                = "TENANT"
      + provider_region_name         = "providerRegionName"
      + provider_volume_type         = (known after apply)
      + replication_factor           = (known after apply)
      + snapshot_backup_policy       = (known after apply)
      + srv_address                  = (known after apply)
      + state_name                   = (known after apply)
 
      + labels {
          + key   = (known after apply)
          + value = (known after apply)
        }
 
      + replication_specs {
          + id         = (known after apply)
          + num_shards = (known after apply)
          + zone_name  = (known after apply)
 
          + regions_config {
              + analytics_nodes = (known after apply)
              + electable_nodes = (known after apply)
              + priority        = (known after apply)
              + read_only_nodes = (known after apply)
              + region_name     = (known after apply)
            }
        }
    }
 
  # mongodbatlas_database_user.my_user will be created
  + resource "mongodbatlas_database_user" "my_user" {
      + auth_database_name = "admin"
      + id                 = (known after apply)
      + password           = (sensitive value)
      + project_id         = (known after apply)
      + username           = "jww"
      + x509_type          = "NONE"
 
      + labels {
          + key   = (known after apply)
          + value = (known after apply)
        }
 
      + roles {
          + collection_name = (known after apply)
          + database_name   = "admin"
          + role_name       = "atlasAdmin"
        }
    }
 
  # mongodbatlas_project.my_project will be created
  + resource "mongodbatlas_project" "my_project" {
      + cluster_count = (known after apply)
      + created       = (known after apply)
      + id            = (known after apply)
      + name          = "atlasProjectName"
      + org_id        = "5d3716bfcf09a21576d7983e"
    }
 
  # mongodbatlas_project_ip_whitelist.my_ipaddress will be created
  + resource "mongodbatlas_project_ip_whitelist" "my_ipaddress" {
      + aws_security_group = (known after apply)
      + cidr_block         = (known after apply)
      + comment            = "My IP Address"
      + id                 = (known after apply)
      + ip_address         = "204.210.139.18"
      + project_id         = (known after apply)
    }
 
Plan: 4 to add, 0 to change, 0 to destroy.
 
------------------------------------------------------------------------
 
Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```
After reviewing the configuration to be applied, you can then create the Atlas cluster with the terraform configuration file with the command:
```
terraform apply
```
Type in ```yes``` when prompted.

## Deleting the Atlas Cluster via Terraform
To delete the Atlas cluster, simply navigate to where your ```main.tf``` file is located then simply run:
```
terraform destroy
```
Type in ```yes``` when prompted.
