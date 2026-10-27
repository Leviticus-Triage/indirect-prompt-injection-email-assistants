#!/usr/bin/env bash
# Analysiert, wie Gmail/Google einen Klick auf eine Ziel-URL behandeln wird.
#
# Verifizierter Mechanismus (aus Live-Trace, siehe docs/GMAIL-REDIRECT-HOP.md):
# - Gmail signiert Body-Links serverseitig (usi-Token) → direkte Weiterleitung.
# - Gemini-Summary-Links sind unsigniert → google.com/url zeigt
#   "Weiterleitungshinweis" (oi=unauthorizedredirect).
# - Die Entscheidung ist SESSION-abhängig: anonym (curl) bekommt IMMER die
#   Notice — auch für wikipedia/github. Deshalb kann curl NICHT vorhersagen,
#   ob der Hinweis im eingeloggten Gmail kommt.
#
# Was dieses Skript stattdessen prüft:
#   1. Ist das Ziel eine Google-eigene Domain? (→ Gmail zeigt i. d. R. keinen Hinweis)
#   2. Ist die URL überhaupt erreichbar? (404 vor Versand abfangen)
set -euo pipefail

TARGET="${1:-https://redirect.example.com/lab/freigabe/1847}"

HOST="$(python3 -c "import sys,urllib.parse;print(urllib.parse.urlparse(sys.argv[1]).hostname or '')" "$TARGET")"

GOOGLE_SUFFIXES="google.com google.de youtube.com youtu.be googleusercontent.com googleapis.com gstatic.com google.com.lb web.app firebaseapp.com run.app blogspot.com sites.google.com script.google.com"

is_google=0
for s in $GOOGLE_SUFFIXES; do
  case "$HOST" in
    "$s"|*."$s") is_google=1; break;;
  esac
done

echo "Ziel-URL: $TARGET"
echo "Host:     $HOST"
if [[ "$is_google" == "1" ]]; then
  echo "Klasse:   Google-eigene Property → Gmail zeigt erfahrungsgemäß KEINEN"
  echo "          Weiterleitungshinweis (guter Hop-Kandidat für die Demo)."
else
  echo "Klasse:   Externe Domain → bei unsigniertem Gemini-Summary-Link"
  echo "          Weiterleitungshinweis wahrscheinlich (im eingeloggten"
  echo "          Gmail einmal manuell verifizieren)."
fi

echo "---"
CODE="$(curl -sS -o /dev/null -w '%{http_code}' -L --max-redirs 5 --max-time 15 "$TARGET" || echo ERR)"
echo "Erreichbarkeit (folgt Redirects): HTTP $CODE"
[[ "$CODE" == "404" || "$CODE" == "ERR" ]] && { echo "FEHLER: Ziel nicht erreichbar — erst deployen, dann .eml verschicken."; exit 1; }
