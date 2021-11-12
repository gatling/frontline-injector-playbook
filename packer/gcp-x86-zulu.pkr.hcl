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

# -----------------------------------------------
# Data & Sources
# -----------------------------------------------

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "googlecompute" "x86_64" {
  image_description = "classic-openjdk-${var.java_major}"
  image_family      = "injector-${var.java_major}"
  image_name        = "classic-openjdk-${var.java_major}"
  #  image_name          = replace("Gatling Enterprise Injector x86_64 OpenJDK ${var.java_version} (${var.build_id})", "+", "-")
  project_id          = "${var.project_id}"
  source_image_family = "debian-10"
  ssh_username        = "${var.ssh_username}"
  zone                = "${var.zone}"
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

  post-processor "manifest" {
    output = "manifest.json"
  }
}
