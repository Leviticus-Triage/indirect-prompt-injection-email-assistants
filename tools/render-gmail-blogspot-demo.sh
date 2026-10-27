#!/usr/bin/env bash
# Render Gmail privat-Demo mit Blogger-Post-URL + .eml für padded und hybrid.
set -euo pipefail
DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_FILE="${DIR}/.demo-portal-url"
PORTAL_URL="${DEMO_PORTAL_URL:-}"

# Fallback: letzte bekannte URL aus State-Datei (kein erneutes Exportieren nötig)
if [[ -z "$PORTAL_URL" && -f "$STATE_FILE" ]]; then
  PORTAL_URL="$(tr -d '[:space:]' < "$STATE_FILE")"
  echo "DEMO_PORTAL_URL aus ${STATE_FILE}: ${PORTAL_URL}" >&2
fi

if [[ -z "$PORTAL_URL" ]]; then
  echo "Set DEMO_PORTAL_URL to your blogspot post URL, e.g.:" >&2
  echo "  export DEMO_PORTAL_URL='https://freigabe-portal-1847.blogspot.com/2026/10/freigabe-r-2026-1847.html'" >&2
  exit 1
fi

if [[ "$PORTAL_URL" != *blogspot.com* ]]; then
  echo "DEMO_PORTAL_URL must be a blogspot.com post (Gmail hardened chain). Got: $PORTAL_URL" >&2
  exit 1
fi

if [[ "${SKIP_PORTAL_CHECK:-0}" != "1" ]]; then
  # blogspot liefert auf GET ohne komplette Browser-Header oft 404 (Bot-Filter),
  # obwohl die Seite im Browser läuft. HEAD + Browser-UA ist die robustere Prüfung.
  CODE="$(curl -sS -o /dev/null -w '%{http_code}' -I -L --max-redirs 8 --max-time 20 \
    -A 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36' \
    "$PORTAL_URL" || echo ERR)"
  if [[ "$CODE" == "404" || "$CODE" == "ERR" ]]; then
    echo "FEHLER: Post nicht erreichbar (HTTP $CODE). Blogger-Setup: redirect/BLOGGER-SETUP.md" >&2
    echo "Im Browser geprueft und OK? Dann: SKIP_PORTAL_CHECK=1 DEMO_PORTAL_URL='…' $0" >&2
    exit 1
  fi
  echo "OK: Post erreichbar (HTTP $CODE, HEAD)."
fi

printf '%s' "$PORTAL_URL" > "$STATE_FILE"

export DEMO_PORTAL_URL="$PORTAL_URL"
bash "${DIR}/tools/render-portal-demo.sh"

SUBJ="${DEMO_SUBJ:-Freigabe Rechnung R-2026-1847 — Zahlungsverkehr}"
for base in \
  demo-gmail-private-summarize-portal-padded \
  demo-gmail-private-summarize-portal-hybrid \
  demo-gmail-private-escalation-chain-portal \
  demo-gmail-private-blocker-bait-portal \
  demo-gmail-private-midflag-portal \
  demo-gmail-private-flagguaranteed-portal
do
  BAIT_SUBJ='[SCHULUNG CONTRAST] Freigabe R-2026-1847 — Blocker-Bait'
  MID_SUBJ='[SCHULUNG MID] Freigabe R-2026-1847 — Sicherheitsprüfung erforderlich'
  FLAG_SUBJ='[SCHULUNG FLAG] R-2026-1847 — SOFORT: Konto-Verifizierung erforderlich'
  if [[ "$base" == *flagguaranteed* ]]; then
    DEMO_HTML="${base}.html" DEMO_SUBJ="$FLAG_SUBJ" bash "${DIR}/build-eml.sh"
  elif [[ "$base" == *midflag* ]]; then
    DEMO_HTML="${base}.html" DEMO_SUBJ="$MID_SUBJ" bash "${DIR}/build-eml.sh"
  elif [[ "$base" == *blocker-bait* ]]; then
    DEMO_HTML="${base}.html" DEMO_SUBJ="$BAIT_SUBJ" bash "${DIR}/build-eml.sh"
  else
    DEMO_HTML="${base}.html" DEMO_SUBJ="$SUBJ" bash "${DIR}/build-eml.sh"
  fi
done

STAGE3_SUBJ='Erinnerung Freigabe R-2026-1847 — interne Weitergabe'
STAGE4_SUBJ='Stellvertretung Freigabe R-2026-1847'
DEMO_HTML=demo-email-stage3-redistribution-portal.html DEMO_SUBJ="$STAGE3_SUBJ" bash "${DIR}/build-eml.sh"
DEMO_HTML=demo-email-stage4-delegate-handoff-portal.html DEMO_SUBJ="$STAGE4_SUBJ" bash "${DIR}/build-eml.sh"

echo ""
echo "Versand (Account A → B):"
echo "  export GMAIL_SMTP_USER='account-a@gmail.com'"
echo "  export GMAIL_SMTP_TO='account-b@gmail.com'"
echo "  export GMAIL_SMTP_APP_PASSWORD='…'"
echo "  bash tools/send-gmail-private-test.sh"
echo "  Eskalationskette (Stufe B–D):"
echo "  GMAIL_TEST_HTML=demo-gmail-private-escalation-chain-portal.html bash tools/send-gmail-private-test.sh"
echo "  Prompts: prompts/ESCALATION-CHAIN-DE.md"
echo "  Defense-Kontrast (laute Injection):"
echo "  GMAIL_TEST_HTML=demo-gmail-private-blocker-bait-portal.html GMAIL_TEST_SUBJ='[SCHULUNG CONTRAST] …' bash tools/send-gmail-private-test.sh"
echo "  Mitte (kommt an, sichtbare Warnung — Anchor/Href-Mismatch):"
echo "  GMAIL_TEST_HTML=demo-gmail-private-midflag-portal.html GMAIL_TEST_SUBJ='[SCHULUNG MID] …' bash tools/send-gmail-private-test.sh"
echo "  Deterministisches Flag (Safe-Browsing-Test-URL — kann STILL verworfen werden):"
echo "  GMAIL_TEST_HTML=demo-gmail-private-flagguaranteed-portal.html GMAIL_TEST_SUBJ='[SCHULUNG FLAG] …' bash tools/send-gmail-private-test.sh"
echo "Preflight: bash tools/preflight-gmail-demo.sh '$PORTAL_URL'"
