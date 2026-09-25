#!/usr/bin/env bash
# Deploy build/web to the gh-pages branch (no GitHub Actions workflow scope required).
set -euo pipefail

REPO_NAME="${1:-brew-coffee}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

flutter build web --release --base-href "/${REPO_NAME}/"
cd build/web
touch .nojekyll

if [[ ! -d .git ]]; then
  git init
  git checkout -b gh-pages
fi

git add -A
git commit -m "Deploy $(date -u +%Y-%m-%dT%H:%M:%SZ)" || true
git push -f "https://github.com/atirek-pothiwala/${REPO_NAME}.git" HEAD:gh-pages

echo "Published to https://atirek-pothiwala.github.io/${REPO_NAME}/"
