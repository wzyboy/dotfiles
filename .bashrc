#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=
export HISTSIZE=
export HISTFILE=~/.bash_eternal_history

shopt -s checkwinsize
shopt -s histappend

# functions
try_source() {
    [[ -f "$1" ]] && source "$1"
}
path_insert() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

# paths
path_insert ${HOME}/bin
path_insert ${HOME}/.local/bin

# aliases
alias ls='ls --color=auto -N'
if [[ -x $(command -v eza) ]]; then
  alias l='eza -lbg --time-style=long-iso'
  alias ll='eza -lbga --time-style=long-iso'
else
  alias l='ls -lF --time-style=long-iso'
  alias ll='ls -alF --time-style=long-iso'
fi
alias vim='nvim -p'
alias vimdiff='nvim -d'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias zgrep='zgrep --color=auto'
alias pcregrep='pcregrep --color=auto'
try_source ~/.bash_aliases

# z
export _Z_EXCLUDE_DIRS=(/run /nfs)
try_source ~/.local/z/z.sh

# fzf
try_source ~/.fzf.bash
try_source ~/.local/fzf-extras/fzf-extras.sh
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--exact --no-mouse"

# git
try_source /usr/share/git/git-prompt.sh  # Arch
try_source /usr/lib/git-core/git-sh-prompt  # Ubuntu
try_source /usr/share/git-core/contrib/completion/git-prompt.sh  # Fedora
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\n\$\[\033[00m\]$(__git_ps1) '

# python
export PYTHONUNBUFFERED=True
export PYTHONDONTWRITEBYTECODE=True
export PIP_DISABLE_PIP_VERSION_CHECK=1

# go
export GOPATH=$HOME/go
path_insert ${GOPATH}/bin

# misc
export PAGER=less
export EDITOR=nvim
export MOSH_PREDICTION_DISPLAY=always
export QT_LOGGING_RULES='*=false'
export ANSIBLE_FORCE_COLOR=1
export GPG_TTY=$(tty)
try_source /usr/share/bash-completion/bash_completion  # Ubuntu compat

# local
try_source ~/.bashrc.local
