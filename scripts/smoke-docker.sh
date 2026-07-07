#!/usr/bin/env bash
# Docker smoke stub — customize when Dockerfile and docker-compose.yml exist.
# Reference: https://github.com/jcuel/disk-tool/blob/dev/scripts/smoke-docker.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f Dockerfile ]]; then
  echo "smoke-docker.sh: no Dockerfile — skip or implement container smoke." >&2
  exit 1
fi

if [[ ! -f docker-compose.yml ]]; then
  echo "smoke-docker.sh: no docker-compose.yml — implement or remove Docker CI job." >&2
  exit 1
fi

echo "smoke-docker.sh: stub — replace with docker compose build + smoke services"
exit 0
