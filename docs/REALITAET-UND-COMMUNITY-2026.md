# Funktioniert die Demo? — Realität & Community-Stand (Okt 2026)

**Kurzantwort:** **Nicht garantiert.** Die Methode ist fachlich richtig (indirekte / Cross-Prompt-Injection über E-Mail → Copilot), aber Erfolg hängt von **Tenant, Lizenz, Defender, Oberfläche und Patchstand** ab. Für Live **immer** Testprotokoll + Plan B einplanen.

## Was die Forschung / Microsoft bestätigen

| Fakt | Quelle |
|------|--------|
| Versteckter Text in E-Mails kann Copilot-Zusammenfassungen beeinflussen (XPIA) | [Permiso (März 2026)](https://permiso.io/blog/copilot-prompt-injection-ai-email-phishing), [CVE-2026-26133](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2026-26133) |
| Klickbare Links mit „seriöser“ Beschriftung in der **Copilot-Summary-UI** sind ein dokumentiertes Phishing-Muster | Permiso („Security Alert“ + Link in Summary) |
| **Drei Oberflächen verhalten sich unterschiedlich** | Outlook **Summarize** (mal Block, mal Leak), **Copilot-Seitenpaneel** (oft vorsichtiger), **Teams Copilot** (in Permiso-Tests am ehesten „mitgezogen“) |
| Defender for Office 365 **Plan 2** kann Prompt-Injection in **eingehenden** Mails im Mailflow stoppen (High Confidence Phish) | [Microsoft Learn — Prompt injection protection](https://learn.microsoft.com/en-us/defender-office-365/step-by-step-guides/prompt-injection-protection-defender-for-office-365) |
| Fokus der Mail-Erkennung u. a.: **Exfil per URL**, System-Prompt offenlegen, Tools ausspähen | [Defender-Blog / Partner-Analysen](https://techcommunity.microsoft.com/blog/microsoftdefenderforoffice365blog/defending-the-inbox-against-prompt-injection-attacks/4534636) |
| **Externe** Absender + „untrusted content“-Pfad für Copilot (Outlook External Tags) | [Copilot defense in depth](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-prompt-defense-in-depth), CVE-2026-55145-Hinweise |
| User muss Copilot **aktiv** nutzen („Fasse zusammen“) — kein klassisches Zero-Click wie historische EchoLeak-Demos | [MSRC Indirect PI](https://www.microsoft.com/en-us/msrc/blog/2025/07/how-microsoft-defends-against-indirect-prompt-injection-attacks), [EchoLeak-Paper](https://arxiv.org/html/2509.10540v1) |

## Passt unser Rick-Roll / Portal-Link dazu?

| Aspekt | Einschätzung |
|--------|----------------|
| **Story** | Ja — gleiche Klasse wie „Modell gibt vertrauenswürdigen Link aus“, nur harmloses Ziel. |
| **Technik** (`display:none`, versteckte Anweisung „Markdown-Link ausgeben“) | Standard für indirekte PI; entspricht auch [Immersive Labs / OWASP-LLM-Diskussion](https://www.immersivelabs.com/resources/c7-blog/weaponizing-llms-bypassing-email-security-products-via-indirect-prompt-injection). |
| **Erfolgswahrscheinlichkeit Live** | **Mittel** auf „grünem“ E5-Tenant mit aktivem Defender PI-Schutz und **externer** Demo-Mail — **höher** auf Test-Tenant mit Simulation/Audit, **interner** Weiterleitung oder wenn Mail nicht als HCP geblockt wird. |
| **Portal-URL statt youtube.com** | Hilft bei **Zuschauer-Wirkung** (URL-Leiste); ändert Defender-Scoring **nicht zwingend** (versteckte URL-Anweisung kann trotzdem treffen). |
| **Kalender Stage 2** | **Niedrig** — Copilot erstellt selten Termine ohne Bestätigung; reicht oft als **Textvorschlag** mit Link. |
| **Automatisches Browser-Öffnen** | **Nein** — unrealistisch; Klick durch User nötig. |

## Was seit Permiso / Microsoft geändert wurde

- Mitigations zu **CVE-2026-26133** (Rollout bis März 2026) — weniger vorhersehbares Verhalten in Outlook/Teams.
- **Defender Prompt Injection Protection** (Preview ab Juli 2026, GA ~Okt 2026) — Demo-Mail kann in **Quarantäne** landen, bevor Copilot sie sieht.
- **Unicode / versteckte Instructions** in Copy-Paste — Copilot-Sanitization ([defense in depth](https://learn.microsoft.com/en-us/microsoft-365/copilot/copilot-prompt-defense-in-depth)); ST3GG-Tier C kann helfen oder **mehr** Defender-Noise erzeugen.

**Paket-Update (Community-Optimierungen):** [COMMUNITY-OPTIMIERUNGEN-2026.md](COMMUNITY-OPTIMIERUNGEN-2026.md) — gepaddete Mail, weiche Injektion, Gemini-Track, Markdown-Referenz.

## Empfohlene Test-Reihenfolge (brandaktuell)

1. **Tenant-Check:** MDO Plan 2? PI Protection aktiv? Aktion bei HCP = Quarantäne oder **Simulation**?
2. **Mail zustellen:** Kommt `demo-email-context-link-rickroll-portal.eml` im Posteingang an (nicht nur Quarantäne)?
3. **Oberflächen** (gleicher Prompt, notieren welche funktioniert):
   - Outlook **Copilot-Chat / Seitenbereich** (euer fester Schulungs-Prompt)
   - Outlook **„Zusammenfassen“** (Ribbon)
   - **Teams** — gleiche Mail / Thread, Teams Copilot (oft laut Permiso erfolgreicher — für Kunde ggf. zweite Demo-Spur)
4. **Absender:** extern simulieren **und** intern weiterleiten testen (External-Tags ändern Copilot-Pfad).
5. **Fallback-Stufen** A/B/C im [TEST-PROTOKOLL-VOR-LIVE.md](TEST-PROTOKOLL-VOR-LIVE.md).

## Wenn nichts „mitspielt“ — trotzdem starke Schulung

1. **Quarantäne / HCP** im Defender-Portal zeigen → „Schicht 1 hat gewirkt“.
2. **HTML-Quelltext** → unsichtbare Anweisung.
3. **Purview / External in Outlook** erwähnen.
4. Optional: HTML in **Copilot Web** „Analysiere diese E-Mail“ (Plan C) — zeigt Risiko ohne Mailflow.

## Community / Foren (kein „Silver Bullet“-Rezept)

- **GitHub elder-plinius / ST3GG:** Text-Encoding & Hide-Techniken — nützlich für **Tier C**, kein Garant für M365 Copilot 2026 (Jailbreaks bewusst **nicht** im Paket).
- **Red Team / Blue Team:** Diskussion verschiebt sich von „ob PI möglich“ zu „welche Schicht stoppt“ — eure Demo sollte **beides** zeigen können (Exploit **oder** Defense-Sieg).

## Lab conclusions

| Versprechen | Erlaubt? |
|-------------|----------|
| „Copilot **kann** so manipuliert werden“ | **Ja** (mit Quellen oben) |
| „Das klappt **morgen garantiert** beim Kunden“ | **Nein** |
| „Rick Roll + Portal-Link ist eine **glaubwürdige** Demo-Story“ | **Ja**, wenn Redirect live und Plan B sitzt |
| „Kalender wird heimlich befüllt“ | **Nein** — nur als Entwurf/Vorschlag darstellen |

**Pflicht:** Nacht vor dem Termin [TEST-PROTOKOLL-VOR-LIVE.md](TEST-PROTOKOLL-VOR-LIVE.md) im **gleichen** Tenant wie die Show.
