#!/usr/bin/env bash
# Deploy redirect/public/ to a training webroot (schulung only). Requires SSH + RoE.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
DEST_HOST="${LAB_REDIRECT_HOST:-}"
DEST_PATH="${LAB_REDIRECT_PATH:-/var/www/lab-redirect/}"

if [[ -z "$DEST_HOST" ]]; then
  echo "Set LAB_REDIRECT_HOST=your-training-host (oder Schulungs-VPS)" >&2
  echo "Optional: LAB_REDIRECT_PATH=/var/www/lab-redirect/" >&2
  exit 1
fi

rsync -avz --delete "${ROOT}/public/" "${DEST_HOST}:${DEST_PATH}"
echo "Deployed. Test:"
echo "  curl -sI 'https://YOUR-DEMO-HOST/freigabe/1847/' | head -5"
