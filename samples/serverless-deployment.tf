# Configure the MongoDB Atlas Provider
#
terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
 }

provider "mongodbatlas" {
# Calling the public and private API key variables
  public_key  = var.mongodb_atlas_api_pub_key_value
  private_key = var.mongodb_atlas_api_pri_key_value

  # *** Be sure to 
  # $ export MONGODB_ATLAS_ENABLE_BETA=true 
  # as per the docs to deploy serverless instance for now
  # https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/serverless_instance
}

#
# Create a Project
#
/*
resource "mongodbatlas_project" "my_project" {
  name   = "atlasProjectName"
  org_id = var.mongodb_atlas_org_id_value
}
*/


resource "mongodbatlas_serverless_instance" "my_serverless" {

  project_id  = var.mongodb_atlas_project_id_value
  name        = "aws-serverless"

  provider_settings_backing_provider_name = "AWS"
  provider_settings_provider_name         = "SERVERLESS"
  provider_settings_region_name           = "US_EAST_1"
}

#
# Create an IP Access list entry
#
# can also take a CIDR block or AWS Security Group -
# replace ip_address with either cidr_block = "CIDR_NOTATION"
# or aws_security_group = "SECURITY_GROUP_ID"
#
/*
resource "mongodbatlas_project_ip_access_list" "my_ipaddress" {
      project_id = var.mongodb_atlas_project_id_value
      ip_address = var.mongodb_atlas_accesslistip_value
      comment    = "My IP Address"
}
*/

# Use terraform output to display connection strings.
output "connection_strings" {
  value = mongodbatlas_serverless_instance.my_serverless.connection_strings_standard_srv
}

output "id" {
  value = mongodbatlas_serverless_instance.my_serverless.id
}

output "mongo_db_version" {
  value = mongodbatlas_serverless_instance.my_serverless.mongo_db_version
}
