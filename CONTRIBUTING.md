# Contributing to <your-project>

Thank you for your interest in contributing. This project welcomes collaboration under the terms of the [LICENSE](LICENSE).

## Branch model

| Branch | Purpose | Who merges here |
|--------|---------|-----------------|
| **`dev`** | Integration branch for all contributor work | Maintainers (via reviewed PRs) |
| **`master`** | Stable / release-ready | **Maintainer only** (`dev` → `master`) |

**Contributors:** fork the repo, branch from `dev`, and open pull requests **into `dev`**.

**Do not** open PRs targeting `master` unless you are the maintainer performing a release integration (`dev` → `master` only).

```
fork ──► feat/your-change ──► PR ──► dev ──► (maintainer) ──► master
```

## Enforced branch rules (GitHub)

These policies are applied via [repository rulesets](https://github.com/<owner>/<repo>/settings/rules) (not documentation-only):

| Branch | Enforcement |
|--------|-------------|
| **`dev`** | Pull request required; CI must pass; no force-push; branch cannot be deleted |
| **`master`** | Direct pushes blocked (admin bypass via PR only); pull request required; CI + branch-policy must pass; no force-push; branch cannot be deleted |

Required CI checks (bootstrap): **Bootstrap — repo check**.

When you add language-specific CI, update [`.github/rulesets/`](.github/rulesets/) with your job names and re-sync rulesets.

Contributors opening a PR to `master` (other than maintainer `dev` → `master`) will fail the **Policy — master is maintainer-only** check.

Ruleset definitions live in [`.github/rulesets/`](.github/rulesets/). They sync automatically to GitHub when merged to `dev` via the [Sync branch rulesets](https://github.com/<owner>/<repo>/actions/workflows/sync-branch-rulesets.yml) workflow (requires the `GH_RULESET_SYNC` repo secret — a fine-grained PAT with **Administration** read/write on this repo). Maintainers can also run locally for debugging:

```bash
bash scripts/apply-branch-rulesets.sh
```

## Add your stack CI

The template ships with [`.github/workflows/ci-bootstrap.yml`](.github/workflows/ci-bootstrap.yml) — a minimal passing job so branch rulesets work on day one.

**Full pipeline templates** (Go + Node + Docker + Cypress + Trivy) live in [`templates/pipelines/`](templates/pipelines/README.md):

| Template | Purpose |
|----------|---------|
| [`ci-go-node-docker-e2e.yml`](templates/pipelines/ci-go-node-docker-e2e.yml) | Full CI workflow — copy to `.github/workflows/ci.yml` |
| [`rulesets-dev.full.json`](templates/pipelines/rulesets-dev.full.json) | Required checks for full CI on `dev` |
| [`rulesets-master.full.json`](templates/pipelines/rulesets-master.full.json) | Required checks for full CI on `master` |

Supporting scripts: `scripts/trivy-pr-comment.sh`, `scripts/smoke-api.sh`, `scripts/smoke-docker.sh`, `scripts/e2e-run.sh` (stubs until you implement your app).

When you enable full CI:

1. Copy `templates/pipelines/ci-go-node-docker-e2e.yml` → `.github/workflows/ci.yml` and replace `<your-project>`.
2. Copy `templates/pipelines/rulesets-*.full.json` → `.github/rulesets/`.
3. Remove or disable `ci-bootstrap.yml`.
4. Update `sync-project-board.yml` to trigger on workflow `CI` instead of `CI bootstrap`.
5. Merge to `dev` to re-sync rulesets.

Or build your own CI:

1. Create `.github/workflows/ci.yml` with your test, lint, and security jobs.
2. Update required status check names in [`.github/rulesets/dev.json`](.github/rulesets/dev.json) and [`master.json`](.github/rulesets/master.json).
3. Merge to `dev` to trigger [sync-branch-rulesets.yml](.github/workflows/sync-branch-rulesets.yml).

### Recommended CI security baseline

Reference implementation: [jcuel/disk-tool](https://github.com/jcuel/disk-tool) CI.

| Scan | Tool | When to add |
|------|------|-------------|
| Dependency vulnerabilities (Go) | [govulncheck](https://go.dev/blog/vuln) | When using Go modules |
| Filesystem + container CVEs | [Trivy](https://github.com/aquasecurity/trivy-action) | When shipping containers or want FS scan |
| Dependency updates | [Dependabot](https://docs.github.com/en/code-security/dependabot) | Already configured for `github-actions`; extend per stack |

Record manual security review in `testing-report.md` via `/verify` until CI scans are automated.

## Release to master (version bump)

When a maintainer merges **`dev` → `master`**, the [Release version](https://github.com/<owner>/<repo>/actions/workflows/release-version.yml) workflow runs automatically:

1. Reads the current version from [`openspec/config.yaml`](openspec/config.yaml) (source of truth).
2. Bumps **`openspec/config.yaml`** (extend [`scripts/bump-version.sh`](scripts/bump-version.sh) for additional version files).
3. Commits `[release] bump version to X.Y.Z` on `master` and creates git tag `vX.Y.Z`.

**Default bump:** minor (`0.1.0` → `0.2.0`).

**Explicit version (recommended for milestone releases):** include in the `dev` → `master` PR description:

```text
Release-Version: 1.1.0
```

**Repository variables (optional):** set `RELEASE_VERSION` or `RELEASE_BUMP_KIND` (`major` | `minor` | `patch`) under Settings → Secrets and variables → Actions → Variables.

**Push permission:** if branch rules block `github-actions[bot]` from pushing to `master`, add repo secret **`GH_RELEASE_TOKEN`** (fine-grained PAT with **Contents** write on this repo) or grant Actions bypass on the master ruleset.

After the release commit lands on `master`, **`dev` is synced automatically** via [Sync dev from master](https://github.com/<owner>/<repo>/actions/workflows/sync-dev-from-master.yml) (opens a `master` → `dev` PR when drift is detected). See [Sync dev from master (branch drift)](#sync-dev-from-master-branch-drift) below.

### Release assets

When tag `vX.Y.Z` is pushed, [Release assets](https://github.com/<owner>/<repo>/actions/workflows/release-assets.yml) is a stub workflow — customize it to build and upload your release artifacts.

## Sync dev from master (branch drift)

Release merges and version bumps on `master` can leave `dev` behind in **commit history** even when file content matches.

| Check | Command / workflow |
|-------|-------------------|
| Report drift | `bash scripts/check-branch-drift.sh` |
| Fix (open sync PR) | `bash scripts/sync-dev-from-master.sh` |
| Automatic | [sync-dev-from-master.yml](.github/workflows/sync-dev-from-master.yml) on push to `master` and after Release version |
| Weekly monitor | [branch-drift-check.yml](.github/workflows/branch-drift-check.yml) (warns only) |

**Normal states:** `dev_ahead` (integration work before release) — no action. **`master_ahead`** — merge the auto-opened `master` → `dev` PR.

**Optional repo variable:** `AUTO_MERGE_BRANCH_SYNC=true` auto-merges sync PRs when drift is history-only (same tree).

**Optional secret:** `GH_BRANCH_SYNC` — PAT with `contents` + `pull_requests` write if the default `GITHUB_TOKEN` cannot open PRs.

## Repository secrets

| Secret | Purpose |
|--------|---------|
| `GH_RULESET_SYNC` | Fine-grained PAT with **Administration** read/write — sync branch rulesets |
| `GH_RELEASE_TOKEN` | Fine-grained PAT with **Contents** write — release version commits/tags |
| `GH_BRANCH_SYNC` | PAT with `contents` + `pull_requests` write — open branch sync PRs |
| `GH_PROJECT_SYNC` | Classic PAT (`project` + `repo`) — sync GitHub Project board |

See [`.github/PROJECT.md`](.github/PROJECT.md) for project board setup.

## Getting started

1. Fork [`<owner>/<repo>`](https://github.com/<owner>/<repo>) on GitHub.
2. Clone your fork and add upstream:
   ```bash
   git clone https://github.com/YOUR_USER/<repo>.git
   cd <repo>
   git remote add upstream https://github.com/<owner>/<repo>.git
   ```
3. Create a feature branch from **`dev`**:
   ```bash
   git fetch upstream
   git checkout -b feat/my-change upstream/dev
   ```
4. Make changes and run your project's local checks.
5. Push to your fork and open a PR **against `dev`**.

## Pull requests

- Use the [pull request template](.github/pull_request_template.md).
- Open issues via [GitHub issue templates](.github/ISSUE_TEMPLATE/) (bug, OpenSpec change, chore, question).
- Link a GitHub issue when the work is non-trivial (`Closes #N` in the description).
- Keep PRs focused; one logical change per PR.
- CI must pass before merge.
- For larger features, follow the OpenSpec / SPECBOOT flow documented in [README.md](README.md) and `.cursor/rules/`.

## Code style

- Match existing patterns in the file you edit.
- No unrelated drive-by refactors in the same PR.

## Security

Report vulnerabilities privately — see [SECURITY.md](SECURITY.md). Do not open public issues for security bugs.

## Code of conduct

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). Participants are expected to uphold it.

## Questions

Open a [GitHub Discussion](https://github.com/<owner>/<repo>/discussions) or an issue labeled `question` if Discussions are not enabled.
