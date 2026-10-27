# Abgleich mit [elder-plinius / Pliny](https://github.com/elder-plinius) — was für LAB Copilot-Demo passt

Pliny’s Ökosystem (CL4R1T4S, L1B3RT4S, G0DM0D3, …) zielt primär auf **direkte Chat-Jailbreaks** und System-Prompt-Leaks — **nicht** auf Microsoft 365 Copilot in Outlook. Die für **E-Mail → Copilot** relevante Linie ist **[ST3GG](https://github.com/elder-plinius/ST3GG)**: versteckte Instruktionen in **Text/HTML**, unsichtbares Unicode, Mehrschicht-Encoding — genau die Fläche, die Defender for Office 365 bei Mailflow analysiert ([Microsoft Learn](https://learn.microsoft.com/en-us/defender-office-365/step-by-step-guides/prompt-injection-protection-defender-for-office-365)).

| Pliny / ST3GG-Idee | In diesem Paket | Copilot-Relevanz |
|--------------------|-----------------|------------------|
| Unsichtbares Unicode in „sichtbarem“ Text | `tools/encode-hidden-text.py` → `unicode_tags`, ZWSP | Text-Extraktion für LLM kann mehr sehen als Mensch |
| Mehrfach-Encoding / Schichten | `demo-email-stego-tiered.html` (Tier A/B/C) | Erhöht Trefferchance **oder** Defender-Block — deshalb **Test-Protokoll** |
| Bild-Stego / Polyglots | `demo-attachment-note.md` (optional Anhang) | SharePoint/„Datei zusammenfassen“-Story, nicht Pflicht für E-Mail-Live |
| L1B3RT4S / „God mode“ Prompts | **Nicht** enthalten | In M365 Copilot praktisch wirkungslos; würde Schulung unseriös machen |

**Wichtig:** Aggressivere Stego-Vektoren können **eher** von Defender gestoppt werden. Live-Reihenfolge: **Tier A → B → C**, nicht mit C starten.
