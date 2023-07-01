#!/usr/bin/env bash

# This i far from ideal, as all secret fields will be re-encrypted
# every time this script is run. It'd be preferable to be able to
# feed the latest machienconfig directly into sops as a replacement
# and have it encrypt fields as necessary, but sops does not support this.
#
# I also investigated an approach whereby I would decrypt the config
# in the repository, fetch the new one, get the yaml diff of the two,
# apply the patch to the encrypted file, and then re-encrypt it in an
# attempt to only modify fields which have been changed, but I was not
# able to find a tool capable of generating yaml diffs in the form of
# applicable patches.

talosctl -e 159.69.60.182 -n n1  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n1.yaml && sops -e -i machineconfigs/n1.yaml
talosctl -e 88.99.105.56  -n n2  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n2.yaml && sops -e -i machineconfigs/n2.yaml
talosctl -e 46.4.77.66    -n n3  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n3.yaml && sops -e -i machineconfigs/n3.yaml
