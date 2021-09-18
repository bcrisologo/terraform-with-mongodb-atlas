# Terraform with MongoDB Atlas

## Introduction

This is a short guide on being able to deploy a MongoDB Atlas cluster using terraform. You would need to [Download](https://www.terraform.io/downloads.html) and [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) as a prerequisite.

You can also use the [Create an Atlas Cluster from a Template using Terraform for VSCode](https://docs.mongodb.com/mongodb-vscode/create-cluster-terraform/#create-an-service-cluster-from-a-template-using-terraform) as an alternative resource for deploying a shared-tier cluster on [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).

## Getting Started
You can create a folder where you'll place your terraform file(s).  In that directory, you can make a file called `main.tf`.  The content of the file will be broken down below

### Setting up your variables

For simply creating a cluster on a project, you would just need to create a [Project API key](https://docs.atlas.mongodb.com/tutorial/configure-api-access/project/create-one-api-key/) and set it with the [Project Owner role](https://docs.atlas.mongodb.com/reference/user-roles/#mongodb-authrole-Project-Owner) on the provider section.

```terraform
provider "mongodbatlas" {
  public_key  = mongodb_atlas_api_pub_key
  private_key = mongodb_atlas_api_pri_key
}
```

To create the cluster you can fill in the ```resource``` section broken down below.

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
  # provider_region_name = "providerRegionName"
  provider_region_name = "US_EAST_1"
```

