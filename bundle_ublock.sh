#!/bin/bash
set -e
SCRIPT_DIR=$(realpath $(dirname $0))
mkdir -p "$SCRIPT_DIR/extensions/dist"

UBLOCK_URL="https://clients2.google.com/service/update2/crx?response=redirect&prodversion=130.0.0.0&acceptformat=crx2,crx3&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26uc"
echo "Downloading and bundling uBlock Origin..."
python3 "$SCRIPT_DIR/extensions/bundle.py" "$SCRIPT_DIR/extensions/dist" ublock_origin "$UBLOCK_URL"
echo "uBlock Origin bundled successfully!"