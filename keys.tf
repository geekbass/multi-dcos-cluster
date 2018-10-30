# Create Key Pair for the Instances
locals {
  ssh_public_key_file = "${var.ssh_public_key_file == "" ? format("%s/main.tf", path.module) : var.ssh_public_key_file}"
  ssh_key_content     = "${file(local.ssh_public_key_file)}"
}

// create a ssh-key entry if ssh_public_key is set
resource "aws_key_pair" "deployer" {
  key_name   = "${var.cluster_name}-deployer-key"
  public_key = "${local.ssh_key_content}"
}
