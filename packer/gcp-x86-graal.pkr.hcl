# -----------------------------------------------
# Variables
# -----------------------------------------------



packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/googlecompute"
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

variable "kernel_version" {
  type    = string
  default = "kernel-5"
}

variable "build_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "project_id" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "google-user"
}

variable "image_family" {
  type = string
}

variable "image_name" {
  type = string
}

# -----------------------------------------------
# Data & Sources
# -----------------------------------------------

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "googlecompute" "x86_64" {
  image_description       = replace("Gatling Enterprise Injector x86 OpenJDK ${var.graalvm_version} (${var.build_id})", "+", "-")
  image_family            = "${var.image_family}"
  image_name              = "${var.image_name}"
  project_id              = "${var.project_id}"
  source_image_family     = "debian-12"
  ssh_username            = "${var.ssh_username}"
  zone                    = "${var.zone}"
  image_storage_locations = ["eu"]
}


# -----------------------------------------------
# Build
# -----------------------------------------------

build {
  sources = ["source.googlecompute.x86_64"]

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
      "remote-script/07-cleanup.sh"
      ]
  }
  
}
