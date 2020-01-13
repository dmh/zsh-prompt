#!/usr/bin/env bash

# use _show function to add parameters to prompt from the Theme variables
# $(_show "icon?" "value?" "color" "bg" "b/u/bu")
# bg - background
# b - bold, u - underscore, bu - bold with underscore
function _show {
    local icon="$1"
    local value="$2"
    local color=$3
    local background=$4
    local formatting=$5

    if [[ -n $icon ]]; then icon=$(_theme "$icon") ; fi
    if [[ -n $value ]]; then value=$(_theme "$value") ; fi
    if [[ -n $color ]]; then color=$(_theme "$color") ; fi

    local formatting_start
    local formatting_end
    if [[ $formatting = "bu" ]]; then
        formatting_start="%B%U"
        formatting_end="%u%b"
    elif [[ $formatting = "b" ]]; then
        formatting_start="%B"
        formatting_end="%b"

    elif [[ $formatting = "u" ]]; then
        formatting_start="%U"
        formatting_end="%u"

    else
        formatting_start=""
        formatting_end=""
    fi

    if [[ -z $background ]]; then
        echo "${formatting_start}%F{$color}${icon}${value}%f${formatting_end}"
    else
        background=$(_theme "$background")
        echo "${formatting_start}%K{$background}%F{$color}${icon}${value}%f%k${formatting_end}"
    fi
}
