#!/bin/bash

for ctx in dev prod; do
  kubectx $ctx
  
  kubectl create namespace devops-handson-ns
  kubectl create serviceaccount --namespace devops-handson-ns devops-handson-ksa
  
  gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${GOOGLE_CLOUD_PROJECT}.svc.id.goog[devops-handson-ns/devops-handson-ksa]" \
    devops-handson-gsa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
  
  kubectl annotate serviceaccount \
    --namespace devops-handson-ns \
    devops-handson-ksa \
    iam.gke.io/gcp-service-account=devops-handson-gsa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
done
