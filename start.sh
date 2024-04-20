#!/bin/bash

ORGANIZATION="$ORGANIZATION"
ACCESS_TOKEN="$ACCESS_TOKEN"

# Set flags to control the --name option
USE_HOSTNAME="${USE_HOSTNAME:-false}"  # Use default value 'false' if not set
CUSTOM_NAME="${CUSTOM_NAME:-}"

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" "https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token" | jq .token --raw-output)

# Specify the desired behavior based on flags
cd /home/docker/actions-runner || exit

if [ "$USE_HOSTNAME" = "true" ] && [ -n "$CUSTOM_NAME" ]; then
    echo "error: --use-hostname and --custom-name are mutually exclusive"
    exit 1
elif [ "$USE_HOSTNAME" = "true" ]; then
    # Use hostname as the runner name
    echo "USE_HOSTNAME selected. Name for runner: $(hostname)"
    ./config.sh \
        --url "https://github.com/${ORGANIZATION}" \
        --token "$REG_TOKEN" \
        --name "$(hostname)"
elif [ -n "$CUSTOM_NAME" ]; then
    echo "CUSTOM_NAME selected. Name for runner: $CUSTOM_NAME"
    # Use custom name specified by the user
    ./config.sh \
        --url "https://github.com/${ORGANIZATION}" \
        --token "$REG_TOKEN" \
        --name "$CUSTOM_NAME"
else
    # Do not include --name option
    ./config.sh \
        --url "https://github.com/${ORGANIZATION}" \
        --token "$REG_TOKEN"
fi

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
