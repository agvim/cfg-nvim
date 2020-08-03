#!/bin/bash

# check stdin or pipe
if [ -t 0 ]; then
    # lauch kitty with no shortcuts and execute neovim
    kitty -c ~/.config/kitty/kittygnvim.conf nvim "$@" &
    KITTYPID=$!
else
    # export PIPED="$(cat <&0)" # note that this has a kernel limitation as PIPED is expanded
    WRAPPERPID=$$
    # run with piped input
    kitty -c ~/.config/kitty/kittygnvim.conf /bin/sh -c "cat /proc/$WRAPPERPID/fd/0 | nvim $@" &
    KITTYPID=$!
fi

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
