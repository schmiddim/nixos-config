# NeoMutt Workflow (GMX, mbsync, msmtp)

Kurz und praktisch fuer den Alltag. Diese Notizen beziehen sich auf die
Home-Manager-Config in diesem Repo (neomutt + mbsync + msmtp).

## 1) Erststart
- IMAP/SMTP muessen bei GMX aktiviert sein.
- Mails synchronisieren:
  - einmalig: `mbsync -a`
  - laufend: systemd user timer (alle 5 Min) laeuft automatisch

## 2) NeoMutt starten
- `neomutt` starten
- Sidebar zeigt Inbox/Sent/Drafts/Trash (sofern Foldernamen passen)

## 3) Zentrale Shortcuts
- `q` = quit
- `c` = change folder
- `s` = save message
- `r` = reply
- `g` = group reply
- `f` = forward
- `d` = delete (toggelt)
- `u` = undelete
- `Ctrl+b` = Sidebar ein/aus
- `F5` = manuelles Sync: `mbsync -a`

## 4) Mails abrufen / versenden
- Abruf:
  - automatisch per timer
  - manuell mit `F5` oder `mbsync -a`
- Versand:
  - ueber msmtp (wird von neomutt aufgerufen)

## 5) Wenn Ordnernamen nicht passen
GMX nutzt manchmal deutschsprachige Ordner.
Teste per:
- `mbsync -l` (zeigt IMAP-Ordner)

Passe danach in `home/mutt.nix` an:
- `accounts.email.accounts.gmx.folders` (Inbox/Sent/Drafts/Trash)
- `accounts.email.accounts.gmx.neomutt.extraMailboxes`

## 6) Passwort/Secrets
- Passwort kommt aus `~/.config/zsh/env.secrets`:
  - `export GMX_MAIL_PASSWD=...`

## 7) Probleme/Checkliste
- Keine Mails?
  - IMAP bei GMX aktiviert?
  - `mbsync -a` error output pruefen
- Kein Versand?
  - SMTP Daten korrekt?
  - `msmtp --debug` testen

