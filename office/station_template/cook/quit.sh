#!/bin/bash
# ============================================================================
#  LINE COOK CONTRACT: FIRE (Teardown Script)
# ============================================================================
# This script is executed exactly once when the Head Chef fires this Line Cook
# using `bake burnt <this_cook>`.
#
# Use this script to unregister system-level changes (like Jupyter kernels)
# that shouldn't be left behind when the station is destroyed.

echo "      [-] The line cook is packing their knives..."

# Example:
# jupyter kernelspec uninstall -f my-kernel
