# ============================================================================
#  THE HEAD CHEF'S MENU
# ============================================================================

menu::
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  The Head Chef's Menu (multi-makery)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  CORE OPERATIONS"
	@echo "    bake first <name>    Hire a cook and open their new station (e.g. 'python')"
	@echo "    bake burnt <name>    Fire a cook, close their station, and throw out recipes"
	@echo "    bake inspo           Inspiration: list all available stations at the agency"
	@echo "    bake germs           Health Inspector prep: scrub all workbenches"
	@echo "    bake fresh <name>    Force the cook to scrub their specific workbench"
	@echo "    bake all             Bake everything at once, exploding the kitchen"
	@echo ""
	@echo "  (Standard 'make' fallback is supported: e.g. 'make first s=python')"
	@echo ""

inspo::
	@bash .makery/kitchen/headchef/orders/inspo.sh

concrete::
	@bash .makery/office/open_makery.sh make
	@$(MAKE) menu

first::
	@bash .makery/kitchen/headchef/orders/first.sh $(s)

burnt::
	@bash .makery/kitchen/headchef/orders/burnt.sh $(s)

germs::
	@bash .makery/kitchen/headchef/orders/fresh.sh

fresh::
	@bash .makery/kitchen/headchef/orders/fresh.sh $(s)

all::
	@bash .makery/kitchen/headchef/orders/all.sh

help:: menu