#!/usr/bin/env bash

# ================================================
# font
# Monoid Nerd Font
# https://www.nerdfonts.com/font-downloads

# icons
# https://www.nerdfonts.com/cheat-sheet

# colors
# https://jonasjacek.github.io/colors/
# ================================================


# shellcheck disable=SC2034  # Unused variables as a theme
function _theme {
    local var=$1

    local grey3=232 # #080808
    local grey7=233 # #121212
    local grey11=234 # #1c1c1c ***
    local grey15=235 # #262626
    local grey19=236 # #303030
    local grey23=237 # #3a3a3a
    local grey27=238 # #444444 ***
    local grey30=239 # #4e4e4e
    local grey35=240 # #585858
    local grey39=241 # #626262
    local grey42=242 # #6c6c6c ***
    local grey46=243 # #767676
    local grey50=244 # #808080 ***
    local grey54=245 # #8a8a8a
    local grey58=246 # #949494
    local grey62=247 # #9e9e9e
    local grey66=248 # #a8a8a8 ***
    local grey70=249 # #b2b2b2
    local grey74=250 # #bcbcbc ***
    local grey78=251 # #c6c6c6
    local grey82=252 # #d0d0d0
    local grey85=253 # #dadada
    local grey89=254 # #e4e4e4
    local grey93=255 # #eeeeee

    local darkCyan=36      # #00af87
    local deepSkyBlue1=39  # #00afff
    local green3=40        # #00d700
    local cyan3=43         # #00d7af
    local aquamarine1=86   # #5fffd7
    local mediumPurple3=98 # #875fd7
    local red3=160         # #d70000
    local magenta3=164     # #d700d7
    local indianRed1=203   # #ff5f5f
    local darkOrange=208   # #ff8700
    local orange1=214      # #ffaf00
    local gold1=220        # #ffd700

    local red='203'
    local green='40'
    local yellow='220'
    local blue='39'
    local purple='98'
    local magenta='164'
    local cyan='86'
    local orange='208'



    # ###################################
    # git module
    # ###################################

    local git_stash_icon='★ '
    local git_stash_color=$darkOrange
    local git_stash_bg

    local git_hash_color=$grey62
    local git_hash_bg

    # local git_untracked_files_icon=' ✚ '
    local git_untracked_files_icon=' U '
    local git_untracked_files_color=$indianRed1
    local git_untracked_files_bg=$grey23

    # local git_changes_not_staged_for_commit_icon=' 𝗠 '
    local git_changes_not_staged_for_commit_icon=' M '
    local git_changes_not_staged_for_commit_color=$gold1
    local git_changes_not_staged_for_commit_bg=$grey35

    local git_changes_to_be_committed_icon=' ☰ '
    local git_changes_to_be_committed_color=$green3
    local git_changes_to_be_committed_bg=$grey23

    local git_has_conflicts_icon=' ✖ '
    local git_has_conflicts_color=$indianRed1
    local git_has_conflicts_bg=$grey19

    local git_detached_branch_color=$indianRed1
    local git_branch_color=$deepSkyBlue1
    local git_branch_bg=$grey7

    local git_has_diverged_icon='⬇⬆'
    local git_has_diverged_color=$indianRed1
    local git_has_diverged_bg=$grey7

    local git_up_symbol_icon='⬆'
    local git_down_symbol_icon='⬇'

    # local git_synchronized_with_remote_icon='↻'
    local git_synchronized_with_remote_icon='⮂'
    local git_arrows_color=$gold1
    local git_arrows_bg=$grey7

    local git_upstream_color=$grey66
    local git_upstream_bg=$grey7

    local no_git_icon=' not a git repo '
    local no_git_color=$grey54
    local no_git_bg=$grey19

    local git_tag_color=$gold1
    local git_tag_bg

    local git_hidden_icon_color=$grey7
    # ===============================================



    # ###################################
    # docker
    # ###################################
    local container_status_ok='⬆ '
    local container_status_exit='⬇ '
    # ===============================================



    # ###################################
    # prompt
    # ###################################

    local frame_start_icon='⎡'
    local frame_middle_icon='⎢'
    local frame_end_icon='⎣'

    local hostname='%m'
    local username='%n'
    local working_directory='%~'
    local shell_run_user_icon='❱'
    local shell_run_root_icon='#'
    local cmd_time='%*'
    local cmd_date=" | %w "
    local cmd_status_ok_icon=' ✔ '
    local cmd_status_error_icon=' ✖ '

    echo "${(P)var}"
}


# use _show function to add parameters from the theme variables above
# $(_show "icon?" "value?" "color" "bg" "b/u/bu")
# bg - background
# b - bold, u - underscore, bu - bold with underscore

# !!! use spaces, line breaks and slash to format your custom prompt
PROMPT="

$(_show "frame_start_icon" "" "grey27" "" "b") \
$(_show "" "working_directory" "cyan")\$(show_docker_info)
\
$(_show "frame_middle_icon" "" "grey27" "" "b") \
\$(show_git_info)
\
$(_show "frame_end_icon" "" "grey27" "" "b") \
$(_show "" "username" "grey30") \
%(!.$(_show "shell_run_root_icon" "" "indianRed1").$(_show "shell_run_user_icon" "" "cyan3" "" "b")) "


RPROMPT="\
%(?.$(_show "cmd_status_ok_icon" "" "green3" "grey19").$(_show "cmd_status_error_icon" "" "indianRed1" "grey19"))\
$(_show "" "cmd_time" "grey54" "grey19")\
$(_show "" "cmd_date" "grey54" "grey19")"
