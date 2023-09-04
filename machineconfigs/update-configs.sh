#!/usr/bin/env bash

# This script passes itself as an editor to the sops edit command
# in order to completely replace the target file in a way that
# allows sops to do a diff and only re-encrypt values that have
# have changed, and updating the mac.
#
# Ideally it would be possible to feed the new machineconfig into
# sops and have it automatically diff the output, but there's no
# such command. Nor can sops read from stdin to replace contents.
#
# The only options for sops are:
#
#   1. Replacing the entire file with the updated plaintext and then
#      re-encrypting everything, which means ALL values meant to be
#      encrypted will change, making diffs useless.
#
#   2. Using the --set flag configure individual fields, but this
#      does not provide any way of removing fields. Setting them to
#      null might be an option for simple values, but array entries
#      cannot be deleted this way.
#
#   3. Using the sops edit command to manually update the changes.
#
# This script uses the third option, but provides *itself* as the
# $EDITOR to use for the editing, allowing it to programmatically
# override the values file temporarily decrypted by sops for manual
# editing, with the new fetched values file, grabbed from talosctl.
#
# The process works as follows:
#
#   1. Uses talosctl to download the current machineconfig for the
#      node, and stores it in a temp file.
#
#   2. Executes sops <checked in node machineconfig.yaml, setting
#      the EDITOR variable to itself, and SOPS_COPY_FROM as the path
#      of the file downloaded in the first step.
#
#   3. sops invokes the EDITOR (this script again), which copies the
#      contents of SOPS_COPY_FROM into the first argument provided
#      to the sops-invoked script, which is the path to the temporary
#      file sops has stored the unencrypted plaintext of the checked
#      in machineconfig for the node
#
#   4. sops-invoked script exits successfully, sops picks up the changed
#      file and performs a diff between the old and new version,
#      encrypting all the values marked for encryption, but have been
#      modified by the script.
#
# Sops leaves the already-encrypted variables as they are, causing no
# diff when compared to prior versions, and updates the mac of the file.
#
# This achieves a few things compared to other approaches:
#
#   1. Only variables that actually change will be updated in the
#      encrypted output file.
#
#   2. Mac is updated on change. Editing plaintext fields manually
#      in the yaml would invalidate the mac signature, causing sops
#      to throw a fit.


# The path of the file for which we act as an "editor" is passed as
# the first argument by sops, if this is the sops-invocation of the
# script
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

# Update the config using <endpoint> for <node>
function update_config() {
  # Create a temporary file to hold the machineconfig from talosctl.
  TEMP_MACHINECONFIG_FILE=$(mktemp)
  
  # Make sure the file exists before continuing.
  if [ ! -f "$TEMP_MACHINECONFIG_FILE" ]; then
    echo "Temp file not created, exiting."
    exit 1
  fi
  
  # Fetch the node's machineconfig, extracting only the spec itself, and 
  # storing it in our temp file.
  talosctl -e "$1" -n "$2"  get machineconfig -o yaml | yq '.spec' > "$TEMP_MACHINECONFIG_FILE"

  # Invoke sops' edit mode for the target file, causing it to decrypt
  # into a temp file and in turn invoke this script as EDITOR.
  EDITOR=$(pwd)/"$0" SOPS_COPY_FROM="$TEMP_MACHINECONFIG_FILE" sops machineconfigs/"$2".yaml
  
  # Clean up.
  rm "$TEMP_MACHINECONFIG_FILE"
}

# If we aren't running as an editor, initate update of all machine configs.
update_config 159.69.60.182 n1
update_config 88.99.105.56  n2
update_config 46.4.77.66    n3
