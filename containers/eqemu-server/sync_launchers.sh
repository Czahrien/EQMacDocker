#!/bin/bash
# Apply DYNAMIC_ZONES and STATIC_ZONES to the launcher tables, then run the
# given command. World reads the launcher tables only when it starts, so this
# runs in the world container just before world.
set -euo pipefail

DYNAMIC_LAUNCHER=dynzone1
DYNAMIC_ZONES=${DYNAMIC_ZONES:-10}
LAUNCHER=static
PORT_START=${STATIC_ZONE_PORT_START:-7401}
PORT_END=${STATIC_ZONE_PORT_END:-7425}

export MYSQL_PWD="$DATABASE_PASSWORD"
sql() {
    mariadb -h db -u "$DATABASE_USER" -N -B "$DATABASE_NAME" -e "$1"
}

# World names dynamic zones dynamic_01 through dynamic_254.
if [[ ! "$DYNAMIC_ZONES" =~ ^[0-9]+$ ]] || (( DYNAMIC_ZONES > 254 )); then
    echo "DYNAMIC_ZONES: must be a number from 0 to 254, got [$DYNAMIC_ZONES]" >&2
    exit 1
fi

zones=()
IFS=', ' read -ra items <<< "${STATIC_ZONES:-}"
for zone in "${items[@]}"; do
    zone=${zone,,}
    if [[ ! "$zone" =~ ^[a-z0-9_]+$ ]]; then
        echo "STATIC_ZONES: invalid zone name [$zone]" >&2
        exit 1
    fi
    if [[ " ${zones[*]} " != *" $zone "* ]]; then
        zones+=("$zone")
    fi
done

if (( ${#zones[@]} > 0 )); then
    in_list="'$(IFS=,; echo "${zones[*]}" | sed "s/,/','/g")'"

    known=$(sql "SELECT short_name FROM zone WHERE short_name IN ($in_list)")
    for zone in "${zones[@]}"; do
        if ! grep -qx "$zone" <<< "$known"; then
            echo "STATIC_ZONES: unknown zone [$zone]" >&2
            exit 1
        fi
    done

    boats=$(sql "SELECT zone FROM launcher_zones WHERE launcher = 'boats' AND zone IN ($in_list)")
    if [ -n "$boats" ]; then
        echo "STATIC_ZONES: already run by the boats launcher: $(echo $boats)" >&2
        exit 1
    fi

    if (( PORT_START + ${#zones[@]} - 1 > PORT_END )); then
        echo "STATIC_ZONES: ${#zones[@]} zones do not fit in ports $PORT_START-$PORT_END" >&2
        exit 1
    fi
fi

echo "Dynamic zones: [$DYNAMIC_ZONES]"
statements="INSERT INTO launcher (name, dynamics) VALUES ('$DYNAMIC_LAUNCHER', $DYNAMIC_ZONES)
    ON DUPLICATE KEY UPDATE dynamics = $DYNAMIC_ZONES;
INSERT INTO launcher (name, dynamics) VALUES ('$LAUNCHER', 0)
    ON DUPLICATE KEY UPDATE dynamics = 0;
DELETE FROM launcher_zones WHERE launcher = '$LAUNCHER';"
port=$PORT_START
for zone in "${zones[@]}"; do
    statements+="
INSERT INTO launcher_zones (launcher, zone, port, enabled) VALUES ('$LAUNCHER', '$zone', $port, 1);"
    echo "Static zone [$zone] on port [$port]"
    port=$((port + 1))
done
sql "$statements"

exec "$@"
