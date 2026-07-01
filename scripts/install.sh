#!/bin/bash
#
# Walnut AI CLI Installer (macOS / Linux)
# Usage: curl -fsSL https://raw.githubusercontent.com/walnutai-labs/Walnut-Extension/main/install.sh | bash
#

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

REPO="walnutai-labs/Walnut-Extension"
# API-free "latest release" asset redirect — this does NOT hit api.github.com,
# so it is not subject to the 60-req/hour unauthenticated rate limit that made
# shared office networks fail with a misleading "No release found". It requires
# every release to also carry a stable-named `walnut-ai.zip` asset (produced by
# scripts/build-release.sh). If that asset is missing (older releases), we fall
# back to the rate-limited API below.
STABLE_URL="https://github.com/${REPO}/releases/latest/download/walnut-ai.zip"

echo ""
echo -e "${BOLD}  🌰 Walnut AI CLI Installer${NC}"
echo ""

# Step 1: Check/install Bun
if command -v bun &> /dev/null; then
  echo -e "  ${GREEN}✓${NC} Bun v$(bun --version) found"
else
  echo -e "  ${YELLOW}→${NC} Installing Bun..."
  curl -fsSL https://bun.sh/install | bash 2>/dev/null
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  if ! command -v bun &> /dev/null; then
    echo -e "  ${RED}✗${NC} Bun install failed. Run: curl -fsSL https://bun.sh/install | bash"
    exit 1
  fi
  echo -e "  ${GREEN}✓${NC} Bun installed"
fi

# Step 2: Download the latest release
TMPDIR=$(mktemp -d)
echo -e "  ${YELLOW}→${NC} Downloading latest release..."

if curl -fsSL "$STABLE_URL" -o "$TMPDIR/walnut-ai.zip"; then
  # Got it via the API-free redirect — no rate limit involved.
  :
else
  # Fallback: older releases without the stable asset. This path uses the
  # rate-limited GitHub API, so detect a rate-limit response and say so plainly
  # instead of the old misleading "No release found".
  echo -e "  ${YELLOW}→${NC} Stable asset not found, querying GitHub API..."
  API_RESP=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest")
  if echo "$API_RESP" | grep -qi "rate limit exceeded"; then
    echo -e "  ${RED}✗${NC} GitHub API rate limit reached (shared networks hit the 60/hour cap fast),"
    echo -e "     and the latest release has no stable 'walnut-ai.zip' asset to bypass it."
    echo -e "     Wait ~an hour, or download manually from: ${CYAN}https://github.com/${REPO}/releases${NC}"
    rm -rf "$TMPDIR"
    exit 1
  fi
  DOWNLOAD_URL=$(echo "$API_RESP" | grep "browser_download_url.*\.zip" | head -1 | cut -d '"' -f 4)
  if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "  ${RED}✗${NC} No release found at github.com/${REPO}/releases"
    echo -e "     Download manually from: ${CYAN}https://github.com/${REPO}/releases${NC}"
    rm -rf "$TMPDIR"
    exit 1
  fi
  curl -fsSL "$DOWNLOAD_URL" -o "$TMPDIR/walnut-ai.zip"
fi

cd "$TMPDIR"
unzip -qo walnut-ai.zip
echo -e "  ${GREEN}✓${NC} Downloaded"

# Step 3: Install to ~/.walnut-ai
INSTALL_DIR="$HOME/.walnut-ai"
rm -rf "$INSTALL_DIR"
mv walnut-ai "$INSTALL_DIR"
echo -e "  ${GREEN}✓${NC} Installed to $INSTALL_DIR"

# Step 4: Install platform-specific native bindings.
# The release zip ships node_modules from the build OS, so @opentui/core's
# native binding (@opentui/core-{platform}-{arch}) only matches that build.
# On a different OS/arch, walnutai fails at runtime with
# "Cannot find module '@opentui/core-linux-x64/index.ts'". Running bun install
# pulls the correct platform binding from npm without re-downloading
# everything else.
echo -e "  ${YELLOW}→${NC} Installing platform-specific native bindings..."
cd "$INSTALL_DIR"
bun install --production --silent 2>/dev/null || bun install --production 2>&1 | tail -3
echo -e "  ${GREEN}✓${NC} Native bindings ready"

# Step 5: Link globally
cd "$INSTALL_DIR"
npm link --silent 2>/dev/null || {
  BIN_DIR="$HOME/.bun/bin"
  mkdir -p "$BIN_DIR"
  ln -sf "$INSTALL_DIR/cli.js" "$BIN_DIR/walnutai"
}
echo -e "  ${GREEN}✓${NC} Linked globally"

# Cleanup
rm -rf "$TMPDIR"

echo ""
if command -v walnutai &> /dev/null; then
  echo -e "  ${GREEN}${BOLD}✓ Walnut AI CLI installed!${NC}"
else
  echo -e "  ${GREEN}${BOLD}✓ Walnut AI CLI installed!${NC}"
  echo -e "  ${YELLOW}  Restart your terminal or run:${NC}"
  echo -e "    ${CYAN}export PATH=\"\$HOME/.bun/bin:\$PATH\"${NC}"
fi
echo ""
echo -e "  ${CYAN}walnutai${NC}                              Start"
echo -e "  ${CYAN}walnutai --server-url http://...${NC}      Connect to server"
echo -e "  ${CYAN}walnutai --help${NC}                       Help"
echo ""
echo -e "  To update: re-run this command"
echo ""
