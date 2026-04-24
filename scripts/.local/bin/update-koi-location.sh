#!/usr/bin/env sh

CONFIG_FILE="$HOME/.config/koirc"

# Get public IP
IP="$(curl -s https://ipinfo.io/ip)"
[ -z "$IP" ] && return 0

# Get location (format: lat,lon)
LOC="$(curl -s "https://ipinfo.io/${IP}/loc")"

# Split into latitude and longitude
LAT="$(printf '%s' "$LOC" | cut -d',' -f1)"
LON="$(printf '%s' "$LOC" | cut -d',' -f2)"

# Safety check
if [ -z "$LAT" ] || [ -z "$LON" ]; then
    echo "Failed to retrieve location"
    return 1
fi

sed -i -e "s/^latitude=.*/latitude=${LAT}/" -e "s/^longitude=.*/longitude=${LON}/" "$CONFIG_FILE" || return 1

unset CONFIG_FILE IP LOC LAT LON TMP
