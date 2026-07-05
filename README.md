# SPECBOOT Project Template

Reusable scaffold for OpenSpec + SPECBOOT workflow. Copy into a new repo root to bootstrap.

## Bootstrap

From the target project root:

```powershell
# Copy Cursor config and OpenSpec skeleton (adjust paths if needed)
Copy-Item -Recurse -Force template\.cursor .
Copy-Item -Recurse -Force template\openspec .

# Rename domain folder and set project name
Rename-Item openspec\specs\_domain_ <your-domain>
```

Edit `openspec/config.yaml`:

```yaml
project: <your-project>
domain: <your-domain>
version: 0.1.0
```

Replace `<domain>` in `.cursor/commands/` paths if you customized the folder name differently from `config.yaml` `domain` value. Commands resolve the domain from `openspec/config.yaml`.

## Contents

| Path | Purpose |
|------|---------|
| `.cursor/rules/` | Engineering guardrails + SPECBOOT state machine |
| `.cursor/commands/` | Slash commands (`/enrich-us` through `/commit`) |
| `.cursor/templates/openspec/` | Artifact templates for new changes |
| `openspec/config.yaml` | Project and domain configuration |
| `openspec/specs/_domain_/spec.md` | Source-of-truth spec stub (rename folder) |
| `openspec/changes/` | Empty; one folder per feature change |

## Workflow

```
/enrich-us → /propose → /apply → /verify → /code-review → /archive → /commit
```

Type `/` in Cursor Agent chat to invoke commands after copying `.cursor/commands/` to the project root.

## Placeholders

- `_domain_` — rename to your OpenSpec domain (e.g. `disk-tool`, `api`, `core`)
- `config.yaml` — set `project` and `domain` to match your repo

Do not copy `openspec/changes/<example-change>/` from a live project; start with an empty `changes/` folder.
