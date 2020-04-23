# Offline Kubeadm Installation Builder

## Purpose

This creates a kubeadm/docker bundle that can be used to install kubeadm and docker (with dependencies) on an offline system.

## Releases

Releases track with their latest respective stable and compatable versions, but are published with each release of kubernetes.


## Usage
From an internet connected machine:
```
bash create-export-pack.sh
```

On the target system:

```
bash selfextract.bsx
```
