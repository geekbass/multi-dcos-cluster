#!/bin/bash

# Set the number of clusters
number=$1

# Create a file called dcos-N.tf for every number 
for n in `seq 1 $number`; do
    sed 's/CLUSTER_NUMBER/'${n}'/g' dcos-cluster.tf.template > dcos-cluster-${n}.tf;
done 
