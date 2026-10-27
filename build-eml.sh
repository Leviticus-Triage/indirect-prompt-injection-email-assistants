#!/usr/bin/env bash
# Build a simple .eml for Outlook import (schulung only).
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="${DEMO_HTML:-${DIR}/demo-email-rechnung.html}"
BASE="$(basename "$HTML" .html)"
OUT="${DIR}/${BASE}.eml"
FROM="${DEMO_FROM:-schulung.demo@extern.invalid}"
TO="${DEMO_TO:-teilnehmer@firma.invalid}"
SUBJ="${DEMO_SUBJ:-[SCHULUNG DEMO] Rechnung R-2026-1847 - Copilot Prompt Injection}"

BOUNDARY="----=_lab_demo_$(date +%s)"
BODY_B64="$(base64 -w0 "$HTML")"

cat >"$OUT" <<EOF
From: ${FROM}
To: ${TO}
Subject: ${SUBJ}
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="${BOUNDARY}"

--${BOUNDARY}
Content-Type: text/plain; charset=utf-8

[SCHULUNG] Siehe HTML-Teil. Demo fuer indirekte Prompt Injection.

--${BOUNDARY}
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: base64

${BODY_B64}

--${BOUNDARY}--
EOF

echo "Wrote ${OUT}"
echo "Import in Outlook: Datei oeffnen oder als Anhang senden."
