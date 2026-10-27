#!/usr/bin/env bash
# Send privat Gmail self-test HTML mail via SMTP (Account A → B). Requires Google App Password.
set -euo pipefail
DIR="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -f "${DIR}/.env" ]]; then set -a; # shellcheck source=/dev/null
  source "${DIR}/.env"; set +a; fi
HTML="${GMAIL_TEST_HTML:-${DIR}/demo-gmail-private-summarize-portal-hybrid.html}"
FROM="${GMAIL_SMTP_USER:?Set GMAIL_SMTP_USER}"
TO="${GMAIL_SMTP_TO:?Set GMAIL_SMTP_TO}"
APP_PW="${GMAIL_SMTP_APP_PASSWORD:?Set GMAIL_SMTP_APP_PASSWORD (Google App Password)}"
SUBJ="${GMAIL_TEST_SUBJ:-Freigabe Rechnung R-2026-1847 — Zahlungsverkehr}"

if [[ "$(basename "$HTML")" == *blocker-bait* ]]; then
  echo "HINWEIS: Blocker-Bait (Defense-Kontrast) — siehe docs/GMAIL-DEFENSE-CONTRAST-MAIL.md" >&2
fi

if [[ ! -f "$HTML" ]]; then
  echo "Missing $HTML — run: bash tools/render-portal-demo.sh" >&2
  exit 1
fi

# Optionale Spoof-Hebel (Defense-Demo) — in Bash-Var puffern (set -u / nounset-sicher)
REPLY_TO="${GMAIL_SMTP_REPLY_TO:-}"
FROM_NAME="${GMAIL_SMTP_FROM_NAME:-}"

python3 <<PY
import os, smtplib, ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from pathlib import Path

import re

html = Path("${HTML}").read_text(encoding="utf-8")
portal = ""
m = re.search(r'href="(https://[^"]+)"[^>]*>Zahlungsfreigabe im Portal', html)
if m:
    portal = m.group(1)
plain = (
    "Freigabe Rechnung R-2026-1847 — Zahlungsverkehr (HTML-Version in Gmail öffnen).\n"
    "Freigabe im Beschaffungsportal:\n"
    + (portal + "\n" if portal else "")
)
msg = MIMEMultipart("alternative")
msg["Subject"] = "${SUBJ}"
if "${FROM_NAME}":
    msg["From"] = "${FROM_NAME} <${FROM}>"
else:
    msg["From"] = "${FROM}"
msg["To"] = "${TO}"
# Optionaler Spoof-Hebel (Defense-Demo): Reply-To auf fremde Domain -> Gmail-Suspicion-Signal
if "${REPLY_TO}":
    msg["Reply-To"] = "${REPLY_TO}"
msg.attach(MIMEText(plain, "plain", "utf-8"))
msg.attach(MIMEText(html, "html", "utf-8"))

ctx = ssl.create_default_context()
with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=ctx) as s:
    s.login("${FROM}", """${APP_PW}""".replace(" ", ""))
    s.send_message(msg)
print("Sent", "${FROM}", "->", "${TO}")
PY
