# variables file

# Replace ORG_ID, PROJ_ID, PUBLIC_KEY and PRIVATE_KEY with your Atlas variables
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


variable "mongodb_atlas_org_id_value" {
    description = "Organization ID"
    default = "atlas_org_id"
}


# ====================================

# Replace USERNAME And PASSWORD with what you want for your database user
# https://docs.atlas.mongodb.com/tutorial/create-mongodb-user-for-cluster/
# Make sure to add the database user on Atlas to fill these in

variable "mongodb_atlas_database_username_value" {
    description = "Atlas Database Username"
    default = "atlas_db_user"
}

variable "mongodb_atlas_database_user_password" {
    description = "Atlas Database User Password"  
    default = "atlas_db_user_password"
}

# ====================================

# Replace IP_ADDRESS with the IP Address from where your application will connect
# https://docs.atlas.mongodb.com/security/add-ip-address-to-list/
# Make sure to add the IP address of the host where you're running this file from

variable "mongodb_atlas_accesslistip_value" {
  description = "IP Address where your application is hosted on"
  default = "application_ip_address"
}