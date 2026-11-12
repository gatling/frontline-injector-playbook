#!/usr/bin/bash
#
# Installs what gatling-browser needs: Node.js for the Playwright driver (instead of the one bundled in Playwright's
# driver-bundle jar), Chrome Headless Shell, and their libraries and fonts.
# Supports Debian (GCP, Azure) and Amazon Linux 2023 (AWS), x86_64 and aarch64.
# Only run by the GraalVM packer builds with browser=true, for the graalvm-browser images: GraalVM runs both JVM and
# JavaScript simulations, so one flavor covers both, and the graalvm-openjdk and Zulu images stay without a browser.
set -Eeuo pipefail

if [ "$(id -u)" -ne 0 ]; then
  exec sudo --preserve-env=NODE_VERSION,PLAYWRIGHT_VERSION bash "$0" "$@"
fi

echo "------------------------------------------------------------------------"
echo "-- installing browser runtime                                         --"
echo "------------------------------------------------------------------------"

# An LTS of the Node.js major bundled by the Playwright version below.
NODE_VERSION="${NODE_VERSION:-24.22.2}"
# The playwright-core version of the Playwright driver used by gatling-browser: it pins the Chrome Headless Shell
# revision, which the driver doesn't download as PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD is set.
PLAYWRIGHT_VERSION="${PLAYWRIGHT_VERSION:-1.64.0}"

readonly NODE_HOME=/opt/node
readonly BROWSERS_PATH=/opt/ms-playwright

case "$(uname -m)" in
  x86_64) NODE_ARCH=x64 ;;
  aarch64) NODE_ARCH=arm64 ;;
  *) echo "Unsupported architecture $(uname -m)" >&2; exit 1 ;;
esac

# The libraries of Chrome Headless Shell, plus fontconfig and the Liberation fonts: at least one font is required, and
# Liberation has the metrics of Arial, Times New Roman and Courier New, so pages lay out like on users' machines (it
# matters for LCP and CLS).
if command -v apt-get > /dev/null; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl xz-utils \
    libasound2t64 libatk-bridge2.0-0t64 libatk1.0-0t64 libatspi2.0-0t64 libdbus-1-3 libdrm2 libexpat1 libgbm1 \
    libglib2.0-0t64 libnspr4 libnss3 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 libxfixes3 libxkbcommon0 \
    libxrandr2 \
    fontconfig fonts-liberation
elif command -v dnf > /dev/null; then
  dnf install -y \
    tar xz \
    alsa-lib at-spi2-atk at-spi2-core atk dbus-libs expat glib2 libdrm libX11 libxcb libXcomposite libXdamage libXext \
    libXfixes libxkbcommon libXrandr mesa-libgbm nspr nss \
    fontconfig liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts
else
  echo "Neither apt-get nor dnf found" >&2
  exit 1
fi

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

# Node.js from the official distribution, checksum verified. Only the node binary is kept: the Playwright driver
# doesn't need npm, corepack or the headers.
NODE_ARCHIVE="node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz"
curl --fail --silent --show-error --location -o "$WORK_DIR/$NODE_ARCHIVE" "https://nodejs.org/dist/v${NODE_VERSION}/${NODE_ARCHIVE}"
curl --fail --silent --show-error --location -o "$WORK_DIR/SHASUMS256.txt" "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt"
(cd "$WORK_DIR" && grep " ${NODE_ARCHIVE}\$" SHASUMS256.txt | sha256sum --check --strict -)
mkdir "$WORK_DIR/node"
tar -xJf "$WORK_DIR/$NODE_ARCHIVE" --strip-components=1 -C "$WORK_DIR/node"
rm -rf "$NODE_HOME"
mkdir -p "$NODE_HOME/bin"
cp "$WORK_DIR/node/bin/node" "$NODE_HOME/bin/"
cp "$WORK_DIR/node/LICENSE" "$NODE_HOME/"

# Chrome Headless Shell, installed by the Playwright CLI so that it has the layout the Playwright driver expects.
# FFmpeg comes along but is only for video recording, which gatling-browser doesn't use.
# playwright-core is installed in a temporary project rather than run with npx: the CLI prints a warning about missing
# project dependencies when it's run from the npx cache.
rm -rf "$BROWSERS_PATH"
export npm_config_cache="$WORK_DIR/npm-cache" npm_config_update_notifier=false npm_config_audit=false npm_config_fund=false
PATH="$WORK_DIR/node/bin:$PATH" npm install --silent --prefix "$WORK_DIR/playwright" "playwright-core@${PLAYWRIGHT_VERSION}"
PLAYWRIGHT_BROWSERS_PATH="$BROWSERS_PATH" \
  "$WORK_DIR/node/bin/node" "$WORK_DIR/playwright/node_modules/playwright-core/cli.js" install chromium-headless-shell
rm -rf "$BROWSERS_PATH"/ffmpeg-* "$BROWSERS_PATH/.links"
chmod -R a+rX "$BROWSERS_PATH" "$NODE_HOME"

# chrome-headless-shell-linux64/chrome-headless-shell on x86_64, chrome-linux/headless_shell on aarch64
BROWSER=""
for candidate in "$BROWSERS_PATH"/chromium_headless_shell-*/*/chrome-headless-shell "$BROWSERS_PATH"/chromium_headless_shell-*/*/headless_shell; do
  if [ -f "$candidate" ]; then
    BROWSER="$candidate"
  fi
done
if [ -z "$BROWSER" ]; then
  echo "Chrome Headless Shell not found in $BROWSERS_PATH" >&2
  exit 1
fi
if ldd "$BROWSER" "$NODE_HOME/bin/node" | grep 'not found'; then
  echo "Missing libraries" >&2
  exit 1
fi

fc-cache --force

# For login shells, and for processes started through PAM (SSH sessions). Processes started by cloud-init, like the
# load generator, read neither: they must set these variables themselves.
cat > /etc/profile.d/gatling-browser.sh << EOF
export PLAYWRIGHT_NODEJS_PATH=$NODE_HOME/bin/node
export PLAYWRIGHT_BROWSERS_PATH=$BROWSERS_PATH
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
EOF
chmod 644 /etc/profile.d/gatling-browser.sh
touch /etc/environment
sed -i '/^PLAYWRIGHT_\(NODEJS_PATH\|BROWSERS_PATH\|SKIP_BROWSER_DOWNLOAD\)=/d' /etc/environment
cat >> /etc/environment << EOF
PLAYWRIGHT_NODEJS_PATH=$NODE_HOME/bin/node
PLAYWRIGHT_BROWSERS_PATH=$BROWSERS_PATH
PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
EOF

echo "Node.js $("$NODE_HOME/bin/node" --version) and $(basename "$(dirname "$(dirname "$BROWSER")")") installed"
