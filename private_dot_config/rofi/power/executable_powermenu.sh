#!/bin/bash

## Author : Aditya Shakya (adi1090x)
## Mail : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x

# Available Styles
# >> Styles Below Only Works With "rofi-git(AUR)", Current Version: 1.5.4-76-gca067234
# full     full_circle     full_rounded     full_alt
# card     card_circle     column     column_circle
# row     row_alt     row_circle
# single     single_circle     single_full     single_full_circle     single_rounded     single_text

style="column_circle"

rofi_command="rofi -theme power/$style.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

# Options
shutdown=""
reboot=""
logout=""
dir="$HOME/.config/rofi/power"

# Variable passed to rofi
options="$shutdown\n$reboot\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
		ans=$($dir/confirm.sh)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
        systemctl poweroff
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
        exit
        else
        rofi -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
        fi
        ;;
    $reboot)
		ans=$($dir/confirm.sh)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
        systemctl reboot
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
        exit
        else
        rofi -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
        fi
        ;;
    $logout)
		ans=$($dir/confirm.sh)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
        # Compositor-aware logout. This was `bspc quit`, a bspwm command that
        # silently does NOTHING under Hyprland -- the menu entry looked like it
        # worked and the session stayed up. Fixed 2026-08-26.
        if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
            if command -v uwsm >/dev/null 2>&1; then
                # uwsm-managed: let uwsm unwind the systemd units.
                uwsm stop 2>/dev/null || hyprctl dispatch 'hl.dsp.exit()'
            else
                hyprctl dispatch 'hl.dsp.exit()'
            fi
        elif pgrep -x bspwm >/dev/null 2>&1; then
            bspc quit
        else
            # Last resort: end every session belonging to this user.
            loginctl terminate-user "$USER"
        fi
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
        exit
        else
        rofi -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
        fi
        ;;
esac
