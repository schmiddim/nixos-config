SHELL := /usr/bin/env bash
FLAKE_DIR := /etc/nixos
HOST := $(shell hostname)
FLAKE := $(FLAKE_DIR)#$(HOST)

.PHONY: help show check test build boot switch update upgrade diff gc clean

help:
	@echo "Targets:"
	@echo "  make show     - show flake outputs"
	@echo "  make check    - run flake checks"
	@echo "  make test     - activate in test mode (no boot entry)"
	@echo "  make boot     - build + set as default for next boot"
	@echo "  make switch   - build + switch now"
	@echo "  make update   - update flake inputs (writes flake.lock)"
	@echo "  make upgrade  - update + switch"
	@echo "  make diff     - diff closures (current vs new build)"
	@echo "  make gc       - garbage collect (-d)"
	@echo "  make clean    - remove local result* symlinks"

show:
	nix flake show $(FLAKE_DIR)

check:
	nix flake check $(FLAKE_DIR)

test:
	sudo nixos-rebuild test --flake "$(FLAKE)"

boot:
	sudo nixos-rebuild boot --flake "$(FLAKE)"

switch:
	sudo nixos-rebuild switch --flake "$(FLAKE)"

update:
	cd $(FLAKE_DIR) && nix flake update

upgrade: update switch

diff:
	@current="$$(readlink -f /run/current-system)"; \
	next="$$(nix build --no-link --print-out-paths $(FLAKE_DIR)#nixosConfigurations.$(HOST).config.system.build.toplevel)"; \
	nix store diff-closures "$$current" "$$next" || true

gc:
	sudo nix-collect-garbage -d

clean:
	rm -f result result-*
