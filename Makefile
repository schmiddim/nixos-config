SHELL := /usr/bin/env bash

NIXOS_DIR ?= /etc/nixos
CONFIG    ?= $(NIXOS_DIR)/configuration.nix

.PHONY: help where check test build boot switch diff gc clean fmt

help:
	@echo "Targets:"
	@echo "  make where   - show config path"
	@echo "  make check   - dry build (sanity check)"
	@echo "  make test    - activate in test mode"
	@echo "  make build   - build system"
	@echo "  make boot    - set as default for next boot"
	@echo "  make switch  - build + switch now"
	@echo "  make diff    - diff closures"
	@echo "  make gc      - garbage collect (-d)"
	@echo "  make clean   - remove result symlinks"
	@echo "  make fmt     - format nix files"

where:
	@echo "Using config: $(CONFIG)"

check:
	sudo nixos-rebuild dry-build -I nixos-config=$(CONFIG)

test:
	sudo nixos-rebuild test -I nixos-config=$(CONFIG)

build:
	sudo nixos-rebuild build -I nixos-config=$(CONFIG)

boot:
	sudo nixos-rebuild boot -I nixos-config=$(CONFIG)

switch:
	sudo nixos-rebuild switch -I nixos-config=$(CONFIG)

diff:
	@current="$$(readlink -f /run/current-system)"; \
	next="$$(nixos-rebuild build -I nixos-config=$(CONFIG) --no-link --print-out-paths)"; \
	nix store diff-closures "$$current" "$$next" || true

gc:
	sudo nix-collect-garbage -d

clean:
	rm -f result result-*

fmt:
	alejandra $(NIXOS_DIR)