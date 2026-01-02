HOST ?= nixos
FLAKE ?= .
NIX_ARGS ?=

.PHONY: help switch boot build dry-switch check update lock

help:
@echo "Available targets (override HOST=<name> or FLAKE=<path> as needed):"
@echo "  switch      Rebuild and activate the system configuration immediately."
@echo "  boot        Rebuild and set the configuration for the next boot."
@echo "  build       Build the system without activating it."
@echo "  dry-switch  Show what would change without activating (dry activate)."
@echo "  check       Run flake checks."
@echo "  update      Update flake inputs (equivalent to nix flake update)."
@echo "  lock        Write a lock file without updating inputs."
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

dry-switch:
nixos-rebuild dry-activate --flake $(FLAKE)#$(HOST) $(NIX_ARGS)

check:
nix flake check $(FLAKE)

update:
nix flake update $(FLAKE)

lock:
nix flake lock $(FLAKE)
