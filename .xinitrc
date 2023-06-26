#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Disable (erroneous) HiDPI
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_FONT_DPI=96
xrdb -merge ~/.Xresources

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
nitrogen --restore

export XDG_CURRENT_DESKTOP="XFCE"
# exec gnome-session
# exec startkde
# exec startxfce4
#exec startdwm
#dbus-launch i3
exec i3
killall xss-lock
# ...or the Window Manager of your choice
