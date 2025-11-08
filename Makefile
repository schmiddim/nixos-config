HOST ?= p52
FLAKE ?= .
NIX_ARGS ?=

.PHONY: help switch boot build dry-switch check update fmt cleanup

help:
	@echo "Available targets (override HOST=<name> or FLAKE=<path> as needed):"
	@echo "  switch      Rebuild and activate the system configuration immediately."
	@echo "  boot        Rebuild and set the configuration for the next boot."
	@echo "  build       Build the system without activating it."
	@echo "  dry-build   Evaluate NixOS config and show planned changes (no build, no activation, no sudo)"
	@echo "  dry-switch  Show what would change without activating (dry activate)."
	@echo "  check       Run flake checks."
	@echo "  update      Update flake inputs (equivalent to nix flake update)."
	@echo "  fmt      Format all .nix files with nixfmt-rfc-style."
	@echo "  cleanup     Garbage collect old generations (system + user) and optimise the store."
	@echo ""
	@echo "Examples:"
	@echo "  make update"
	@echo "  make switch HOST=p52"

switch:
	nixos-rebuild switch --flake $(FLAKE)#$(HOST) $(NIX_ARGS)

boot:
	nixos-rebuild boot --flake $(FLAKE)#$(HOST) $(NIX_ARGS)

build:
	nixos-rebuild build --flake $(FLAKE)#$(HOST) $(NIX_ARGS)

dry-build:
	nixos-rebuild dry-build --flake $(FLAKE)#$(HOST) -L $(NIX_ARGS)

dry-switch:
	nixos-rebuild dry-activate --flake $(FLAKE)#$(HOST) $(NIX_ARGS)

check:
	nix flake check

fmt: 
	 nix run nixpkgs#nixfmt-rfc-style -- $(shell find . -name '*.nix' -not -path './.git/*' -not -path '././*')
update:
	nix flake update --flake $(FLAKE)

cleanup:
	sudo nix-collect-garbage --delete-older-than 14d
	nix-collect-garbage --delete-older-than 14d
	nix store optimise
