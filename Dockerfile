ARG KUBECTL_VERSION="v1.27.4"
ARG TALOSCTL_VERSION="v1.4.7"
ARG YQ_VERSION="v4.35.1"
ARG SOPS_VERSION="v3.7.3"

FROM debian:bookworm-slim AS installer
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && apt-get clean

RUN mkdir -p /tools
WORKDIR /tools
RUN curl -L -o kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN curl -L -o talosctl https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-amd64
RUN curl -L -o yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64
RUN curl -L -o sops https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64
