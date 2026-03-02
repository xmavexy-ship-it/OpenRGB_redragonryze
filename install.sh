#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/xmavexy-ship-it/OpenRGB_redragonryze.git"
REPO_BRANCH="codex/add-redragon-ryze-support"
BUILD_ROOT="/tmp/openrgb-redragonryze-build"

if [[ ${EUID} -ne 0 ]]; then
    echo "Please run as root: sudo sh install.sh"
    exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "This installer currently supports Debian/Ubuntu/Mint (apt) only."
    exit 1
fi

if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    BUILD_USER="${SUDO_USER}"
    BUILD_HOME="$(getent passwd "${BUILD_USER}" | cut -d: -f6)"
else
    BUILD_USER="root"
    BUILD_HOME="/root"
fi

run_as_build_user() {
    if [[ "${BUILD_USER}" == "root" ]]; then
        bash -lc "$*"
    else
        runuser -u "${BUILD_USER}" -- bash -lc "$*"
    fi
}

echo "[1/5] Installing build dependencies..."
apt update
apt install -y \
    git build-essential qtcreator qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    libusb-1.0-0-dev libhidapi-dev pkgconf libmbedtls-dev qttools5-dev-tools debhelper

echo "[2/5] Preparing build directory..."
rm -rf "${BUILD_ROOT}"
mkdir -p "${BUILD_ROOT}"
chown -R "${BUILD_USER}:${BUILD_USER}" "${BUILD_ROOT}"

echo "[3/5] Cloning repository..."
run_as_build_user "cd '${BUILD_ROOT}' && git clone --depth 1 --branch '${REPO_BRANCH}' '${REPO_URL}' OpenRGB"

echo "[4/5] Building .deb package..."
run_as_build_user "cd '${BUILD_ROOT}/OpenRGB' && scripts/build-package-files.sh debian/changelog && dpkg-buildpackage -us -B"

echo "[5/5] Installing .deb package..."
DEB_PATH=$(find "${BUILD_ROOT}" -maxdepth 1 -type f -name 'openrgb_*.deb' | head -n 1 || true)

if [[ -z "${DEB_PATH}" ]]; then
    echo "Build finished, but .deb package was not found in ${BUILD_ROOT}."
    echo "Check build logs in ${BUILD_ROOT}/OpenRGB"
    exit 1
fi

apt install -y "${DEB_PATH}"

echo
echo "OpenRGB installed successfully from ${DEB_PATH}"
echo "If keyboard control does not work, install/reload udev rules:"
echo "  sudo bash scripts/openrgb-udev-install.sh"
