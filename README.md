# fight4australia

Static site for [fight4australia.org](https://fight4australia.org/), deployed as Cloudflare Worker **fight4aus** (id `17cf9246080c410d9a5ac9fcffbff558`).

## Source note

This repository was imported from the live Worker/site on Cloudflare.

- Worker name: `fight4aus`
- Public URL: https://fight4australia.org/
- `workers_get_worker_code` returned null (Worker appears to be **static-assets-only**, no custom script module)
- Files under `public/` are a cleaned mirror of the live site (Cloudflare email protection decoded; challenge/email-decode scripts removed)

## Deploy

```bash
npx wrangler deploy
```

Requires Cloudflare account access for Worker `fight4aus`.
