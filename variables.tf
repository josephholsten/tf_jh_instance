# required
variable {
  role = {}
  chef_validation_key = {}
}

# Optional
variable "ssh_keys" {
  default = ""
}

variable "zone" {
  default = "josephholsten.com"
}

variable "environment" {
  description = "lifecycle environment, often useful as a key"
  default = "dev"
}

variable "chef_org" {
  description = "chef organization, often useful as a key"
  default = "josephholsten"
}

variable "chef_validation_client_name" {
  default = "josephholsten-validator"
}

variable "instance_count" {
  default = 1
}

variable "instance_flavor" {
  default = "512mb"
}

variable "dc_region" {
  description = "datacenter region, often useful as a key"
  default = "nyc3"
}
