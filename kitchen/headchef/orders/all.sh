#!/bin/bash
# ============================================================================
#  HEAD CHEF: ALL (Bake everything, overload the ovens)
# ============================================================================

echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;31m  BAKING ALL COOKS AT ONCE 💥 (Total Kitchen Destruction) \033[0m"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

read -p "Are you absolutely sure you want to bake everything at once? The ovens will explode. (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "  [.] You turned off the ovens. The kitchen is safe."
    exit 0
fi

# Run quit.sh on all cooks to ensure system changes are reverted first
echo "  [.] The Head Chef has lost their mind. Baking all chefs..."
for dir in .makery/kitchen/stations/*/; do
    if [ ! -d "$dir" ]; then continue; fi
    STATION_NAME=$(basename "$dir")
    if [ -f "$dir/cook/quit.sh" ]; then
        echo "  [.] Teardown protocol at the '$STATION_NAME' station (running quit.sh)..."
        bash "$dir/cook/quit.sh"
    fi
done

echo "  [.] The ovens have overloaded! The .makery is blowing up!"
rm -rf .makery/

echo "  [.] The menu and the front door are gone..."
rm -f bake
rm -f Makefile.thin

echo -e "\n\033[1;32m  ✓ The Restaurant has burned to the ground.\033[0m"
echo -e "\033[1;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
