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
  type = string
  default = "zulu"
}

variable "kernel_version" {
  type = string
  default = "kernel-5"
}

variable "ami" {
  type = string
  default = "amzn2-ami-kernel-5.10-hvm-2.0.*-arm64-gp2"
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
  ami_name         = replace("Gatling Enterprise Injector arm64 OpenJDK ${var.java_version} (${var.build_id})", "+", "-")
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
    Name         = replace("Gatling Enterprise Injector arm64 OpenJDK ${var.java_version} (${var.build_id})", "+", "-")
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

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--become", "--extra-vars", "install_path=/opt", "--extra-vars", "java_major=${var.java_major}", "--extra-vars", "java_version=${var.java_version}", "--extra-vars", "java_vendor=${var.java_vendor}", "--extra-vars", "java_bundle_type=${var.java_bundle_type}"]
    playbook_file    = "ansible/probe.yml"
    user             = "ec2-user"
    use_proxy        = false
  }
}
