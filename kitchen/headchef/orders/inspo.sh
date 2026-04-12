#!/bin/bash
# ============================================================================
#  HEAD CHEF: INSPO (List available stations from the agency)
# ============================================================================

echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;34m  LOOKING FOR INSPIRATION AT THE AGENCY... \033[0m"
echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

# Default to the stations repository if not set
REPO_URL="${MAKERY_STATIONS_REPO:-https://github.com/salomepoulain/makery-stations}"

echo "  [.] Contacting the agency at $REPO_URL..."

# Use a temporary clone to see what's available
TMP_DIR=$(mktemp -d)
# We only need the top level list of folders
git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMP_DIR" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "\033[1;31mError: Could not reach the agency.\033[0m"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "\n\033[1mAvailable Line Cooks & Stations:\033[0m"
cd "$TMP_DIR" || exit 1

# List directories (excluding hidden ones like .git)
# We assume stations are at the root of the stations repo
for dir in */; do
    if [ -d "$dir" ] && [[ "$dir" != .* ]]; then
        station_name=$(basename "$dir")
        echo -e "  \033[1;32m•\033[0m $station_name"
    fi
done

cd - > /dev/null
rm -rf "$TMP_DIR"

echo -e "\n\033[1;33m  Hire one using: bake first <name>\033[0m"
echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
