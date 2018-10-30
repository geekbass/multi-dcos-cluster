##############################################
# Create The Infrastructure for DC/OS Cluster
##############################################

# Bootstrap
module "dcos-bootstrap-instance-1" {
  source = "dcos-terraform/bootstrap/aws"

  cluster_name = "${var.cluster_name}-1"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]
  aws_key_name           = "${var.cluster_name}-deployer-key"
}

# Master
module "dcos-master-instances-1" {
  source = "dcos-terraform/masters/aws"

  cluster_name = "${var.cluster_name}-1"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]
  aws_key_name           = "${var.cluster_name}-deployer-key"

  num_masters = "${var.num_masters}"
}

# Private Agent
module "dcos-privateagent-instances-1" {
  source = "dcos-terraform/private-agents/aws"

  cluster_name = "${var.cluster_name}-1"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]
  aws_key_name           = "${var.cluster_name}-deployer-key"

  num_private_agents = "${var.num_private_agents}"
}

# Public Agent
module "dcos-publicagent-instances-1" {
  source = "dcos-terraform/public-agents/aws"

  cluster_name = "${var.cluster_name}-1"

  aws_subnet_ids         = ["${module.dcos-vpc.subnet_ids}"]
  aws_security_group_ids = ["${list(module.dcos-security-groups.internal, module.dcos-security-groups.admin)}"]

  aws_key_name = "${var.cluster_name}-deployer-key"

  num_public_agents = "${var.num_public_agents}"
}

# ELBs 
module "dcos-elb-1" {
  source = "dcos-terraform/elb-dcos/aws"

  cluster_name = "${var.cluster_name}-1"
  subnet_ids   = ["${module.dcos-vpc.subnet_ids}"]

  security_groups_masters          = ["${list(module.dcos-security-groups.admin,module.dcos-security-groups.internal)}"]
  security_groups_masters_internal = ["${list(module.dcos-security-groups.internal)}"]
  security_groups_public_agents    = ["${list(module.dcos-security-groups.admin,module.dcos-security-groups.internal)}"]
  master_instances                 = ["${module.dcos-master-instances-1.instances}"]
  public_agent_instances           = ["${module.dcos-publicagent-instances-1.instances}"]
}

##############################################
# Create the Execution for the DC/OS Cluster
##############################################
module "dcos-install-1" {
  source               = "dcos-terraform/dcos-install-remote-exec/null"
  bootstrap_ip         = "${module.dcos-bootstrap-instance-1.public_ip}"
  bootstrap_private_ip = "${module.dcos-bootstrap-instance-1.private_ip}"
  bootstrap_os_user    = "${module.dcos-bootstrap-instance-1.os_user}"

  master_ips         = ["${module.dcos-master-instances-1.public_ips}"]
  master_private_ips = ["${module.dcos-master-instances-1.private_ips}"]
  masters_os_user    = "${module.dcos-master-instances-1.os_user}"
  num_masters        = "${var.num_masters}"

  private_agent_ips      = ["${module.dcos-privateagent-instances-1.public_ips}"]
  private_agents_os_user = "${module.dcos-privateagent-instances-1.os_user}"
  num_private_agents     = "${var.num_private_agents}"

  public_agent_ips      = ["${module.dcos-publicagent-instances-1.public_ips}"]
  public_agents_os_user = "${module.dcos-publicagent-instances-1.os_user}"
  num_public_agents     = "${var.num_public_agents}"

  dcos_install_mode              = "${var.dcos_install_mode}"
  dcos_cluster_name              = "${var.cluster_name}-1"
  dcos_version                   = "${var.dcos_version}"
  dcos_variant                   = "${var.dcos_variant}"
  dcos_license_key_contents      = "${file("./license.txt")}"
  dcos_master_discovery          = "static"
  dcos_exhibitor_storage_backend = "static"
  dcos_ip_detect_public_filename = "/genconf/ip-detect-public"

  dcos_ip_detect_public_contents = <<EOF
#!/bin/sh
set -o nounset -o errexit

curl -fsSL http://whatismyip.akamai.com/
EOF

  dcos_ip_detect_contents = <<EOF
#!/bin/sh
# Example ip-detect script using an external authority
# Uses the AWS Metadata Service to get the node's internal
# ipv4 address
curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
EOF

  dcos_fault_domain_detect_contents = <<EOF
#!/bin/sh
set -o nounset -o errexit

METADATA="$(curl http://169.254.169.254/latest/dynamic/instance-identity/document 2>/dev/null)"
REGION=$(echo $METADATA | grep -Po "\"region\"\s+:\s+\"(.*?)\"" | cut -f2 -d:)
ZONE=$(echo $METADATA | grep -Po "\"availabilityZone\"\s+:\s+\"(.*?)\"" | cut -f2 -d:)

echo "{\"fault_domain\":{\"region\":{\"name\": $REGION},\"zone\":{\"name\": $ZONE}}}"
EOF
}

##############################################
# Create A local file with Public IPs 
##############################################

# Locals Vars
locals {
  bootstrap_ips-1      = "${join("\n", flatten(list(module.dcos-bootstrap-instance-1.public_ip)))}"
  masters_ips-1        = "${join("\n", flatten(list(module.dcos-master-instances-1.public_ips)))}"
  private_agents_ips-1 = "${join("\n", flatten(list(module.dcos-privateagent-instances-1.public_ips)))}"
  public_agents_ips-1  = "${join("\n", flatten(list(module.dcos-publicagent-instances-1.public_ips)))}"
  cluster_address-1    = "${module.dcos-elb-1.masters_dns_name}"
  public-agent-lb-1    = "${module.dcos-elb-1.public_agents_dns_name}"
}

resource "local_file" "inventory-1" {
  filename = "./dcos-clusterinfo-1.txt"

  content = <<EOF

[cluster]
${var.cluster_name}-1

[cluster-address]
${local.cluster_address-1}

User: bootstrapuser
Pass: deleteme

[bootstrap]
${local.bootstrap_ips-1}

[masters]
${local.masters_ips-1}

[private-agents]
${local.private_agents_ips-1}

[public-agents]
${local.public_agents_ips-1}

[public-agent-lb]
${local.public-agent-lb-1}

EOF
}
