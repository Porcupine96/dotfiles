picom &
sxhkd &
dunst &
flameshot &
dropbox start &
xfce4-clipman &
nm-applet &
blueman-applet &
copyq &

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh) || echo "gnome-keyring-daemon not found or failed"

xset r rate 200 40
xset m 20/12 0

setxkbmap pl
setxkbmap -option altwin:swap_lalt_lwin
setxkbmap -option ctrl:nocaps

exec i3
