#!/bin/bash

# move back to parent directory
cd ..

echo "Initialize Minikube"
#sudo service docker start
yes | docker system prune
minikube stop
minikube delete
#minikube start --driver=docker
minikube start

echo "Create docker image in minikube"
eval $(minikube docker-env)
docker build -t altais -f docker/Dockerfile .
minikube ssh "docker image ls"

echo "Create Namespace"
kubectl apply -f k8s/namespace.yml


echo "Create deployment"
kubectl apply -f k8s/deployment.yml


echo "Create service"
kubectl apply -f k8s/service.yml

echo "Enable ingress add-on"
minikube addons enable ingress


echo "Create ingress"
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
kubectl apply -f k8s/ingress.yml
minikube service list

echo "Running Test Cases"
service_url=$(minikube service --url ingress-nginx-controller -n ingress-nginx | head -n 1)
#wait for pods to come in ready state
sleep 30
kubectl get pods -n ns-altais

echo $service_url/sayhi
