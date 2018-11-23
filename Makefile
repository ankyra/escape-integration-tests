# Uses packages and binaries from the Inventory
# Runs in Docker
#
escape-test:
	escape run build && escape run test

local-notice:
	@echo "##################################################"
	@echo ""
	@echo "  Hello fellow Anchor:"
	@echo "  This Make step uses the 'escape' and "
	@echo "  'escape-inventory' binaries found on the PATH"
	@echo ""
	@echo "##################################################"
	@echo 

# Uses binaries on the PATH
# Runs locally
#
local-test: local-notice
	rm -rf deps
	cd godog && godog
	
# Only run tests tagged with "@failing"
# Uses binaries on the PATH
# Runs locally
#
local-failing-tag-test: local-notice
	rm -rf deps
	cd godog && godog --tags=@failing

# Only run tests tagged with "@builds"
# Uses binaries on the PATH
# Runs locally
#
local-builds-tag-test: local-notice
	rm -rf deps
	cd godog && godog --tags=@builds

# Only run tests tagged with "@provider-activation"
# Uses binaries on the PATH
# Runs locally
#
local-provider-activation-tag-test: local-notice
	rm -rf deps
	cd godog && godog --tags=@provider-activation
