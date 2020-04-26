FROM centos:centos7.7.1908 AS build-stage

# Setup Directories and stage scripts
RUN mkdir -p /build/payload/{images,manifests,packages}
WORKDIR /build

# Copy in binary scripts
COPY installer payload/
COPY decompress .
COPY build .

# Setup Repos and prepare dependency downloads
COPY kubernetes.repo /etc/yum.repos.d/
RUN yum install -y epel-release yum-utils skopeo
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

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

# Pull yum packages
RUN yum install --downloadonly --downloaddir=payload/packages/ docker-ce containerd.io docker-cli kubeadm kubectl kubelet

# Pull the weave-net manifest
RUN curl https://cloud.weave.works/k8s/v1.16/net.yaml -o payload/manifests/weave-net.yaml

# Build it
RUN bash build

FROM centos:centos7.7.1908 AS export-stage
COPY --from=build-stage /build/selfextract.bsx /