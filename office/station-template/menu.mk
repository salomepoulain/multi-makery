# station-name/menu.mk
# Standalone Makefile — works with: cd .makery/kitchen/stations/<name> && make <skill>

# Skills defined below are run via: bake call s=<station> d=<skill>
# (first, fresh, burnt are managed by the Head Chef)

menu::
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  my-station Station"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  STATION SKILLS"
	@echo "    bake my-station <skill>    Description of the skill"
	@echo ""

# Add your skills below:
