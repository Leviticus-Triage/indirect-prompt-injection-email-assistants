/**
 * LAB-Demo: Auto-Forward auf Google-eigener Infrastruktur.
 *
 * Hintergrund (verifiziert aus Gmail-Netzwerk-Trace):
 * Gmail signiert Body-Links serverseitig (usi-Token). Links, die Gemini
 * in der Summary als frisches DOM-Element erzeugt, haben KEINE Signatur →
 * google.com/url antwortet mit "Weiterleitungshinweis" (oi=unauthorizedredirect).
 * Die Signatur ist ein Google-seitiger HMAC — aus der Mail nicht fälschbar.
 *
 * Ausweg: Ziel liegt auf Google-eigener Property (script.google.com),
 * gegen die Gmail keine Warnseite zeigt. Dieses Script ist der Auto-Forward:
 *
 *   Gmail-Klick → script.google.com/macros/s/.../exec (kein Hinweis)
 *              → Meta-Refresh 0s → YouTube (Rick Roll)
 *
 * Deployment (einmalig, ~5 Minuten, eigenes Google-Konto):
 *   1. https://script.google.com → "Neues Projekt"
 *   2. Diesen Code einfügen, speichern
 *   3. Bereitstellen → Neue Bereitstellung → Typ: Web-App
 *      - Ausführen als: Ich
 *      - Zugriff: "Jeder"  ← wichtig, sonst Login-Wall beim Klick
 *   4. Web-App-URL kopieren: https://script.google.com/macros/s/AKfyc.../exec
 *   5. Als Demo-URL rendern:
 *      DEMO_PORTAL_URL='https://script.google.com/macros/s/AKfyc.../exec' \
 *        bash tools/render-portal-demo.sh
 *
 * Hinweis: HtmlService rendert in einem Sandbox-Kontext. Deshalb versucht
 * das Script top- UND self-Navigation; schlägt beides fehl, bleibt der
 * sichtbare Fallback-Link. Vor Live einmal im eingeloggten Gmail testen.
 *
 * Nur für autorisierte Schulung/Demo (RoE). Keine echten Bank-/ERP-Flows imitieren.
 */

var TARGET = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

function doGet() {
  var t = JSON.stringify(TARGET);
  var html = '<!DOCTYPE html><html><head>' +
    '<meta charset="utf-8">' +
    '<title>Freigabe-Portal — Weiterleitung</title>' +
    '<meta http-equiv="refresh" content="1;url=' + TARGET + '">' +
    '</head><body style="font-family:sans-serif;color:#1f1f1f">' +
    '<p>Verbindung zum Freigabe-Portal wird hergestellt …</p>' +
    '<p><a id="go" href="' + TARGET + '" target="_top">Weiter zum Portal</a></p>' +
    '<scr' + 'ipt>' +
    'try { window.top.location.replace(' + t + '); }' +
    'catch (e) { try { window.location.replace(' + t + '); } catch (e2) {} }' +
    'setTimeout(function(){ try { document.getElementById("go").click(); } catch (e) {} }, 600);' +
    '</scr' + 'ipt>' +
    '</body></html>';

  return HtmlService.createHtmlOutput(html)
    .setTitle('Freigabe-Portal')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1');
}
