# Blogger-Hop (Primärweg Gmail-Demo)

**Ziel:** Klick aus Gemini-Summary → keine Weiterleitungshinweis-Seite, kein YouTube-Chip in der Mail, kein Phishing-Muster wie `script.google.com/macros`.

**Konto:** Drittes Google-Konto (nur Blog-Hosting). **Versand** der Test-Mail weiterhin von **Account A** (etabliert, weniger Spam).

## Schritte (~10 Min)

1. https://www.blogger.com → **Blog erstellen**
   - Titel: z. B. „Freigabe Portal 1847“
   - Adresse: z. B. `freigabe-portal-1847.blogspot.com`
2. Linkes Menü → **Theme** → Dropdown neben **Anpassen** → **HTML bearbeiten**
3. Direkt **nach** der Zeile `<head …>` einfügen (aus [blogger-autoforward-snippet.html](blogger-autoforward-snippet.html)):

```xml
<meta content='0;url=https://www.youtube.com/watch?v=dQw4w9WgXcQ' http-equiv='refresh'/>
<script type='text/javascript'>
//<![CDATA[
try { window.top.location.replace('https://www.youtube.com/watch?v=dQw4w9WgXcQ'); }
catch (e) { window.location.replace('https://www.youtube.com/watch?v=dQw4w9WgXcQ'); }
//]]>
</script>
```

4. **Theme speichern**
5. **Neuer Beitrag** — Titel „Freigabe R-2026-1847“, Text kurz (wird sofort weitergeleitet) → **Veröffentlichen**
6. **Post-URL kopieren** (Beispiel):
   `https://freigabe-portal-1847.blogspot.com/2026/10/freigabe-r-2026-1847.html`
7. Im Browser einmal öffnen: sollte in &lt;1 s auf YouTube springen (Rick Roll).

## Demo-Mail bauen

```bash
cd .
export DEMO_PORTAL_URL='https://DEIN-BLOG.blogspot.com/2026/…/freigabe-r-2026-1847.html'
bash tools/render-gmail-blogspot-demo.sh
```

Erzeugt u. a. `demo-gmail-private-summarize-portal-padded.html` und `-hybrid.html` sowie `.eml`.

## Welches Template?

| Datei | Live-Einsatz |
|--------|----------------|
| `demo-gmail-private-summarize-portal-hybrid` | **Standard** — Gemini-Wow + Body-Link (Klick ohne Notice) |
| `demo-gmail-private-summarize-portal-padded` | Gleicher Body-Link wie hybrid (älterer Name) |

Versand: `GMAIL_TEST_HTML=…` siehe [PRIVATE-GMAIL-SELBSTTEST.md](../PRIVATE-GMAIL-SELBSTTEST.md).
