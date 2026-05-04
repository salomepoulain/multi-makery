# ============================================================================
#  THE HEAD CHEF'S MENU
# ============================================================================

menu::
	@bash -c 'source .makery/kitchen/headchef/personality.sh && STARTER "The Head Chef'\''s Menu" && \
		ITEM "first <name>" "Hire a cook and open their new station (e.g. '\''python'\'')" && \
		ITEM "burnt <name>" "Fire a cook, close their station, and throw out recipes" && \
		ITEM "inspo" "Inspiration: list all available stations at the agency" && \
		ITEM "germs" "Health Inspector prep: scrub all workbenches" && \
		ITEM "fresh <name>" "Force the cook to scrub their specific workbench" && \
		ITEM "all" "Bake everything at once, exploding the kitchen" && \
		FINISHED'

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

# Build station menus dynamically (append after headchef menu)
menu::
	@for station_dir in .makery/kitchen/stations/*/; do \
		[ -f "$$station_dir/menu.mk" ] && $(MAKE) -f "$$station_dir/menu.mk" menu; \
	done

help:: menu
