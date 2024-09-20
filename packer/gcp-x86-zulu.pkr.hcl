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
  image_description       = replace("Gatling Enterprise Injector x86 OpenJDK ${var.java_version} (${var.build_id})", "+", "-")
  #image_family            = "classic-openjdk-${var.java_major}"
  #image_name              = "classic-openjdk-${var.java_major}-${var.build_id}"
  image_family            = "${var.image_family}"
  image_name              = "${var.image_name}"
  project_id              = "${var.project_id}"
  source_image_family     = "debian-12"
  ssh_username            = "${var.ssh_username}"
  zone                    = "${var.zone}"
  image_storage_locations = ["eu"]
}

build {
  sources = ["source.googlecompute.x86_64"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--become", "--extra-vars", "install_path=/opt", "--extra-vars", "java_major=${var.java_major}", "--extra-vars", "java_version=${var.java_version}", "--extra-vars", "java_vendor=${var.java_vendor}", "--extra-vars", "java_bundle_type=${var.java_bundle_type}"]
    playbook_file    = "ansible/probe.yml"
    user             = "${var.ssh_username}"
    use_proxy        = false
  }

}
