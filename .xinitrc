picom &
sxhkd &
dunst &
flameshot &
dropbox start &
xfce4-clipman &
nm-applet &
blueman-applet &
copyq &
xflux -l 50.0 -g 19.94 -k 2000 &

dbus-update-activation-environment --systemd DISPLAY || echo "dbus-update-activation-environment not found"
eval $(/usr/bin/gnome-keyring-daemon --start) || echo "gnome-keyring-daemon not found or failed"
export SSH_AUTH_SOCK

xset r rate 200 40
xset m 20/12 0

setxkbmap pl
setxkbmap -option altwin:swap_lalt_lwin
setxkbmap -option ctrl:nocaps

exec i3
