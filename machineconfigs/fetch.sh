#!/usr/bin/env bash

talosctl -e 159.69.60.182 -n n1  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n1.yaml && sops -e -i machineconfigs/n1.yaml
talosctl -e 88.99.105.56  -n n2  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n2.yaml && sops -e -i machineconfigs/n2.yaml
talosctl -e 46.4.77.66    -n n3  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n3.yaml && sops -e -i machineconfigs/n3.yaml