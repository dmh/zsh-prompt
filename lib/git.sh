#!/usr/bin/env bash

function _git_render {
    local value=$1
    local color=$2
    local background=$3
    local formatting=$4

    local space1=" "
    local space2=" "
    if [[ $5 = 0 ]]; then space1="" ; fi
    if [[ $6 = 0 ]]; then space2="" ; fi

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
        echo "${formatting_start}%F{$color}${space1}${value}${space2}%f${formatting_end}"
    else
        background=$(_theme "$background")
        if [[ -z $background ]]; then
            echo "${formatting_start}%F{$color}${space1}${value}${space2}%f${formatting_end}"
        else
            echo "${formatting_start}%K{$background}%F{$color}${space1}${value}${space2}%f%k${formatting_end}"
        fi
    fi
}

function _git_render_icon {
    local icon=$1
    local color=$2
    local background=$3
    local formatting=$4
    local test=$5

    if [[ -n $icon ]]; then icon=$(_theme "$icon") ; fi
    if [[ -n $color ]]; then color=$(_theme "$color") ; fi
    if [[ -n $test ]]; then
        if [[ $test = 0 ]]; then color=$(_theme "git_hidden_icon_color"); fi
    fi

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
        echo "${formatting_start}%F{$color}${space1}${icon}${space2}%f${formatting_end}"
    else
        background=$(_theme "$background")
        if [[ -z $background ]]; then
            echo "${formatting_start}%F{$color}${space1}${icon}${space2}%f${formatting_end}"
        else
            echo "${formatting_start}%K{$background}%F{$color}${space1}${icon}${space2}%f%k${formatting_end}"
        fi
    fi
}

function show_git_info {

    local prompt

    local git_hash
    local is_a_git_repo

    local git_stash
    local is_git_stash

    local git_logs
    local just_init

    local git_status

    local untracked_files
    local is_untracked_files
    local changes_not_staged_for_commit
    local is_changes_not_staged_for_commit
    local changes_to_be_committed
    local is_changes_to_be_committed

    local is_unmerged
    local unmerged

    local git_branch
    local detached
    local detached_branch

    local upstream
    local is_upstream
    local commits_diff
    local commits_ahead
    local commits_behind
    local diverged

    local git_tag
    local is_git_tag

    git_hash=$(git rev-parse --short HEAD 2> /dev/null)
    is_a_git_repo=$([[ -n $git_hash ]] && echo 1 || echo 0)

    #! add initiall commit message

    if [[ $is_a_git_repo = 1 ]]
    then

        # git stash
        git_stash="$(git stash list -n1 2> /dev/null | wc -l)"
        is_git_stash=$([[ $git_stash -gt 0 ]] && echo 1 || echo 0)

        # git logs
        git_logs="$(git log --pretty=oneline -n1 | wc -l 2> /dev/null)"
        if [[ $git_logs -eq 0 ]]; then just_init=1; fi

        # parse git status
        git_status="$(git status --porcelain 2> /dev/null)"

        # untracked files
        untracked_files="$(grep ^\?\? <<< "${git_status}")"
        is_untracked_files=$([[ -n $untracked_files ]] && echo 1 || echo 0)

        # changes not staged for commit
        changes_not_staged_for_commit=$(grep "^.[MADRC]" <<< "${git_status}")
        is_changes_not_staged_for_commit=$([[ -n $changes_not_staged_for_commit ]] && echo 1 || echo 0)

        # changes to be committed
        changes_to_be_committed="$(grep "^[MADRC]" <<< "${git_status}")"
        is_changes_to_be_committed=$([[ -n $changes_to_be_committed ]] && echo 1 || echo 0)


        # updated but unmerged
        unmerged="$(grep "^\U\U" <<< "${git_status}")"
        is_unmerged=$([[ -n $unmerged ]] && echo 1 || echo 0)

        if [[ $just_init != 1 ]]
        then
            # git branch
            git_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
            if [ "$git_branch" = 'HEAD' ]; then detached=1; fi

            if [[ $detached = 1 ]]
            then
                # if branch detached
                detached_branch=$(git status | head -1 2> /dev/null)

            else
                # if upstream
                upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @\{upstream\} 2> /dev/null)
                is_upstream=$([[ -n $upstream ]] && echo 1 || echo 0)

                if [[ $is_upstream = 1 ]]
                then
                    commits_diff="$(git log --pretty=oneline --topo-order --left-right "${git_hash}"..."${upstream}" 2> /dev/null)"
                    commits_ahead="$(grep -c ^\< <<< "${commits_diff}")"
                    commits_behind="$(grep -c ^\> <<< "${commits_diff}")"
                    if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then diverged=1; fi
                fi
            fi

            # git tag
            git_tag=$(git describe --exact-match --tags "$git_hash" 2> /dev/null)
            is_git_tag=$([[ -n $git_tag ]] && echo 1 || echo 0)
        fi
    fi


    if [[ $is_a_git_repo = 1 ]]; then

        [[ $is_git_stash = 1 ]] && prompt+=$(_git_render_icon "git_stash_icon" "git_stash_color" "git_stash_bg")

        prompt+=$(_git_render "$git_hash" "git_hash_color" "git_hash_bg" "" 0 1)

        prompt+=$(_git_render_icon\
            "git_untracked_files_icon"\
            "git_untracked_files_color"\
            "git_untracked_files_bg"\
            ""\
            "$is_untracked_files"\
        )

        prompt+=$(_git_render_icon\
            "git_changes_not_staged_for_commit_icon"\
            "git_changes_not_staged_for_commit_color"\
            "git_changes_not_staged_for_commit_bg"\
            ""\
            "$is_changes_not_staged_for_commit"\
        )

        prompt+=$(_git_render_icon\
            "git_changes_to_be_committed_icon"\
            "git_changes_to_be_committed_color"\
            "git_changes_to_be_committed_bg"\
            ""\
            "$is_changes_to_be_committed"\
        )

        [[ $is_unmerged = 1 ]] && prompt+=$(_git_render_icon "git_has_conflicts_icon" "git_has_conflicts_color" "git_has_conflicts_bg")

        if [[ $just_init != 1 ]]; then
            if [[ $detached = 1 ]]; then
                prompt+=$(_git_render "$detached_branch" "git_detached_branch_color" "git_branch_bg")

            elif [[ $is_upstream = 1 ]]; then
                prompt+=$(_git_render "$git_branch" "git_branch_color" "git_branch_bg")

                if [[ $diverged = 1 ]]; then
                    prompt+=$(_git_render\
                        "-${commits_behind} $(_theme "git_has_diverged_icon") +${commits_ahead}"\
                        "git_has_diverged_color"\
                        "git_has_diverged_bg"\
                        ""\
                        0\
                        0\
                    )
                else

                    # if commits behind
                    if [[ $commits_behind -gt 0 ]]; then
                        prompt+=$(_git_render\
                            "$(_theme "git_down_symbol_icon") -${commits_behind}"\
                            "git_arrows_color"\
                            "git_arrows_bg"\
                            ""\
                            0\
                            0\
                        )
                    fi

                    # if commits ahead
                    if [[ $commits_ahead -gt 0 ]]; then
                        prompt+=$(_git_render\
                            "$(_theme "git_up_symbol_icon") +${commits_ahead}"\
                            "git_arrows_color"\
                            "git_arrows_bg"\
                            ""\
                            0\
                            0\
                        )
                    fi

                    # if synced
                    if [[ $commits_ahead = 0 && $commits_behind = 0 ]]; then
                        prompt+=$(_git_render\
                            "$(_theme git_synchronized_with_remote_icon)"\
                            "git_arrows_color"\
                            "git_arrows_bg"\
                            ""\
                            0\
                            1\
                        )
                    fi
                fi
                prompt+=$(_git_render "$upstream" "git_upstream_color" "git_upstream_bg")

            else
                prompt+=$(_git_render "$git_branch" "git_branch_color" "git_branch_bg")
            fi
        fi
        # ----> add info for a git tag
        [[ $is_git_tag = 1 ]] && prompt+=$(_git_render "$git_tag" "git_tag_color" "git_tag_bg")

    else
        prompt+=$(_git_render_icon "no_git_icon" "no_git_color" "no_git_bg")
    fi

    echo "$prompt"

}
