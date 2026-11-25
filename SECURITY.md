# Sicherheit

## Lücken melden

Bitte Sicherheitslücken **nicht** als öffentliches Issue melden. Nutze stattdessen die private Meldung über GitHub: Reiter **Security** → **Report a vulnerability**.

## Grundsätze dieses Repositories

- Das Repository ist öffentlich. Es enthält keine Zugangsdaten, Schlüssel, Kundendaten, internen Adressen oder Konfigurationen.
- Zugangsdaten werden ausschließlich zur Laufzeit eingegeben und sicher gespeichert (App: Secure Storage, Server: Umgebungsvariablen).
- Jeder Push und jeder Pull Request wird automatisch auf versehentlich eingecheckte Geheimnisse geprüft.
- Der Branch `main` ist geschützt: Änderungen nur per Pull Request, kein Force-Push, kein Löschen.
- GitHub Actions sind auf feste Commit-Hashes gepinnt und laufen mit minimalen Rechten. Pull Requests von außen erhalten keine Secrets.
