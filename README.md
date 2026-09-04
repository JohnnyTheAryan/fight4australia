# fight4australia

Static site for [fight4australia.org](https://fight4australia.org/), deployed as Cloudflare Worker **fight4aus** (id `17cf9246080c410d9a5ac9fcffbff558`).

## Source note

Imported from the live Cloudflare Worker / site.

- Worker name: `fight4aus`
- Public URL: https://fight4australia.org/
- `fight4aus.workers.dev` does not resolve (custom domain only)
- Cloudflare MCP `workers_get_worker_code` returned null — Worker appears **static-assets-only** (no custom JS module)
- No Workers Builds history for this Worker
- Files under `public/` (and the full dump in `export/`) are a cleaned mirror of the live site

### Live HTML quirks cleaned in this import

- Cloudflare email-protection links decoded to real `mailto:` addresses
- Cloudflare challenge / email-decode scripts removed
- Live responses contain a stray STX (`\x02`) where `</div>` should be; restored to `</div>`

## Full export archive

If individual page files are incomplete on `main`, restore everything with:

```bash
bash scripts/extract-export.sh
```

That concatenates `export/site-export.tar.gz.b64.part*` and extracts `public/`, `wrangler.toml`, etc.

Also: `bash scripts/decode-logo.sh` after extract if `public/assets/logo.webp` is missing (needs `public/assets/logo.webp.b64`).

## Deploy

```bash
npx wrangler deploy
```

Requires Cloudflare account access for Worker `fight4aus`.
