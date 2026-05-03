#!/usr/bin/env bash
# install_makery.sh — Global installer for multi-makery
# Review this script before running:
#   curl -sSL https://raw.githubusercontent.com/salomepoulain/multi-makery/main/install_makery.sh -o install_makery.sh
#   sha256sum install_makery.sh
#   bash install_makery.sh

set -euo pipefail

REPO_URL="https://github.com/salomepoulain/multi-makery"

# Fetch the latest release tag dynamically
RELEASE_TAG=$(curl -sSL "https://api.github.com/repos/salomepoulain/multi-makery/releases/latest" | \
  grep -oP '"tag_name":\s*"\K[^"]+' || echo "v0.1.0")
if [ -z "$RELEASE_TAG" ]; then
  echo -e "\033[1;31mFailed to fetch latest release tag, defaulting to v0.1.0\033[0m"
  RELEASE_TAG="v0.1.0"
fi

TARBALL_NAME="multi-makery-${RELEASE_TAG}.tar.gz"
CHECKSUM_NAME="${TARBALL_NAME}.sha256"
HQ_DIR="$HOME/.makery"
BIN_DIR="$HOME/.local/bin"
BINARY_NAME="bake"

echo -e "\033[1;35m==> Building global Makery headquarters...\033[0m"

# Warn about PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo -e "\n\033[1;33mNOTE: $HOME/.local/bin is not in your PATH.\033[0m"
  echo "Add it with:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo "and consider adding that line to your shell profile."
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
cp "$HQ_DIR/office/cabinet/bake" "$BIN_DIR/$BINARY_NAME"
chmod +x "$BIN_DIR/$BINARY_NAME"

echo
echo -e "\033[1;32m==> Global Makery installed to $BIN_DIR/$BINARY_NAME\033[0m"
echo "Ensure $BIN_DIR is in your PATH."
echo "Next: create a kitchen with 'bake' inside a project folder."
