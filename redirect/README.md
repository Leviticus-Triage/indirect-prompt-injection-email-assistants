# Portal-Redirect (kurze, seriöse URL → Rick Roll)

**Gmail privat (gehärtete Kette):** Primär **Blogger** — siehe [BLOGGER-SETUP.md](BLOGGER-SETUP.md), Build `tools/render-gmail-blogspot-demo.sh`.

Copilot soll in der Antwort **keine** lange `youtube.com`-URL zeigen, sondern z. B.:

`https://redirect.example.com/lab/freigabe/1847`

Ein Klick leitet per **302** oder **HTML-Redirect** auf das harmlose Schulungsvideo um.

## Standard-URL (Render-Skript)

```bash
cd ..
DEMO_PORTAL_URL='https://redirect.example.com/lab/freigabe/1847' bash tools/render-portal-demo.sh
```

Eigene Domain (nur Schulung, mit RoE):

```bash
DEMO_PORTAL_URL='https://schulung.ihre-firma.de/portal/r/1847' bash tools/render-portal-demo.sh
```

## Option A — Statische Dateien

Inhalt von `redirect/public/` unter den Webroot legen, sodass  
`/freigabe/1847/` → `public/freigabe/1847/index.html` erreichbar ist.

```bash
# Beispiel (Host + Pfad anpassen)
LAB_REDIRECT_HOST=your-training-host bash deploy-static.sh
curl -sI 'https://redirect.example.com/lab/freigabe/1847/index.html' | head -5
```

Erwartung: `200` oder Redirect-Kette endet auf YouTube.

## Option B — nginx 302

`nginx-snippet.conf` in die vhost-Config der **Schulungs**-Subdomain einbinden, `nginx -t && systemctl reload nginx`.

## Option C — Cloudflare Redirect Rule

| Feld | Wert |
|------|------|
| URL | `*lab-demo*/freigabe/1847*` |
| Type | Dynamic |
| Expression | `concat("https://www.youtube.com/watch?v=dQw4w9WgXcQ")` |

Nur Test-Zone / Demo-Subdomain — nicht auf Produktions-Landingpages.

## Check vor Live

```bash
curl -sI "$DEMO_PORTAL_URL" | grep -iE '^(HTTP|location:)'
```

Wenn `404`: erst deployen, **dann** `.eml` verschicken.

## Recht

Keine echten Bank-/ERP-Domains nachahmen. Subdomain klar als Demo kennzeichnen (z. B. `lab-demo`, `schulung`).
