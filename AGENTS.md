# AGENTS.md — nixos-config (ThinkPad P52)

## Scope
Dieses Repo ist eine NixOS-Flake-Konfiguration für den Host `p52` (ThinkPad P52) inkl. Home-Manager.
Alle Änderungen müssen **reproduzierbar, reviewbar und nicht-destruktiv** sein.

Dieses Repo wird **niemals aktiv auf ein laufendes System angewendet**.

## 🔒 HARTE REGEL: KEINE AKTIVIERUNG
**Es ist strikt verboten, folgende Befehle auszuführen oder vorzuschlagen:**
- `make switch`
- `make boot`
- `nixos-rebuild switch`
- `nixos-rebuild boot`

➡️ Auch nicht „als Vorschlag“, „optional“, „zum Testen“ oder „wenn gewünscht“.  
➡️ Änderungen werden **nur gebaut, geprüft oder dry-run validiert**.

--
## 🔁 Standard-Workflow: Branch → Push → Pull Request (verbindlich)

Wenn du ein Feature/Bugfix umsetzt, dann **immer** so arbeiten:

1) Erstelle einen neuen Branch (nie direkt auf default branch arbeiten)
    - Branch-Schema: `codex/<kurzer-slug>` oder `codex/issue-<nr>-<slug>`
    - Beispiel: `codex/issue-12-nvidia-suspend`

2) Falls Du auf dem Host P52 bist (findest du mit dem Befehl `host-check` heraus:
- Folge dem Golden Path

3) Commit-Regeln
    - Kleine, reviewbare Commits (max. ~200 LoC pro Commit, wenn möglich)
    - Commit-Message: prägnant + was/warum
    - Keine Lockfile-Änderungen (`flake.lock`), außer Aufgabe ist Update/Lock.
4) Push
    - Push den Branch ins Origin (upstream setzen).

5) Pull Request erstellen
    - PR-Titel: wie Branch / Issue
    - PR-Beschreibung muss enthalten:
        - Was geändert wurde (Bulletpoints)
        - Wie es verifiziert wurde: `make check`, `make build`, ggf. `make dry-switch`
        - Hinweise zu Risiko-Bereichen (Boot/FS/GPU/etc.), falls betroffen
        - Wenn `flake.lock` geändert: warum + was genau updated wurde

6) Keine Aktivierung
    - Niemals `make switch` oder `make boot` ausführen oder vorschlagen.

7) Wenn der Pull Request erfolgreich ausgeführt wurde master branch lokal auschecken
---

## Default-Werte & Variablen
- Default `HOST=p52`
- Default `FLAKE=.`
- Optional `NIX_ARGS` für zusätzliche Flags (z.B. `--show-trace`, `-L`)

Beispiele:
- `make check`
- `make dry-build`

---

## Golden Path (erlaubte Targets)
**Nutze ausschließlich diese Makefile-Targets.**
- `make fmt`   formatiert alle dateien
- `make dry-build`  Evaluate NixOS config and show planned changes (no build, no activation, no sudo)
- `make check`   Run flake checks.
---

## Flake- & Lockfile-Policy
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
- [ ] `make check` grün
- [ ] `make build` erfolgreich
- [ ] ggf. `make dry-switch` geprüft
- [ ] Diff minimal & erklärbar
- [ ] `flake.lock` nur geändert, wenn beabsichtigt
- [ ] verwendete Optionen sind dokumentiert / referenziert


## Issues als Arbeitsinput
- Der Agent darf relevante Issues lesen, um Requirements zu klären. 
- Nutze dafür das unter .git/config konfigurierte repo
- Wenn ein Issue unklar ist: stelle Rückfragen im PR-Text (oder als Kommentar), statt zu raten.
