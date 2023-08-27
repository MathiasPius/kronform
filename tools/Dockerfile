# This stage is responsible for downloading all the binaries which make up
# our toolset. We'll later copy the tools to a separate stage designed for running.
FROM debian:bookworm-slim AS installer

# Using arguments allows us to update the tools easily in the future.
ARG KUBECTL_VERSION="1.27.4"
ARG TALOSCTL_VERSION="1.4.7"
ARG YQ_VERSION="4.35.1"
ARG SOPS_VERSION="3.7.3"
ARG FLUX_VERSION="2.1.0"

# Install curl and CA certificates, so we can access GitHub over HTTPS.
RUN apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl \
    && apt-get clean

# Create a /tools directory so we can copy all of them over wholesale.
RUN mkdir -p /tools
WORKDIR /tools

RUN curl -L -o kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod u+x kubectl

RUN curl -L -o talosctl https://github.com/siderolabs/talos/releases/download/v${TALOSCTL_VERSION}/talosctl-linux-amd64 \
    && chmod u+x talosctl

RUN curl -L -o yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 \
    && chmod u+x yq

RUN curl -L -o sops https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 \
    && chmod u+x sops

RUN curl -L -o flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz \
    && tar -xf flux.tar.gz \
    && rm flux.tar.gz \
    && chmod u+x flux

# ===========================================================================
# Stage which contains only the tools required, set up to run as the default
# non-root linux user, so that mounting our working directory into it won't
# cause all kinds of ownership issues.
FROM debian:bookworm-slim AS workspace

# Create group and user.
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} user
RUN useradd -M -s /bin/bash -u ${UID} -g ${GID} user

# We'll mount the kronform repository in /data
RUN mkdir /data && chown user:user /data
WORKDIR /data

# Copy all the tools from our installer stage.
COPY --chown=user:user --from=installer /tools/* /usr/local/bin/

USER ${UID}

