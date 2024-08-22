#!/bin/bash

function get_hub_kubeconfig() {
    # Remember to login to the Hub before running these commands
    # oc extract secret/node-kubeconfigs -n openshift-kube-apiserver --confirm
    # cat lb-ext.kubeconfig > hub.kubeconfig
    ls $HOME/.kube
    cat $HOME/.kube/config > hub.kubeconfig
}

function get_managed_cluster_kubeconfig() {
    CLUSTER_NAME=$1
    # Get the managed cluster kubeconfig pod
    kubeconfig_pod_name=$(oc -n $CLUSTER_NAME get secrets | grep kubeconfig | awk '{print $1}')
    # Get the kubeconfig
    # oc get secret -n $CLUSTER_NAME $kubeconfig_pod_name -o jsonpath={.data.raw-kubeconfig} | base64 -d > managed.cluster.kuebconfig
    oc get secret -n $CLUSTER_NAME $kubeconfig_pod_name -o 'jsonpath={.data.kubeconfig}' | base64 -d > managed.cluster.kuebconfig
}

function get_managed_cluster_password() {
    CLUSTER_NAME=$1
    # Get the managed cluster password pod
    password_pod_name=$(oc -n $CLUSTER_NAME get secrets | grep password | awk '{print $1}')
    # Get the managed cluster password
    oc get secret -n $CLUSTER_NAME $password_pod_name -o jsonpath={.data.password} | base64 -d > managed.cluster.password
}

function get_managed_cluster_user() {
    CLUSTER_NAME=$1
    # Get the managed cluster password pod
    password_pod_name=$(oc -n $CLUSTER_NAME get secrets | grep password | awk '{print $1}')
    # Get the managed cluster username
    pwd=${password_pod_name//-password/} 
    user=${pwd//$CLUSTER_NAME-/}
    echo $user > managed.cluster.username
}
