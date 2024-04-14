#!/bin/bash

ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN

# Set flags to control the --name option
USE_HOSTNAME=false
CUSTOM_NAME=""

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

# Specify the desired behavior based on flags
if $USE_HOSTNAME && [ -n "$CUSTOM_NAME" ]; then
    echo "error: --use-hostname and --custom-name are mutually exclusive"
    exit 1
elif $USE_HOSTNAME; then
    # Use hostname as the runner name
    NAME_OPTION="--name $(hostname)"
elif [ -n "$CUSTOM_NAME" ]; then
    # Use custom name specified by the user
    NAME_OPTION="--name $CUSTOM_NAME"
else
    # Do not include --name option
    NAME_OPTION=""
fi

cd /home/docker/actions-runner || exit

./config.sh \
    --url "https://github.com/${ORGANIZATION}" \
    --token "$REG_TOKEN" \
    "$NAME_OPTION"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!