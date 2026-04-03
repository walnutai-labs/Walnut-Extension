#!/bin/bash
#
# Walnut AI CLI Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/walnutai-labs/Walnut-Extension/main/scripts/install.sh | bash
#

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

REPO="walnutai-labs/Walnut-Extension"

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

# Step 2: Get latest release URL
echo -e "  ${YELLOW}→${NC} Fetching latest release..."
DOWNLOAD_URL=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url.*\.zip" \
  | head -1 \
  | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo -e "  ${RED}✗${NC} No release found at github.com/${REPO}/releases"
  echo -e "    Download manually from: ${CYAN}https://github.com/${REPO}/releases${NC}"
  exit 1
fi

# Step 3: Download and extract
TMPDIR=$(mktemp -d)
echo -e "  ${YELLOW}→${NC} Downloading..."
curl -sL "$DOWNLOAD_URL" -o "$TMPDIR/walnut-ai.zip"
cd "$TMPDIR"
unzip -qo walnut-ai.zip
echo -e "  ${GREEN}✓${NC} Downloaded"

# Step 4: Install to ~/.walnut-ai
INSTALL_DIR="$HOME/.walnut-ai"
rm -rf "$INSTALL_DIR"
mv walnut-ai "$INSTALL_DIR"
echo -e "  ${GREEN}✓${NC} Installed to $INSTALL_DIR"

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
