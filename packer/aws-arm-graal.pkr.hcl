# -----------------------------------------------
# Variables
# -----------------------------------------------

packer {
  required_plugins {
      amazon = {
        version = ">= 1.3.1"
        source = "github.com/hashicorp/amazon"
      }
  }
}

variable "java_major" {
  type = string
}

variable "java_version" {
  type = string
}

variable "java_bundle_type" {
  type    = string
  default = "jdk"
}

variable "java_vendor" {
  type = string
  default = "GraalVM"
}

variable "kernel_version" {
  type = string
  default = "kernel-6"
}

variable "ami" {
  type = string
  default = "al2023-ami-*-kernel-6.1-arm64"  
}

variable "region" {
  type = string
  default = "eu-west-3"	
}

variable "copy_regions" {
  type = list(string)
}

variable "aws_profile" {
  type = string
}

variable "build_id" {
  type = string
}

variable "ami_description" {
  type = string
}

# -----------------------------------------------
# Data & Sources
# -----------------------------------------------

data "amazon-ami" "arm64" {
  filters = {
    name                = "${var.ami}"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = "${var.region}"
}

source "amazon-ebs" "arm64" {
  ami_description  = "${var.ami_description}"
  ami_groups       = ["all"]
  ami_name         = replace("Gatling Enterprise Injector arm64 GraalVM ${var.java_version} (${var.build_id})", "+", "-")
  ami_regions      = var.copy_regions
  region           = "${var.region}"
  source_ami       = "${data.amazon-ami.arm64.id}"
  #instance_type    = "t2.large"
  spot_instance_types = ["c6g.large"]
  spot_price          = "auto"

  ssh_interface = "public_ip"
  ssh_username  = "ec2-user"

	profile = "${var.aws_profile}"

  tags = {
    Name         = replace("Gatling Enterprise Injector arm64 GraalVM ${var.java_version} (${var.build_id})", "+", "-")
    JavaBundleType = "${var.java_bundle_type}"
    JavaVendor     = "${var.java_vendor}"
    JavaVersion    = "${var.java_version}"
    KernelVersion  = "${var.kernel_version}"
  }
}

# -----------------------------------------------
# Build
# -----------------------------------------------

build {
  sources = ["source.amazon-ebs.arm64"]

  provisioner "shell" {
   environment_vars = [
    "JAVA_MAJOR=${var.java_major}",
  ]

    
    scripts= [
      "remote-script/01-wait-cloud-init-ends.sh",
      "remote-script/02-update-system.sh",
      "remote-script/03-install-commons.sh",
      "remote-script/04-disable-update.sh",
      "remote-script/06-graalvm-setup-arm64.sh",
      "remote-script/07-system.sh",
      "remote-script/08-cleanup.sh"
      ]
  }
  
}
