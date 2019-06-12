# These are windows environment variables to connect to vRA
# These are set via $env:TF_VAR_var_x = $env:<var_x>
# Or, a secret/gitignored tf_vars file - which might be more portable.
# So VRA_USER in the TF context is set via `$env:TF_VAR_VRA_USER = $env:VRA_USER
variable "VRA_USER" {}
variable "VRA_PASS" {}
variable "KT_USER" {}
variable "KT_PASS" {}

# This one took a minute to figure out.
# TF doesn't like interpolation-within-interpolation, 
# so you have to create intermediate variables.
# These are all built-in TF functions.
locals {
  username = "${element(split("@", "${var.VRA_USER}"), 0 )}"
  user_key_path = "${join("", list("${local.username}", ".pem"))}"
}

variable "chef_server_url" {
  description = "The Chef Server TF will use as its cookbook repository"
  default = "your-chef-server-including-organization-name"
}
variable "vra_tenant" {
  description = "The tenant name for vRa"
  default = "your-tenant-name"
}

variable "vra_url" {
  description = "The URL for our internal VMWare cloud"
  default = "your-cloud-address"
}

variable "server_count" {
  description = "How many machines do you want?"
  default = 1
}

# can also use catalog ID
variable "vra_cat_item_name" {
  description = "The catalog item name of the vRa item"
  default = "catalog-friendly-name"
}

variable "run_list" {
  description = "the run_list to apply to the node"
  default = ""
}
