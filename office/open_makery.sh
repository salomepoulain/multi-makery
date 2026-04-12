#!/bin/bash
# ============================================================================
#  OPEN MAKERY (Bootstrap / Install Script)
# ============================================================================
# Usage:
#   bash open_makery.sh make  -> Local project setup
#   bash open_makery.sh bake  -> Global system install

MODE=$1
REPO_URL="${MAKERY_REPO:-https://github.com/salomepoulain/multi-makery}"

setup_local() {
    echo -e "\033[1;34m  LAYING THE CONCRETE (Local Setup)... \033[0m"    
    
    TMP_DIR=$(mktemp -d)
    git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMP_DIR" > /dev/null 2>&1
    cd "$TMP_DIR" || exit 1
    git sparse-checkout set "kitchen/headchef" "office" > /dev/null 2>&1
    cd - > /dev/null
    
    mkdir -p .makery/kitchen
    cp -r "$TMP_DIR/kitchen/headchef" ".makery/kitchen/"
    cp -r "$TMP_DIR/office" ".makery/"
    rm -rf "$TMP_DIR"

    # Handle Makefile
    if [ ! -f "Makefile" ]; then
        echo "  [.] Creating new Makefile..."
        cat << 'EOF' > Makefile
.PHONY: menu first burnt germs fresh all concrete

# Include the Head Chef's core menu
-include .makery/kitchen/headchef/menu.mk

# Include all station menus
-include .makery/kitchen/stations/*/menu.mk

# Default goal: show the menu
.DEFAULT_GOAL := menu
EOF
    else
        if ! grep -q ".makery/kitchen/headchef/menu.mk" Makefile; then
            echo "  [.] Adding Makery hooks to existing Makefile..."
            echo -e "\n# --- MAKERY HOOKS ---" >> Makefile
            echo "-include .makery/kitchen/headchef/menu.mk" >> Makefile
            echo "-include .makery/kitchen/stations/*/menu.mk" >> Makefile
        fi
    fi

    # Create local bake wrapper
    cat << 'EOF' > bake
#!/bin/bash
COMMAND="${1:-menu}"
STATION="$2"

case "$COMMAND" in
    first|burnt|fresh) 
        shift 2
        make -f Makefile "$COMMAND" s="$STATION" "$@"
        ;; 
    *)
        make -f Makefile "$COMMAND" "$@"
        ;; 
esac
EOF
    chmod +x bake
    chmod +x .makery/kitchen/headchef/orders/*.sh

    # 1. Automatic .gitignore for the Kitchen itself
    if [ -f ".gitignore" ]; then
        if ! grep -q "^\.makery/$" .gitignore; then
            echo "  [.] Hiding the kitchen (.makery/) from the Health Inspector..."
            echo -e "\n# --- MAKERY ---" >> .gitignore
            echo ".makery/" >> .gitignore
            echo "bake" >> .gitignore
        fi
    else
        echo ".makery/" > .gitignore
        echo "bake" >> .gitignore
    fi
}

install_global() {
    echo -e "\033[1;35m  BUILDING THE GLOBAL HEADQUARTERS... \033[0m"
    HQ_DIR="$HOME/.makery"
    BIN_DIR="$HOME/.local/bin"
    
    mkdir -p "$HQ_DIR"
    mkdir -p "$BIN_DIR"

    TMP_DIR=$(mktemp -d)
    git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TMP_DIR" > /dev/null 2>&1
    cd "$TMP_DIR" || exit 1
    git sparse-checkout set "kitchen/headchef" "office" > /dev/null 2>&1
    cd - > /dev/null
    
    cp -r "$TMP_DIR/kitchen" "$HQ_DIR/"
    cp -r "$TMP_DIR/office" "$HQ_DIR/"
    rm -rf "$TMP_DIR"

    # Install global bake command
    cat << 'EOF' > "$BIN_DIR/bake"
#!/bin/bash
# Global bake command
if [ -f "Makefile" ] && grep -q ".makery" Makefile; then
    COMMAND="${1:-menu}"
    STATION="$2"
    case "$COMMAND" in
        first|burnt|fresh)
            shift 2
            make -f Makefile "$COMMAND" s="$STATION" "$@"
            ;; 
        *)
            make -f Makefile "$COMMAND" "$@"
            ;; 
    esac
else
    COMMAND="${1:-concrete}"
    if [ "$COMMAND" == "concrete" ]; then
        # Check if we have a local office, otherwise use global HQ
        if [ -f ".makery/office/open_makery.sh" ]; then
            bash ".makery/office/open_makery.sh" make
        else
            bash "$HOME/.makery/office/open_makery.sh" make
        fi
    else
        echo "No kitchen found here. Type 'bake concrete' to lay the foundation."
    fi
fi
EOF
    chmod +x "$BIN_DIR/bake"
    
    echo -e "\n\033[1;32m  ✓ Global Makery installed to $BIN_DIR/bake\033[0m"
    echo "  (Make sure $BIN_DIR is in your PATH)"
}

case "$MODE" in
    make) setup_local ;; 
    bake) install_global ;; 
    *) echo "Usage: open_makery.sh [make|bake]"; exit 1 ;; 
esac
