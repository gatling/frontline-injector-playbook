variable "tag" {
  type = string
  default = "latest"
}

variable "java_major" { 
  type = string
  default = "17"
}  

variable "java_bundle_type" {
  type = string 
  default = "jdk"
}

variable "java_vendor" { 
  type = string
  default = "zulu"
}  

variable "java_version"{
  type = string 
  default = "17.0.1+12"
}


source "docker" "rockylinux" {
  commit = true
  image  = "rockylinux/rockylinux:latest"
}

build {
  sources = ["source.docker.rockylinux"]
    provisioner "shell" {
    script = "./scripts/install_python.sh"
  }
  provisioner "ansible-local" {
    playbook_file = "../ansible/probe-conatiner-poc.yml"
    playbook_dir = "../ansible"
    extra_arguments  = ["--become", "--extra-vars", "install_path=/opt", "--extra-vars", "java_major=${var.java_major}", "--extra-vars", "java_version=${var.java_version}", "--extra-vars", "java_vendor=${var.java_vendor}", "--extra-vars", "java_bundle_type=${var.java_bundle_type}"]
  }
#  post-processor "docker-tag" {
#    repository = "my-image"
#    tags        = [ var.tag ]
#  }

}
