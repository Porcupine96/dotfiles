# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/lukaszkazmierczak/.zsh/completions:"* ]]; then export FPATH="/Users/lukaszkazmierczak/.zsh/completions:$FPATH"; fi
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#

export ZVM_INIT_MODE=sourcing
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/$HOME/.npm-global/bin"
export PATH="$PATH:/Users/lukaszkazmierczak/Library/Application Support/Coursier/bin"
export PATH="$HOME/.local/bin:$PATH"
#export GOOGLE_APPLICATION_CREDENTIALS="$HOME/work/prod-ansible/credentials/vertex-ai.json"
export FZF_PATH=/opt/homebrew/opt/fzf
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"
export CPATH="/opt/homebrew/include:$CPATH"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Cache brew prefix for faster startup
BREW_PREFIX=$(brew --prefix)

# Only source bash_profile if it exists and contains content
[[ -s ~/.bash_profile ]] && source ~/.bash_profile

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    docker
    git
    z
  # zsh-vi-mode
)



source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias mid="mirrord exec -f .mirrord/mirrord.json -- sbt -J-Xmx4096M -mem 8129 \"~creator-genai-gateway/run\""
alias keu="k9s --context zowie-prod-eu1 -n app-prod-eu1"
alias kus="k9s --context zowie-prod-us1 -n app-prod-us1"
alias kze1="k9s --context zowie-dev -n sl-dev-zowie-engine1"
alias kze2="k9s --context zowie-dev -n sl-dev-zowie-engine2"
alias kze3="k9s --context zowie-dev -n sl-dev-zowie-engine3"
alias kzem="k9s --context zowie-dev -n sl-dev-zem"
alias kmain="k9s --context zowie-dev -n sl-dev-main-ll"
alias k="kubectx"
alias kn="kubens"
alias gs="git status"
alias pc="pclaude --allow-dangerously-skip-permissions --dangerously-skip-permissions"

alias prod-vpn='sudo openfortivpn -c /etc/openfortivpn/admin'
#alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
#alias j11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version"
#alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
#alias j21="export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version"

alias argoz='bash ~/dotfiles/scripts/argoz.sh'
alias argos='bash ~/dotfiles/scripts/argos.sh'

alias copyq="/Applications/CopyQ.app/Contents/MacOS/CopyQ"

alias slurm="ssh lkazmierczak@10.149.156.60"

alias gemini="~/.nvm/versions/node/v22.14.0/bin/gemini"

alias wt="webtorrent download"

# set the default java version
# export JAVA_HOME=$(/usr/libexec/java_home -v 11)
#export JAVA_HOME=$(/usr/libexec/java_home -v 17)

fpath+=("$BREW_PREFIX/share/zsh/site-functions")

autoload -U promptinit; promptinit
prompt pure

# >>> scala-cli completions >>>
fpath=("/Users/lukaszkazmierczak/Library/Application Support/ScalaCli/completions/zsh" $fpath)
# Cache compinit for faster startup
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi
# <<< scala-cli completions <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lukaszkazmierczak/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/lukaszkazmierczak/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/lukaszkazmierczak/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/lukaszkazmierczak/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

source $BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "${FZF_PATH}/shell/key-bindings.zsh"

bindkey -s ^f "tmux-sessionizer\n"

# disable bindkey

export PATH="$PATH:/Users/lukaszkazmierczak/Library/Application Support/Coursier/bin"
export PATH="$PATH:/Users/lukaszkazmierczak/dotfiles/scripts"
export PATH="$PATH:/Users/lukaszkazmierczak/projects/watcher/bin"
export PATH="$PATH:/Library/TeX/texbin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# >>> conda initialize (lazy-loaded) >>>
__conda_lazy_load() {
    unset -f conda
    unset -f __conda_lazy_load
    __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    conda "$@"
}
conda() {
    __conda_lazy_load "$@"
}
# <<< conda initialize <<<

# Lazy load NVM for faster startup
export NVM_DIR="$HOME/.nvm"
_nvm_resolve=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
while [[ -f "$NVM_DIR/alias/$_nvm_resolve" ]]; do
  _nvm_resolve=$(cat "$NVM_DIR/alias/$_nvm_resolve")
done
export PATH="$NVM_DIR/versions/node/$_nvm_resolve/bin:$PATH"
unset _nvm_resolve
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}
node() {
    unset -f node
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unset -f npm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# pnpm
export PNPM_HOME="/Users/lukaszkazmierczak/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
. "/Users/lukaszkazmierczak/.deno/env"

# opencode
export PATH=/Users/lukaszkazmierczak/.opencode/bin:$PATH

eval "$(direnv hook zsh)"

fpath+=~/.zfunc; autoload -Uz compinit; compinit
