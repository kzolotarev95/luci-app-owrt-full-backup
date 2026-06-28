# openwrt-full-backup

OpenWrt package overlay for creating and restoring a single backup archive with:

- sysupgrade configuration backup;
- installed package list and opkg metadata;
- OpenWrt release, board, mount, partition and UCI metadata;
- optional `/overlay/upper` snapshot;
- optional `/rom` read-only rootfs snapshot;
- optional copy of a sysupgrade firmware image;
- optional raw MTD dumps for same-device disaster recovery.

The scripts target OpenWrt `/bin/sh` (BusyBox ash) and are intended for OpenWrt 22.x, 23.x, 24.x and 25.x.

## Build

Copy this repository into an OpenWrt build tree, or copy `package/openwrt-full-backup` into the build tree `package/` directory.

```sh
make menuconfig
# Utilities -> openwrt-full-backup
make package/openwrt-full-backup/compile V=s
```

The package installs two commands:

```sh
owrt-full-backup
owrt-backup
```

## Create Backup

Recommended backup to USB or another persistent mount:

```sh
owrt-full-backup create -o /mnt/usb
```

Include the exact sysupgrade image if you have it on the router:

```sh
owrt-full-backup create -o /mnt/usb --firmware-image /tmp/openwrt-sysupgrade.bin
```

Include the read-only firmware root filesystem snapshot:

```sh
owrt-full-backup create -o /mnt/usb --include-rom
```

Create a same-device raw flash dump too:

```sh
owrt-full-backup create -o /mnt/usb --include-raw-mtd
```

Raw MTD dumps are not portable between different models or partition layouts.

## Restore

Safe restore mode restores configs and reinstalls packages from feeds:

```sh
owrt-full-backup restore /mnt/usb/router-backup.tar.gz --yes
```

Restore only configs:

```sh
owrt-full-backup restore /mnt/usb/router-backup.tar.gz --yes --no-packages
```

Restore the overlay snapshot too, only on the same device and preferably the same OpenWrt release:

```sh
owrt-full-backup restore /mnt/usb/router-backup.tar.gz --yes --overlay
```

Flash firmware from the archive:

```sh
owrt-full-backup restore /mnt/usb/router-backup.tar.gz --yes --flash-firmware
```

Firmware flashing uses `sysupgrade` and reboots the device. The original OpenWrt sysupgrade image is usually not stored on the router, so include it at backup time with `--firmware-image` if you need this.

## Default Config

The package installs `/etc/config/fullbackup`:

```uci
config backup 'main'
	option output_dir '/tmp'
	option include_overlay '1'
	option include_rom '0'
	option include_raw_mtd '0'
	option keep_days '0'
```

Use `/tmp` only for quick tests. Real backups should go to USB, network storage, or a mounted persistent disk.
