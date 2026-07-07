# SPECBOOT Project Template

Reusable scaffold for OpenSpec + SPECBOOT workflow with OSS governance, GitHub automation, and branch protection.

## Quick start

Use this repo as a template or copy its contents into a new repository root.

### 1. Configure project identity

Edit `openspec/config.yaml`:

```yaml
project: <your-project>
domain: <your-domain>
version: 0.1.0   # semver source of truth for releases
```

Rename the domain spec folder:

```powershell
Rename-Item openspec\specs\_domain_ <your-domain>
```

### 2. Replace placeholders

Find-replace across the repo:

| Placeholder | Example |
|-------------|---------|
| `<owner>` | `jcuel` |
| `<repo>` | `my-project` |
| `<your-project>` | `my-project` |
| `<your-domain>` | `my-project` |
| `<project-board-url>` | `https://github.com/users/jcuel/projects/1` |

Files with placeholders: `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `LICENSE`, `.github/PROJECT.md`, `.github/ISSUE_TEMPLATE/config.yml`, `.cursor/rules/github-workflow.mdc`, `scripts/project-board.env`, `scripts/setup-gh-project-sync-secret.*`

### 3. Create GitHub branches

Create **`dev`** and **`master`** branches. Set default branch to **`dev`** for contributor PRs.

### 4. GitHub Project board

1. Create a project board (Table or Board layout).
2. Add a **Status** single-select field: Backlog, Ready, In progress, In review, Done.
3. Paste the board URL into `.github/PROJECT.md` and `.cursor/rules/github-workflow.mdc`.
4. Fill `scripts/project-board.env` with board IDs (use `gh project field-list`).

### 5. Repository secrets

| Secret | Purpose |
|--------|---------|
| `GH_RULESET_SYNC` | Fine-grained PAT — **Administration** read/write (sync branch rulesets) |
| `GH_RELEASE_TOKEN` | Fine-grained PAT — **Contents** write (release version commits/tags) |
| `GH_BRANCH_SYNC` | PAT — open `master` → `dev` sync PRs (optional) |
| `GH_PROJECT_SYNC` | Classic PAT — `project` + `repo` scopes (project board sync) |

Helpers: `scripts/setup-gh-project-sync-secret.sh` / `.ps1`

### 6. Sync branch rulesets

Merge to `dev` (or run locally):

```bash
bash scripts/apply-branch-rulesets.sh
```

Rulesets require CI job **Bootstrap — repo check** from `ci-bootstrap.yml`.

### 7. License

Default: **MIT** (`LICENSE`). For noncommercial licensing, see [PolyForm Noncommercial](https://polyformproject.org/licenses/noncommercial/1.0.0/) (used by [disk-tool](https://github.com/jcuel/disk-tool)).

## Contents

| Path | Purpose |
|------|---------|
| `.cursor/rules/` | Engineering guardrails, SPECBOOT state machine, GitHub workflow |
| `.cursor/commands/` | Slash commands (`/enrich-us` through `/commit`) |
| `.cursor/templates/openspec/` | Artifact templates for new changes |
| `openspec/config.yaml` | Project, domain, and version configuration |
| `openspec/specs/_domain_/spec.md` | Source-of-truth spec stub (rename folder) |
| `openspec/changes/` | One folder per feature change |
| `CODE_OF_CONDUCT.md` | Contributor Covenant 2.1 |
| `CONTRIBUTING.md` | Branch model, rulesets, release flow |
| `SECURITY.md` | Private vulnerability reporting |
| `.github/` | Workflows, rulesets, issue/PR templates, project board guide |
| `templates/pipelines/` | Full CI workflow + rulesets — see [`templates/pipelines/README.md`](templates/pipelines/README.md) |

## Workflow

```
/enrich-us → /propose → /apply → /verify → /code-review → /archive → /commit
```

Type `/` in Cursor Agent chat to invoke commands.

Each stage updates GitHub Issues and the Project board (see `github-workflow.mdc`).

## CI bootstrap

Ships with [`.github/workflows/ci-bootstrap.yml`](.github/workflows/ci-bootstrap.yml) — a minimal passing job so branch rulesets work immediately.

### Full pipeline templates

Copy-ready CI from disk-tool lives in [`templates/pipelines/`](templates/pipelines/README.md):

| File | Purpose |
|------|---------|
| `ci-go-node-docker-e2e.yml` | Linux/Windows tests, govulncheck, Docker smoke, Cypress E2E, Trivy |
| `rulesets-dev.full.json` / `rulesets-master.full.json` | Matching branch protection checks |

Also available via GitHub **Actions → New workflow** (`.github/workflow-templates/`).

**Enable steps:**

1. Replace `<your-project>` in the copied workflow.
2. `cp templates/pipelines/ci-go-node-docker-e2e.yml .github/workflows/ci.yml`
3. `cp templates/pipelines/rulesets-*.full.json .github/rulesets/`
4. Implement `scripts/smoke-*.sh` and `scripts/e2e-run.sh` (stubs included).
5. Disable `ci-bootstrap.yml`; update `sync-project-board.yml` to watch workflow `CI`.

When you add custom CI instead:

1. Create `.github/workflows/ci.yml` with your test/lint/security jobs.
2. Update required status check names in [`.github/rulesets/dev.json`](.github/rulesets/dev.json) and [`master.json`](.github/rulesets/master.json).
3. Merge to `dev` to re-sync rulesets.

### Recommended security baseline

Reference: [disk-tool CI](https://github.com/jcuel/disk-tool/blob/dev/.github/workflows/ci.yml)

| Scan | Tool |
|------|------|
| Go dependency CVEs | govulncheck |
| Filesystem + container CVEs | Trivy |
| Dependency updates | Dependabot (extend [`.github/dependabot.yml`](.github/dependabot.yml)) |

Record manual security review in `testing-report.md` via `/verify` until CI scans are configured.

## Release flow

Maintainer merges **`dev` → `master`**:

1. [Release version](.github/workflows/release-version.yml) bumps `openspec/config.yaml` and tags `vX.Y.Z`.
2. [Release assets](.github/workflows/release-assets.yml) stub runs (customize for your artifacts).
3. [Sync dev from master](.github/workflows/sync-dev-from-master.yml) opens a sync PR if branches drift.

See [CONTRIBUTING.md](CONTRIBUTING.md) for `Release-Version: X.Y.Z` in PR descriptions.

## Placeholders

- `_domain_` — rename to your OpenSpec domain (e.g. `api`, `core`)
- `config.yaml` — set `project`, `domain`, and `version`
- Do not copy `openspec/changes/<example-change>/` from a live project; start with an empty `changes/` folder
