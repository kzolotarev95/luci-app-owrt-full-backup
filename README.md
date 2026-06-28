# luci-app-owrt-full-backup

Веб-панель для полного бэкапа и восстановления OpenWrt. Сборка `.ipk` не нужна: установка идет напрямую из GitHub на роутер.

Поддержка: OpenWrt 22.x, 23.x, 24.x и 25.x.

## Что устанавливается

- `/usr/sbin/owrt-full-backup` - консольная команда;
- `/www/cgi-bin/owrt-full-backup` - веб-панель;
- `/usr/lib/lua/luci/controller/owrt_full_backup.lua` - пункт меню LuCI;
- `/etc/config/fullbackup` - настройки по умолчанию;
- `/etc/owrt-full-backup/web.key` - секретный ключ для входа в панель.

## Установка

Через `git`:

```sh
git clone https://github.com/kzolotarev95/luci-app-owrt-full-backup.git
cd luci-app-owrt-full-backup
sh install.sh
```

Установка одной командой:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh | sh
```

Если GitHub или браузер отдал старую версию, принудительно обнови с cache-bust:

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/uhttpd restart
```

После установки скрипт покажет приватную ссылку:

```text
http://192.168.1.1/cgi-bin/owrt-full-backup?key=SECRET
```

Эту ссылку никому не отдавай: ключ в URL дает доступ к созданию и восстановлению бэкапов.

Также появится пункт меню LuCI:

```text
Службы -> OpenWrt Full Backup
```

Если пункт не появился сразу, обнови страницу LuCI или выйди и зайди снова.

## Возможности веб-панели

- создать полный архив бэкапа;
- скачать готовый архив;
- посмотреть содержимое/метаданные архива;
- восстановить настройки;
- отдельно включить восстановление списка пакетов;
- отдельно включить восстановление overlay;
- отдельно прошить firmware image из архива;
- сохранить настройки по умолчанию.

По умолчанию восстановление из веб-панели возвращает только настройки. Пакеты, overlay и прошивка включаются отдельными галочками.

## Удаление

Если репозиторий уже скачан:

```sh
sh uninstall.sh
```

Удаление одной командой:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/uninstall.sh | sh
```

Удалить еще и конфиг с веб-ключом:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/uninstall.sh | PURGE=1 sh
```

Архивы бэкапов при удалении не стираются.

## Примеры CLI

Создать бэкап на USB:

```sh
owrt-full-backup create -o /mnt/usb
```

Добавить в архив файл прошивки, если он уже лежит на роутере:

```sh
owrt-full-backup create -o /mnt/usb --firmware-image /tmp/openwrt-sysupgrade.bin
```

Посмотреть архив:

```sh
owrt-full-backup inspect /mnt/usb/router-owrt-full-backup.tar.gz
```

Восстановить только настройки:

```sh
owrt-full-backup restore /mnt/usb/router-owrt-full-backup.tar.gz --yes --no-packages
```

## Почему раньше был 404

Старая команда ссылалась на другой репозиторий:

```sh
https://raw.githubusercontent.com/kzolotarev95/openwrt-full-backup/main/install.sh
```

Правильный адрес для этого проекта:

```sh
https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh
```
