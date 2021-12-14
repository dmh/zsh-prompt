#!/usr/bin/env bash

function show_env_info {
    if [[ -f ".env" ]];
    then
        typo3_context=$(grep -v '^#' .env | grep ^TYPO3_CONTEXT | cut -d '=' -f2 | tail -1)
        uid=$(grep -v '^#' .env | grep ^USER_ID | cut -d '=' -f2 | tail -1)
        virtual_host_1=$(grep -v '^#' .env | grep ^VIRTUAL_HOST_1 | cut -d '=' -f2 | tail -1)
        compose_file=$(grep -v '^#' .env | grep ^COMPOSE_FILE | cut -d '=' -f2 | cut -d"-" -f2 | tail -1)
        compose_file="${compose_file#*.}"
        icon=$(_show "frame_middle_icon" "" "grey27" "" "b")
        title=$(_show "" "" "deepSkyBlue1" "" "b" "DC")

        if [[ $typo3_context = 'Development/local' ]]
        then
            context=$(_show "" "" "orange1" "grey19" "b" " dev ")
        else
            context=$(_show "" "" "deepSkyBlue1" "grey19" "b" " prod ")
        fi

        if [[ $uid = '' || $uid = 'mac' ]]
        then
            user_id=$(_show "" "" "grey58" "" "" " uid:")
            user_id+=$(_show "" "" "cyan3" "" "b" "mac ")
        else
            user_id=$(_show "" "" "grey58" "" "" " uid:")
            user_id+=$(_show "" "uid" "red3" "" "b")
            user_id+=$(_show "" "" "" "" "" " ")
        fi

        if [[ $compose_file = 'yml' ]]
        then
            dcompose=$(_show "" "" "grey66" "grey7" "b" " default ")
        else
            compose_file=" .${compose_file%.*} "
            dcompose=$(_show "" "compose_file" "grey66" "grey7" "b")
        fi

        prompt="$context$user_id$dcompose $virtual_host_1"
        echo -e "$prompt"
    fi
}

function show_docker_info {
    dcps=$(docker compose ps 2> /dev/null)
    cmd_status=$?
    if [[ $cmd_status -lt 1 ]];
    then
        icon=$(_show "frame_middle_icon" "" "grey27" "" "b")
        title=$(_show "" "" "deepSkyBlue1" "" "b" "DC")
        web=$(grep web <<< "${dcps}" | grep running)
        db=$(grep db <<< "${dcps}" | grep running)

        web_staus=$(_show "" "" "grey58" "" "" "web" )
        db_staus=$(_show "" "" "grey58" "" "" " db" )
        if [[ -n $web ]]
        then
            if grep -q 'healthy' <<< "${web}"
            then
                web_staus+=$(_show "container_status_ok" "" "green3" "" "b")
            else
                web_staus+=$(_show "container_status_ok" "" "darkOrange" "" "b")
            fi
        else
            web_staus+=$(_show "container_status_exit" "" "red3" "" "b")

        fi

        if [[ -z $db ]]
        then
            db_staus+=$(_show "container_status_exit" "" "red3" "" "b")
        else
            db_staus+=$(_show "container_status_ok" "" "green3" "" "b")
        fi

        prompt="\n$icon $title $web_staus$db_staus $(show_env_info)"
        echo -e "$prompt"
    fi
}
