# OpenWrt Full Backup Web

Direct web panel for OpenWrt backup and restore. No OpenWrt buildroot package or `.ipk` build is required.

It installs:

- `/usr/sbin/owrt-full-backup` command line helper;
- `/www/cgi-bin/owrt-full-backup` web panel;
- `/etc/config/fullbackup` defaults;
- `/etc/owrt-full-backup/web.key` secret web key.

Target: OpenWrt 22.x, 23.x, 24.x and 25.x.

## Install From Git

```sh
git clone https://github.com/kzolotarev95/openwrt-full-backup.git
cd openwrt-full-backup
sh install.sh
```

One-line install:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/openwrt-full-backup/main/install.sh | sh
```

The installer prints a private panel link:

```text
http://192.168.1.1/cgi-bin/owrt-full-backup?key=SECRET
```

Keep this link private.

## Web Panel

The panel can:

- create a full backup archive;
- download created archives;
- inspect an existing archive;
- restore configs;
- optionally reinstall saved package list;
- optionally restore overlay;
- optionally flash firmware image from the archive;
- save default backup settings.

Restore from the web panel does not reinstall packages unless you tick that checkbox.

## Remove

From a cloned repo:

```sh
sh uninstall.sh
```

One-line remove:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/openwrt-full-backup/main/uninstall.sh | sh
```

Remove config and web key too:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/openwrt-full-backup/main/uninstall.sh | PURGE=1 sh
```

Backup archives are not deleted by uninstall.

## CLI Examples

Create backup to USB:

```sh
owrt-full-backup create -o /mnt/usb
```

Include firmware image if it is already on the router:

```sh
owrt-full-backup create -o /mnt/usb --firmware-image /tmp/openwrt-sysupgrade.bin
```

Inspect backup:

```sh
owrt-full-backup inspect /mnt/usb/router-owrt-full-backup.tar.gz
```

Restore configs only:

```sh
owrt-full-backup restore /mnt/usb/router-owrt-full-backup.tar.gz --yes --no-packages
```
