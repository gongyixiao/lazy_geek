# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=51200

# Check window size after each command to update LINES and COLUMNS as needed
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support for ls and grep using aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add some aliases for ls
alias ll='ls -hlF'
alias la='ls -A'
alias l='ls -CF'

# An alias that helps view tab-delimited data
alias lc="sed ':x s/\(^\|\t\)\t/\1 \t/; t x' | column -ts$'\t' | less -SFX"

# Pull more aliases from .bash_aliases if found
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Ask for confirmation before removing or overwriting stuff
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Limit the size of core dump files cuz they can fill up home dir quotas
ulimit -c 0

# This prevents me from accidentally closing the terminal with Ctrl+D
set -o ignoreeof

# This prevents me from accidentally overwriting a file with I/O redirects
set -o noclobber

# Some customized parameters for the less command
export LESS=-eiMXR

# Set umask so that your group members can help you with your work
umask 002

# Use /scratch/username instead of /tmp if /scratch disk is found
if [ -d "/scratch" ]; then
    mkdir -p /scratch/$USER
    export TMP=/scratch/$USER
    export TMPDIR=/scratch/$USER
fi

# A function that sources all .sh files within a given directory
function load_dir {
    LOAD_DIR=${1}
    if [ -d $LOAD_DIR -a -r $LOAD_DIR -a -x $LOAD_DIR ]; then
        local i
        for i in $(find -L $LOAD_DIR -name '*.sh'); do
            source $i
        done
    fi
}

# Source all .sh files in directory .bashrc.d if found and change the prompt
if [ -d "$HOME/.bashrc.d" ]; then
    load_dir $HOME/.bashrc.d

    # Intuitive color schemes for git repositories
    if [ "$PS1" ]; then
        CYAN="\[\033[0;36m\]"
        BROWN="\[\033[0;33m\]"
        NONE="\[\e[m\]"
        export PS1R="${BROWN}\W\$${NONE} "
        export PS1=$BROWN'\W'$CYAN'$(__git_ps1 " (%s)")'$BROWN'$'$NONE" "
	PS1="[\u@\h \W]\$ "
    fi
fi

# Source Homeshick scripts if found, and sync all the castles
if [ -d "$HOME/.homesick/repos/homeshick" ]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fi

# Set PATH to include tools under /opt/common if found
if [ -d "/opt/common/CentOS_6-dev/bin/current" ]; then
    export PATH=/opt/common/CentOS_6-dev/bin/current:$PATH
elif [ -d "/opt/common/bin" ]; then
    export PATH=/opt/common/bin:$PATH
fi

# Set PATH to include MSKCC's python bin if found
if [ -d "/opt/common/CentOS_6-dev/python/python-2.7.10/bin" ]; then
    export PATH=/opt/common/CentOS_6-dev/python/python-2.7.10/bin:$PATH
fi

# Configure Roslin, if its settings are found in the expected folders
if [ -f "/ifs/work/pi/roslin-core/2.0.3/config/settings.sh" ]; then
    source /ifs/work/pi/roslin-core/2.0.3/config/settings.sh
    source /ifs/work/pi/roslin-core/2.0.3/config/variant/2.3.0/settings.sh
    export PATH=${ROSLIN_CORE_BIN_PATH}:$PATH
    export TOIL_LSF_ARGS="-sla Haystack -S 1"
fi

# Reference newer gcc libraries if found
if [ -d "/opt/common/CentOS_6/gcc/gcc-4.9.3/lib64" ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/common/CentOS_6/gcc/gcc-4.9.3/lib64
fi

# Load NVM and bash completion if found
if [ -d "/opt/common/CentOS_6-dev/nvm/v0.33.9" ]; then
    export NVM_DIR=/opt/common/CentOS_6-dev/nvm/v0.33.9
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Yixiao's Config
PS1="[\u@\h \W]\$ "
PATH=$PATH:$HOME/.local/bin/:$HOME/utilities/:$HOME/utilities/bin/:$HOME/utilities/bin/kentUtils/:$HOME/utilities/bin/textutils:$HOME/utilities/scripts/
export PATH

### For R (dplyr related): Set PATH and some ENV variables to point to some libraries we can't otherwise get in CentOS 6:
export PATH=/opt/common/CentOS_6/gcc/gcc-4.9.3/bin:/opt/common/CentOS_6-dev/R/packages4R/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/common/CentOS_6/gcc/gcc-4.9.3/lib64:/opt/common/CentOS_6-dev/R/packages4R/lib
export CFLAGS="-I/opt/common/CentOS_6-dev/R/packages4R/include"
export LDFLAGS="-L/opt/common/CentOS_6-dev/R/packages4R/lib"
export NXF_SINGULARITY_CACHEDIR="/juno/work/taylorlab/cmopipeline/sandbox/singularity_images"

export PERL5LIB=$PERL5LIB:$HOME/perl5/lib/perl5/

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
alias pt='pstree -apl gongy'
alias joint='join -t $'"'"'\t'"'"''
alias joinc='join -t $'"'"','"'"''
alias joins='join -t $'"'"'\s'"'"''
alias sortt='sort -t $'"'"'\t'"'"''
alias sortc='sort -t $'"'"','"'"''
alias sorts='sort -t $'"'"'\s'"'"' -k1,1'
alias sortt1='sort -t $'"'"'\t'"'"' -k1,1'
alias sortc1='sort -t $'"'"','"'"' -k1,1'
alias sorts1='sort -t $'"'"'\s'"'"' -k1,1'
alias tsep='tr "\t" "\n"'
alias csep='tr "," "\n"'
alias ssep='tr "\s" "\n"'
alias header='head -1'
alias header2='head -2 | tail -1'
alias tailer='tail -1'
alias tailer2='tail -2 | head -1'
alias chomp='sed '"'"'s/^ *//;s/ *$//;s/\t*$//;s/,*$//'"'"''
alias perlt='perl -F/\\t/'
alias trs='tr -s'
alias trsst='tr -s "\s" "\t"'

