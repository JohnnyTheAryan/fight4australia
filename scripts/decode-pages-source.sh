#!/usr/bin/env bash
# Decode gzipped base64 Worker/API sources from Grok FULL-BACKUP into plain JS.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
decode_one() {
  local b64="$1" out="$2"
  mkdir -p "$(dirname "$out")"
  base64 -d < "$b64" | gzip -dc > "$out"
  echo "Wrote $out ($(wc -c < "$out") bytes)"
}
decode_one "$root/pages-source/_worker.js.gz.b64" "$root/pages-source/_worker.js"
decode_one "$root/workers/api.js.gz.b64" "$root/workers/api.js"
decode_one "$root/pages-source/functions/api/[[path]].js.gz.b64" "$root/pages-source/functions/api/[[path]].js"
