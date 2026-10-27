# Security policy

## Reporting issues in this repository

If you discover a **security problem in this repo** (accidental secret commit, unsafe default, etc.):

1. **Do not** open a public issue with exploit details against live services.
2. Open a **private** security advisory on GitHub or contact the maintainer directly.
3. Include steps to reproduce and suggested fix.

## Secrets

This project must **never** contain:

- Gmail App Passwords or OAuth client secrets  
- API keys for Google Cloud, Microsoft Graph, or third parties  
- Private keys, `.pem`, or session cookies  
- Real victim/customer email addresses from non-public RoE  

Before every release tag, run:

```bash
bash scripts/verify-no-secrets.sh
```

## Responsible use of lab payloads

Artifacts are designed for **controlled environments**. Misuse against systems without authorization may violate law and provider ToS. Maintainers do not condone such use.

## Safe defaults

- Redirect defaults point to `redirect.example.com` and `*.invalid` mail addresses.  
- Harmful exfil URLs in contrast templates use `*.invalid` or Google’s **official** Safe Browsing **test** URLs only.
