#
# ~/.bashrc
#
# vim: set foldmethod=marker:

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# bash settings {{{
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=
export HISTSIZE=
export HISTFILE=~/.bash_eternal_history

shopt -s checkwinsize
shopt -s histappend
# }}}

# helper functions {{{
try_source() {
  [[ -f "$1" ]] && source "$1"
}
path_insert() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}
# }}}

# paths {{{
path_insert "${HOME}/bin"
path_insert "${HOME}/.local/bin"
# }}}

# core utils {{{
alias ls='ls --color=auto -N'
if [[ -x $(command -v eza) ]]; then
  alias l='eza -lbg --time-style=long-iso'
  alias ll='eza -lbga --time-style=long-iso'
else
  alias l='ls -lF --time-style=long-iso'
  alias ll='ls -alF --time-style=long-iso'
fi

if [[ -x $(command -v nvim) ]]; then
  export EDITOR=nvim
  alias vim='nvim -p'
  alias vimdiff='nvim -d'
else
  export EDITOR=vim
  alias vim='vim -p'
fi

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias zgrep='zgrep --color=auto'
alias pcregrep='pcregrep --color=auto'
alias df='df -xtmpfs -xdevtmpfs -x efivarfs -l'
# }}}

# navigation {{{
if [[ -x $(command -v zoxide) ]]; then
  eval "$(zoxide init bash)"
fi

if [[ -x $(command -v direnv) ]]; then
  eval "$(direnv hook bash)"
fi

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

function zgit() {
  cd "$(
    fd --type d --hidden --follow --max-depth 6 --glob .git ~ \
      --exclude .cache \
      --exclude .local \
      --exclude node_modules \
      --exclude .venv \
    | sed -r 's#/\.git/?$##' \
    | fzf
  )" || return
}
# }}}

# fzf {{{
try_source ~/.fzf.bash
try_source ~/.local/fzf-extras/fzf-extras.sh
export FZF_DEFAULT_OPTS="--exact --no-mouse"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --border=none \
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
# }}}

# git {{{
try_source /usr/share/git/git-prompt.sh  # Arch
try_source /usr/lib/git-core/git-sh-prompt  # Ubuntu
try_source /usr/share/git-core/contrib/completion/git-prompt.sh  # Fedora

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='auto'
alias __git_dir='git rev-parse --show-toplevel >/dev/null 2>&1 && echo " [$(basename $(git rev-parse --show-toplevel))]"'
PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\n\$\[\033[00m\]$(__git_dir)$(__git_ps1) '

alias gitroot='cd "$(git rev-parse --show-toplevel)"'
alias gdiff='git diff --no-index'

if [[ -x $(command -v wt) ]]; then
  eval "$(wt config shell init bash)"
fi

function auto_commit() {
  local interval=${1:-300}
  while true; do
    if [[ -n "$(git status --porcelain)" ]]; then
      git add -A
      git commit -m "auto-save"
    fi
    sleep "$interval"
  done
}
# }}}

# python {{{
export PYTHONUNBUFFERED=True
export PYTHONDONTWRITEBYTECODE=True
export PIP_DISABLE_PIP_VERSION_CHECK=1

function venv() {
  local venv_dir="${1:-.venv}"

  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    source "${venv_dir}/Scripts/activate"
  else
    source "${venv_dir}/bin/activate"
  fi
}
# }}}

# go {{{
export GOPATH="${HOME}/go"
path_insert "${GOPATH}/bin"
# }}}

# misc {{{
export LESS="-R"
export MOSH_PREDICTION_DISPLAY=always
export QT_LOGGING_RULES='*=false'
export ANSIBLE_FORCE_COLOR=1
export GPG_TTY=$(tty)

try_source /usr/share/bash-completion/bash_completion  # Ubuntu compat
# }}}

# local {{{
try_source ~/.bashrc.local
try_source ~/.bash_aliases
# }}}
