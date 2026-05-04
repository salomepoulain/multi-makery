#!/bin/bash
# ============================================================================
#  HEAD CHEF: INSPO (List available stations from the agency)
# ============================================================================

# shellcheck source=../personality.sh
source "$(dirname "${BASH_SOURCE[0]}")/../personality.sh"

STARTER "LOOKING FOR INSPIRATION AT THE AGENCY..."

# Default to the stations repository if not set
REPO_URL="${MAKERY_STATIONS_REPO:-https://github.com/salomepoulain/makery-stations}"

SAY "Contacting the agency at $REPO_URL..."

# Use a temporary clone to see what's available
TMP_DIR=$(mktemp -d)
# We only need the top level list of folders
if ! git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMP_DIR" > /dev/null 2>&1; then
    SAY "Could not reach the agency."
fi

SAY "Available Line Cooks & Stations:"
cd "$TMP_DIR" || exit 1

# List directories from the stations/ folder
for dir in stations/*/; do
    if [ -d "$dir" ]; then
        station_name=$(basename "$dir")
        SAY "• $station_name"
    fi
done

cd - > /dev/null || exit
rm -rf "$TMP_DIR"

SAY "Hire one using: bake first <name>"

FINISHED
