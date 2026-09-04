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


## Grok / Pages advanced-mode source

Grok-provided zips under local `/workspace/grok-ffa/` were unpacked and compared to this mirror.

**Merged from `fight4australia-FULL-BACKUP.zip` (canonical richest tree):**
- `pages-source/_worker.js` — live Pages Advanced Mode Worker (~580 lines; API + security headers)
- `pages-source/_routes.json`, `pages-source/_headers`
- `pages-source/functions/api/[[path]].js` — Pages Functions variant
- `workers/api.js`, `workers/register.js` — alternate standalone Worker sources
- `public/admin/` — admin UI
- `db/` — D1 schema, setup docs, redacted sample export
- `public/robots.txt`, `sitemap.xml`, `llms.txt`, `assets/logo.svg`, `assets/logo-mark.svg`

**Skipped:**
- Overwriting cleaned `public/*.html` — Grok HTML still had stray STX (`\\x02`); this repo's cleaned mirror is better
- `ffa-worker.zip` — only `workers/register.js` (same file as in FULL-BACKUP); no `package.json` / `wrangler.toml` (placeholder/partial)
- Smaller zips (`pages`, `full`, `complete`, `ONE`) — subsets or older than FULL-BACKUP; ONE had a smaller `_worker.js`
- Uploading all six raw backup zips (redundant bloat)
- Raw `database-export.json` admin password hash — see `db/database-export.sample.json` (hash redacted)

**Note:** Live Cloudflare Worker `fight4aus` still appeared assets-only when queried via MCP. The `_worker.js` here is the Pages advanced-mode backend from the Grok backup (D1 binding `DB`), not necessarily what currently serves fight4australia.org.
