#!/usr/bin/env bash
# API smoke test stub — customize for your application.
# Reference: https://github.com/jcuel/disk-tool/blob/dev/scripts/smoke-api.sh
set -euo pipefail

BIN="${1:-./bin/<your-project>}"

if [[ ! -f "$BIN" ]]; then
  echo "smoke-api.sh: binary not found at $BIN" >&2
  echo "Implement scripts/smoke-api.sh before enabling full CI (see templates/pipelines/README.md)." >&2
  exit 1
fi

echo "smoke-api.sh: stub — replace with your API health checks"
exit 0
