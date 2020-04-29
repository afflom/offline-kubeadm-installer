FROM centos:centos7.7.1908 AS build-stage

# Setup Directories and stage scripts
RUN mkdir -p /build/payload/{images,manifests,packages}
WORKDIR /build

# Copy in binary scripts
COPY installer payload/
COPY decompress .
COPY build .
COPY image.list .

# Setup Repos and prepare dependency downloads
COPY kubernetes.repo /etc/yum.repos.d/
RUN yum install -y epel-release yum-utils podman kubeadm
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Pull kubeadm + weave-net
RUN for c in $(cat image.list); do podman pull $c && \
      podman save $_ > payload/images/$(date +%s).tar && \
      echo $(podman images --format '{{.Repository}}:{{.Tag}} {{.ID}}' $c) >> payload/images/container.list; \
      done

# Pull yum packages
RUN yum install --downloadonly --downloaddir=payload/packages/ docker-ce containerd.io docker-cli kubeadm kubectl kubelet device-mapper-persistent-data lvm2

# Pull the weave-net manifest
RUN curl https://cloud.weave.works/k8s/v1.16/net.yaml -o payload/manifests/weave-net.yaml

# Build it
RUN bash build

FROM scratch AS export-stage
COPY --from=build-stage /build/selfextract.bsx /