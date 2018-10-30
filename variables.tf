# Variables ALL REQUIRED
variable "cluster_name" {
  description = ""
  default     = "dcos-train"
}

variable "subnet_range" {
  description = ""
  default     = "172.12.0.0/16"
}

variable "admin_ips" {
  description = ""
  default     = ["PUBLIC_IP_HERE"]
}

variable "ssh_public_key_file" {
  description = ""
  default     = "~/.ssh/id_rsa.pub"
}

variable "num_masters" {
  description = ""
  default     = "1"
}

variable "num_private_agents" {
  description = ""
  default     = "1"
}

variable "num_public_agents" {
  description = ""
  default     = "1"
}

variable "dcos_install_mode" {
  description = ""
  default     = "install"
}

variable "dcos_version" {
  description = ""
  default     = "1.12.0"
}

variable "dcos_variant" {
  description = ""
  default     = "ee"
}
