# Builds a "tools" container with most of the tools required
# to interact with the cluster, both Talos itself and Kubernetes.
build:
    docker build -t tools:latest tools/

# Run the container, mounting in our SSH and GPG identities.
#
# I'm explicitly setting the DNS here, because my host machine
# uses DNS-over-TLS, which means the nameservers specified in
# /etc/resolv.conf won't work with plain DNS traffic, breaking
# resolution within the container.
tools:
    docker run -it --rm                                 \
    --dns 8.8.8.8			                            \
    -v $(pwd):/data                                     \
    -v /run/user/1000/:/run/user/1000/:ro               \
    -v $HOME/.config/sops:/home/user/.config/sops:ro    \
    tools:latest || true

rotate-keys:
    find .                                  \
        -not -path '*/\.git/*'              \
        -not -name ".sops.yaml"             \
        -type f -print0                     \
    | while IFS= read -r -d '' file; do     \
        sops updatekeys --yes               \
            --input-type yaml "$file";      \
    done
    exit 0

update-flux:
    docker run -it --rm                                 \
    --dns 8.8.8.8			                            \
    -v $(pwd):/data                                     \
    -v /run/user/1000/:/run/user/1000/:ro               \
    -v $HOME/.config/sops:/home/user/.config/sops:ro    \
    tools:latest flux install                           \
        --cluster-domain "local.kronform.pius.dev"      \
        --components-extra="image-reflector-controller,image-automation-controller" \
        --export > manifests/cluster/flux-system/gotk-components.yaml
