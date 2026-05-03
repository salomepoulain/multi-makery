#!/bin/bash
# ============================================================================
#  HEAD CHEF: BURNT (Tear down a Station)
# ============================================================================

source "$(dirname "${BASH_SOURCE[0]}")/../personality.sh"

if [ -z "$1" ]; then
    error "You didn't tell me which station to tear down."
fi

STATION_NAME="$1"
KITCHEN_ROOT="$(dirname "${BASH_SOURCE[0]}")/../.."
STATION_DIR="$KITCHEN_ROOT/stations/$STATION_NAME"

if [ ! -d "$STATION_DIR" ]; then
    SAY "The '$STATION_NAME' station doesn't even exist."
    exit 0
fi

STARTER "BAKING BURNT $STATION_NAME"

# 1. The Teardown Script (System Purge)
if [ -f "$STATION_DIR/cook/contract/fired.sh" ]; then
    # Load personality if it exists
    if [ -f "$STATION_DIR/cook/personality.sh" ]; then
        source "$STATION_DIR/cook/personality.sh"
    fi

    bash "$STATION_DIR/cook/contract/fired.sh"
fi

# 2. Local Cleanup
if [ -f "$STATION_DIR/workbench/.dishsoap" ]; then
     SAY "Scrubbing the workbench before tearing it down..."
     while IFS= read -r path_to_clean || [ -n "$path_to_clean" ]; do
        if [[ -z "$path_to_clean" || "$path_to_clean" == \#* ]]; then continue; fi
        if [ -e "$path_to_clean" ]; then
            rm -rf "$path_to_clean"
            SAY "- Wiped: $path_to_clean"
        fi
    done < "$STATION_DIR/workbench/.dishsoap"
fi

# 3. Delete
SAY "Demolishing the physical station..."
rm -rf "$STATION_DIR"

SAY "The '$STATION_NAME' cook is permanently fired and their station is closed."
DONE
