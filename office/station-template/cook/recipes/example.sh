#!/usr/bin/env bash
# shellcheck disable=SC2034
# Example recipe to be run with: bake call s=<station> d=example

# Source personality for cook-specific identity
source "$(dirname "${BASH_SOURCE[0]}")/../personality.sh"

# Reference pantry items (static files in workbench/pantry)
PANTRY_DIR="$(dirname "${BASH_SOURCE[0]}")/../../workbench/pantry"

SPEAK "Running example recipe..."
# Example: ls "$PANTRY_DIR"
