# Redragon Ryze (K556/K616) on Linux Mint

This guide helps verify detection and access for Redragon Ryze keyboards on Linux Mint.

## 1) Confirm that OpenRGB supports your USB ID

OpenRGB includes these known Redragon Ryze-compatible entries:

- `0c45:5004` as `Redragon K556/K616 Ryze` (EVision)
- `320f:5004` as `Redragon K616 Ryze (alt VID)` (EVision)
- `258a:0049` as `Redragon K616 Ryze (BY Tech)` (Sinowealth)

## 2) Verify your keyboard USB ID on Mint

Run:

```bash
lsusb | grep -Ei 'redragon|by tech|0c45:5004|320f:5004|258a:0049'
```

If one of these IDs appears (`0c45:5004`, `320f:5004`, or `258a:0049`), OpenRGB has a matching detector for it.

## 3) Ensure Linux device permissions are configured

OpenRGB on Linux requires udev rules so non-root access works correctly.

- If installed from distro/package manager, rules are usually already installed.
- For AppImage/build-from-source/Flatpak, install or update `60-openrgb.rules` and reload udev.

See: [Udev Rules](UdevRules.md)

## 4) Start OpenRGB and test

1. Close vendor RGB software if any is running.
2. Start OpenRGB.
3. Look for `Redragon K556/K616 Ryze`, `Redragon K616 Ryze (alt VID)`, or `Redragon K616 Ryze (BY Tech)`.
4. Change to a static color and click apply.

## 5) Troubleshooting

- If device is not visible, unplug/replug keyboard and restart OpenRGB.
- If detected but control fails, re-check udev rules and permissions.
- If your `lsusb` ID differs from `0c45:5004` / `320f:5004` / `258a:0049`, that exact VID:PID needs to be added to a detector.


## 6) Build OpenRGB yourself on Linux Mint (.deb or AppImage)

If you cannot download prebuilt artifacts, you can build them locally.

### A) Build a `.deb` package (recommended on Mint)


### Quick install script (build + install `.deb`)

From this repository root:

```bash
sudo sh install.sh
```

The script installs dependencies, clones the Ryze branch into `/tmp/openrgb-redragonryze-build`, builds a `.deb`, and installs it automatically.

```bash
sudo apt update
sudo apt install -y git build-essential qtcreator qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libusb-1.0-0-dev libhidapi-dev pkgconf libmbedtls-dev qttools5-dev-tools debhelper

cd ~
git clone https://github.com/xmavexy-ship-it/OpenRGB_redragonryze OpenRGB
cd OpenRGB
scripts/build-package-files.sh debian/changelog
dpkg-buildpackage -us -B
```

Expected output package location: `~/openrgb_*.deb`.

Install it:

```bash
sudo apt install ../openrgb_*.deb
```

### B) Build an AppImage

`build-appimage.sh` expects `linuxdeploy-<arch>.AppImage` and `linuxdeploy-plugin-qt-<arch>.AppImage` in your `PATH`.

```bash
sudo apt update
sudo apt install -y git build-essential qtcreator qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libusb-1.0-0-dev libhidapi-dev pkgconf libmbedtls-dev qttools5-dev-tools

cd ~/OpenRGB
chmod +x scripts/build-appimage.sh
DEB_HOST_ARCH=$(dpkg --print-architecture) DEB_HOST_GNU_CPU=$(dpkg-architecture -qDEB_HOST_GNU_CPU) scripts/build-appimage.sh
```

Expected output: `~/OpenRGB/OpenRGB-<arch>.AppImage` plus `60-openrgb.rules`.

After install/start, re-check that your keyboard appears as one of:
- `Redragon K556/K616 Ryze`
- `Redragon K616 Ryze (alt VID)`
- `Redragon K616 Ryze (BY Tech)`
