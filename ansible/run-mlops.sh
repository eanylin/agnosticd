#!/bin/bash

OCP_USERNAME="admin"
WORKLOAD="ocp4-workload-mlops"
USER_COUNT=5

# a TARGET_HOST is specified in the command line, without using an inventory file
ansible-playbook -i localhost, -c local ./configs/ocp-workloads/ocp-workload.yml \
    -e "ansible_python_interpreter=`which python`" \
    -e"ACTION=create" \
    -e"ocp_username=${OCP_USERNAME}" \
    -e"ocp_workload=${WORKLOAD}" \
    -e"silent=False" \
    -e"user_count=${USER_COUNT}" 

