#!/bin/bash
# ============================================================================
#  HEAD CHEF: FIRST (The Recruiter)
# ============================================================================

# --- Formatting Helpers ---
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

hr() { echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }
status() { echo -e "  [.] $1"; }
success() { echo -e "  ${GREEN}✓ $1${NC}"; }
warn() { echo -e "  ${YELLOW}⚠ $1${NC}"; }
error() { echo -e "  ${RED}✗ Error: $1${NC}"; exit 1; }

# --- validation ---
STATION_NAME="$1"
[ -z "$STATION_NAME" ] && error "Usage: bake first <station_name>"

STATION_DIR=".makery/kitchen/stations/$STATION_NAME"
STATIONS_REPO="${MAKERY_REGISTRY:-https://github.com/salomepoulain/makery-stations}"

hr
echo -e "${BLUE}  HIRING COOK & OPENING STATION: ${BOLD}$STATION_NAME${NC}"
hr

# --- Interactive Replacement Check ---
if [ -d "$STATION_DIR" ]; then
    echo -ne "  ${YELLOW}⚠ The '$STATION_NAME' cook is already at their station. Replace them? (y/N): ${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        status "Firing the current cook and clearing the station..."
        rm -rf "$STATION_DIR"
    else
        success "Keeping the current cook. No changes made."
        echo ""
        exit 0
    fi
fi

# --- Fetching ---
status "Fetching '$STATION_NAME' from the Registry..."
TMP_DIR=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse "$STATIONS_REPO" "$TMP_DIR" > /dev/null 2>&1 || error "Failed to contact Registry."

cd "$TMP_DIR" || exit 1
git sparse-checkout set "$STATION_NAME" > /dev/null 2>&1

if [ ! -d "$STATION_NAME" ]; then
    cd - > /dev/null
    rm -rf "$TMP_DIR"
    error "The '$STATION_NAME' station doesn't exist in the Registry."
fi

cd - > /dev/null
mkdir -p .makery/kitchen/stations
mv "$TMP_DIR/$STATION_NAME" ".makery/kitchen/stations/"
rm -rf "$TMP_DIR"

success "The new cook has arrived."

# --- 1. Dependencies ---
if [ -f "$STATION_DIR/cook/.prerequisite" ]; then
    status "Checking personal tools..."
    while IFS= read -r dep || [ -n "$dep" ]; do
        [[ -z "$dep" || "$dep" == "#"* ]] && continue
        if ! command -v "$dep" &> /dev/null; then
            echo -e "      ${RED}✗ Missing:${NC} $dep"
            rm -rf "$STATION_DIR"
            error "Missing essential tools. Station setup aborted."
        else
            echo -e "      ${GREEN}✓ Found:${NC} $dep"
        fi
    done < "$STATION_DIR/cook/.prerequisite"
fi

# --- 2. Pantry (Static files) ---
if [ -d "$STATION_DIR/workbench/pantry" ]; then
    status "Unpacking pantry ingredients..."
    for item in "$STATION_DIR/workbench/pantry"/*; do
        [ -f "$item" ] || continue
        filename=$(basename "$item")
        if [ ! -e "$filename" ]; then
            cp "$item" "$filename"
            echo "      + Stocked: $filename"
        else
            echo "      ~ Already stocked: $filename"
        fi
    done
fi

# --- 3. Contraband ---
if [ -f "$STATION_DIR/workbench/.contraband" ]; then
    status "Hiding contraband..."
    touch .gitignore
    while IFS= read -r line || [ -n "$line" ]; do
        [[ -z "$line" || "$line" == "#"* ]] && continue
        if ! grep -Fxq "$line" .gitignore; then
            echo "$line" >> .gitignore
            echo "      + Hidden: $line"
        fi
    done < "$STATION_DIR/workbench/.contraband"
fi

# --- 4. Setup Script ---
if [ -f "$STATION_DIR/cook/hired.sh" ]; then
    if [ -f "$STATION_DIR/cook/personality.sh" ]; then
        source "$STATION_DIR/cook/personality.sh"
    fi

    if [ -n "$DIALOGUE_START" ]; then
        echo -e "  [.] The cook speaks: ${UNIFORM}\"${DIALOGUE_START}\"${NC}"
    else
        status "The cook is silently setting up..."
    fi
    bash "$STATION_DIR/cook/hired.sh"
fi

echo -e "\n${GREEN}  ✓ The '$STATION_NAME' Station is ready to bake!${NC}"
hr
echo ""
