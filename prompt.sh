#!/usr/bin/env bash

SCRIPT_SOURCE=${0%/*}

source "$SCRIPT_SOURCE/lib/git.sh"
source "$SCRIPT_SOURCE/lib/helpers.sh"


if [[ -n "$1" && -f "$1" ]]; then
    source "$1"
else
    source "$SCRIPT_SOURCE/theme/default.sh"
fi
