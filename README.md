# Multiple DC/OS Clusters using DC/OS Terraform
This project is written with the purpose of being able to spin up multiple DC/OS clusters using the DC/OS Terraform modules under the same VPC. 

Each Cluster will be maintained under its own `dcos-N.tf` file. You will use the script `build.sh` to generate these files. 

Each cluster that is provisioned will also create a .txt file that contains IP information about the cluster called `dcos-N.txt`. 

# Important Notes
- All of the clusters will be managed under the same current directory and managed under the same `terraform.tfstate file`. *DO NOT REMOVE OF LOSE THIS*

# Pre-reqs

# Usage
1) Pull down the repo

2) Auth to the AWS

3) Generate the dcos-#.tf files. Each one of these files is responsible for provisioning a cluster.

```
bash build.sh <Number of Clusters Needed>
```

Example for 10 clusters:
```
bash build.sh 10
```
4) Plan to ensure it looks good.

5) Apply the plan.
