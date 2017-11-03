# Uses packages and binaries from the Inventory
# Runs in Docker
#
escape_test:
	escape build && escape test

# Uses binaries on the PATH
# Runs locally
#
local_test:
	rm -rf deps
	cd godog && godog
