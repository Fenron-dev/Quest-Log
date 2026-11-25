# Quest-Log

Persönliche App für Aufgaben, Zeiterfassung, Projekte und Ziele – für Android und Desktop (Windows, macOS, Linux). Das Projekt befindet sich am Anfang der Entwicklung.

## Aufbau

| Ordner | Inhalt |
| --- | --- |
| `app/` | Flutter-App für Android und Desktop |
| `server/` | Go-Backend für Synchronisation und Anbindungen |
| `docs/` | öffentliche Entwickler-Hinweise |

## Entwicklung

Builds laufen über GitHub Actions, siehe `.github/workflows/`. Lokal reichen Analyse und Tests:

```bash
cd app && flutter analyze && flutter test
cd server && go vet ./... && go test ./...
```

Vor dem ersten Commit einmalig den Secret-Scanner als Git-Hook einrichten:

```bash
pip install pre-commit && pre-commit install
```

## Sicherheit

Sicherheitslücken bitte nicht als öffentliches Issue melden, siehe [SECURITY.md](SECURITY.md).

## Lizenz

Es ist keine Lizenz vergeben. Alle Rechte vorbehalten.
