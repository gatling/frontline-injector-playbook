# -----------------------------------------------
# Variables
# -----------------------------------------------

variable "java_major" {
  type = string
}

variable "java_version" {
  type = string
}

variable "java_bundle_type" {
  type    = string
  default = "jre"
}

variable "java_vendor" {
  type    = string
  default = "zulu"
}

variable "build_id" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "azure-user"
}

variable "image_version" {
  type = string
}

source "azure-arm" "x86_64" {

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  managed_image_resource_group_name = "gei-prod-westeurope-rg"
  managed_image_name                = "gei-classic-openjdk-${var.java_major}-prod-${var.build_id}-img"

  ssh_username = "${var.ssh_username}"
  location     = "${var.location}"

  os_type         = "Linux"
  image_publisher = "Debian"
  image_offer     = "debian-12"
  image_sku       = "12"
  vm_size         = "STANDARD_F4S_V2"

  shared_image_gallery_destination {
    subscription        = "${var.subscription_id}"
    resource_group      = "gei-prod-westeurope-rg"
    gallery_name        = "gei_prod_acg"
    image_name          = "gei-classic-openjdk-${var.java_major}-prod-vid"
    image_version       = "${var.image_version}"
    replication_regions = ["${var.location}"]
  }

}

build {
  sources = ["source.azure-arm.x86_64"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments = ["--become",
      "--extra-vars", "install_path=/opt",
      "--extra-vars", "java_major=${var.java_major}",
      "--extra-vars", "java_version=${var.java_version}",
      "--extra-vars", "java_vendor=${var.java_vendor}",
      "--extra-vars", "java_bundle_type=${var.java_bundle_type}"]
    playbook_file = "ansible/probe.yml"
    user          = "${var.ssh_username}"
    use_proxy     = false
  }

  provisioner "shell" {
    inline = ["sudo find /var/log -type f -exec rm -f {} \\;", "sudo find /tmp -exec rm -f \\;", "sudo rm -rf /root/.ansible"]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}
