#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
cat export/site-export.tar.gz.b64.part* | base64 -d > /tmp/site-export.tar.gz
tar -xzf /tmp/site-export.tar.gz
echo "Extracted site into current directory"
