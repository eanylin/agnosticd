#!/bin/bash

OCP_USERNAME="opentlc-mgr"
WORKLOAD="ocp4-workload-mlops" #ocp4-workload-ceph 
USER_COUNT=5
PASSWORD=r3dh4t1!
ACTION=create #create # create #remove

# This to reset password
ansible-playbook -i localhost, -c local ./configs/ocp-workloads/ocp-workload.yml \
    -e "ansible_python_interpreter=`which python`" \
    -e"ACTION=create" \
    -e"ocp_username=${OCP_USERNAME}" \
    -e"ocp_workload=roles_ocp_workloads/ocp4_workload_authentication" \
    -e"silent=False" \
    -e"ocp4_workload_authentication_remove_kubeadmin=False" \
    -e"ocp4_workload_authentication_htpasswd_user_count=${USER_COUNT}" \
    -e"ocp4_workload_authentication_admin_user=${OCP_USERNAME}" \
    -e"ocp4_workload_authentication_htpasswd_admin_password=${PASSWORD}" \
    -e"ocp4_workload_authentication_htpasswd_user_password=${PASSWORD}"

#TARGET_HOST is specified in the command line, without using an inventory file
ansible-playbook -i localhost, -c local ./configs/ocp-workloads/ocp-workload.yml \
    -e "ansible_python_interpreter=`which python`" \
    -e"ACTION=$ACTION" \
    -e"ocp_username=${OCP_USERNAME}" \
    -e"ocp_workload=${WORKLOAD}" \
    -e"silent=False" \
    -e"num_users=${USER_COUNT}" 