# Pull the images
FROM centos:centos7.7.1908 AS pull-stage

# Setup Directories and stage scripts
RUN mkdir -p /build/payload/images
WORKDIR /build

# Setup Repos and prepare dependency downloads
COPY kubernetes.repo /etc/yum.repos.d/
RUN yum install -y podman kubeadm

RUN for c in $(kubeadm config images list); do podman pull $c && \
      podman save $_ > payload/images/$(date +%s).tar && \
      echo $(podman images --format '{{.Repository}}:{{.Tag}} {{.ID}}' $c) >> payload/images/container.list; \
      done


# Build the binary
FROM ubuntu:xenial AS build-stage
RUN mkdir -p /build/payload/images
RUN mkdir /build/payload/packages
RUN mkdir /build/payload/manifests
WORKDIR /build

# Copy in images
COPY --from=pull-stage /build/payload/images/* /build/payload/images/

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
RUN cp /var/cache/apt/archives/*.deb payload/packages/

# Pull the weave-net manifest
RUN curl https://cloud.weave.works/k8s/v1.16/net.yaml -o payload/manifests/weave-net.yaml

# Build it
RUN bash build


# Export the binary
FROM scratch AS export-stage
COPY --from=build-stage /build/selfextract.bsx /