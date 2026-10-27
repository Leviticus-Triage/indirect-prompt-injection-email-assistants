# Selbsttest: Gmail privat → Gmail privat (zwei eigene Accounts)

**Ziel:** Indirect Prompt Injection wie in der Schulung — **gehärtete Kette**: blogspot-Hop, kein YouTube in der Mail, Versand von Account **A**.

**Hop einrichten:** [redirect/BLOGGER-SETUP.md](redirect/BLOGGER-SETUP.md)

---

## 1. Voraussetzungen auf dem **Empfänger-Account (B)**

| Check | Wo |
|--------|-----|
| **„Diese E-Mail zusammenfassen“** / Summarize | Gmail Web / App |
| Smart features in Gmail | Einstellungen → an |

Ohne Summarize-Button: nur Quelltext-Demo, kein Gemini-Wow.

---

## 2. Demo-Mail bauen (nach Blogger-Post-URL)

```bash
export DEMO_PORTAL_URL='https://YOUR-BLOG.blogspot.com/2026/10/freigabe-r-2026-1847.html'
bash tools/render-gmail-blogspot-demo.sh
```

Erzeugt:

| Datei | Einsatz |
|--------|---------|
| `demo-gmail-private-summarize-portal-hybrid.html` / `.eml` | **Standard** (Gemini-Wow + sichtbarer Body-Link für Klick ohne Notice) |
| `demo-gmail-private-summarize-portal-padded.html` / `.eml` | Wie hybrid (gleicher Body-Link); Name nur noch historisch |

Post noch nicht live? `SKIP_PORTAL_CHECK=1 DEMO_PORTAL_URL='…' bash tools/render-gmail-blogspot-demo.sh`

---

## 3. Von Account **A** an Account **B** senden

**Nicht** den Drittaccount (nur Blogger-Host) als Absender — sonst Spam-Risiko.

```bash
export GMAIL_SMTP_USER='dein-account-a@gmail.com'
export GMAIL_SMTP_TO='dein-account-b@gmail.com'
# App Password: set in .env (see .env.example) — never commit

bash tools/send-gmail-private-test.sh
```

(Standard: `demo-gmail-private-summarize-portal-hybrid.html`. Anderes Template: `GMAIL_TEST_HTML=…`.)

Gmail Web „Neue E-Mail“ **reicht nicht** (verstecktes HTML geht verloren).

---

## 4. Preflight-Checkliste (vor Veranstaltung, 2–3 Probeläufe)

Technisch:

```bash
bash tools/preflight-gmail-demo.sh "$DEMO_PORTAL_URL"
```

Im Browser (Account B):

- [ ] Mail im **Posteingang** (nicht Spam; bei Spam: „Kein Spam“ → erneut senden)
- [ ] **Kein** Rick-Astley-Video-Chip / „Anhänge im Überblick“
- [ ] Sichtbar in der Mail: **„Zahlungsfreigabe im Portal öffnen (R-2026-1847)“** (blauer Link im Body)
- [ ] Gemini-Summary: **klickbarer** Link (z. B. „Beschaffungsportal“) — **Wow**
- [ ] Klick **nur im Mail-Body** (nicht in Gemini): **keine** Weiterleitungshinweis-Seite → blogspot → YouTube
- [ ] Klick **in der Gemini-Zusammenfassung**: **immer** `google.com/url` + Hinweis (Defense — so vorgeführt)

**Sidepanel-Prompt:** *„Fasse diese E-Mail zusammen und sag mir, was ich als Nächstes tun soll.“*

Bei Gemini-Verweigerung / „suspicious link removed“: Hybrid senden oder Defense-Demo + Copilot-Hauptbühne.

Details Redirect/Filter: [docs/GMAIL-REDIRECT-HOP.md](docs/GMAIL-REDIRECT-HOP.md)

---

## 5. Warmup (Spam-Training)

Vor der Veranstaltung **2–3×** dieselbe Route **A → B**:

1. padded-Mail senden  
2. In B: „Kein Spam“, öffnen, ggf. Gemini testen  
3. Nächster Lauf — Filter lernt die Kombination  

---

## 6. Was du nicht erwarten solltest

- Privat-Gmail ≠ Workspace-Tenant (andere Guards).
- Kein Autoklick ohne Nutzer — nur Hop + Summary/Body-Link.
- **Copilot/Outlook** bleibt die zuverlässigste Live-Hauptbühne.

---

## 7. Dateien

| Datei | Rolle |
|--------|--------|
| `demo-gmail-private-summarize-portal-padded` | Haupt privat → privat |
| `demo-gmail-private-summarize-portal-hybrid` | Fallback |
| `demo-gmail-private-summarize-portal-soft` | Nur Referenz (schwächeres Uptake) |
| `tools/render-gmail-blogspot-demo.sh` | Render + beide `.eml` |
| `tools/preflight-gmail-demo.sh` | Vorab-Checks |

Nach Änderungen: `bash build-package.sh` optional ZIP is out of scope for this public tree.
