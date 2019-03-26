# .zshrc

# Bug in GNOME does not source /etc/profile, resulting in an incomplete $PATH.
# Because of this bug, biber (and other commands) cannot be found.
# Source it manually here.
# https://bbs.archlinux.org/viewtopic.php?id=218767
# https://bbs.archlinux.org/viewtopic.php?id=218197
# https://bugzilla.gnome.org/show_bug.cgi?id=736660
# for file in /etc/profile.d/*.sh; do source "${file}"; done

## Colour in virtual console
if [ "$TERM" = "linux" ]; then
    # Parse .Xresources
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        echo -en "$i"
    done
    # Overwrite color0 and color15 (colorf) and set background and foreground colours.
    echo -en "\e]P02d2c28" #black    -> this is the background color as well.
    echo -en "\e]PFa4a6ab" #white   -> this is the foreground color as well.
    clear #for background artifacting

    # # taken from https://bbs.archlinux.org/viewtopic.php?id=167717
    # echo -en "\e]P0222222" #black    -> this is the background color as well.
    # echo -en "\e]P8222222" #darkgray
    # echo -en "\e]P1803232" #darkred
    # echo -en "\e]P9982b2b" #red
    # echo -en "\e]P25b762f" #darkgreen
    # echo -en "\e]PA89b83f" #green
    # echo -en "\e]P3aa9943" #brown
    # echo -en "\e]PBefef60" #yellow
    # echo -en "\e]P4324c80" #darkblue
    # echo -en "\e]PC2b4f98" #blue
    # echo -en "\e]P5706c9a" #darkmagenta
    # echo -en "\e]PD826ab1" #magenta
    # echo -en "\e]P692b19e" #darkcyan
    # echo -en "\e]PEa1cdcd" #cyan
    # echo -en "\e]P7ffffff" #lightgray
    # echo -en "\e]PFdedede" #white   -> this is the foreground color as well.
    # clear #for background artifacting
fi

### History ###
HISTFILE=$HOME/.cache/zsh.hist
HISTSIZE=1000
SAVEHIST=1000

LESSHISTFILE=$HOME/.cache/less.hist


### Variables ###
# export TERM="xterm-256color"
export TERM="screen-256color"
export BROWSER=""
export EDITOR="/bin/vim"
export SYSTEMD_EDITOR="/bin/vim"
# export PATH="${PATH}:${HOME}/bin"
export PATH="${HOME}/bin:${PATH}"
export VISUAL="/bin/vim"
export PAGER="/bin/less"
export LESS="-r"  # color support
# export DISPLAY=:0.0
export PYTHONPATH="$HOME/lib/python/"
export PYTHONUSERBASE="$HOME/lib/python/"  # directory for pip -user
export XDG_CONFIG_HOME="$HOME/.config"
export MATPLOTLIBRC="$HOME/.config/matplotlib/"
export R_LIBS_USER="$HOME/lib/R/"
export R_PROFILE_USER="$HOME/.Rprofile"
export R_DEFAULT_PACKAGES=NULL  # do not let R preload anything
# color grep output
export GREP_COLOR='1;33'  # yellow
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib/cpp/"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export STARDICT_DATA_DIR="$HOME/var/stardict/dic"
# support fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx


### Keybindings ###
# use vi mode
bindkey -v
# typeset -g -A key

# #bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# history search with arrow keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# history search with j and k in normal mode
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward


### Auto completion ###
autoload -Uz compinit
compinit -d $HOME/.cache/zsh.compdump
# move the cursor around the list of completions to select one
zstyle ':completion:*' menu select
# This way you tell zsh comp to take the first part of the path to be exact,
# and to avoid partial globs. Now path completions became nearly immediate.
zstyle ':completion:*' accept-exact '*(N)'
# When completing for openpdf script, match only *.pdf files.
zstyle ":completion:*:*:openpdf:*" file-patterns "*.pdf *(-/)"
# autocomplete aliases
setopt completealiases


### Window title ###
case $TERM in
    termite|*xterm*|rxvt*)
        precmd () { print -Pn '\e]0;%n@%m:%4d\a' }
        ;;
esac


### Dirstack ###
DIRSTACKFILE="$HOME/.cache/zsh.dirs"
DIRSTACKSIZE=10
setopt autopushd pushdsilent pushdtohome
# remove duplicate entries
setopt pushdignoredups
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}


### Aliases ###
alias ls='/bin/ls --color=auto'
alias ds='dirs -v'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias cp='cp -i -p'
alias rm='rm -iv'
alias handbrake='ghb'
alias grep='grep --color=always'
# alias matlab='LD_LIBRARY_PATH="/home/takao/etc/matlab_libs/" /usr/local/bin/matlab -nosplash -nodesktop'


### Prompt ###
### Notify after long processes ###
autoload -Uz vcs_info
preexec () {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
}

precmd () {
    vcs_info

    # Proceed only if we've ran a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then
        # Note current date in unix time
        CMD_END_DATE=$(date +%s)
        # Store the difference between the last command start date vs. current date.
        CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
        # Store an arbitrary threshold, in seconds.
        CMD_NOTIFY_THRESHOLD=10

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
            # print elapsed time if the elapsed time (in seconds) is greater than threshold
            echo -e ""
            echo -e "---"
            # echo -e "\033[0mElapsed time: ${CMD_ELAPSED_TIME} seconds.\033[0m"
            hours=$(($CMD_ELAPSED_TIME / 3600))
            remaining_seconds=$(($CMD_ELAPSED_TIME % 3600))
            minutes=$(($remaining_seconds / 60))
            seconds=$(($remaining_seconds % 60))

            output="Elapsed time:"
            if [[ $hours -gt 1 ]]; then
                output="${output} ${hours} hours"
            elif [[ $hours -gt 0 ]]; then
                output="${output} ${hours} hour"
            fi

            if [[ $minutes -gt 1 ]]; then
                output="${output} ${minutes} minutes and"
            elif [[ $hours -gt 0 ]]; then
                output="${output} ${minutes} minute and"
            fi

            if [[ $seconds -gt 1 ]]; then
                output="${output} ${seconds} seconds"
            else
                output="${output} ${minutes} second"
            fi

            echo -e "\033[0m${output}.\033[0m"

            # Send a notification
            # notify-send "Job Finished" "\"$CMD_NAME\" in ${CMD_ELAPSED_TIME} seconds."
        fi
    fi
    echo -e ""
}


### Prompt ###
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats 'branch:%b'
setopt PROMPT_SUBST
PROMPT='${vcs_info_msg_0_}
%F{white}%d
%B%F{magenta}>%F{yellow}>%F{blue}>%b%F{white} '

function indicate_mode {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
}
indicate_mode

function zle-line-init zle-keymap-select {
    indicate_mode
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select



### Misc ###
unsetopt beep

# disable XON/XOFF flow control (^s/^q)
stty -ixon

# activate zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
