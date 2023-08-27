# This stage is responsible for downloading all the binaries which make up
# our toolset. We'll later copy the tools to a separate stage designed for running.
FROM debian:bookworm-slim AS installer

# Using arguments allows us to update the tools easily in the future.
ARG KUBECTL_VERSION="v1.27.4"
ARG TALOSCTL_VERSION="v1.4.7"
ARG YQ_VERSION="v4.35.1"
ARG SOPS_VERSION="v3.7.3"

# Install curl and CA certificates, so we can access GitHub over HTTPS.
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && apt-get clean

RUN mkdir -p /tools
WORKDIR /tools

RUN curl -L -o kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod u+x kubectl \
    && chown ${UID}:${GID} kubectl

RUN curl -L -o talosctl https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-amd64 \
    && chmod u+x talosctl \
    && chown ${UID}:${GID} talosctl

RUN curl -L -o yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    && chmod u+x yq \
    && chown ${UID}:${GID} yq

RUN curl -L -o sops https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 \
    && chmod u+x sops \
    && chown ${UID}:${GID} sops

# ===========================================================================
# Stage which contains only the tools required, set up to run as the default
# non-root linux user, so that mounting our working directory into it won't
# cause all kinds of ownership issues.
FROM debian:bookworm-slim AS workspace
t
# Create group and user.
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} user
RUN useradd -M -s /bin/bash -u ${UID} -g ${GID} user
USER ${UID}

# Copy all the tools from our installer stage.
COPY --chown=user:user --from=installer /tools/* /usr/local/bin/
