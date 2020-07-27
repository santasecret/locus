#!/bin/sh


set -e

CERT_MANAGER_VERSION="0.14.0"

# Create a namespace for cert manager
if ! kubectl get ns | grep cert-manager &> /dev/null ; then
  echo "Creating 'cert-manager' namespace"
  kubectl create namespace cert-manager
else
  echo "Namespace 'cert-manager' already exists"
fi

# Install cert-managers CRDs:
echo "Applying cert-manager CRDs"
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/v${CERT_MANAGER_VERSION}/deploy/manifests/00-crds.yaml

# Install the cert manager helm chart
helm repo add jetstack https://charts.jetstack.io
helm repo update
if helm list -n cert-manager | grep cert-manager &> /dev/null; then
  echo "'cert-manager' helm chart is already installed, checking if the version is upto date"
  if [ ! $(helm list -n cert-manager | grep cert-manager | awk '{print $10}' | tr -d 'v') = ${CERT_MANAGER_VERSION} ]; then
    echo "'cert-manager' version upgrade required"
  else
    echo "'cert-manager' version upto date"
  fi
else
  echo "Installing 'cert-manager' helm chart"
  helm install cert-manager --namespace cert-manager --version v${CERT_MANAGER_VERSION} jetstack/cert-manager
fi

