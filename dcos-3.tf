##############################################
# Create The Infrastructure for DC/OS Cluster
##############################################

# Bootstrap
module "dcos-bootstrap-instance-3" {
  source = "dcos-terraform/bootstrap/aws"

  cluster_name = "${var.cluster_name}-3"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]
  aws_key_name           = "${var.cluster_name}-deployer-key"
}

# Master
module "dcos-master-instances-3" {
  source = "dcos-terraform/masters/aws"

  cluster_name = "${var.cluster_name}-3"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]
  aws_key_name           = "${var.cluster_name}-deployer-key"

  num_masters = "${var.num_masters}"
}

# Private Agent
module "dcos-privateagent-instances-3" {
  source = "dcos-terraform/private-agents/aws"

  cluster_name = "${var.cluster_name}-3"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]
  aws_key_name           = "${var.cluster_name}-deployer-key"

  num_private_agents = "${var.num_private_agents}"
}

# Public Agent
module "dcos-publicagent-instances-3" {
  source = "dcos-terraform/public-agents/aws"

  cluster_name = "${var.cluster_name}-3"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]

  aws_key_name = "${var.cluster_name}-deployer-key"

  num_public_agents = "${var.num_public_agents}"
}

# ELBs 
module "dcos-elb-3" {
  source = "dcos-terraform/elb-dcos/aws"

  cluster_name = "${var.cluster_name}-3"
  subnet_ids   = ["${module.dcos-vpc.subnet_ids}"]

  security_groups_masters          = ["${list(module.dcos-security-groups.admin,module.dcos-security-groups.internal)}"]
  security_groups_masters_internal = ["${list(module.dcos-security-groups.internal)}"]
  security_groups_public_agents    = ["${list(module.dcos-security-groups.admin,module.dcos-security-groups.internal)}"]
  master_instances                 = ["${module.dcos-master-instances-3.instances}"]
  public_agent_instances           = ["${module.dcos-publicagent-instances-3.instances}"]
}

##############################################
# Create the Execution for the DC/OS Cluster
##############################################
module "dcos-install-3" {
  source               = "dcos-terraform/dcos-install-remote-exec/null"
  bootstrap_ip         = "${module.dcos-bootstrap-instance-3.public_ip}"
  bootstrap_private_ip = "${module.dcos-bootstrap-instance-3.private_ip}"
  bootstrap_os_user    = "${module.dcos-bootstrap-instance-3.os_user}"

  master_ips         = ["${module.dcos-master-instances-3.public_ips}"]
  master_private_ips = ["${module.dcos-master-instances-3.private_ips}"]
  masters_os_user    = "${module.dcos-master-instances-3.os_user}"
  num_masters        = "${var.num_masters}"

  private_agent_ips      = ["${module.dcos-privateagent-instances-3.public_ips}"]
  private_agents_os_user = "${module.dcos-privateagent-instances-3.os_user}"
  num_private_agents     = "${var.num_private_agents}"

  public_agent_ips      = ["${module.dcos-publicagent-instances-3.public_ips}"]
  public_agents_os_user = "${module.dcos-publicagent-instances-3.os_user}"
  num_public_agents     = "${var.num_public_agents}"

  dcos_install_mode         = "${var.dcos_install_mode}"
  dcos_cluster_name         = "${var.cluster_name}-3"
  dcos_version              = "${var.dcos_version}"
  dcos_variant              = "${var.dcos_variant}"
  dcos_license_key_contents = "${file("./license.txt")}"
}

##############################################
# Create A local file with Public IPs 
##############################################

# Locals Vars
locals {
  bootstrap_ips-3      = "${join("\n", flatten(list(module.dcos-bootstrap-instance-3.public_ip)))}"
  masters_ips-3        = "${join("\n", flatten(list(module.dcos-master-instances-3.public_ips)))}"
  private_agents_ips-3 = "${join("\n", flatten(list(module.dcos-privateagent-instances-3.public_ips)))}"
  public_agents_ips-3  = "${join("\n", flatten(list(module.dcos-publicagent-instances-3.public_ips)))}"
  cluster_address-3    = "${module.dcos-elb-3.masters_internal_dns_name}"
  public-agent-lb-3    = "${module.dcos-elb-3.public_agents_dns_name}"
}

resource "local_file" "inventory-3" {
  filename = "./dcos-3.txt"

  content = <<EOF

[cluster]
${var.cluster_name}-3

[cluster-address]
${local.cluster_address-3}

User: bootstrapuser
Pass: deleteme

[bootstrap]
${local.bootstrap_ips-3}

[masters]
${local.masters_ips-3}

[private-agents]
${local.private_agents_ips-3}

[public-agents]
${local.public_agents_ips-3}

[public-agent-lb]
${local.public-agent-lb-3}

EOF
}
