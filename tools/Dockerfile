# This stage is responsible for downloading all the binaries which make up
# our toolset. We'll later copy the tools to a separate stage designed for running.
FROM debian:bookworm-slim@sha256:df52e55e3361a81ac1bead266f3373ee55d29aa50cf0975d440c2be3483d8ed3 AS installer

# renovate: datasource=github-releases depName=kubernetes/kubernetes
ARG KUBECTL_VERSION=v1.33.1
# renovate: datasource=github-releases depName=siderolabs/talos
ARG TALOSCTL_VERSION=v1.10.2
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.47.1
# renovate: datasource=github-releases depName=getsops/sops
ARG SOPS_VERSION=v3.10.2
# renovate: datasource=github-releases depName=fluxcd/flux2
ARG FLUX_VERSION=2.6.4
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=v3.19.0

# Install curl and CA certificates, so we can access GitHub over HTTPS.
RUN apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && apt-get clean

# Create a /tools directory so we can copy all of them over wholesale.
RUN mkdir -p /tools
WORKDIR /tools

RUN curl -L -o kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod u+x kubectl

RUN curl -L -o talosctl https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-amd64 \
    && chmod u+x talosctl

RUN curl -L -o yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    && chmod u+x yq

RUN curl -L -o sops https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 \
    && chmod u+x sops

RUN curl -L -o flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz \
    && tar -xf flux.tar.gz \
    && rm flux.tar.gz \
    && chmod u+x flux

RUN curl -L -o helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xf helm.tar.gz \
    && rm helm.tar.gz \
    && mv linux-amd64/helm helm \
    && chmod u+x helm

# ===========================================================================
# Stage which contains only the tools required, set up to run as the default
# non-root linux user, so that mounting our working directory into it won't
# cause all kinds of ownership issues.
FROM debian:bookworm-slim@sha256:df52e55e3361a81ac1bead266f3373ee55d29aa50cf0975d440c2be3483d8ed3 AS workspace
ENV EDITOR=vim

# Install vim for editing
RUN apt-get update \
    && apt-get -y install --no-install-recommends $EDITOR \
    && apt-get clean

# Create group and user.
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} user
RUN useradd -m -s /bin/bash -u ${UID} -g ${GID} user

# We'll mount the kronform repository in /data
RUN mkdir /data && chown user:user /data
RUN mkdir -p /home/user/.config/helm && chown 1000:1000 /home/user/.config/helm
WORKDIR /data

# Copy all the tools from our installer stage.
COPY --chown=user:user --from=installer /tools/* /usr/local/bin/

# Copy in our entrypoint which is used for setting up the environment.
COPY --chown=user:user --chmod=0700 entrypoint.sh /usr/bin/local/entrypoint

USER ${UID}
ENTRYPOINT ["/usr/bin/local/entrypoint"]
