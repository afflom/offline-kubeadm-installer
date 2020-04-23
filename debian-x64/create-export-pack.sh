#!/bin/bash

cd payload

# Get directory for easy reference
directory=$(pwd)
# I just like wget
yum install wget -y

# Create subdirectories
mkdir kubernetes-bundle
mkdir kubernetes-bundle/images
mkdir kubernetes-bundle/packages
mkdir kubernetes-bundle/templates

# Save image name, tag, and hash to file
docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | sed 's/\:<none>//g' > $directory/kubernetes-bundle/images/allinone.list

# Save images to tar
docker save $(docker images --format '{{.Repository}}:{{.Tag}}' | sed 's/\:<none>//g') -o $directory/kubernetes-bundle/images/allinone.tar

# Download kubernetes packages
wget -P $directory/kubernetes-bundle/packages/ https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/14bfe6e75a9efc8eca3f638eb22c7e2ce759c67f95b43b16fae4ebabde1549f3-cri-tools-1.13.0-0.x86_64.rpm
wget -P $directory/kubernetes-bundle/packages/ https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/515b36bce35de42218470b171ae2ba5cd82132e63d98c7bb87e4298d61fde1dc-kubeadm-1.18.2-0.x86_64.rpm
wget -P $directory/kubernetes-bundle/packages/ https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/29337f2b1dfd3e11eb9465dbf87b35a1cc48ff0a5e8f992c9f1da70f7641c6bf-kubectl-1.18.2-0.x86_64.rpm
wget -P $directory/kubernetes-bundle/packages/ https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/d9c0a14c480bd39ac0890746493f9a01325e9ef8fc6fc923520bfc7d0f11744e-kubelet-1.18.2-0.x86_64.rpm
wget -P $directory/kubernetes-bundle/packages/ https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/Packages/548a0dcd865c16a50980420ddfa5fbccb8b59621179798e6dc905c9bf8af3b34-kubernetes-cni-0.7.5-0.x86_64.rpm

# Download Docker
wget -P $directory/kubernetes-bundle/packages/ https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm
wget -P $directory/kubernetes-bundle/packages/ https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.09.9-3.el7.x86_64.rpm
wget -P $directory/kubernetes-bundle/packages/ https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-18.09.9-3.el7.x86_64.rpm


# Download weavenet config
wget -P $directory/kubernetes-bundle/templates/ https://cloud.weave.works/k8s/v1.16/net.yaml

tar cf ../payload.tar ./*
cd ..

if [ -e "payload.tar" ]; then
    gzip payload.tar

    if [ -e "payload.tar.gz" ]; then
        cat decompress payload.tar.gz > selfextract.bsx
    else
        echo "payload.tar.gz does not exist"
        exit 1
    fi
else
    echo "payload.tar does not exist"
    exit 1
fi

echo "selfextract.bsx created"
exit 0