# ============================================================================
#  THE LINE COOK'S MENU (Makefile Fragment)
# ============================================================================

# Add the specific commands this cook can perform to the main menu.
# Always prefix commands with the cook's name to avoid kitchen chaos.

menu::
	@echo "  THE [NAME] STATION"
	@echo "    ./bake [name]-action  A brief description of this specific action."

# Define the actual actions
[name]-action:
	@bash .makery/linecooks/[name]/skills/action.sh
