#!/usr/bin/env bash

mkdir /home/user/.talos
sops -d --input-type=yaml --output-type=yaml configs/talosconfig.yaml > /home/user/.talos/config

mkdir /home/user/.kube
sops -d --input-type=yaml --output-type=yaml configs/kubeconfig.yaml > /home/user/.kube/config

if [ $# -eq 0 ]; then
    $SHELL
else
    $@
fi