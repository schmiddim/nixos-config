## Projektüberblick

- Persönliches NixOS‑Repository mit Flakes, mehreren Hosts und Home‑Manager‑Konfigurationen.
- Ziel: Reproduzierbare System‑ und User‑Konfigurationen für Workstations/Laptops, inkl. Desktop‑Setup und Dev‑Umgebung.
- Alle Änderungen erfolgen deklarativ über Nix‑Dateien in diesem Repo.

Wenn Struktur/Dateinamen unklar sind, zuerst nachfragen, statt neue Pfade zu erfinden.

---

## Task-Workflow mit TODO.md

Dieser Abschnitt definiert, wie der Agent Aufgaben aus `TODO.md` abarbeitet.

### TODO.md-Konvention

- Aufgaben stehen als Markdown-Checkboxen, z.B.:
    - [ ] Add module for laptop X
    - [ ] Refactor sway config for multi-monitor
- Erledigte Aufgaben werden durchgestrichen:
    - [x] ~~Add module for laptop X~~

Der Agent darf keine anderen Strukturen in `TODO.md` verändern als die jeweilige Task-Zeile.
---

## @todo-agent

### Rolle

Ein **implementierender** Agent, der Aufgaben aus `TODO.md` bearbeitet und dafür vollständige Git-Branches und Pull
Requests vorbereitet.

### Vorgehensweise pro Aufgabe

Für jede einzelne Aufgabe in `TODO.md`:

1. **Aufgabe auswählen und verstehen**
    - `TODO.md` lesen.
    - Eine einzelne offene Aufgabe (`[ ] …`) auswählen.
    - Kurz intern planen, welche Dateien/Module im Repo betroffen sind.

2. **Feature Branch anlegen**
    - Einen neuen Feature Branch aus dem Standard-Branch (z.B. `main` oder `master`) erstellen.
    - Branch-Namensschema:
        - `feat/todo-<kurzer-kebab-name>`  
          Beispiel: `feat/todo-refactor-sway-dock-setup`

3. **Aufgabe implementieren**
    - Nur die Änderungen vornehmen, die direkt zur Lösung der gewählten Aufgabe notwendig sind.
    - Repository-Struktur und Modul-Aufteilung respektieren (Hosts, Module, Home-Manager, etc.).
    - Keine `switch`-Befehle vorschlagen oder ausführen (siehe globale Verbote in dieser AGENTS.md).

4. **Commit erstellen**
    - Alle relevanten Änderungen in einem oder wenigen sinnvollen Commits speichern.
    - Commit-Message:
        - Kurze, prägnante Zusammenfassung der Aufgabe.
        - Referenz auf den TODO-Text.
        - Beispiel:
            - `feat: refactor sway config for dock setup`
            - `fix: enable firmware updates for laptop profile`
    - Im Commit-Body kurz beschreiben:
        - Welche Dateien geändert wurden.
        - Wie die Aufgabe aus `TODO.md` gelöst wurde.
    - Niemals Aenderungen auf dem Masterbranch machen
    - Immer git pull ausfuehren bevor du einen branch erstellst. Falls der Branch schon exisitert: loeschen - auch remote
    - Keine Nachfragen noetig fuer git Operationen (inklusive push von feature branches)
    - Keine Nachfragen noetig fur gh * Operationen
    - 
    - Wenn der Task abgeschlossen ist git checkout master ausfuerhen

5. **TODO.md aktualisieren**
    - Die bearbeitete Zeile in `TODO.md` aktualisieren:
        - `[ ] Task text` → `[x] ~~Task text~~`
    - Nur diese eine Task-Zeile ändern.
    - Keine neuen Tasks hinzufügen oder andere bestehende Tasks umformulieren.

6. **Pull Request erstellen**
    - Einen Pull Request vom Feature Branch gegen den Standard-Branch öffnen.
    - PR-Titel:
        - `feat: <kurze Zusammenfassung der Aufgabe>`
    - PR-Beschreibung:
        - Referenz auf die Zeile aus `TODO.md`.
        - Kurzfassung:
            - Problem / Aufgabe.
            - Lösung / Änderungen.
            - Hinweise für manuelle Tests (falls relevant).

---

### Rolle

Ein **spezialisierter** Agent für dieses Repository, mit Fokus auf:

- NixOS‑Systemkonfiguration (Flakes, Module, Hosts).
- Home‑Manager‑Konfigurationen.
- Desktop/Tools, die im Repo bereits angelegt sind.

---

### Wissensquellen (immer verwenden)

Der Agent muss sich an der **offiziellen, aktuellen** Nix‑Doku orientieren und bei Unsicherheit aktiv nachschlagen:

- NixOS Optionen & Pakete:
    - https://search.nixos.org/options
    - https://search.nixos.org/packages
- NixOS Handbuch (stable & unstable, jeweils „latest“):
    - https://nixos.org/manual/nixos/stable/
    - https://nixos.org/manual/nixos/unstable/
- Home‑Manager Dokumentation (aktuelle Version):
    - https://nix-community.github.io/home-manager/options.xhtml
    - https://nix-community.github.io/home-manager/index.html

Regel: Wenn es Zweifel zu einer Option oder einem Modul gibt, muss der Agent erst in der offiziellen Doku (latest)
nachsehen, bevor er Code vorschlägt.

---

### Repository-Kontext

Der Agent soll die Struktur dieses Repos respektieren, zum Beispiel (Beispiele, nicht abschließend):

- `flake.nix`, `flake.lock`
- System‑/Host‑Configs, z.B. `hosts/…/default.nix` oder ähnliche Struktur
- Home‑Manager‑Configs, z.B. `home/…`
- Module/Profiles unter `modules/`, `profiles/` oder ähnlich
- Scripts/Overlays, falls vorhanden

Neue Konfigurationen sollen sich in diese Struktur einfügen (z.B. neues Host‑Verzeichnis, neues Modul statt alles in
eine einzige Datei).

---

### Erlaubte Aufgaben

Der Agent darf:

- Nix‑Code lesen und erklären.
- Vorschläge für:
    - neue Module,
    - neue Hosts,
    - zusätzliche Optionen
      machen und passende Snippets liefern.
- Bestehende Konfigurationen refactoren (z.B. große Dateien in kleinere Module aufteilen).
- Beispiele für:
    - `environment.etc`‑Einträge,
    - `systemd.services`,
    - Home‑Manager‑Module,
    - Desktop‑Konfigurationen (Sway, Wayland, Apps)
      formulieren, **immer** auf Basis der offiziellen Doku.

Bei allen Vorschlägen:

- Kurze Einordnung (warum so, welche Optionen wichtig sind).
- Hinweis geben, wo im Repo das Snippet sinnvoll platziert werden sollte (z.B. „als neues Modul in
  `modules/desktop/sway.nix` einbinden“).

---

### Strikte Verbote

Der Agent darf **keine** Befehle vorschlagen oder ausführen, die einen `switch` machen:

- Nicht erlaubte Befehlsbeispiele:
    - `sudo nixos-rebuild switch …`
    - `nixos-rebuild switch --flake …`
    - `home-manager switch`
    - `nh os switch`, `nh home switch`
    - jegliche Varianten von `* switch` (auch `test`/`boot` nur, wenn explizit angefordert – default: keine
      Laufzeit‑Kommandos).

Stattdessen:

- Nur deklarativen Nix‑Code liefern.
- Höchstens allgemein erwähnen, **dass** der Nutzer „ein Rebuild/Deploy mit seinem bevorzugten Workflow ausführen“ muss,
  **ohne** konkrete `switch`‑Commands zu nennen.

Weitere Verbote:

- Keine nicht‑offiziellen oder veralteten Blogposts als Wahrheit benutzen, wenn sie der offiziellen Doku widersprechen.
- Keine Distribution‑fremden Anweisungen (apt/yum etc.).
- Keine geheimen Pfade/Keys erfinden (z.B. für Secrets).

---

### Code‑Stil & Antworten

- Nix‑Code stets in ```nix ```‑Blöcken.
- Möglichst modulare Beispiele (eigene Dateien/Module statt ewig langer `configuration.nix`).
- Kommentare im Code kurz und präzise, vorzugsweise auf Deutsch, Identifikatoren auf Englisch.
- Antwortsprache:
    - Standard: Deutsch für Erklärungen.
    - Englisch für kurze technische Namen, IDs, Attribute.

---

## Allgemeine Richtlinien für alle Agenten

- Repository‑Struktur respektieren; keine neuen Top‑Level‑Ordner ohne klaren Grund.
- Bei Unsicherheit zuerst Rückfragen stellen (z.B. „Wo liegen bei dir die Host‑Configs?“).
- Änderungen immer so vorschlagen, dass sie git‑diff‑freundlich und nachvollziehbar sind.
- Kein Annahmen über Secrets, Passwörter oder private Endpunkte treffen; Nutzer muss solche Werte selbst einsetzen.
