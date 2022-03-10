# turn off the fish greeing
set fish_greeting

# set $PATH
fish_add_path -p ~/scripts
fish_add_path -p ~/work/nlp-scripts/bin
fish_add_path -p ~/.local/share/coursier/bin
fish_add_path -p ~/.local/bin
fish_add_path -p ~/projects/zowier
fish_add_path -p /usr/share/applications

# aliases
alias prod-vpn='sudo openfortivpn -c /etc/openfortivpn/admin'
alias vf='vifm'
alias vim='nvim'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias nix-flakes='nix --extra-experimental-features nix-command --extra-experimental-features flakes'

# prompt
set pure_color_git_branch "green"
set pure_color_virtualenv "yellow"

# pyenv-virtualenv support
# status is-login; and pyenv init --path | source
# status --is-interactive; and pyenv init - | source
# status --is-interactive; and pyenv virtualenv-init - | source

set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# make rofi work: https://github.com/nix-community/home-manager/issues/354
# set -x LOCALE_ARCHIVE (nix-build '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
set -x LOCALE_ARCHIVE "/nix/store/ahzi8gfj34762a0yccafanspwylqj1z4-glibc-locales-2.33-108/lib/locale/locale-archive"
set -x XDG_DATA_DIRS "/usr/share:/usr/local/share:$HOME/.local/share:$HOME/.nix-profile/share"

# set -x QT_STYLE_OVERRIDE Fusion
set -x QT_AUTO_SCREEN_SCALE_FACTOR 0

# direnv
set -x DIRENV_LOG_FORMAT ""

# gnome-keyring-daemon
set -x (gnome-keyring-daemon --start | string split "=")

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

# use VI bindings
fish_vi_key_bindings

source /home/porcupine/dotfiles/config/fish/zowie.fish
