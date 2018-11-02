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
  default     = ["0.0.0.0/0"]
}

variable "ssh_public_key_file" {
  description = ""
  default     = "~/.ssh/id_rsa.pub"
}

variable "bootstrap_instance_type" {
  description = ""
  default     = "t2.medium"
}

variable "num_masters" {
  description = ""
  default     = "1"
}

variable "master_instance_type" {
  description = ""
  default     = "m4.xlarge"
}

variable "num_private_agents" {
  description = ""
  default     = "1"
}

variable "private_agent_instance_type" {
  description = ""
  default     = "m4.xlarge"
}

variable "num_public_agents" {
  description = ""
  default     = "1"
}

variable "public_agent_instance_type" {
  description = ""
  default     = "t2.medium"
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
