#!/bin/bash

set -e

echo "[INFO] Deploying K3s NFS + nginx setup..."

# Optional: validate that the NFS server IP is set in the PV file
if grep -q "<NFS_SERVER_IP>" ../nfs-pv.yaml; then
    echo "[ERROR] Please replace <NFS_SERVER_IP> in nfs-pv.yaml with your actual server IP."
    exit 1
fi

echo "[STEP 1] Applying PersistentVolume..."
kubectl apply -f ../nfs-pv.yaml

echo "[STEP 2] Applying PersistentVolumeClaim..."
kubectl apply -f ../nfs-pvc.yaml

echo "[STEP 3] Applying nginx ConfigMap..."
kubectl apply -f ../nginx-config.yaml

echo "[STEP 4] Applying nginx Deployment..."
kubectl apply -f ../nginx-deployment.yaml

if [ -f ../nginx-service.yaml ]; then
    echo "[STEP 5] Applying optional nginx Service (NodePort)..."
    kubectl apply -f ../nginx-service.yaml
else
    echo "[INFO] Skipping optional NodePort service (nginx-service.yaml not found)"
fi

echo "[DONE] All resources have been deployed."

echo
echo "[NEXT] Run this to check pod IPs:"
echo "  kubectl get pods -l app=nginx -o wide"
echo
echo "[OR] Test with:"
echo "  kubectl exec -it <pod-name> -- curl http://localhost:1234"
