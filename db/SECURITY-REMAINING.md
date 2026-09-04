# Remaining security steps (dashboard only)

Already in this zip (after deploy):
- HSTS, X-Frame-Options, CSP, nosniff, Referrer-Policy, Permissions-Policy on responses
- In-worker rate limit on /api/register, /subscribe, /contact (20/min/IP best-effort)
- Google Fonts removed; system font stack
- _routes.json includes /* so headers apply to HTML too

Still do in Cloudflare / registrar:

1. SSL/TLS → Edge Certificates → enable HSTS at zone level too (backup to worker header)
2. Security → Bots → Bot Fight Mode ON
3. Account → 2FA ON
4. Registrar → WHOIS privacy ON
5. Rotate admin password if shared in chat
6. Optional: WAF rate limit on /api/* (extra to worker limit)
7. Optional: DNS www CNAME → fight4australia.pages.dev (proxied)
8. Long-term: drop Tailwind CDN dependency (pages still load it for utility classes)

After deploy, verify headers:
curl -sI https://fight4australia.org/ | grep -i strict-transport
curl -sI https://fight4australia.org/ | grep -i x-frame
curl -sI https://fight4australia.org/ | grep -i content-security
