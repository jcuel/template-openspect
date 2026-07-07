#!/usr/bin/env bash
# Cypress E2E stub — customize when web/ + Cypress are configured.
# Reference: https://github.com/jcuel/disk-tool/blob/dev/scripts/e2e-run.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ ! -d "$ROOT/web" ]]; then
  echo "e2e-run.sh: no web/ directory — remove E2E CI job or add frontend." >&2
  exit 1
fi

echo "e2e-run.sh: stub — replace with build, serve, and Cypress run"
exit 0
