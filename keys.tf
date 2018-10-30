# Create Key Pair for the Instances
resource "aws_key_pair" "deployer" {
  key_name   = "${var.cluster_name}-deployer-key"
  public_key = "${var.ssh_public_key_file}"
}
