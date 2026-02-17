# Redragon Ryze (K556/K616) on Linux Mint

This guide helps verify detection and access for Redragon Ryze keyboards on Linux Mint.

## 1) Confirm that OpenRGB supports your USB ID

OpenRGB EVision detection includes these Redragon Ryze entries:

- `0c45:5004` as `Redragon K556/K616 Ryze`
- `320f:5004` as `Redragon K616 Ryze (alt VID)`

## 2) Verify your keyboard USB ID on Mint

Run:

```bash
lsusb | grep -Ei 'redragon|0c45:5004|320f:5004'
```

If `0c45:5004` or `320f:5004` appears, OpenRGB has a matching EVision detector.

## 3) Ensure Linux device permissions are configured

OpenRGB on Linux requires udev rules so non-root access works correctly.

- If installed from distro/package manager, rules are usually already installed.
- For AppImage/build-from-source/Flatpak, install or update `60-openrgb.rules` and reload udev.

See: [Udev Rules](UdevRules.md)

## 4) Start OpenRGB and test

1. Close vendor RGB software if any is running.
2. Start OpenRGB.
3. Look for `Redragon K556/K616 Ryze` (or the alt VID variant).
4. Change to a static color and click apply.

## 5) Troubleshooting

- If device is not visible, unplug/replug keyboard and restart OpenRGB.
- If detected but control fails, re-check udev rules and permissions.
- If your `lsusb` ID differs from `0c45:5004` / `320f:5004`, that exact PID needs to be added to a detector.
