#!/bin/bash
# ============================================================================
#  HEAD CHEF: FIRST (Open a Station)
# ============================================================================

echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;34m  HIRING COOK & OPENING STATION: $1 \033[0m"
echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

if [ -z "$1" ]; then
    echo -e "\033[1;31mError: You didn't tell me which station to open.\033[0m"
    echo "Usage: bake first <station_name>"
    exit 1
fi

STATION_NAME="$1"
STATION_DIR=".makery/kitchen/stations/$STATION_NAME"
STATIONS_REPO="${MAKERY_REGISTRY:-https://github.com/salomepoulain/makery-stations}"

if [ -d "$STATION_DIR" ]; then
    echo -e "\033[1;33mThe '$STATION_NAME' station is already open.\033[0m"
    exit 0
fi

echo "  [.] Head Chef is fetching the '$STATION_NAME' station from the Registry..."
TMP_DIR=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse "$STATIONS_REPO" "$TMP_DIR" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "\033[1;31mError: Failed to contact the registry ($STATIONS_REPO).\033[0m"
    rm -rf "$TMP_DIR"
    exit 1
fi

cd "$TMP_DIR" || exit 1
git sparse-checkout set "$STATION_NAME" > /dev/null 2>&1

if [ ! -d "$STATION_NAME" ]; then
    echo -e "\033[1;31mError: The '$STATION_NAME' station doesn't exist in the registry.\033[0m"
    cd - > /dev/null
    rm -rf "$TMP_DIR"
    exit 1
fi

cd - > /dev/null
mkdir -p .makery/kitchen/stations
mv "$TMP_DIR/$STATION_NAME" ".makery/kitchen/stations/"
rm -rf "$TMP_DIR"

echo -e "\033[1;32m  ✓ The '$STATION_NAME' cook has arrived at their new station.\033[0m"

# 1. Dependencies
if [ -f "$STATION_DIR/cook/.prerequisite" ]; then
    echo "  [.] Checking if the cook has their required personal tools..."
    MISSING_DEPS=0
    while IFS= read -r dep || [ -n "$dep" ]; do
        # FIXED: Added quotes around the #
        if [[ -z "$dep" || "$dep" == "#"* ]]; then continue; fi
        
        if ! command -v "$dep" &> /dev/null; then
            echo -e "      \033[1;31m✗ Missing:\033[0m $dep"
            MISSING_DEPS=$((MISSING_DEPS + 1))
        else
            echo -e "      \033[1;32m✓ Found:\033[0m $dep"
        fi
    done < "$STATION_DIR/cook/.prerequisite"

    if [ $MISSING_DEPS -gt 0 ]; then
        echo -e "\n\033[1;31mError: Missing essential tools. Firing the cook and tearing down their station.\033[0m"
        rm -rf "$STATION_DIR"
        exit 1
    fi
fi

# 2. Pantry (Static files)
if [ -d "$STATION_DIR/workbench/pantry" ]; then
    echo "  [.] The cook is unpacking ingredients from the pantry onto the workbench..."
    for item in "$STATION_DIR/workbench/pantry"/*; do
        if [ -f "$item" ]; then
            filename=$(basename "$item")
            if [ ! -e "$filename" ]; then
                cp "$item" "$filename"
                echo "      + Stocked: $filename"
            else
                echo "      ~ Already stocked: $filename"
            fi
        fi
    done
fi

# 3. .contraband
if [ -f "$STATION_DIR/workbench/.contraband" ]; then
    echo "  [.] The cook is hiding their contraband under the workbench..."
    touch .gitignore
    while IFS= read -r line || [ -n "$line" ]; do
        # FIXED: Added quotes around the #
        if [[ -z "$line" || "$line" == "#"* ]]; then continue; fi
        
        if ! grep -Fxq "$line" .gitignore; then
            echo "$line" >> .gitignore
            echo "      + Hidden: $line"
        fi
    done < "$STATION_DIR/workbench/.contraband"
fi

# 4. Setup Script
if [ -f "$STATION_DIR/cook/start.sh" ]; then
    if [ -f "$STATION_DIR/cook/personality.sh" ]; then
        source "$STATION_DIR/cook/personality.sh"
    fi

    if [ -n "$DIALOGUE_START" ]; then
        echo -e "  [.] The cook speaks: ${UNIFORM}\"${DIALOGUE_START}\"\033[0m"
    else
        echo "  [.] The cook is silently setting up their workbench..."
    fi

    bash "$STATION_DIR/cook/start.sh"
fi

echo -e "\n\033[1;32m  ✓ The '$STATION_NAME' Station is ready to bake!\033[0m"
echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
