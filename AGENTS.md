# AGENTS.md

## Zweck
Diese Datei definiert verbindliche Regeln für KI-Agenten (z. B. OpenAI Codex),
die in diesem Repository arbeiten.  
**Ziel:** kleine, sichere Diffs, reproduzierbare NixOS-Konfigurationen,
keine impliziten Annahmen.

---

## Projektüberblick
- NixOS Konfiguration mit **Flakes**
- Nutzung von **home-manager**
- Wayland-Setup (z. B. kanshi, Hyprland)
- Fokus: deklarativ, modular, reproduzierbar

---

## Zwingender Workflow (immer einhalten)
1. **Lesen**
    - `AGENTS.md`
    - `flake.nix`
    - relevante Module (`home/*.nix`)
2. **Plan**
    - Kurze Beschreibung der geplanten Änderung
3. **Patch**
    - Minimaler Diff
    - Keine unnötigen Refactors
4. **Verify**
    - `make check`
