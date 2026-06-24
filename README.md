
A small Linux systemd helper that keeps selected OpenRazer devices in **driver mode**.


Some wireless Razer mice can wake from their own internal sleep state and fall back from OpenRazer driver mode:

```text
03 00
```

to normal mode:

```text
00 00
```

When this happens, OpenRazer-managed behavior may stop working until `openrazer-daemon.service` is restarted. This project avoids repeatedly restarting the daemon by directly restoring the device's `device_mode` sysfs value.

## Tested Device

Tested with:

```text
Razer Basilisk V3 X HyperSpeed
Vendor ID:  1532
Product ID: 00B9
```

## What It Does

Every few seconds, the service checks for a matching sysfs file like:

```text
/sys/devices/.../0003:1532:00B9.*/device_mode
```

If the mode is not:

```text
03 00
```

it writes:

```text
03 00
```

back to `device_mode`.

The service only logs when it actually restores driver mode.

## Install

```bash
git clone https://github.com/bloopybae/openrazer-driver-mode-keeper.git
cd openrazer-driver-mode-keeper
sudo ./install.sh
```

Check the service:

```bash
systemctl status openrazer-driver-mode-keeper.service
```

## Configure

Edit the config file:

```bash
sudo nano /etc/openrazer-driver-mode-keeper.conf
```

Default config:

```bash
VENDOR_ID=1532
PRODUCT_ID=00B9
INTERVAL_SECONDS=5
```

Restart the service after changing the config:

```bash
sudo systemctl restart openrazer-driver-mode-keeper.service
```

## Verify Device Mode Manually

Find the `device_mode` file:

```bash
sudo find /sys/devices -path '*0003:1532:00B9.*' -name device_mode -print 2>/dev/null
```

Read it as raw bytes:

```bash
sudo od -An -tx1 -N2 /path/to/device_mode
```

Driver mode should read:

```text
03 00
```

Normal mode may read:

```text
00 00
```

## Uninstall

```bash
sudo ./uninstall.sh
```

The uninstall script leaves the config file in place:

```text
/etc/openrazer-driver-mode-keeper.conf
```

Remove it manually:

```bash
sudo rm /etc/openrazer-driver-mode-keeper.conf
```

## Notes

This is a workaround for wireless Razer devices that fall out of OpenRazer driver mode after internal sleep/wake behavior.


## License

MIT
