# K3s NFS and Nginx Practice

## Overview

This project demonstrates using NFS storage with K3s Kubernetes, deploying nginx pods using a PersistentVolumeClaim to mount shared storage.

## Setup

1. Setup NFS server on the K3s host (see `scripts/setup-nfs-server.sh`).
2. Update `nfs-pv.yaml` with your NFS server IP.
3. Deploy manifests:
   ```bash
   kubectl apply -f nfs-pv.yaml
   kubectl apply -f nfs-pvc.yaml
   kubectl apply -f nginx-config.yaml
   kubectl apply -f nginx-deployment.yaml
   kubectl apply -f nginx-service.yaml  # optional
