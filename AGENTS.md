# AGENTS.md — nixos-config (ThinkPad P52)

## Scope
Dieses Repo ist eine NixOS-Flake-Konfiguration für den Host `p52` (ThinkPad P52) inkl. Home-Manager.
Alle Änderungen müssen **reproduzierbar, reviewbar und nicht-destruktiv** sein.
---


## Golden Path (erlaubte Targets)
# Flake- & Lockfile-Policy
- `flake.lock` **niemals nebenbei ändern**
- Änderungen an Inputs **nur**, wenn explizit gewünscht oder klar begründet
- Bei Updates: kurz erklären *welche* Inputs sich ändern und *warum*

---

## Repo-Landkarte
- `flake.nix`
    - definiert `nixosConfigurations.p52`
    - bindet `nixos-hardware` + `home-manager` ein
- `configuration.nix`
    - Haupt-Systemkonfiguration
- `hardware-configuration.nix`
    - hardware-spezifisch → **hands-off**
- `home/`
    - Home-Manager Konfigurationen
- `Makefile`
    - einzig erlaubte Entry-Points für Checks & Builds

---

## 📚 Dokumentationspflicht (Context7 & GitHub MCP)

Bei unklaren Optionen, Paketen oder Modulen:
- **nicht raten**
- **nicht halluzinieren**
- **immer zuerst in offizieller Doku nachschlagen**

Bevorzugte Quellen (immer aktuell):

### NixOS
- Optionen: https://search.nixos.org/options
- Pakete: https://search.nixos.org/packages
- Handbuch (stable/latest): https://nixos.org/manual/nixos/stable/

### Home Manager
- Optionen: https://nix-community.github.io/home-manager/options.xhtml
- Handbuch: https://nix-community.github.io/home-manager/index.html

### Community / Edge Cases
- NixOS Discourse: https://discourse.nixos.org/

➡️ **Context7 und GitHub MCP aktiv nutzen**, um:
- Optionsdefinitionen nachzulesen
- Modulverhalten zu verifizieren
- Beispiele aus offizieller Doku oder Issues zu prüfen

Wenn eine Option genutzt wird:
- kurz erwähnen, **wo sie dokumentiert ist**
- idealerweise mit Link oder exaktem Optionspfad

---

## Change Policy (Arbeitsweise)
- Kleine, reviewbare Diffs
- Keine Refactors ohne expliziten Auftrag
- Bei Unsicherheit: erst erklären, dann ändern
- Systemkritische Bereiche (Kernel, Boot, FS, GPU, Power):
    - erst Plan + Risiko, dann Umsetzung

---

## Guardrails / Tabus
- Keine Secrets, Tokens oder Passwörter committen
- `hardware-configuration.nix` nicht ändern (außer ausdrücklich gefordert)
- Keine Bootloader-/FS-/Partition-/Encryption-Änderungen ohne klaren Auftrag
- Keine großflächigen Reformatierungen ohne Nutzen

---

## Definition of Done
- [ ] Diff minimal & erklärbar
- [ ] verwendete Optionen sind dokumentiert / referenziert


## Issues als Arbeitsinput
- Der Agent darf relevante Issues lesen, um Requirements zu klären. 
- Nutze dafür das unter .git/config konfigurierte repo
- Wenn ein Issue unklar ist: stelle Rückfragen im PR-Text (oder als Kommentar), statt zu raten.
- Wenn der Pull Request erstelle ist darfst du das Issue schliessen
