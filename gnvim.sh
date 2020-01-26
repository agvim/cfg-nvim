#!/bin/bash

# lauch kitty with no shortcuts and execute neovim
kitty -c ~/.config/kitty/kittygnvim.conf nvim $@ &
KITTYPID=$!

# wait for kitty to spawn nvim and get its PID
TARGETPID=""
while [ "$TARGETPID" = "" ]
do
    TARGETPID="$(pgrep -P "$KITTYPID" | tr -d '\n')"
    if [ $? -ne 0 ]
    then
        sleep 0.1
    fi
done

# get the window id
TARGETWINDOW=""
while [ "$TARGETWINDOW" = "" ]
do
    TARGETWINDOW="$(xargs --null --max-args=1 -a "/proc/$TARGETPID/environ" | grep WINDOWID | sed s/WINDOWID=//)"
    if [ $? -ne 0 ]
    then
        sleep 0.1
    fi
done

xseticon -id "$TARGETWINDOW" "$HOME/Pictures/neovim-icon.png" &
