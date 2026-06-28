#!/bin/sh

set -eu

ROOT="${ROOT:-/}"
PURGE="${PURGE:-0}"

target_path() {
	printf '%s/%s' "${ROOT%/}" "$1"
}

rmf() {
	rm -f "$(target_path "$1")"
}

rmf usr/sbin/owrt-full-backup
rmf usr/sbin/owrt-full-backup-upload
rmf usr/sbin/owrt-backup
rmf www/cgi-bin/owrt-full-backup
rmf usr/lib/lua/luci/controller/owrt_full_backup.lua

if [ "$PURGE" = "1" ]; then
	rmf etc/config/fullbackup
	rmf etc/owrt-full-backup/web.key
	rmdir "$(target_path etc/owrt-full-backup)" 2>/dev/null || true
fi

rm -rf "$(target_path tmp/luci-indexcache)" "$(target_path tmp/luci-modulecache)" 2>/dev/null || true

if [ -x "$(target_path etc/init.d/uhttpd)" ]; then
	"$(target_path etc/init.d/uhttpd)" reload >/dev/null 2>&1 || "$(target_path etc/init.d/uhttpd)" restart >/dev/null 2>&1 || true
fi

printf '%s\n' "Веб-панель OpenWrt Full Backup удалена."
if [ "$PURGE" != "1" ]; then
	printf '%s\n' "Конфиг и веб-ключ оставлены. Для полного удаления запусти с PURGE=1."
fi
