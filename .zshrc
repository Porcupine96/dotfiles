# General {{{

# language and encoding settings
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# shortcut to this dotfiles path is $ZSH
export ZSH=$HOME/.dotfiles

# your project folder that we can `c [tab]` to
export PROJECTS=~/Development

setopt extended_glob

# source every .zsh file in this rep
for config_file ($ZSH/**^external/*.zsh) source $config_file

# use .localrc for SUPER SECRET CRAP that you don't
# want in your public, versioned repo.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# load every completion after autocomplete loads
for config_file ($ZSH/**^external/completion.sh) source $config_file

#if which tmux 2>&1 >/dev/null; then
#  test -z "$TMUX" && tmux new-session && exit
#fi

unsetopt ignoreeof

export VISUAL=nvim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# }}}

# Alias {{{

# Tmux
alias tat='tmux new-session -As $(basename "$PWD" | tr . -)' # will attach if session exists, or create a new session
alias tmuxsrc="tmux source-file ~/.tmux.conf"
alias tmuxkillall="tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}" # tmux kill all sessions
alias tmuxkillunnamed="tmux ls | cut -d : -f 1 | grep '\d' | xargs -I {} tmux kill-session -t {}" # tmux kill unnamed sessions

# Python
alias python2="python"
alias python="python3"

# Java
alias useJava8="export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home"
alias useJava9="export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-9.0.1.jdk/Contents/Home"

# Scala + Bloop
alias bcw="bloop compile --watch $(basename "$PWD")"

# Git
alias gpp="git pull --no-edit && git push"

# Spotify
alias sp="spotify play"
alias spa="spotify play album"
alias spar="spotify play artist"

# Ranger
alias r=ranger

# Misc
alias ls="exa"

# Emacs
alias ecd="emacs --daemon"

# Docker
alias docker-clean-containers='docker container stop $(docker container ls -a -q) && docker container rm $(docker container ls -a -q)'
alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='docker stop $(docker container ls -a -q) && docker system prune -a -f --volumes'

# }}}

# Plugins {{{

plugins=(
    git
    wd
)

fpath=(~/path/to/wd $fpath)

# }}}

# Misc {{{

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
wd() {
  . /Users/porcupine/bin/wd/wd.sh
}

# Use Java8 by defaule
useJava8

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/porcupine/tool/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/porcupine/tool/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/porcupine/tool/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/porcupine/tool/google-cloud-sdk/completion.zsh.inc'; fi

# Python specific configuration
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# }}}

# Function {{{

vf() { fzf | xargs nvim; }

# }}}

# Exports {{{

# LLVM
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"

# Go
export GOPATH=/usr/local/go/src

# FZF.vim configuraion
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Racket
# TODO: move to .profile
export PATH=$PATH:~/.local/bin:/Applications/Racket\ v7.3/bin

# }}}
