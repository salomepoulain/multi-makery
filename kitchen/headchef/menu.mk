# ============================================================================
#  THE HEAD CHEF'S MENU
# ============================================================================

menu::
	@source .makery/kitchen/headchef/personality.sh && STARTER "The Head Chef's Menu (multi-makery)" && \
		echo "  CORE OPERATIONS" && \
		ITEM "bake first <name>" "Hire a cook and open their new station (e.g. 'python')" && \
		ITEM "bake burnt <name>" "Fire a cook, close their station, and throw out recipes" && \
		ITEM "bake inspo" "Inspiration: list all available stations at the agency" && \
		ITEM "bake germs" "Health Inspector prep: scrub all workbenches" && \
		ITEM "bake fresh <name>" "Force the cook to scrub their specific workbench" && \
		ITEM "bake all" "Bake everything at once, exploding the kitchen" && \
		echo "" && \
		echo "  (Standard 'make' fallback is supported: e.g. 'make first s=python')" && \
		echo "" && \
		FINISHED

inspo::
	@bash .makery/kitchen/headchef/orders/inspo.sh

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

call::
	@STATION="$(s)"; \
	DISH="$(d)"; \
	cd .makery/kitchen/stations/$$STATION && make -f menu.mk $$DISH

# Include station menus if available (for use as .makery/menu.mk)
-include .makery/kitchen/stations/*/menu.mk

help:: menu
