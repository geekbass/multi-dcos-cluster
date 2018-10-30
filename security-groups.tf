# Creates the SG's for all the DC/OS Clusters
module "dcos-security-groups" {
  source       = "dcos-terraform/security-groups/aws"
  vpc_id       = "${module.dcos-vpc.vpc_id}"
  cluster_name = "${var.cluster_name}"
  subnet_range = "${var.subnet_range}"
  admin_ips    = "${var.admin_ips}"
}
