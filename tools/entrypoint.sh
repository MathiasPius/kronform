#!/usr/bin/env bash

mkdir /home/user/.talos
sops -d --input-type=yaml --output-type=yaml talosconfig > /home/user/.talos/config

mkdir /home/user/.kube
sops -d --input-type=yaml --output-type=yaml kubeconfig > /home/user/.kube/config

if [ $# -eq 0 ]; then
    bash
else
    $@
fi