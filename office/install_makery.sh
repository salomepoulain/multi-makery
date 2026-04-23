#!/usr/bin/env bash
# install_makery.sh — Global installer for multi-makery
# Recommended: review this script, verify checksum, then run.

set -euo pipefail

REPO_URL="https://github.com/salomepoulain/multi-makery"
RELEASE_TAG="v1.0.0"                 # <- pin a release
EXPECTED_SHA256=""                   # <- set this to the release tarball/clone hash
HQ_DIR="$HOME/.makery"
BIN_DIR="$HOME/.local/bin"
BINARY_NAME="bake"

echo -e "\033[1;35m==> Building global Makery headquarters...\033[0m"

# Verify PATH contains BIN_DIR or give guidance
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo -e "\n\033[1;33mNOTE:\$HOME/.local/bin is not in your PATH.\033[0m"
  echo "Add it with:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo "and consider adding that line to your shell profile (~/.bashrc or ~/.zshrc).\n"
fi

# Create directories
mkdir -p "$HQ_DIR" "$BIN_DIR"

# Clone the repo at a specific tag/ref for reproducibility
TMP_DIR=$(mktemp -d)
echo "Cloning $REPO_URL (ref: $RELEASE_TAG) into temporary directory..."
git clone --depth 1 --branch "$RELEASE_TAG" "$REPO_URL" "$TMP_DIR"

# Optional integrity check (if you provide SHA256 for the tarball or a manifest)
# if [ -n "$EXPECTED_SHA256" ]; then
#   cd "$TMP_DIR"
#   sha256sum -c <<< "$EXPECTED_SHA256  multi-makery.tar.gz"
# fi

# Install only the binary (if you provide one). If shipping the repo, copy selectively.
# Here we assume 'kitchen' and 'office' are needed for the per-project kitchen.
echo "Copying kitchen and office to $HQ_DIR ..."
cp -r "$TMP_DIR/kitchen" "$HQ_DIR/"
cp -r "$TMP_DIR/office" "$HQ_DIR/"

# Install the global binary (generate from repo or prebuilt)
echo "Installing global $BINARY_NAME to $BIN_DIR ..."
cat > "$BIN_DIR/$BINARY_NAME" << 'BINARY_EOF'
#!/bin/bash
# Global bake command router
if [ -f "Makefile" ] && grep -q "\.makery" Makefile; then
    COMMAND="${1:-menu}"
    STATION="$2"
    case "$COMMAND" in
        first|burnt|fresh|germs)
            shift 2
            make -f Makefile "$COMMAND" s="$STATION" "$@"
            ;;
        *)
            if [ -n "$2" ] && [[ ! "$2" == *=* ]]; then
                make -f Makefile "$1-$2" "$@"
            else
                make -f Makefile "$COMMAND" "$@"
            fi
            ;;
    esac
else
    if [ -z "$1" ]; then
        bash "$HOME/.makery/office/open_makery.sh"
    else
        echo -e "\033[1;31mNo kitchen found here. Type 'bake' to build one.\033[0m"
        exit 1
    fi
fi
BINARY_EOF

chmod +x "$BIN_DIR/$BINARY_NAME"

# Keep HQ's open_makery.sh up-to-date (optional)
# cp "$TMP_DIR/office/open_makery.sh" "$HQ_DIR/office/"

rm -rf "$TMP_DIR"

echo
echo -e "\033[1;32m==> Global Makery installed to $BIN_DIR/$BINARY_NAME\033[0m"
echo "Ensure $BIN_DIR is in your PATH."
echo "Next: create a kitchen with 'bake' inside a project folder."
