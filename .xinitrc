compton &
sxhkd &
dunst &
nordvpn connect &
dropbox start &
xfce4-clipman &
nm-applet &

alias spotify="spotify --force-device-scale-factor=1.5"

xset r rate 200 40
xset m 20/12 0

setxkbmap -option altwin:swap_lalt_lwin
setxkbmap -option ctrl:nocaps
xmodmap ~/.Xmodmap

export BROWSER="brave.desktop"
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# ~/.fehbg &
nitrogen --set-scaled ~/Pictures/wallpaper.jpg

xrdb ~/.Xresources

exec i3
