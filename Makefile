ifndef NIX
NIX = nix
endif

ifndef STATIX
STATIX = $(NIX) run nixpkgs\#statix --
endif

UPDATED_FLAKE_INPUTS = neovim workstation-deps zsh-plugin-syntax-highlight
FLAKE_INPUTS = $(foreach i,$(UPDATED_FLAKE_INPUTS),--update-input $(i) )

.PHONY: statix
statix:
	$(STATIX) check

.PHONY: test
test: statix
	$(NIX) flake check
	$(NIX) build --no-link '.#homeConfigurations."'"$(shell whoami)@$(shell hostname)"'".activationPackage'

.PHONY: apply
apply:
	$(NIX) build '.#homeConfigurations."'"$(shell whoami)@$(shell hostname)"'".activationPackage'
	./result/activate && rm ./result

.PHONY: update
update:
	$(NIX) flake lock $(FLAKE_INPUTS)
	@# $(NIX) flake update
	@# $(NIX) flake update

.PHONY: upgrade
upgrade: update
	@# alias helper for 'update'
	@true
