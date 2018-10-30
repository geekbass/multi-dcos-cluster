module "dcos-iam" {
  source       = "dcos-terraform/iam/aws"
  cluster_name = "${var.cluster_name}"
}
