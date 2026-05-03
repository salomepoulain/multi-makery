#!/bin/bash
# ============================================================================
#  OPEN MAKE (Kitchen setup for make users)
# ============================================================================
# This script initializes a kitchen for projects using `make` directly.
# A Makefile with makery includes will be created in your project.
# ============================================================================

# Determine where this script lives so we can find the kitchen
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAKERY_HOME="$(dirname "$SCRIPT_DIR")"

echo -e "\033[1;34m  LAYING THE FOUNDATION (Make Setup)... \033[0m"

# 1. Bring the Head Chef to this specific project
mkdir -p .makery/kitchen
cp -r "$MAKERY_HOME/kitchen/headchef" ".makery/kitchen/"

# 2. Create a Makefile with makery includes
if [ ! -f "Makefile" ]; then
    echo "  Creating Makefile with makery hooks..."
    cat << 'EOF' > Makefile
.PHONY: menu first burnt germs fresh all call

-include .makery/kitchen/headchef/menu.mk
-include .makery/kitchen/stations/*/menu.mk

# Default goal: show the menu
.DEFAULT_GOAL := menu
EOF
else
    # Hook into existing Makefile if necessary
    if ! grep -q "\.makery/kitchen/headchef/menu\.mk" Makefile; then
        echo "  Adding Makery hooks to existing Makefile..."
        {
            echo -e "\n# --- MAKERY HOOKS ---"
            echo "-include .makery/kitchen/headchef/menu.mk"
            echo "-include .makery/kitchen/stations/*/menu.mk"
        } >> Makefile
    fi
fi

# 3. Set permissions for the Head Chef's orders
chmod +x .makery/kitchen/headchef/orders/*.sh

# 4. Hide the kitchen from Git
if [ -f ".gitignore" ]; then
    if ! grep -q "^\.makery/$" .gitignore; then
        echo -e "\n# --- MAKERY ---" >> .gitignore
        echo ".makery/" >> .gitignore
    fi
else
    echo ".makery/" > .gitignore
fi

# 5. Safety check: Ensure no local 'bake' file clutters the workspace
rm -f bake 2>/dev/null

echo -e "\033[1;32m  ✓ Local kitchen is open and ready.\033[0m"