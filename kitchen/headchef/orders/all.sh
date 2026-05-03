#!/bin/bash
# ============================================================================
#  HEAD CHEF: ALL (Bake everything, overload the ovens)
# ============================================================================

# shellcheck source=../personality.sh
source "$(dirname "${BASH_SOURCE[0]}")/../personality.sh"

STARTER "BAKING ALL, EVERYONE IS COOKED... (Total Kitchen Destruction)"


KITCHEN_ROOT="$(dirname "${BASH_SOURCE[0]}")/../.."

echo -ne "  ${HC_COLOR}$HC_ICON${NC} Are you absolutely sure? The ovens will explode. (y/N) "
read -n 1 -r
echo 
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    SAY "You turned off the ovens. The kitchen is safe."
    exit 0
fi

# Run fired.sh on all cooks to ensure system changes are reverted first
SAY "Baking all chefs..."
for dir in "$KITCHEN_ROOT/stations"/*/; do
    if [ ! -d "$dir" ]; then continue; fi
    STATION_NAME=$(basename "$dir")
    if [ -f "$dir/cook/contract/fired.sh" ]; then
        SAY "Teardown protocol at the '$STATION_NAME' station (running fired.sh)..."
        bash "$dir/cook/contract/fired.sh"
    fi
done

SAY "The ovens have overloaded! Everything is blowing up!"
rm -rf "$KITCHEN_ROOT/stations"

SAY "The menu and the front door are gone..."
rm -f bake
rm -f Makefile.thin

SAY "The Bakery has burned to the ground."
FINISHED
