# Offline Kubeadm Installation Builder

## Purpose

This creates a kubeadm 1.18 bundle that can be used to install kubeadm on an offline system.

## Prereqs

create-export-pack.sh must be run on a centos 7 machine that already has kubeadm installed and running.

The airgapped system must have all of the Centos Repos (inlcuding extras) enabled.


## Usage
From an internete connected kubeadm machine:
```
bash create-export-pack.sh
```

On the target system:

```
bash selfextract.bsx
```
