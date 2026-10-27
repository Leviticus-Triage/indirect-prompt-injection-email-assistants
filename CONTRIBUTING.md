# Contributing

Thank you for improving this research lab framework.

## What we welcome

- Documented lab findings (product version, date, repro steps) in `docs/FINDINGS.md`  
- New `*.html.in` variants with clear matrix entry in `README.md`  
- Locale-specific trainer prompts under `prompts/`  
- Fixes to build scripts and false-positive reductions in `verify-no-secrets.sh`  

## What we do not accept

- Real exfiltration endpoints, malware, or credential harvesters  
- Committed secrets or personal identifiers  
- Changes whose primary goal is evading production abuse systems without research justification  

## Pull request checklist

- [ ] `bash scripts/verify-no-secrets.sh` passes  
- [ ] No `.env` or `.demo-portal-url` committed  
- [ ] Templates use `__PORTAL_URL__` or documented placeholders  
- [ ] Ethics / RoE section updated if behavior changes materially  
- [ ] FINDINGS or README updated for new attack or defense paths  

## Development flow

```bash
cp .env.example .env   # local only
export DEMO_PORTAL_URL='https://your-hop.example/...'
bash tools/render-gmail-blogspot-demo.sh
bash tools/preflight-gmail-demo.sh "$DEMO_PORTAL_URL"
```

## Code style

- Bash: `set -euo pipefail` where already used  
- Comments in templates: distinguish **stealth** vs **contrast** variants  
- Prefer declarative metadata over imperative jailbreak text for “success path” templates  
