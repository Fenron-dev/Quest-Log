# CLAUDE.md – Arbeitsregeln für Quest-Log

## Zuerst lesen

- Die fachliche Spezifikation liegt lokal unter `docs/private/SPEC.md`. Lies sie vor jeder größeren Aufgabe. Sie ist **nicht** im Repository und darf es nie werden.
- Antworte und dokumentiere auf Deutsch. Code, Bezeichner und Commit-Nachrichten auf Englisch.

## Dieses Repository ist öffentlich

Alles, was committet wird, ist für jeden sichtbar – inklusive Commit-Nachrichten, PR-Texten, Issues und Build-Artefakten. Deshalb gilt ausnahmslos:

1. **Keine Geheimnisse:** keine Passwörter, API-Schlüssel, Tokens, Zertifikate, Signatur-Schlüssel, Webhook-URLs.
2. **Keine echten Daten:** keine Kunden-, Firmen- oder Personennamen, Telefonnummern, Adressen, E-Mail-Adressen, internen Hostnamen, IP-Adressen oder Server-URLs. Testdaten sind erfunden (z. B. „Beispiel GmbH“, `example.com`, Rufnummern aus `+49 30 1234567`-Platzhaltern).
3. **Keine Spezifikation im Repo:** Inhalte aus `docs/private/` nicht in Code-Kommentare, README, Commit-Nachrichten, PR-Beschreibungen oder Issues kopieren. Beschreibe Änderungen technisch und knapp.
4. **Konfiguration nur zur Laufzeit:** Server-Adressen, Zugangsdaten und Schlüssel gibt der Nutzer in der App ein (gespeichert mit `flutter_secure_storage`) bzw. der Server liest sie aus Umgebungsvariablen. Nur `.env.example` mit Platzhaltern wird eingecheckt. Keine Geheimnisse per `--dart-define` in Builds.
5. **Build-Artefakte sind öffentlich:** Alles, was in eine APK oder Desktop-App kompiliert wird, kann jeder herunterladen und auslesen.
6. Ordner für Code nicht `secrets`, `data` (im Hauptordner), `exports` oder `backups` nennen – diese sind per `.gitignore` ausgeschlossen.

Vor jedem Commit: `git diff --staged` prüfen. Der Pre-commit-Hook (gitleaks) muss laufen; nie mit `--no-verify` umgehen.

## Git-Ablauf

- `main` ist geschützt. Immer in einem Feature-Branch arbeiten (`feat/…`, `fix/…`, `chore/…`) und einen Pull Request öffnen.
- Kein Force-Push, kein Rebase von bereits gepushten fremden Commits, kein Löschen von Branches anderer.
- Kleine, in sich geschlossene Commits. Merge erst, wenn die CI grün ist; den Merge macht der Nutzer.

## Projektstruktur

```
app/      Flutter-App (Android zuerst, Desktop: Windows, macOS, Linux; iOS später)
server/   Go-Backend (Sync, Anbindungen an externe Systeme)
docs/     öffentliche Hinweise; docs/private/ nur lokal
```

## Technik

- **App:** Flutter (stable), Riverpod für Zustand, Drift (SQLite) als lokale Datenbank, offline-first. Feature-orientierte Ordner unter `app/lib/features/`.
- **Server:** Go (Version aus `server/go.mod`), PostgreSQL, Standardbibliothek bevorzugen, wenige gut gepflegte Abhängigkeiten.
- **Sync:** lokal zuerst; Server-Sync kommt in einer späteren Phase (siehe Spezifikation).
- Neue Abhängigkeiten nur, wenn nötig, aktiv gepflegt und mit fester Version. Kurz im PR begründen.

## Sicherheitsregeln für den Code

- **Server:** jeder Endpunkt mit Authentifizierung; TLS voraussetzen; Eingaben validieren; nur parametrisierte SQL-Abfragen; Rate-Limiting; kein `Access-Control-Allow-Origin: *`; Fehlermeldungen ohne interne Details; Logs ohne personenbezogene Daten und ohne Tokens.
- **Zugangsdaten externer Systeme** liegen nur auf dem Server, nie in der App.
- **App:** Tokens nur in Secure Storage, nie in SharedPreferences oder Logs; Zertifikatsprüfung nie abschalten; Berechtigungen (Anrufe, Standort, Kamera) erst bei Bedarf und mit Erklärung anfordern.
- **Backups/Exporte** enthalten persönliche Daten: verschlüsselt anbieten, nie automatisch hochladen.

## GitHub Actions

- Actions immer auf einen vollständigen Commit-Hash pinnen (mit Versions-Kommentar).
- Workflows mit `permissions: contents: read`; mehr Rechte nur pro Job und begründet.
- Niemals `pull_request_target` oder Secrets in Workflows, die bei Pull Requests laufen.
- Signierte Release-Builds später nur über eine GitHub-Umgebung `release` mit Freigabe durch den Nutzer.

## Befehle

```bash
# App
cd app && flutter pub get && dart format . && flutter analyze && flutter test
# Server
cd server && go vet ./... && go test -race ./...
```

Der Mac des Nutzers hat wenig freien Speicher: **keine vollständigen Android- oder Desktop-Builds lokal**. Lokal nur Analyse und Tests; gebaut wird in der CI. Build-Artefakte stehen nach dem Lauf unter Actions → Artifacts.

## Fertig heißt

- Analyse und Tests lokal grün, CI grün.
- Neue Logik hat Tests (besonders Zeiterfassung, AE-Rundung, Sync).
- Keine Geheimnisse oder echten Daten im Diff.
- Kurze Zusammenfassung für den Nutzer auf Deutsch: was geändert wurde, wie man es testet.
