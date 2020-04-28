# Pull the images
FROM centos:centos7.7.1908 AS pull-stage

# Setup Directories and stage scripts
RUN mkdir -p /build/payload/images
WORKDIR /build

# Setup Repos and prepare dependency downloads
RUN yum install -y skopeo

# Pull kubeadm + weave-net
RUN skopeo copy docker://k8s.gcr.io/coredns:1.6.7 docker-archive:payload/images/coredns.tar
RUN skopeo copy docker://k8s.gcr.io/kube-apiserver:v1.18.2 docker-archive:payload/images/kube-apiserver.tar
RUN skopeo copy docker://k8s.gcr.io/kube-controller-manager:v1.18.2 docker-archive:payload/images/controller-manager.tar
RUN skopeo copy docker://k8s.gcr.io/kube-scheduler:v1.18.2 docker-archive:payload/images/kube-scheduler.tar
RUN skopeo copy docker://k8s.gcr.io/kube-proxy:v1.18.2 docker-archive:payload/images/kube-proxy.tar
RUN skopeo copy docker://k8s.gcr.io/pause:3.2 docker-archive:payload/images/pause.tar
RUN skopeo copy docker://k8s.gcr.io/etcd:3.4.3-0 docker-archive:payload/images/etcd.tar
RUN skopeo copy docker://docker.io/weaveworks/weave-kube:2.6.2 docker-archive:payload/images/weave-kube.tar
RUN skopeo copy docker://docker.io/weaveworks/weave-npc:2.6.2 docker-archive:payload/images/weave-npc.tar


# Build the binary
FROM ubuntu:xenial AS build-stage
COPY --from=pull-stage /build/payload/images/* /build/payload/images/
RUN mkdir -p /build/payload/{images,manifests,packages}
WORKDIR /build

# Copy in binary scripts
COPY installer payload/
COPY decompress .
COPY build .

# Setup Repos and prepare dependency downloads
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update -y
# Pull yum packages
RUN apt-get install -y --download-only  docker-ce=5:19.03.8~3-0~ubuntu-$(lsb_release -cs) containerd.io=1.2.13-1 docker-ce-cli=5:19.03.8~3-0~ubuntu-$(lsb_release -cs) kubeadm kubectl kubelet
RUN cp /var/cache/apt/archives/*.deb /payload/packages/
# Pull the weave-net manifest
RUN curl https://cloud.weave.works/k8s/v1.16/net.yaml -o payload/manifests/weave-net.yaml

# Build it
RUN bash build


# Export the binary
FROM scratch AS export-stage
COPY --from=build-stage /build/selfextract.bsx /