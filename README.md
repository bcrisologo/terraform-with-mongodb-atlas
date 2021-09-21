# Terraform Basics with MongoDB Atlas

## Introduction

This is a short guide on being able to deploy a MongoDB Atlas cluster using terraform. You would need to [Download](https://www.terraform.io/downloads.html) and [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) as a prerequisite.  You can then check out the official [MongoDB Atlas for Terraform Github Repo](https://github.com/mongodb/terraform-provider-mongodbatlas) for additional information.

You can also use the [Create an Atlas Cluster from a Template using Terraform for VSCode](https://docs.mongodb.com/mongodb-vscode/create-cluster-terraform/#create-an-service-cluster-from-a-template-using-terraform) as an alternative resource for deploying a shared-tier cluster on [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).

This tutorial will include being able to deploy dedicated M10+ clusters.

## Getting Started
You can create a folder where you'll place your terraform files.  In that directory, you can make two files called `main.tf` and `variables.tf`.  The content of the files will be broken down below.

### Setting up your variables

At this point, you should already have created a [Project on Atlas](https://docs.atlas.mongodb.com/tutorial/manage-projects/) in order to proceed.

For simply creating a cluster on a project, you would need to create a [Project API key](https://docs.atlas.mongodb.com/tutorial/configure-api-access/project/create-one-api-key/) on the Atlas UI and set it with the [Project Owner role](https://docs.atlas.mongodb.com/reference/user-roles/#mongodb-authrole-Project-Owner) on the provider section.

On the `variables.tf` file, you would need to update the variables in the `default` fields with the appropriate Programmatic Public and Private API keys, as well as the [Project ID](https://docs.atlas.mongodb.com/reference/api/project-get-one/).  *(Note: For this tutorial, you may simply leave the other fields as is or comment them out)*
```terraform
variable "mongodb_atlas_api_pub_key_value" {
    description = "Project/Programmatic API public key"
    default = "atlas_programmatic_api_public_key"
}

variable "mongodb_atlas_api_pri_key_value" {
    description = "Project/Programmatic API private key"
    default = "atlas_programmatic_api_private_key"
}

variable "mongodb_atlas_project_id_value" {
    description = "Project ID"
    default = "atlas_project_id"
}
```


### Resources for Cluster
To specify the cluster specifications, you can fill in the `resource` section broken down below.

You would need to provide the name of the cluster in the `name` section:
```terraform
resource "mongodbatlas_cluster" "my_cluster" {  
  project_id              = var.mongodb_atlas_project_id_value
  name                    = "test-deployment"
```

For shared-tier clusters such as **M2/M5**, set the `provider_name` as `"TENANT"`, then set the `backing_provider_name` as any of the three cloud service provider options (AWS, GCP, AZURE).
```terraform
  provider_name = "TENANT"
  backing_provider_name = "AWS"
```

For **M10+** dedicated clusters, simply set `provider_name` with the Cloud Service Provider of choice (i.e. AWS, GCP, or Azure).
```terraform
  provider_name = "AWS"
```

Select the region available for the `provider_region_name` variable.  For M2/M5, you have only a limited amount of selections as outlined in the comment section below.  You can check the Atlas [available regions per cloud service provider](https://docs.atlas.mongodb.com/cloud-providers-regions/) for reference when deploying your shared or dedicated cluster.
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
For **M10+** dedicated clusters, you have more options available such as setting the cluster_type, default disk_size_gb, enable/disable cloud_backup, auto-scale disk size, etc.  You can uncomment these entries on the `main.tf` file when selecting M10+ clusters.
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
On the folder where your `main.tf` file is located, you can then run the initialization command and install the appropriate providers
```
terraform init
```

Once done, you can then run the command below to see what the happens when the configuration file is applied
```
terraform plan
```

After reviewing the configuration to be applied, you can then create the Atlas cluster with the terraform configuration file with the command:
```
terraform apply
```
Type in `yes` when prompted.

## Deleting the Atlas Cluster via Terraform
To delete the Atlas cluster, simply navigate to where your ```main.tf``` file is located then simply run:
```
terraform destroy
```
Type in `yes` when prompted.


## Additional Configurations (Optional)
The above configuration assumes that you already have the following created:
* [Atlas Project](https://docs.atlas.mongodb.com/tutorial/manage-projects/)
* [Programmatic API keys](https://docs.atlas.mongodb.com/tutorial/configure-api-access/project/create-one-api-key/)
* [IP Access List](https://docs.atlas.mongodb.com/security/ip-access-list/)

With the `main.tf` file attached, you also perform the following:

* [Create a Project](https://docs.atlas.mongodb.com/tutorial/manage-projects/#create-a-project)

In the `variables.tf` file, fill in the `default` section for the [Organization ID](https://docs.atlas.mongodb.com/reference/api/organizations/):
```terraform
variable "mongodb_atlas_org_id_value" {
    description = "Organization ID"
    default = "atlas_org_id"
}
```
In the `main.tf` file, uncomment and fill in the **Create a Project** section:
```terraform
#
# Create a Project
#
resource "mongodbatlas_project" "my_project" {
  name   = "atlasProjectName"
  org_id = var.mongodb_atlas_org_id_value
}
```

* [Create an Atlas Admin Database User](https://docs.atlas.mongodb.com/security-add-mongodb-users/)

In the `variables.tf` file, fill in the `default` section for the **Atlas Database Username** and **Atlas Database User Password**:
```terraform
variable "mongodb_atlas_database_username_value" {
    description = "Atlas Database Username"
    default = "atlas_db_user"
}

variable "mongodb_atlas_database_user_password" {
    description = "Atlas Database User Password"  
    default = "atlas_db_user_password"
}
```

In the ```main.tf``` file, uncomment and fill in the **Create an Atlas Admin Database User** section:
```terraform
#
# Create an Atlas Admin Database User
#
resource "mongodbatlas_database_user" "my_user" {
  username           = var.mongodb_atlas_database_username_value
  password           = var.mongodb_atlas_database_user_password
  project_id         = var.mongodb_atlas_project_id_value
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}
```

* [Add an IP Access list entry](https://docs.atlas.mongodb.com/security/ip-access-list/)

In the `variables.tf` file, fill in the `default` section for the **IP Address section**:
```terraform
variable "mongodb_atlas_accesslistip_value" {
  description = "IP Address where your application is hosted on"
  default = "application_ip_address"
}
```

In the ```main.tf``` file, uncomment and fill in the **Create an IP Access list entry** section:
```terraform
#
# Create an IP Accesslist
#
resource "mongodbatlas_project_ip_access_list" "my_ipaddress" {
      project_id = var.mongodb_atlas_project_id_value
      ip_address = var.mongodb_atlas_accesslistip_value
      comment    = "My IP Address"
}
```

* [Multi-region Setup](https://docs.atlas.mongodb.com/cluster-config/multi-cloud-distribution/)
Under the **samples** folder, there is a template for creating a multi-region AWS cluster.  Do note that the total number of nodes (excluding analytic nodes) should be odd as per MongoDB Atlas recommendation:

> The total number of electable nodes must be 3, 5, or 7 to ensure reliable elections

Further, each region `priority` should be numbered anywhere from 1 - 7 where no `region_config` should have the same `priority` level.  The higher the `priorty` level, the higher the chances of being elected as primary.
```terraform
  replication_specs {
    num_shards = 1
    regions_config {
      region_name = "region_1"
      electable_nodes = 1
      priority = 7
      read_only_nodes = 0
      analytics_nodes = 0
    }
    regions_config {
      region_name = "region_2"
      electable_nodes = 1
      priority = 6
      read_only_nodes = 0
      analytics_nodes = 0
    }
    regions_config {
      region_name = "region_3"
      electable_nodes = 1
      priority = 5
      read_only_nodes = 0
      analytics_nodes = 0
    }
  }
```

## Disclaimer
This is a quick tutorial for easily deploying a basic MongoDB Atlas cluster.  There are more options for configurations available that can be found on the [MongoDB Atlas with Terraform documentation](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs).
