#!/usr/bin/env bash
# build-zip.sh — VibeCodeProtocols distributable package builder
# Run from the vibecodeprotocols/ directory
# Output: vibecodeprotocols-<version>.zip + checksums.txt

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
VERSION="${1:-$(date +%Y.%m.%d)}"
OUTPUT_NAME="vibecodeprotocols-${VERSION}"

echo "=== VibeCodeProtocols Package Builder ==="
echo "Version: $VERSION"
echo "Source:  $PACKAGE_DIR"
echo ""

# Work from parent directory
cd "$(dirname "$PACKAGE_DIR")"

# Clean previous
rm -f "${OUTPUT_NAME}.zip" checksums.txt

# Create zip
zip -r "${OUTPUT_NAME}.zip" "vibecodeprotocols/" \
  --exclude "*/\.git/*" \
  --exclude "*/__pycache__/*" \
  --exclude "*/.pytest_cache/*" \
  --exclude "*/node_modules/*" \
  --exclude "*/.DS_Store" \
  --exclude "*/Thumbs.db"

# Generate checksums
sha256sum "${OUTPUT_NAME}.zip" > checksums.txt

SIZE=$(du -sh "${OUTPUT_NAME}.zip" | cut -f1)
SHA=$(cat checksums.txt | awk '{print substr($1,1,16) "..."}')

echo "✓ ${OUTPUT_NAME}.zip ($SIZE)"
echo "✓ checksums.txt (SHA256: $SHA)"
echo ""
echo "=== Distribute ==="
echo ""
echo "Option A — Direct download (share the .zip file)"
echo "  Recipient: unzip ${OUTPUT_NAME}.zip && cd vibecodeprotocols && ./scripts/install.sh"
echo ""
echo "Option B — Git clone"
echo "  git clone <your-repo-url> && cd vibecodeprotocols && ./scripts/install.sh"
echo ""
echo "Option C — One-liner (host the zip on GitHub releases)"
echo "  curl -fsSL <raw-url>/scripts/install-remote.sh | bash"
