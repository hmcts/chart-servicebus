.DEFAULT_GOAL := all
CHART := servicebus
RELEASE := chart-${CHART}-release
NAMESPACE := chart-tests
TEST := ${RELEASE}-test-service
ACR := hmctssandbox
AKS_RESOURCE_GROUP := cnp-aks-sandbox-rg
AKS_CLUSTER := cnp-aks-sandbox-cluster

setup:
	az configure --defaults acr=${ACR}
	az acr helm repo add
	az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER}

clean:
	-helm delete ${RELEASE} -n ${NAMESPACE}
	-kubectl delete pod ${TEST} -n ${NAMESPACE}

lint:
	helm lint ${CHART}

deploy:
	helm install ${RELEASE} ${CHART} --namespace ${NAMESPACE} -f ci-values.yaml --wait --timeout 60s

test:
	helm test ${RELEASE} -n ${NAMESPACE}

all: setup clean lint deploy test

.PHONY: setup clean lint deploy test all
