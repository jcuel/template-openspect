#!/usr/bin/env bash
# Set project version in openspec/config.yaml (semver source of truth).
# Extend this script to bump additional version files for your stack.
# Usage: bash scripts/bump-version.sh 1.1.0
set -euo pipefail

NEW="${1:?usage: bump-version.sh X.Y.Z}"
if ! [[ "$NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "invalid semver: $NEW" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$ROOT/openspec/config.yaml"

if [[ ! -f "$CONFIG" ]]; then
  echo "missing $CONFIG" >&2
  exit 1
fi

CURRENT="$(grep -E '^version:' "$CONFIG" | sed 's/version:[[:space:]]*//' | tr -d '\r')"
echo "version: $CURRENT -> $NEW"

python - "$CONFIG" "$NEW" <<'PY'
import re, sys
path, ver = sys.argv[1], sys.argv[2]
text = open(path, encoding="utf-8").read()
text = re.sub(r"^version: .*$", f"version: {ver}", text, count=1, flags=re.M)
open(path, "w", encoding="utf-8", newline="\n").write(text)
PY

# Optional: extend version bumps for your stack, e.g.:
# - package.json / package-lock.json (jq)
# - CLI --version string in main.go / main.py
# - pyproject.toml / Cargo.toml version fields

echo "bumped to $NEW"
