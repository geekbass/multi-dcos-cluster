# Create the VPC for the Clusters to use
data "aws_availability_zones" "available" {}
module "dcos-vpc" {
  source       = "dcos-terraform/vpc/aws"
  cluster_name = "${var.cluster_name}"
  subnet_range = "${var.subnet_range}"
  availability_zones  = "${data.aws_availability_zones.available.names}"
}
