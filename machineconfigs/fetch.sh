#!/usr/bin/env bash

# The path of the file for which we act as an "editor" is passed as
# the first argument by sops.
if [ -n "$1" ]; then
  
  # We intend to simply copy the contents from $SOPS_COPY_FROM
  # directly into the "edited" file. That way sops can do a diff
  # on the old and new file and optionally re-encrypt changed fields
  # while updating the mac.
  if [ -n "$SOPS_COPY_FROM" ]; then
    echo "Editing $1, copying contents from $SOPS_COPY_FROM"
    cat "$SOPS_COPY_FROM" > "$1";
    
    # Exit with success, since we have fulfilled our duty as editor. 
    exit 0
  else
    # If a file to be edited is provided, but $SOPS_COPY_FROM is not
    # this script is probably getting invoked improperly, exit.
    echo "SOPS_COPY_FROM variable not provided, exiting with error."
    exit 1
  fi
fi

# If we aren't running as an editor, initate update of all machine configs.



TEMP_MACHINECONFIG_FILE=$(mktemp)
talosctl -e 159.69.60.182 -n n1  get machineconfig -o yaml | yq -y -S '.spec' > "$TEMP_MACHINECONFIG_FILE"

EDITOR=$(pwd)/"$0" SOPS_COPY_FROM="$TEMP_MACHINECONFIG_FILE" sops machineconfigs/n1.yaml

#talosctl -e 159.69.60.182 -n n1  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n1.yaml && sops -e -i machineconfigs/n1.yaml
#talosctl -e 88.99.105.56  -n n2  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n2.yaml && sops -e -i machineconfigs/n2.yaml
#talosctl -e 46.4.77.66    -n n3  get machineconfig -o yaml | yq -y -S '.spec' > machineconfigs/n3.yaml && sops -e -i machineconfigs/n3.yaml
