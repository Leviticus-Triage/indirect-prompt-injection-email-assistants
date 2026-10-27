# Architecture

## Repository layout

```text
.
├── *.html.in              # Email templates (source of truth)
├── build-eml.sh           # MIME multipart .eml builder
├── tools/
│   ├── render-portal-demo.sh
│   ├── render-gmail-blogspot-demo.sh
│   ├── send-gmail-private-test.sh
│   ├── preflight-gmail-demo.sh
│   └── encode-hidden-text.py
├── redirect/              # Static redirect + Blogger / Apps Script notes
├── prompts/               # Word-for-word lab prompts
├── docs/                  # Research write-ups
└── scripts/
    └── verify-no-secrets.sh
```

Generated artifacts (not versioned):

- `demo-*.html` — from `sed` substitution of `__PORTAL_URL__`
- `demo-*.eml` — base64-wrapped HTML for Outlook
- `.demo-portal-url` — last blogspot URL used locally

## Build pipeline

1. **Author** edits `demo-….html.in` with placeholder `__PORTAL_URL__`.
2. **Render** replaces placeholder with `DEMO_PORTAL_URL` (or default lab URL).
3. **Package** optional `.eml` with `build-eml.sh` or SMTP send via `send-gmail-private-test.sh`.
4. **Validate** with `preflight-gmail-demo.sh` (HTTP HEAD on hop URL).

## Injection design layers

| Layer | Mechanism | Detection surface |
|-------|-----------|-------------------|
| Visible body | Invoice narrative + portal CTA | Human + link scanners |
| Hidden textversion | `display:none` block mimicking mobile/plain fallback | LLM context |
| Workflow metadata | Key=value lines (calendar, forward, CC) | LLM context |
| Loud contrast | `<Admin>`, jailbreak English | Gemini direct Q&A; rarely spam |
| Href mismatch | Display URL ≠ `href` | Gmail phishing heuristics |
| Safe Browsing URL | `testsafebrowsing.appspot.com` | SMTP reject / DSN |

## Assistant interaction surfaces

- **Chip summarize** — single-shot; often hardened.
- **Side-panel multi-turn** — user questions; weaker guard in lab tests.
- **Tool use** — calendar create, draft email; persistence and confused-deputy story.

## Redirect hop

Avoid embedding final demo video URL in mail HTML (preview chips). Use an intermediate page (Blogger meta-refresh or static `redirect/public/freigabe/1847/index.html`).
