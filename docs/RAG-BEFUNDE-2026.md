# Methodology notes (public sources)

These notes summarize **public** OWASP and community guidance used while designing the lab templates. They do not describe any private index, host, or internal tool.

## Design implications

### 1. OWASP `LLM_Prompt_Injection_Prevention_Cheat_Sheet.md`

- **Remote/Indirect PI** listet explizit: *E-Mail-Inhalte*, die von KI-Assistenten verarbeitet werden.
- **HTML/Markdown Injection:** „Malicious links disguised as helpful content“ → rechtfertigt **Portal-Link in Summary**.
- **Defenses** filtern u. a. `ignore previous instructions`, `system override`, `reveal prompt` → Paket nutzt **weiche Workflow-Sprache** (kein Jailbreak-Wording).
- **Typoglycemia** (scrambled middle letters) umgeht naive Keyword-Filter → optional `demo-email-*-typo-soft.html` (nur Test-Tenant).
- **Dual-LLM / Guardrails:** Wenn Demo scheitert → Schulungsstory „Quarantined LLM path“.

### 2. OWASP `AI_Agent_Security_Cheat_Sheet.md`

- Externe Daten (E-Mail) = **untrusted**; Delimiter zwischen Instruktion und Daten empfohlen.
- **Angriff:** Grenzen verwirren → neue Datei `demo-email-context-link-rickroll-portal-delimited.html` (fake `USER_DATA_TO_PROCESS`-Block).

### 3. PayloadsAllTheThings `Prompt Injection/README.md`

- Indirect medium: **HTML comments**, versteckte Tags — bleibt in Tier B/C (`demo-email-rechnung.html`).

### 4. Permiso / 0DIN (extern, nicht im KB-Chunk)

- Padding + Teams-Oberfläche — bereits im Paket; RAG bestätigt **Markdown-Link** als Angriffsvektor.

## Umsetzung im LAB-Paket (nach RAG-Pass)

| Stufe | Datei | RAG-Begründung |
|-------|--------|----------------|
| ★★★ | `…-portal-padded.html` | Permiso + langer Body |
| ★★ | `…-portal-delimited.html` | OWASP StruQ/Delimiter-Verwirrung |
| ★ | `…-portal.html` | Markdown-Link (OWASP HTML/MD injection) |
| Tier T | `…-portal-typo-soft.html` | OWASP Typoglycemia (optional) |
| Google | `demo-gemini-workspace-summarize-portal.html` | 0DIN + PAT HTML hide |

## Was RAG **nicht** empfiehlt (für diese Schulung)

- `<img src=…>` Exfil (OWASP nennt es — wir liefern **kein** Exfil in LAB-Demo).
- Direkte Jailbreaks / „ignore all previous“ in Hidden Text → triggert Filter **und** Defender-HCP-Trainingssamples.
