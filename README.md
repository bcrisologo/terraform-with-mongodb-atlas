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
  project_id              = mongodb_atlas_project_id
  name                    = "test-deployment"
```
