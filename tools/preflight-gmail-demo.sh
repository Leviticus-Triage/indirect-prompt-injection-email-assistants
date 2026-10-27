#!/usr/bin/env bash
# Checkliste vor Veranstaltung (technische Vorprüfung; Gemini/Spam nur im Browser).
set -euo pipefail
DIR="$(cd "$(dirname "$0")/.." && pwd)"
PORTAL_URL="${1:-${DEMO_PORTAL_URL:-}}"

fail=0
ok() { echo "  [OK] $*"; }
warn() { echo "  [!!] $*"; fail=1; }

echo "=== Gmail-Demo Preflight ==="
echo ""

if [[ -z "$PORTAL_URL" ]]; then
  warn "Keine Portal-URL — Argument oder DEMO_PORTAL_URL setzen"
else
  echo "Portal: $PORTAL_URL"
  if [[ "$PORTAL_URL" == *youtube.com* || "$PORTAL_URL" == *youtu.be* ]]; then
    warn "Rohe YouTube-URL in Mail → Video-Chip-Spoiler (verboten)"
  else
    ok "Keine rohe YouTube-URL in DEMO_PORTAL_URL"
  fi
  if [[ "$PORTAL_URL" == *script.google.com/macros* ]]; then
    warn "Apps-Script-exec-URL → Spam/Gemini-Guard (verbrannt)"
  fi
  if [[ "$PORTAL_URL" == *blogspot.com* ]]; then
    ok "blogspot-Hop (empfohlen)"
  fi
  # blogspot: GET ohne Browser-Header oft 404 (Bot-Filter) → HEAD + UA verwenden
  CODE="$(curl -sS -o /dev/null -w '%{http_code}' -I -L --max-redirs 8 --max-time 20 \
    -A 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36' \
    "$PORTAL_URL" 2>/dev/null || echo ERR)"
  if [[ "$CODE" == "404" || "$CODE" == "ERR" ]]; then
    warn "Post nicht erreichbar (HTTP $CODE, HEAD)"
  else
    ok "Post erreichbar (HTTP $CODE, HEAD)"
  fi
  bash "${DIR}/tools/test-gmail-google-url-wrap.sh" "$PORTAL_URL" | sed 's/^/    /'
fi

echo ""
echo "HTML-Artefakte:"
for f in demo-gmail-private-summarize-portal-padded.html demo-gmail-private-summarize-portal-hybrid.html; do
  if [[ -f "${DIR}/${f}" ]]; then
    if grep -q 'youtube.com/watch\|youtu.be' "${DIR}/${f}"; then
      warn "${f} enthält YouTube-URL (Spoiler-Risiko)"
    else
      ok "${f} vorhanden, ohne rohe YT-URL"
    fi
  else
    warn "${f} fehlt — bash tools/render-gmail-blogspot-demo.sh"
  fi
done

echo ""
echo "Manuell im Browser (Account B, eingeloggt):"
echo "  1. Mail im Posteingang (nicht Spam)"
echo "  2. Kein Rick-Astley-Vorschau-Chip unter der Mail"
echo "  3. Gemini-Zusammenfassung: klickbarer Portal-Link"
echo "  4. Klick: keine google.com/url-Hinweis-Seite → YouTube"
echo "  5. Fallback: Hybrid-Mail, Body-Link klicken"
echo ""
if [[ "$fail" -ne 0 ]]; then
  echo "Preflight: PROBLEME — siehe [!!] oben"
  exit 1
fi
echo "Preflight: technische Checks grün (Browser-Checks separat)."
