#
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

#
# Create a Shared Tier Cluster
#
resource "mongodbatlas_cluster" "my_cluster" {
  project_id              = var.mongodb_atlas_project_id_value
  name                    = "aws-multi-region-deployment"

  # Provider Settings "block" for dedicated cluster tiers M10+.  Select either AWS, GCP or Azure
  provider_name = "AWS"


  # options: M2/M5 atlas regions per cloud provider
  # GCP - CENTRAL_US SOUTH_AMERICA_EAST_1 WESTERN_EUROPE EASTERN_ASIA_PACIFIC NORTHEASTERN_ASIA_PACIFIC ASIA_SOUTH_1
  # AZURE - US_EAST_2 US_WEST CANADA_CENTRAL EUROPE_NORTH
  # AWS - US_EAST_1 US_WEST_2 EU_WEST_1 EU_CENTRAL_1 AP_SOUTH_1 AP_SOUTHEAST_1 AP_SOUTHEAST_2

  # options for dedicated-tier: M10+, inclusive of cluster_type REPLICAST/SHARDED
  provider_instance_size_name = "M10"
  cluster_type = "REPLICASET"
  
  # multi-region specs
  replication_specs {
    num_shards = 1
    regions_config {
      region_name = "US_WEST_1"
      electable_nodes = 1
      priority = 7
      read_only_nodes = 0
    }
    regions_config {
      region_name = "US_WEST_2"
      electable_nodes = 1
      priority = 6
      read_only_nodes = 0
    }
    regions_config {
      region_name = "US_EAST_1"
      electable_nodes = 1
      priority = 5
      read_only_nodes = 0
    }
  }

  # If not set for dedicated, the default min. size will be selected
  # disk_size_gb = 10
  # Cloud Backup enabled for M10+
  cloud_backup = "true"
  
  # Will not change till new version of MongoDB but must be included
  mongo_db_major_version = "4.4"
  auto_scaling_disk_gb_enabled = "true" # for M10+ clusters
}

#
# Create an Atlas Admin Database User
#
/*
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
*/

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
  value = mongodbatlas_cluster.my_cluster.connection_strings.0.standard_srv
}
