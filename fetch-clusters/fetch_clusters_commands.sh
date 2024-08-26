
#!/bin/bash

set -o nounset
set -o errexit
# set -o pipefail

# OCP parameters
export HUB_OCP_USERNAME=${HUB_OCP_USERNAME:-}
export HUB_OCP_PASSWORD=${HUB_OCP_PASSWORD:-}
export HUB_OCP_API_URL=${HUB_OCP_API_URL:-}

# Check if the OCP variables are provided
if [[ -z $HUB_OCP_USERNAME || -z $HUB_OCP_PASSWORD ||  -z $HUB_OCP_API_URL ]]; then
    echo "HUB credentials cannot be empty. The script will exit"
    exit 1
fi

# echo off
# set +x 
# Login to the Hub cluster
oc login --insecure-skip-tls-verify -u $HUB_OCP_USERNAME -p $HUB_OCP_PASSWORD $HUB_OCP_API_URL
# echo on
# set -x

# Run the script that gets the manmaged clusters created on the Hub
python3 generate_managedclusters_data.py

# Get the managed clusters info

# Cluster name
cat managedClusters.json |jq -r '.managedClusters[0].name' > /tmp/ci/managed.cluster.name
# cat /tmp/ci/managed.cluster.name

# Cluster base domain
cat managedClusters.json |jq -r '.managedClusters[0].base_domain' > /tmp/ci/managed.cluster.base.domain
# cat /tmp/ci/managed.cluster.base.domain

# Cluster API url
cat managedClusters.json |jq -r '.managedClusters[0].api_url' > /tmp/ci/managed.cluster.api.url
# cat /tmp/ci/managed.cluster.api.url

# Cluster username
cat managedClusters.json |jq -r '.managedClusters[0].username' > /tmp/ci/managed.cluster.username
# cat /tmp/ci/managed.cluster.username

# Cluster password
cat managedClusters.json |jq -r '.managedClusters[0].password' > /tmp/ci/managed.cluster.password
# cat /tmp/ci/managed.cluster.password
