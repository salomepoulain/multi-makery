# station-name/menu.mk
# Standalone Makefile — works with: cd .makery/kitchen/stations/<name> && make <recipe>

# Recipes defined below are run via: bake call s=<station> d=<recipe>
# (first, fresh, burnt are managed by the Head Chef)

# Compute station directory when included from main menu.mk
STATION_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

menu::
	@bash -c 'source "$(STATION_DIR)cook/personality.sh" && STARTER "$$COOK_NAME Station" && \ 
		ITEM "<<example>>" "<<Description of the recipe>>" && \
		FINISHED'

# Add your recipes below:

# models: Switch between Anthropic and OpenRouter providers
example:
	@bash cook/recipes/example.sh
