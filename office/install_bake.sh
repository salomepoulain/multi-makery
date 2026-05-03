#!/bin/bash
# ============================================================================
#  INSTALL BAKE (Global installer for the bake command)
# ============================================================================
# This installs the `bake` command to ~/.local/bin and sets up the engine
# in ~/.makery. The bake command uses .makery/menu.mk internally.
# ============================================================================

# --- Formatting Helpers ---
_term_cols() { local cols; cols=$(stty size 2>/dev/null | awk '{print $2}'); [[ "$cols" =~ ^[0-9]+$ ]] && echo "$cols" || echo 80; }
WHITE='\033[1;37m'
NC='\033[0m'

STARTER() { local rule cols; cols=$(_term_cols); rule=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"━";print""}'); rule_thin=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"┈";print""}'); echo -e "${WHITE}${rule}${NC}"; echo -e "${WHITE}  $1${NC}"; echo -e "${WHITE}${rule_thin}${NC}"; }
FINISHED() { local rule cols; cols=$(_term_cols); rule=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"━";print""}'); rule_thin=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"┈";print""}'); echo -e "\n${WHITE}${rule_thin}${NC}"; echo -e "${WHITE}  $1${NC}"; echo -e "${WHITE}${rule}${NC}"; }

set -euo pipefail

REPO_URL="https://github.com/salomepoulain/multi-makery"

# Fetch the latest release tag dynamically
RELEASE_TAG=$(curl -sSL "https://api.github.com/repos/salomepoulain/multi-makery/releases/latest" | \
  grep '"tag_name"' | sed 's/.*"tag_name": "\([^"]*\)".*/\1/' || echo "v0.1.0")
if [ -z "$RELEASE_TAG" ]; then
  echo -e "\033[1;31mFailed to fetch latest release tag, defaulting to v0.1.0\033[0m"
  RELEASE_TAG="v0.1.0"
fi

TARBALL_NAME="multi-makery-${RELEASE_TAG}.tar.gz"
CHECKSUM_NAME="${TARBALL_NAME}.sha256"
HQ_DIR="$HOME/.makery"
BIN_DIR="$HOME/.local/bin"
BINARY_NAME="bake"

STARTER "Building global Makery headquarters..."

# Warn about PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo -e "\n\033[1;33mNOTE: $HOME/.local/bin is not in your PATH.\033[0m"
  echo "Add it with:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  printf "and consider adding that line to your shell profile.\n"
fi

mkdir -p "$HQ_DIR" "$BIN_DIR"

# Fetch release tarball and checksum, then verify
TMP_TARBALL=$(mktemp)
TMP_CHECKSUM=$(mktemp)

echo "Downloading $REPO_URL/releases/download/$RELEASE_TAG/$TARBALL_NAME ..."
curl -sSL -o "$TMP_TARBALL" "$REPO_URL/releases/download/$RELEASE_TAG/$TARBALL_NAME"

echo "Downloading checksum..."
curl -sSL -o "$TMP_CHECKSUM" "$REPO_URL/releases/download/$RELEASE_TAG/$CHECKSUM_NAME"

echo "Verifying checksum..."
EXPECTED_HASH=$(awk '{print $1}' "$TMP_CHECKSUM")
ACTUAL_HASH=$(sha256sum "$TMP_TARBALL" | awk '{print $1}')

if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
  echo -e "\033[1;31mChecksum verification failed!\033[0m"
  echo "Expected: $EXPECTED_HASH"
  echo "Actual:   $ACTUAL_HASH"
  rm "$TMP_TARBALL" "$TMP_CHECKSUM"
  exit 1
fi
echo "Checksum verified."

tar -xzf "$TMP_TARBALL" -C "$HQ_DIR" --strip-components=1
rm "$TMP_TARBALL" "$TMP_CHECKSUM"

# Install the global binary
echo "Installing global $BINARY_NAME to $BIN_DIR ..."
cat > "$BIN_DIR/$BINARY_NAME" << 'BAKE_EOF'
#!/bin/bash
# Global bake command router
if [ -d ".makery" ]; then
    # Use internal menu.mk, leaving project's Makefile untouched
    if [ $# -ge 2 ] && [[ ! "$2" == *=* ]]; then
        make -f .makery/menu.mk "$1" s="$2" "$@" 2>/dev/null || \
            make -f .makery/menu.mk "call" s="$1" d="$2" "$@"
    else
        make -f .makery/menu.mk "$@"
    fi
else
    if [ -z "$1" ]; then
        bash "$HOME/.makery/office/open_bake.sh"
    else
        echo -e "\033[1;31mNo kitchen found here. Type 'bake' to build one.\033[0m"
        exit 1
    fi
fi
BAKE_EOF
chmod +x "$BIN_DIR/$BINARY_NAME"

echo
FINISHED "Global Makery installed to $BIN_DIR/$BINARY_NAME"
echo "Ensure $BIN_DIR is in your PATH."
echo "Next: create a kitchen with 'bake' inside a project folder."