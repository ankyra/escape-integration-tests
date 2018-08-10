# Uses packages and binaries from the Inventory
# Runs in Docker
#
escape-test:
	escape run build && escape run test

# Uses binaries on the PATH
# Runs locally
#
local-test:
	rm -rf deps
	cd godog && godog
	
# Only run tests tagged with "@failing"
# Uses binaries on the PATH
# Runs locally
#
local-failing-tag-test:
	rm -rf deps
	cd godog && godog --tags=@failing
