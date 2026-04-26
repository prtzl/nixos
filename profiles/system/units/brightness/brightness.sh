action="${1:-}"
if [[ "$action" == "up" ]]; then
    brightnessctl set +10%
elif [[ "$action" == "down" ]]; then
    brightnessctl set 10%-
else
    errorstr='WRONG BRIGHTNESS CONTROL COMMAND, up OR down!'
    dunstify -a "brightness" "$errorstr"
    echo "$errorstr"
    exit 1
fi

currentBrightness="$(brightnessctl g)"
maxBrightness="$(brightnessctl m)"
currentBrightnessPercent=$(( currentBrightness * 100 / maxBrightness ))

dunstify -a "brightness" "display brightness: $currentBrightnessPercent%" \
    -t 1000 -r 8888 -h \
    int:value:"$currentBrightnessPercent"
