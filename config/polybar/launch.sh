#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log /tmp/polybar4.log
polybar rwspace >>/tmp/polybar1.log 2>&1 &
polybar rclock >>/tmp/polybar2.log 2>&1 &
polybar rdate >>/tmp/polybar4.log 2>&1 &

echo "Polybar launched..."
