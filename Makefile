NIX := nix
STATIX := $(NIX) run nixpkgs\#statix --

UPDATED_FLAKE_INPUTS = neovim workstation-deps zsh-plugin-syntax-highlight
FLAKE_INPUTS = $(foreach i,$(UPDATED_FLAKE_INPUTS),--update-input $(i) )

.PHONY: test
test:
	$(STATIX) check
	$(NIX) flake check
	$(NIX) build '.#homeConfigurations."'"$(shell whoami)@$(shell hostname)"'".activationPackage' && rm ./result

.PHONY: update
update:
	$(NIX) flake lock $(FLAKE_INPUTS)
	@# $(NIX) flake update
	@# $(NIX) flake update

.PHONY: upgrade
upgrade: update
	@# alias helper for 'update'
	@true
