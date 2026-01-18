# Laptop-Tuning Plan

## Analyse

Das Repo nutzt bereits `nixos-hardware.nixosModules.lenovo-thinkpad-p52` (in flake.nix),
welches Nvidia-Treiber und ThinkPad-spezifische Konfiguration mitbringt.

## Änderungen in diesem Branch

### Phase 1: System-Optimierungen (configuration.nix)

| Service | Zweck | Status |
|---------|-------|--------|
| `services.power-profiles-daemon` | CPU-Profile (balanced/power-saver/performance) | :white_check_mark: |
| `services.thermald` | Intel Thermal Management | :white_check_mark: |
| `zramSwap` | Komprimierter RAM-Swap (50%) | :white_check_mark: |
| `services.fstrim` | SSD TRIM für Langlebigkeit | :white_check_mark: |

### Phase 2: CLI-Tools (home/home.nix + zsh.nix)

| Tool | Zweck | Status |
|------|-------|--------|
| `fzf` | Fuzzy-Finder für Dateien/History (mit zsh-Integration) | :white_check_mark: |
| `bat` | Besseres `cat` mit Syntax-Highlighting | :white_check_mark: |
| `eza` | Modernes `ls` mit Icons (aliased: ll, la, lt) | :white_check_mark: |
| `fd` | Schnelleres `find` | :white_check_mark: |
| `direnv` | Automatische Umgebungsvariablen pro Verzeichnis | :white_check_mark: |

### Nvidia GPU

Wird bereits durch `nixos-hardware.nixosModules.lenovo-thinkpad-p52` konfiguriert.
Keine zusätzliche Konfiguration nötig.

## Verifizierung nach Anwendung

```bash
# Prüfen ob Services laufen
systemctl status power-profiles-daemon
systemctl status thermald

# Zram prüfen
zramctl

# Power-Profile anzeigen
powerprofilesctl list
```

## Referenzen

- [power-profiles-daemon](https://search.nixos.org/options?show=services.power-profiles-daemon.enable)
- [thermald](https://search.nixos.org/options?show=services.thermald.enable)
- [zramSwap](https://search.nixos.org/options?show=zramSwap.enable)
- [fstrim](https://search.nixos.org/options?show=services.fstrim.enable)