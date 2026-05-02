# station-name/menu.mk
# Standalone Makefile — works with: cd .makery/kitchen/stations/<name> && make <dish>

# first: Hire the station (sets up environment)
first:
	@bash cook/first.sh

# fresh: Clean the station's workbench
fresh:
	@bash cook/fresh.sh

# burnt: Fire the station
burnt:
	@bash cook/burnt.sh

# Add your dishes below with comments:

# deploy: Deploy the project
# deploy:
#	@bash dishes/deploy.sh

# setup: Set up the environment
# setup:
#	@bash dishes/setup.sh
