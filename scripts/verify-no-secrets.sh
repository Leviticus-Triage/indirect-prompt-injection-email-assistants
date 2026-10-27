#!/usr/bin/env bash
# Pre-push secret / PII heuristic scan (training repo).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0

echo "==> Forbidden filenames"
for f in .env .demo-portal-url; do
  if [[ -f "$f" ]]; then
    echo "FAIL: $f must not be committed (gitignored)"
    FAIL=1
  fi
done

echo "==> Pattern scan (excluding .git, scripts/verify-no-secrets.sh)"
PATTERNS=(
  "GMAIL_SMTP_APP_PASSWORD=['\"][a-z]{16}['\"]"
  'xox[baprs]-'
  'sk-[A-Za-z0-9]{20,}'
  'AIza[0-9A-Za-z_-]{20,}'
  'ghp_[A-Za-z0-9]{20,}'
  'BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY'
  '/mnt/docker-ssd'
  'VTBW'
  'jonathangruner'
  'exodus-hensen'
  '127\.0\.0\.1:18765'
  'VM200'
)

while IFS= read -r -d '' file; do
  [[ "$file" == *".git/"* ]] && continue
  [[ "$file" == *"scripts/verify-no-secrets.sh" ]] && continue
  for pat in "${PATTERNS[@]}"; do
    if grep -qE "$pat" "$file" 2>/dev/null; then
      echo "FAIL: pattern '$pat' in $file"
      FAIL=1
    fi
  done
done < <(find . -type f ! -path './.git/*' -print0)

echo "==> Check for accidental email-as-filename"
if find . -maxdepth 1 -type f -name '*@*' | grep -q .; then
  find . -maxdepth 1 -type f -name '*@*' -print
  echo "FAIL: remove stray address files from repo root"
  FAIL=1
fi

if [[ "$FAIL" -eq 0 ]]; then
  echo "OK: no obvious secrets detected."
  exit 0
fi
echo "Fix issues before publishing."
exit 1
