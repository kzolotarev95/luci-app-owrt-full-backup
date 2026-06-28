module("luci.controller.owrt_full_backup", package.seeall)

function index()
	entry({"admin", "services", "owrt-full-backup"}, call("action_open"), "OpenWrt Full Backup", 90).dependent = false
end

function action_open()
	local http = require "luci.http"
	local fs = require "nixio.fs"
	local key = fs.readfile("/etc/owrt-full-backup/web.key") or ""

	key = key:gsub("%s+", "")
	if key == "" then
		http.prepare_content("text/html; charset=utf-8")
		http.write("<!doctype html><html><head><meta charset=\"utf-8\"><title>OpenWrt Full Backup</title></head><body>")
		http.write("<h1>OpenWrt Full Backup</h1>")
		http.write("<p>Веб-ключ не найден. Переустанови модуль командой <code>sh install.sh</code>.</p>")
		http.write("</body></html>")
		return
	end

	http.redirect("/cgi-bin/owrt-full-backup?key=" .. key)
end
