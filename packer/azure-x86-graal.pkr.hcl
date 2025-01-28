# -----------------------------------------------
# Variables
# -----------------------------------------------
packer {
  required_plugins {
    azure = {
      version = ">= 2.1.7"
      source  = "github.com/hashicorp/azure"
    }
  }
}


variable "java_major" {
  type = string
}

variable "graalvm_version" {
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
  managed_image_name                = "gei-graalvm-openjdk-${var.java_major}-prod-${var.build_id}-img"

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
    image_name          = "gei-graalvm-openjdk-${var.java_major}-prod-vid"
    image_version       = "${var.image_version}"
    replication_regions = ["${var.location}"]
  }

}

build {
  sources = ["source.azure-arm.x86_64"]


  provisioner "shell" {
   environment_vars = [
    "GRAALVM_VERSION=${var.graalvm_version}",
    "JAVA_MAJOR=${var.java_major}",
  ]

    
    scripts= [
      "remote-script/02-debian-update-system.sh",
      "remote-script/03-debian-install-commons.sh",
      "remote-script/05-graalvm-setup-x86.sh",
      "remote-script/06-system.sh",
      "remote-script/07-debian-cleanup.sh"
      ]
  }

}


