.PHONY: menu first burnt germs fresh all call

# Include the Head Chef's core menu
-include .makery/kitchen/headchef/menu.mk
-include .makery/kitchen/stations/*/menu.mk

# Default goal: show the menu
.DEFAULT_GOAL := menu
