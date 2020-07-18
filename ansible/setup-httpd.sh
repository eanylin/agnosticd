#!/bin/bash

cat << EOF | oc create -f -

{
  "kind": "PersistentVolumeClaim",
  "apiVersion": "v1",
  "metadata": {
    "name": "httpd",
    "namespace": "labs-infra"
  },
  "spec": {
    "accessModes": [
      "ReadWriteMany"
    ],
    "resources": {
      "requests": {
        "storage": "1Gi"
      }
    },
    "storageClassName": "ocs-storagecluster-cephfs",
    "volumeMode": "Filesystem"
  }
}
EOF

oc new-app httpd:2.4 --name=httpd-app  -n labs-infra
oc expose svc/httpd-app -n labs-infra
oc set volume  dc/httpd-app --add -m /var/www/html -t pvc --claim-name httpd --claim-mode ReadWriteMany -n labs-infra
hostname=`oc get routes httpd-app -o jsonpath="{.spec.host}" -n labs-infra`
oc set env dc/guides-m1 WORKSHOPS_URLS=http://$hostname/_ocp-ai-ml-workshop.yml CONTENT_URL_PREFIX=http://$hostname -n labs-infra
