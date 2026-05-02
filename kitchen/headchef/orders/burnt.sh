#!/bin/bash
# ============================================================================
#  HEAD CHEF: BURNT (Tear down a Station)
# ============================================================================

echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;31m  FIRING COOK & CLOSING STATION: $1 \033[0m"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

if [ -z "$1" ]; then
    echo -e "\033[1;31mError: You didn't tell me which station to tear down.\033[0m"
    echo "Usage: ./bake burnt R=<station_name>"
    exit 1
fi

STATION_NAME="$1"
STATION_DIR=".makery/kitchen/stations/$STATION_NAME"

if [ ! -d "$STATION_DIR" ]; then
    echo -e "\033[1;33mThe '$STATION_NAME' station doesn't even exist.\033[0m"
    exit 0
fi

# 1. The Teardown Script (System Purge)
if [ -f "$STATION_DIR/cook/fired.sh" ]; then
    # Load personality if it exists
    if [ -f "$STATION_DIR/cook/personality.sh" ]; then
        source "$STATION_DIR/cook/personality.sh"
    fi

    if [ -n "$DIALOGUE_QUIT" ]; then
        echo -e "  [.] The cook speaks: ${UNIFORM}\"${DIALOGUE_QUIT}\"\033[0m"
    else
        echo "  [.] The cook is silently tearing down their system links..."
    fi

    bash "$STATION_DIR/cook/fired.sh"
fi

# 2. Local Cleanup
if [ -f "$STATION_DIR/workbench/.dishsoap" ]; then
     echo "  [.] Scrubbing the workbench before tearing it down..."
     while IFS= read -r path_to_clean || [ -n "$path_to_clean" ]; do
        if [[ -z "$path_to_clean" || "$path_to_clean" == \#* ]]; then continue; fi
        if [ -e "$path_to_clean" ]; then
            rm -rf "$path_to_clean"
            echo "      - Wiped: $path_to_clean"
        fi
    done < "$STATION_DIR/workbench/.dishsoap"
fi

# 3. Delete
echo "  [.] Demolishing the physical station..."
rm -rf "$STATION_DIR"

echo -e "\n\033[1;32m  ✓ The '$STATION_NAME' cook is permanently fired and their station is closed.\033[0m"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
