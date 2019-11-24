#!/bin/bash

if [[ $1 == "create" ]]
  then

    kubectl apply -f kube/

    aws appmesh create-mesh --mesh-name catdog-eks
    
    aws appmesh create-virtual-node --cli-input-json file://mesh/vn-frontend.json
    aws appmesh create-virtual-node --cli-input-json file://mesh/vn-cat.json
    aws appmesh create-virtual-node --cli-input-json file://mesh/vn-dog.json
    
    aws appmesh create-virtual-router --cli-input-json file://mesh/vr-frontend.json
    aws appmesh create-virtual-router --cli-input-json file://mesh/vr-backend.json
    
    aws appmesh create-virtual-service --cli-input-json file://mesh/vs-backend.json
    
    aws appmesh create-route --cli-input-json file://mesh/route-frontend.json
    aws appmesh create-route --cli-input-json file://mesh/route-backend.json

elif [[ $1 == "update" ]]
  then

    kubectl apply -f kube/

    aws appmesh update-virtual-node --cli-input-json file://mesh/vn-frontend.json
    aws appmesh update-virtual-node --cli-input-json file://mesh/vn-cat.json
    aws appmesh update-virtual-node --cli-input-json file://mesh/vn-dog.json
    aws appmesh update-virtual-service --cli-input-json file://mesh/vs-backend.json
    aws appmesh update-virtual-router --cli-input-json file://mesh/vr-frontend.json
    aws appmesh update-virtual-router --cli-input-json file://mesh/vr-backend.json
    aws appmesh update-route --cli-input-json file://mesh/route-frontend.json
    aws appmesh update-route --cli-input-json file://mesh/route-backend.json

elif [[ $1 == "delete" ]]
  then

    kubectl delete -f kube/

    aws appmesh delete-virtual-node --mesh-name catdog-eks --virtual-node-name catdog-frontend
    aws appmesh delete-virtual-node --mesh-name catdog-eks --virtual-node-name catdog-cat
    aws appmesh delete-virtual-node --mesh-name catdog-eks --virtual-node-name catdog-dog
    aws appmesh delete-virtual-service --mesh-name catdog-eks --virtual-service-name catdog-backend.default.svc.cluster.local
    aws appmesh delete-route --mesh-name catdog-eks --route-name catdog-frontend --virtual-router-name catdog-frontend
    aws appmesh delete-route --mesh-name catdog-eks --route-name catdog-backend --virtual-router-name catdog-backend
    aws appmesh delete-virtual-router --mesh-name catdog-eks --virtual-router-name catdog-frontend
    aws appmesh delete-virtual-router --mesh-name catdog-eks --virtual-router-name catdog-backend
    aws appmesh delete-mesh --mesh-name catdog-eks

elif [[ $1 == "update-routes" ]]
  then

    aws appmesh update-route --cli-input-json file://mesh/route-frontend.json
    aws appmesh update-route --cli-input-json file://mesh/route-backend.json

else
  echo "Give me an argument -- create, update, or delete"
fi