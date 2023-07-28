#!/usr/bin/env bash

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

ps1_arrow='➜'
TIMER_THRESHOLD=1
TIMER_PRECISION=0

if [ "$1" = yes ]; then
    COLOR_NC='\[\033[0m\]'
    COLOR_WHITE='\[\033[1;37m\]'
    COLOR_BLACK='\[\033[0;30m\]'
    COLOR_BLUE='\[\033[0;34m\]'
    COLOR_LIGHT_BLUE='\[\033[1;34m\]'
    COLOR_GREEN='\[\033[0;32m\]'
    COLOR_LIGHT_GREEN='\[\033[1;32m\]'
    COLOR_CYAN='\[\033[0;36m\]'
    COLOR_LIGHT_CYAN='\[\033[1;36m\]'
    COLOR_RED='\[\033[0;31m\]'
    COLOR_LIGHT_RED='\[\033[1;31m\]'
    COLOR_PURPLE='\[\033[0;35m\]'
    COLOR_LIGHT_PURPLE='\[\033[1;35m\]'
    COLOR_BROWN='\[\033[0;33m\]'
    COLOR_YELLOW='\[\033[1;33m\]'
    COLOR_GRAY='\[\033[1;30m\]'
    COLOR_LIGHT_GRAY='\[\033[0;37m\]'
else
    COLOR_NC=''
    COLOR_WHITE=''
    COLOR_BLACK=''
    COLOR_BLUE=''
    COLOR_LIGHT_BLUE=''
    COLOR_GREEN=''
    COLOR_LIGHT_GREEN=''
    COLOR_CYAN=''
    COLOR_LIGHT_CYAN=''
    COLOR_RED=''
    COLOR_LIGHT_RED=''
    COLOR_PURPLE=''
    COLOR_LIGHT_PURPLE=''
    COLOR_BROWN=''
    COLOR_YELLOW=''
    COLOR_GRAY=''
    COLOR_LIGHT_GRAY=''
fi

if [ "$SSH_CONNECTION" ]; then 
    ps1_add="$COLOR_GREEN\u@\h$COLOR_WHITE:"
else
    ps1_add=''
fi

__timer_current_time() {
    echo $(date +%s%N | cut -b1-10)
}

__timer_format_duration() {
    local mins=$(printf '%.0f' $(($1 / 60)))
    local secs=$(printf "%.${TIMER_PRECISION:-1}f" $(($1 - 60 * mins)))
    local duration_str=$(echo "${mins}m${secs}s")
    local format="%d"
    echo "${format//\%d/${duration_str#0m}}"
}

__timer_save_time_preexec() {
    __timer_cmd_start_time=$(__timer_current_time)
}

preexec() { __timer_cmd_start_time=$(__timer_current_time); }

__timer_display_timer_precmd() {
    if [ -n "${__timer_cmd_start_time}" ]; then
        local cmd_end_time=$(__timer_current_time)
        local tdiff=$((cmd_end_time - __timer_cmd_start_time))
        unset __timer_cmd_start_time
        if [[ -z "${TIMER_THRESHOLD}" || ${tdiff} -ge "${TIMER_THRESHOLD}" ]]; then
            local tdiffstr=$(__timer_format_duration ${tdiff})
            local cols=$((COLUMNS - ${#tdiffstr} - 1))
            echo -e "${tdiffstr}"
        else
            echo -e ""
        fi
    fi
}

prompt_cmd () {
    LAST_STATUS=$?
    PS1='\n'
    local took=$(__timer_display_timer_precmd)
    if [ -n "$took" ]; then
	PS1+="took: ${took}\n"
    fi
    unset __timer_cmd_start_time
    PS1+="$ps1_add"
    PS1+="$COLOR_CYAN\w "
    PS1+="$COLOR_LIGHT_RED"
    if type parse_git_branch > /dev/null 2>&1; then
        PS1+=$(parse_git_branch)
    fi
    if [[ $LAST_STATUS = 0 ]]; then
        PS1+="$COLOR_YELLOW"
    else
        PS1+="$COLOR_RED"
    fi
    PS1+='\n'
    PS1+="${ps1_arrow}"
    PS1+="$COLOR_WHITE "
}

export PROMPT_COMMAND=prompt_cmd
