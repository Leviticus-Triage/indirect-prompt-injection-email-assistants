#!/usr/bin/env bash
# Render portal-URL demo HTML from .in templates (schulung only).
set -euo pipefail
DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORTAL_URL="${DEMO_PORTAL_URL:-https://redirect.example.com/lab/freigabe/1847}"
YOUTUBE_URL="${DEMO_YOUTUBE_URL:-https://www.youtube.com/watch?v=dQw4w9WgXcQ}"

escape_sed() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}
PU="$(escape_sed "$PORTAL_URL")"

shopt -s nullglob
for in in "${DIR}"/*.html.in; do
  base="$(basename "$in" .html.in)"
  out="${DIR}/${base}.html"
  sed "s|__PORTAL_URL__|${PU}|g" "$in" >"$out"
  echo "Wrote ${out}"
done
shopt -u nullglob
echo "PORTAL_URL=${PORTAL_URL}"

echo ""
echo "Redirect-Ziel (Klick): ${YOUTUBE_URL}"
echo "Nächster Schritt: redirect/ deployen, dann:"
echo "  DEMO_HTML=demo-email-context-link-rickroll-portal.html bash build-eml.sh"
