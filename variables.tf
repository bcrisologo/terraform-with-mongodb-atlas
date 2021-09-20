# variables file

variable "mongodb_atlas_api_pub_key_value" {
    description = "Project/Programmatic API public key"
    default = "atlas_programmatic_api_public_key"
}

variable "mongodb_atlas_api_pri_key_value" {
    description = "Project/Programmatic API private key"
    default = "atlas_programmatic_api_private_key"
}

variable "mongodb_atlas_org_id_value" {
    description = "Organization ID"
    default = "atlas_org_id"
}

variable "project_id_value" {
    description = "Project ID"
    default = "atlas_project_id"
}