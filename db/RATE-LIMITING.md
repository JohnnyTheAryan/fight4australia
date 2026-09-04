# Optional: rate limit /api/* in Cloudflare

1. Dashboard → Security → WAF (or Security rules)
2. Create rate limiting rule (Free plan may have limits)
3. Match: URI Path starts with `/api/`
4. Threshold: e.g. 30 requests / 1 minute per IP
5. Action: Block or Challenge

Protects register/contact spam. Not required for the site to function.
