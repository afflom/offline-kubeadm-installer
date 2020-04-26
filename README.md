# Offline Kubeadm Installation

## Purpose

Offline installs of kubeadm are tedious. This installer aims to simplify the process in the absence of package managers and container registries.


## Method

This install pack can be used to create single node clusters or multi-node clusters in any configuration. The installation is considered minimal and only configures the installation target as required for a single node installation, as per [the official install guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm). 

This installer will install an the following components and their dependencies on the target system:

docker-ce  
containerd.io  
kubeadm  
kubectl  
kubelet  

**[Docker will be installed according to the official kubeadm documentation](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker)**

The installer will also load all of the required container images required to initialize a kubeadm cluster with the addition of the needed container images to install weave-net.

Additionally, the installer will output a weave-net manifest to the directory from where it was executed (```weave-net.yaml```). As a convenience, you can apply this manifest to your initialized cluster to quickly get a fully functional cluster.

## Releases

Releases track with their latest respective stable and compatable versions, but are published with each release of kubernetes. Check the release notes for the major component versions.


## Usage
1. Download the latest release and copy it to the target system
**As of now, you must disable SElinux to install/run kubeadm**
2. Disable SElinux
```
     setenforce 0
     sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```
3. Install the bundle
```
     chmod +x ./<bundle_name>.bsx
     sudo ./<bundle_name>.bsx
```

## Follow-on tasks
1. Refer to [The official kubeadm guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) for initializing the cluster.
2. After your cluster is initialized and if you choose to, install prepackaged CNI:
```
kubectl apply -f <working_dir>/weave-net.yaml
```
3. If you plan on a multi-manager configuration, you will need to open additional ports for etcd communication. Refer to the [official kubeadm documentation for port requirements](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#control-plane-node-s).

## todo
1. publish debian bundle
2. Add command line flags to customize install (configure different CRI or install components separately)
3. Automatically publish new installer when new new kubernetes version is released.