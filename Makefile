# Uses packages and binaries from the Inventory
# Runs in Docker
#
escape-test:
	escape build && escape test

# Uses binaries on the PATH
# Runs locally
#
local-test:
	rm -rf deps
	cd godog && godog
