#!/bin/bash
# ============================================================================
#  LINE COOK CONTRACT: FIRED (Teardown Script)
# ============================================================================
# This script is executed exactly once when the Head Chef fires this Line Cook
# using `bake burnt <this_cook>`.
#
# Use this script to unregister system-level changes (like Jupyter kernels)
# that shouldn't be left behind when the station is destroyed.
# You can speak during teardown using SPEAK:
#   SPEAK "Packing my knives and cleaning out my locker..."

source "$(dirname "${BASH_SOURCE[0]}")/../personality.sh"

SPEAK "Packing my knives and cleaning out my locker..."

# Example:
# jupyter kernelspec uninstall -f my-kernel
