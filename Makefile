
.PHONY: test
test:
	nix flake check
	nix build '.#homeConfigurations."'"$(shell whoami)@$(shell hostname)"'".activationPackage' && rm ./result

.PHONY: update
update:
	@echo Not yet implemented
	@exit 1

.PHONY: upgrade
upgrade: update
	@# alias helper for 'update'
	@true
