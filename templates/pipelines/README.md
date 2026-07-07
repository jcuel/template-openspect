# CI pipeline templates

Copy-ready workflows from [disk-tool](https://github.com/jcuel/disk-tool). Use when your app has Go + Node + Docker + Cypress.

## What's here

- **`ci-go-node-docker-e2e.yml`** — tests, govulncheck, smoke, E2E, Trivy
- **`rulesets-dev.full.json`** / **`rulesets-master.full.json`** — matching branch checks

Same workflow is also in [`.github/workflow-templates/`](../.github/workflow-templates/) (Actions → New workflow).

## Quick enable

```bash
# 1. Replace <your-project> in the workflow, then:
cp templates/pipelines/ci-go-node-docker-e2e.yml .github/workflows/ci.yml
cp templates/pipelines/rulesets-dev.full.json .github/rulesets/dev.json
cp templates/pipelines/rulesets-master.full.json .github/rulesets/master.json

# 2. Implement scripts/smoke-*.sh and scripts/e2e-run.sh (stubs in scripts/)

# 3. Sync rulesets and retire bootstrap CI
bash scripts/apply-branch-rulesets.sh
# delete or disable .github/workflows/ci-bootstrap.yml
# in sync-project-board.yml: workflows: [CI]  (not CI bootstrap)
```

## Required check names

Must match between workflow jobs and rulesets:

`Linux — unit + API smoke` · `Windows — unit + API smoke` · `Linux — Docker smoke` · `Linux — Cypress E2E` · `Security — Trivy` · `Policy — master is maintainer-only` (master only)

## Needs

`go.mod`, `web/`, `Dockerfile`, `.trivyignore` — or remove the jobs you don't use.
