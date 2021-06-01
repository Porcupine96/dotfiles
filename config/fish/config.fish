# turn off the fish greeing
set fish_greeting

# set $PATH
fish_add_path -p ~/scripts
fish_add_path -p ~/work/nlp-scripts/bin

# aliases
alias prod-vpn='sudo openfortivpn -c /etc/openfortivpn/admin'
alias vf='vifm'
alias vim='nvim'
alias gp='git push'

# prompt
set pure_color_git_branch "green"
set pure_color_virtualenv "yellow"

# pyenv-virtualenv support
status is-login; and pyenv init --path | source
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

# keychain
status --is-interactive; and keychain --quiet --agents ssh --eval ~/.ssh/id_rsa | source

# vterm configuration
function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end 
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

function vterm_cmd --description 'Run an Emacs command among the ones been defined in vterm-eval-cmds.'
    set -l vterm_elisp ()
    for arg in $argv
        set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
    end
    vterm_printf '51;E'(string join '' $vterm_elisp)
end

