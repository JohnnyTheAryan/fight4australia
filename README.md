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

## Grok Pages Worker / API sources

Large JS from Grok FULL-BACKUP is stored gzipped+base64 (same pattern as the logo). Expand with:

```bash
bash scripts/decode-pages-source.sh
```

That writes:
- `pages-source/_worker.js` — live Pages Advanced Mode Worker (~580 lines; D1 `DB`)
- `workers/api.js`
- `pages-source/functions/api/[[path]].js`
- `public/admin/{subscribers,messages,posts,dashboard}.html`

Already plain-text in the repo: `workers/register.js`, `pages-source/_routes.json`, `_headers`, `db/*`, SEO files, SVGs, `public/admin/index.html`.

## Deploy

```bash
npx wrangler deploy
```

Requires Cloudflare account access for Worker `fight4aus`.

## Grok zip comparison (what was merged / skipped)

**Canonical source:** `fight4australia-FULL-BACKUP.zip` (richest tree).

**Skipped:**
- Overwriting cleaned `public/*.html` — Grok HTML still had stray STX; cleaned mirror is better
- `ffa-worker.zip` — only `workers/register.js` (same as FULL-BACKUP); no `package.json` / `wrangler.toml` (placeholder/partial)
- Smaller zips (`pages`, `full`, `complete`, `ONE`) — subsets/older; ONE had a smaller `_worker.js`
- Uploading all six raw backup zips (redundant bloat)
- Raw `database-export.json` admin password hash — see `db/database-export.sample.json` (hash redacted)

**Note:** Live Worker `fight4aus` still appeared assets-only via Cloudflare MCP. The `_worker.js` from Grok is Pages advanced-mode backend source, not necessarily what currently serves the custom domain.
