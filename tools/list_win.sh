#!/bin/sh
#wmctrl -l | grep "0x[a-z0-9]*  0" | sed "s|.* $(hostname) \([a-zA-Z /0-9\-]*\)|\1|" \
#  | dmenu -l 10 -i -b -fa "Lihei Pro-10" -nb "#0a0a0a" -nf "#a0a0a0" -sb "#285577" -sf "#ffffff" -i -b -p "Goto: " \
#  | xargs wmctrl -a
LINE=`wmctrl -l | wc -l`  
#wmctrl -l | cut -d' ' -f5- | dmenu -l $LINE -nb '#3f3f3f' -nf '#dcdccc' -sf '#3f3f3f' -sb '#dcdccc' -i | xargs wmctrl -a
wmctrl -l | cut -d' ' -f5- | dmenu -l $LINE -fn "Droid Sans Fallback-15" -nb '#0a0a0a' -nf '#a0a0a0' -sf '#fff' -sb '#285577' -i -p "Goto> " | xargs wmctrl -a
#wmctrl -l | cut -d' ' -f5- | dmenu -l $LINE -nb '#0a0a0a' -nf '#a0a0a0' -sf '#fff' -sb '#285577' -i -p "Goto> " | xargs wmctrl -a
