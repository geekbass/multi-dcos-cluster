# Multiple DC/OS Clusters using DC/OS Terraform
*THIS IS NOT SUPPORTED AND IN EXTREME DEVELOPMENT PHASE*. 

This project is written with the purpose of being able to spin up multiple DC/OS clusters using the DC/OS Terraform modules under the same VPC. 

Each Cluster will be maintained under its own `dcos-cluster-N.tf` file. You will use the script `build.sh` to generate these files. This file is created from a "template" file `dcos-cluster.tf.template`. 

Each cluster that is provisioned will also create a .txt file that contains IP information about the cluster called `dcos-clusterinfo-N.txt`. 

# Important Notes
- All of the clusters will be managed under the same current directory and managed under the same `terraform.tfstate` file. *DO NOT REMOVE OR LOSE THIS.*


# Pre-reqs

# Usage
1) Pull down the repo

2) Auth to the AWS, export default region and add your ssh keys.

3) Modify the `admin_ips` in the `variables.tf` file to match your Public IPs from http://whatismyip.akamai.com/. [YO.UR.I.P/32]. This will be defaulted to 0.0.0.0/0 when we get the bug fixed. 

4) Generate the `dcos-cluster-#.tf` files. Each one of these files is responsible for provisioning a cluster.

```
bash build.sh <Number of Clusters Needed>
```

Example for 10 clusters:
```
bash build.sh 10
```

5) Initialize.
```
terraform init -upgrade=true
```

6) Plan to ensure it looks good.
```
terraform plan -out plan.out
```

7) Apply the plan.
```
terraform apply plan.out
```