#!/usr/bin/env bash
# Create/replace GH_PROJECT_SYNC with a classic PAT (required for user-owned project boards).
set -euo pipefail

REPO="${1:-<owner>/<repo>}"
PAT_URL="https://github.com/settings/tokens/new?scopes=project,repo&description=<repo>-GH_PROJECT_SYNC"

echo "GitHub fine-grained PATs cannot access user-owned Projects."
echo "Use a classic PAT (ghp_...) with scopes: project, repo"
echo ""
echo "Opening token creation page..."
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$PAT_URL" >/dev/null 2>&1 || true
elif command -v open >/dev/null 2>&1; then
  open "$PAT_URL" || true
else
  echo "$PAT_URL"
fi

echo ""
read -r -s -p "Paste classic PAT (ghp_...), then Enter: " PAT
echo ""
if [[ -z "$PAT" ]]; then
  echo "No token provided." >&2
  exit 1
fi
if [[ ! "$PAT" =~ ^ghp_ ]]; then
  echo "Expected a classic PAT starting with ghp_." >&2
  exit 1
fi

echo "Setting GH_PROJECT_SYNC on $REPO..."
gh secret set GH_PROJECT_SYNC --repo "$REPO" --body "$PAT"
echo "Secret updated."

echo "Done. Configure scripts/project-board.env and test with scripts/sync-project-board.sh"
