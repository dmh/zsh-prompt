#!/usr/bin/env bash

SCRIPT_SOURCE=${0%/*}

# shellcheck source=lib/git.sh
source "$SCRIPT_SOURCE/lib/git.sh"
# shellcheck source=lib/helpers.sh
source "$SCRIPT_SOURCE/lib/helpers.sh"
# shellcheck source=lib/docker.sh
source "$SCRIPT_SOURCE/lib/docker.sh"


if [[ -n "$1" && -f "$1" ]]; then
    # shellcheck disable=SC1090
    source "$1"
else
    # shellcheck source=theme/default.sh
    source "$SCRIPT_SOURCE/theme/default.sh"
fi
