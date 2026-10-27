# Community-Stand & Paket-Optimierungen (Okt 2026)

Abgleich mit Forschung, Microsoft/Google-Abwehr und Red-Team-Write-ups — **nur** für autorisierte Schulung (harmloser Redirect, keine Exfil).

## Quellen (Auswahl)

| Quelle | Erkenntnis für unsere Demo |
|--------|----------------------------|
| [Permiso — Copilot E-Mail-Summaries](https://permiso.io/blog/copilot-prompt-injection-ai-email-phishing) | XPIA über Summarize; **längere, realistische** Mails → weniger vorhersehbares Blocken; **Teams** oft kooperativer als Outlook Summarize |
| [0DIN — Phishing for Gemini](https://0din.ai/blog/phishing-for-gemini) | Gmail **„Summarize this email“** + verstecktes HTML/`Admin`-Framing |
| [Microsoft — Defender PI Protection](https://learn.microsoft.com/en-us/defender-office-365/step-by-step-guides/prompt-injection-protection-defender-for-office-365) | Mailflow erkennt **aggressive** Muster („alignment“, Tool-Discovery, Exfil) → **weiche Workflow-Sprache** in Payloads |
| [Google — Layered defense](https://blog.google/security/mitigating-prompt-injection-attacks) | URLs in Summaries können **redigiert** werden → **Markdown-Referenz** als zweite Zeile im Hidden Block |
| [Embrace The Red — ASCII smuggling](https://embracethered.com/blog/posts/2024/m365-copilot-prompt-injection-tool-invocation-and-data-exfil-using-ascii-smuggling) | Unicode-Tags für Exfil — im Paket nur **Tier C** / optional, nicht für Rick-Roll-Hauptdemo |

**RAG-Pass:** [RAG-BEFUNDE-2026.md](RAG-BEFUNDE-2026.md) (cybersec-rag über OWASP LLM Cheat Sheet, 72k Chunks).

## Was wir **geändert** haben (dieses Update)

| Änderung | Datei | Warum |
|----------|--------|--------|
| **Gepaddete Rechnung** (Tabelle, Fließtext) | `demo-email-context-link-rickroll-portal-padded.html` | Permiso: realistischer Body |
| **Weiche Injektion** (kein „SYSTEM OVERRIDE“) | alle Portal-/Link-HTML | Weniger Defender-HCP-Signale |
| **Dual Markdown** (inline + `[ref]: URL`) | Portal-Templates | Google/Copilot Link-Redaction umgehen *wenn* Modell mitspielt |
| **Doppel-Hide** (`display:none` + `font-size:0` weiß) | Portal padded + Gemini | 0DIN/Gemini-Pipeline liest Raw HTML |
| **Gemini-Track** | `demo-gemini-workspace-summarize-portal.html` | Workspace-Kunden, Trigger: „Diese E-Mail zusammenfassen“ |
| **Delimiter-Fake-Data** | `demo-email-context-link-rickroll-portal-delimited.html` | OWASP Remote PI / StruQ-Grenzverwirrung |
| **Typoglycemia-soft** | `demo-email-context-link-rickroll-portal-typo-soft.html` | OWASP: Filter umgehen *ohne* „ignore instructions“ |

## Was wir **bewusst nicht** ins Schulungspaket legen

| Technik | Grund |
|---------|--------|
| EchoLeak-Style **Zero-Click** / Teams-Preview-Exfil | Nicht nötig für Story; RoE/Peinlichkeitsrisiko |
| CSS `background-image` / `@font-face` Exfil | Echte Datenabfluss — nur Pentest mit Scope |
| „Strip alignment“, Tool-Listing, Webhook-Exfil | Microsoft **Test-Payloads** für HCP — würde Demo-Mail **quarantänen** |
| L1B3RT4S / Jailbreak-Chats | Irrelevant für M365 Summarize |

## Test-Reihenfolge (neu)

1. `demo-email-context-link-rickroll-portal-padded.html` (★★)
2. `demo-email-context-link-rickroll-portal.html`
3. Teams Copilot (gleiche Mail)
4. Google: `demo-gemini-workspace-summarize-portal.html` + Gemini Summarize
5. Fallbacks wie [TEST-PROTOKOLL-VOR-LIVE.md](TEST-PROTOKOLL-VOR-LIVE.md)

## Gemini-Prompt (Workspace)

Englische UI: **Summarize this email** · Deutsch oft **Diese E-Mail zusammenfassen**.

Erwartung: Zeile mit Portal-Link — oder „suspicious link removed“ (dann Plan B wie bei Copilot).
