#!/bin/bash
# ============================================================================
#  GLOBAL INSTALLER (Run once via URL)
# ============================================================================

REPO_URL="https://github.com/salomepoulain/multi-makery"
HQ_DIR="$HOME/.makery"
BIN_DIR="$HOME/.local/bin"

echo -e "\033[1;35m  BUILDING GLOBAL MAKERY HEADQUARTERS... \033[0m"

mkdir -p "$HQ_DIR"
mkdir -p "$BIN_DIR"

# 1. Download the engine to Headquarters
TMP_DIR=$(mktemp -d)
git clone --depth 1 "$REPO_URL" "$TMP_DIR" > /dev/null 2>&1
cp -r "$TMP_DIR/kitchen" "$HQ_DIR/"
cp -r "$TMP_DIR/office" "$HQ_DIR/"
rm -rf "$TMP_DIR"

# 2. Create the global 'bake' command
cat << 'EOF' > "$BIN_DIR/bake"
#!/bin/bash
# Global bake command router

if [ -f "Makefile" ] && grep -q "\.makery" Makefile; then
    # --- PROJECT MODE ---
    COMMAND="${1:-menu}"
    STATION="$2"
    case "$COMMAND" in
        first|burnt|fresh|germs)
            shift 2
            make -f Makefile "$COMMAND" s="$STATION" "$@"
            ;; 
        *)
            # Magic Trick: Stitch words with a hyphen (e.g. git public -> git-public)
            if [ -n "$2" ] && [[ ! "$2" == *=* ]]; then
                make -f Makefile "$1-$2" "$@"
            else
                make -f Makefile "$COMMAND" "$@"
            fi
            ;; 
    esac
else
    # --- INITIALIZATION MODE ---
    if [ -z "$1" ]; then
        # Run the internal open_makery script to build a local kitchen
        bash "$HOME/.makery/office/open_makery.sh"
    else
        echo -e "\033[1;31mNo kitchen found here. Type 'bake' to build one.\033[0m"
        exit 1
    fi
fi
EOF

chmod +x "$BIN_DIR/bake"

# 3. Self-Replicate the open_makery script into HQ for future use
# (Ensures HQ always has the latest version of the per-project script)
# cp "$HQ_DIR/office/open_makery.sh" ... is handled by the initial clone

echo -e "\n\033[1;32m  ✓ Global Makery installed to $BIN_DIR/bake\033[0m"
echo "  (Ensure $BIN_DIR is in your PATH)"
