#  Spin up a server(s) in vRA7 and run chef on it/them.
#  Variables are defined in variables.tf
#  Override them from the command line with `terraform plan/apply -var <var.iable>=<value>`
#  Or persist them using terraform.tfvars file
provider "vra7" {
  username = "${var.VRA_USER}"
  password = "${var.VRA_PASS}"
  tenant = "${var.vra_tenant}"
  host = "${var.vra_url}"
}

resource "vra7_deployment" "TF-Deploy" {
  count             = "${var.server_count}"
  description       = "Terraform Deploy ${count.index + 1}"
  catalog_item_name = "${var.vra_cat_item_name}"
  wait_timeout      = "2000"

  # lifecycle {
  #   create_before_destroy = true
  # }

  resource_configuration {
    vSphere_Machine_1.name = ""
    vSphere_Machine_1.description = "Terraform Machine ${count.index + 1}"
  }

  provisioner "chef" {
    # This is for TF to talk to the new node
    # assumes the node is Windows
    connection {
      host = "${self.resource_configuration.vSphere_Machine_1.name}"
      type = "winrm"
      user = "${var.KT_USER}"
      password = "${var.KT_PASS}"
      insecure = true
    }
  
    # This is for TF to talk to the chef_server
    server_url = "${var.chef_server_url}" 
    node_name  = "terraform-chef-test-${count.index + 1}"
    run_list   = [ "${var.run_list}" ]
    recreate_client = true
    environment = "_default"
    ssl_verify_mode = ":verify_none"
    version = "12"
    user_name  = "${local.username}"
    user_key   = "${file("${local.user_key_path}")}"
  }
}

# Outputs are printed at the end of the terraform run.
output "machine-names" {
  # note the splatting with the "*", that's how we access the list of machines
  value = ["${vra7_deployment.TF-Deploy.*.resource_configuration.vSphere_Machine_1.name}"]
}

output "run_list" {
  value = "${var.run_list}"
}