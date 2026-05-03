# station-name/menu.mk
# Standalone Makefile — works with: cd .makery/kitchen/stations/<name> && make <recipe>

# Recipes defined below are run via: bake call s=<station> d=<recipe>
# (first, fresh, burnt are managed by the Head Chef)

menu::
	@bash -c 'source cook/personality.sh && STARTER "$$COOK_NAME Station" && \
		echo "  STATION RECIPES" && \
		ITEM "bake $$COOK_NAME <recipe>" "Description of the recipe" && \
		echo "" && \
		FINISHED'

# Add your recipes below:

# example: Run an example task
example:
	@bash cook/recipes/example.sh
