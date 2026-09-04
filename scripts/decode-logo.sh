#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
base64 -d public/assets/logo.webp.b64 > public/assets/logo.webp
echo "Wrote public/assets/logo.webp"
