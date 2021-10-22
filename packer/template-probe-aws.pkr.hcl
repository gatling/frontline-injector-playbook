data "amazon-ami" "arm64" {
  filters = {
    name                = "amzn2-ami-kernel-5.10-hvm-2.0.*-arm64-gp2"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = "${var.region}"
}


source "amazon-ebs" "arm64" {
  ami_description  = "OpenJDK ${var.java_major}"
  ami_groups       = ["all"]
  ami_name         = replace("FrontLine Probe AMI (Amazon Linux 2) arm64 w/ OpenJDK ${var.java_version}", "+", "-")
  ami_regions      = var.copy_regions
  force_deregister = true
  region           = "${var.region}"
  source_ami       = "${data.amazon-ami.arm64.id}"
  #  instance_type    = "c6g.large"
  spot_instance_types = ["c6g.large"]
  spot_price          = "auto"

  ssh_interface = "public_ip"
  ssh_username  = "ec2-user"

  tags = {
    JavaBundleType = "${var.java_bundle_type}"
    JavaVendor     = "${var.java_vendor}"
    JavaVersion    = "${var.java_version}"
    KernelVersion  = "${var.kernel_version}"
  }
}


data "amazon-ami" "x86_64" {
  filters = {
    name                = "${var.ami}"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  region      = "${var.region}"
}

source "amazon-ebs" "x86_64" {
  ami_description  = "OpenJDK ${var.java_major}"
  ami_groups       = ["all"]
  ami_name         = replace("FrontLine Probe AMI (Amazon Linux 2) x86_64 w/ OpenJDK ${var.java_version}", "+", "-")
  ami_regions      = var.copy_regions
  force_deregister = true
  region           = "${var.region}"
  source_ami       = "${data.amazon-ami.x86_64.id}"
  #  instance_type    = "t2.large"
  spot_instance_types = ["t2.large"]
  spot_price          = "auto"

  ssh_interface = "public_ip"
  ssh_username  = "ec2-user"

  tags = {
    JavaBundleType = "${var.java_bundle_type}"
    JavaVendor     = "${var.java_vendor}"
    JavaVersion    = "${var.java_version}"
    KernelVersion  = "${var.kernel_version}"
  }
}

build {
  sources = ["source.amazon-ebs.arm64", "source.amazon-ebs.x86_64"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--become", "--extra-vars", "install_path=/opt", "--extra-vars", "java_major=${var.java_major}", "--extra-vars", "java_version=${var.java_version}", "--extra-vars", "java_vendor=${var.java_vendor}", "--extra-vars", "java_bundle_type=${var.java_bundle_type}"]
    playbook_file    = "../probe.yml"
    user             = "ec2-user"
  }

}


variable "java_bundle_type" {
  type    = string
  default = "jre"
}

variable "kernel_version" {
  type = string
}

variable "region" {
  type = string
}

variable "copy_regions" {
  type = list(string)
}

variable "java_major" {
  type = string
}

variable "java_version" {
  type = string
}

variable "java_vendor" {
  type = string
}

variable "ami" {
  type = string
}

