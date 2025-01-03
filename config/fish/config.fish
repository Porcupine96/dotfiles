# turn off the fish greeing
set fish_greeting

# set $PATH
fish_add_path -p ~/scripts
fish_add_path -p ~/work/nlp-scripts/bin
fish_add_path -p ~/.local/share/coursier/bin
fish_add_path -p ~/.local/bin
fish_add_path -p /usr/share/applications
fish_add_path -p /home/porcupine/.nix-profile/bin

# aliases
alias prod-vpn='sudo openfortivpn -c /etc/openfortivpn/admin'
alias dev-vpn='sudo openvpn /etc/openvpn/client.ovpn'
alias k='kubectl'
alias l='ls -alih'
alias vf='vifm'
alias vim='nvim'
alias gp='git push'
alias gl='git pull'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias gs='git status'
alias nix-flakes='nix --extra-experimental-features nix-command --extra-experimental-features flakes'
alias metals-emacs='metals'

# prompt
set pure_color_git_branch "green"
set pure_color_virtualenv "yellow"

set --universal pure_color_system_time pure_color_mute
set --universal pure_show_system_time true

set pure_symbol_prompt "λ"
set pure_symbol_reverse_prompt "N"

set -x XDG_CONFIG_HOME "/home/porcupine/.config"

# set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x LC_ALL "en_US.UTF-8"

# make rofi work: https://github.com/nix-community/home-manager/issues/354
# set -x LOCALE_ARCHIVE (nix-build '<nixpkgs>' -A glibcLocales)/lib/locale/locale-archive
set -x LOCALE_ARCHIVE "/nix/store/9wsgngjxqir8gyw4ppwn66nzb8vjk1l5-glibc-locales-2.34-210/lib/locale/locale-archive"
set -x XDG_DATA_DIRS "/usr/share:/usr/local/share:$HOME/.local/share:$HOME/.nix-profile/share"

set -x QT_QPA_PLATFORM "wayland"
set -x QT_AUTO_SCREEN_SCALE_FACTOR 0

set -x GTK_USE_PORTAL 0

# fcitx for Japanese
set -x GTK_IM_MODULE 'fcitx'
set -x QT_IM_MODULE 'fcitx'
set -x SDL_IM_MODULE 'fcitx'
set -x XMODIFIERS '@im=fcitx'

# for kitty to work with fcitx
set -x GLFW_IM_MODULE 'ibus'

# direnv
set -x DIRENV_LOG_FORMAT ""

# gnome-keyring-daemon
# set -x (gnome-keyring-daemon --start | string split "=")

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

function vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@porcupine-work:'(pwd)
end
functions --copy fish_prompt vterm_old_fish_prompt
function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
    # Remove the trailing newline from the original prompt. This is done
    # using the string builtin from fish, but to make sure any escape codes
    # are correctly interpreted, use %b for printf.
    printf "%b" (string join "\n" (vterm_old_fish_prompt))
    vterm_prompt_end
end
# use VI bindings
fish_vi_key_bindings

# set -Ux PYENV_ROOT $HOME/.pyenv
# fish_add_path $PYENV_ROOT/bin
# pyenv init - | source
# pyenv virtualenv-init - | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/lukaszkazmierczak/anaconda3/bin/conda
    eval /Users/lukaszkazmierczak/anaconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/Users/lukaszkazmierczak/anaconda3/etc/fish/conf.d/conda.fish"
        . "/Users/lukaszkazmierczak/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/Users/lukaszkazmierczak/anaconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

