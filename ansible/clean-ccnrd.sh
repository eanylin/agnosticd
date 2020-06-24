#!/bin/bash

OCP_USERNAME="opentlc-mgr"
WORKLOAD=ocp4-workload-ccnrd
USER_COUNT=5
PASSWORD=r3dh4t1!

for ns in `oc get ns | grep user[0-9]-istio-system | awk '{print $1}'`;
do
    oc delete -n $ns servicemeshcontrolplane.maistra.io/smcp 
    sleep 1m
done

oc delete validatingwebhookconfiguration/openshift-operators.servicemesh-resources.maistra.io
oc delete mutatingwebhoookconfigurations/openshift-operators.servicemesh-resources.maistra.io
oc delete -n openshift-operators daemonset/istio-node
oc delete clusterrole/istio-admin clusterrole/istio-cni clusterrolebinding/istio-cni
oc get crds -o name | grep '.*\.istio\.io' | xargs oc delete
oc get crds -o name | grep '.*\.maistra\.io' | xargs oc delete

oc delete knativeservings.operator.knative.dev knative-serving -n knative-serving
oc delete namespace knative-serving
oc delete knativeeventings.operator.knative.dev knative-eventing -n knative-eventing
oc delete namespace knative-eventing
oc get crd -oname | grep 'knative.dev' | xargs oc delete

oc get subscriptions -n openshift-operators -o name | xargs oc delete -n openshift-operators

oc get csv -n openshift-operators -o name | xargs oc delete -n openshift-operators

oc get crd -o name | grep tekton.dev | xargs oc delete

ansible-playbook -i localhost, -c local ./configs/ocp-workloads/ocp-workload.yml \
    -e "ansible_python_interpreter=`which python`" \
    -e"ACTION=remove" \
    -e"ocp_username=${OCP_USERNAME}" \
    -e"ocp_workload=${WORKLOAD}" \
    -e"silent=False" \
    -e"num_users=${USER_COUNT}" 

oc get projects -o name | grep user[0-9]  | xargs oc delete

