# luci-app-owrt-full-backup

![OpenWrt](https://img.shields.io/badge/OpenWrt-22--25-00A3E0?style=for-the-badge)
![LuCI](https://img.shields.io/badge/LuCI-web%20panel-16A34A?style=for-the-badge)
![Install](https://img.shields.io/badge/install-without%20ipk-111827?style=for-the-badge)

Веб-панель и CLI-утилита для полного бэкапа OpenWrt. Сборка `.ipk` не нужна: модуль ставится прямо с GitHub на роутер.

## Что умеет

- Создает архив бэкапа через веб-панель LuCI или через SSH.
- Сохраняет настройки OpenWrt через `sysupgrade -b`.
- Сохраняет список установленных пакетов `opkg`.
- Может добавить снимок `/overlay/upper`.
- Может добавить снимок `/rom`.
- Может добавить firmware image, если файл прошивки уже лежит на роутере.
- Может добавить raw MTD dump для полного дампа flash-разделов.
- Показывает состояние памяти и температуру роутера.
- Позволяет скачать, загрузить, посмотреть и удалить архив из веб-панели.
- Позволяет восстановить настройки, пакеты, overlay или firmware image отдельными галочками.

## Быстрая установка

Зайди на роутер по SSH и выполни:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh | sh
```

После установки скрипт покажет приватную ссылку:

```text
Открыть: http://192.168.1.1/cgi-bin/owrt-full-backup?key=SECRET
```

Эту ссылку держи в секрете: ключ в URL дает доступ к созданию и восстановлению бэкапов.

Пункт в LuCI:

```text
Службы -> OpenWrt Full Backup
```

## Обновление

Если нужно принудительно поставить свежую версию с GitHub:

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
```

Скрипт сам обновляет файлы, чистит кэш LuCI и перезапускает нужные службы.

## Структура проекта

```text
.
├── install.sh
├── uninstall.sh
├── README.md
├── LICENSE
└── files
    ├── etc
    │   └── config
    │       └── fullbackup
    ├── usr
    │   ├── sbin
    │   │   ├── owrt-full-backup
    │   │   └── owrt-full-backup-upload
    │   └── share
    │       ├── luci
    │       │   └── menu.d
    │       │       └── luci-app-owrt-full-backup.json
    │       └── rpcd
    │           └── acl.d
    │               └── luci-app-owrt-full-backup.json
    └── www
        ├── cgi-bin
        │   └── owrt-full-backup
        └── luci-static
            └── resources
                └── view
                    └── owrt_full_backup.js
```

## Что ставится на роутер

| Путь | Назначение |
| --- | --- |
| `/usr/sbin/owrt-full-backup` | CLI-команда для создания, просмотра и восстановления архива |
| `/usr/sbin/owrt-full-backup-upload` | Потоковая загрузка `.tar.gz` из браузера без Lua |
| `/www/cgi-bin/owrt-full-backup` | Веб-панель |
| `/www/luci-static/resources/view/owrt_full_backup.js` | LuCI-страница-редирект без Lua runtime |
| `/usr/share/luci/menu.d/luci-app-owrt-full-backup.json` | Пункт меню LuCI для OpenWrt 22-25 |
| `/usr/share/rpcd/acl.d/luci-app-owrt-full-backup.json` | Доступ LuCI к приватному веб-ключу |
| `/etc/config/fullbackup` | Настройки по умолчанию |
| `/etc/owrt-full-backup/web.key` | Приватный ключ веб-панели |

## Как делать бэкап

Через веб-панель:

1. Открой `Службы -> OpenWrt Full Backup`.
2. Выбери папку для архива.
3. Нажми `Создать бэкап`.
4. Следи за журналом выполнения на странице.
5. После завершения архив появится в списке ниже.

Через SSH:

```sh
owrt-full-backup create -o /mnt/usb
```

Если нужен firmware image:

```sh
owrt-full-backup create -o /mnt/usb --firmware-image /tmp/openwrt-sysupgrade.bin
```

## Важное про `/tmp`, USB и raw MTD

`/tmp` в OpenWrt обычно находится в RAM. Для маленького бэкапа настроек этого хватает, но для ROM snapshot, firmware image или raw MTD dump лучше сразу использовать флешку или диск:

```text
/mnt/usb
```

Raw MTD dump может быть очень большим и привязан к конкретной модели, разметке flash и загрузчику. Не сохраняй raw MTD в `/tmp`: модуль теперь сразу остановит такую попытку понятной ошибкой.

## Восстановление

Посмотреть архив:

```sh
owrt-full-backup inspect /mnt/usb/router-owrt-full-backup.tar.gz
```

Восстановить только настройки:

```sh
owrt-full-backup restore /mnt/usb/router-owrt-full-backup.tar.gz --yes --no-packages
```

В веб-панели восстановление запускается только после ввода `RESTORE`. Это защита от случайного клика.

## Если пункт не появился в LuCI

Сначала обнови модуль свежей командой:

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
```

Если в меню все еще не видно:

```sh
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache /tmp/luci-indexcache.* /tmp/luci-modulecache.*
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
```

Потом обнови страницу LuCI или выйди из LuCI и зайди снова. Прямая приватная ссылка из вывода `install.sh` тоже всегда работает.

## Если в LuCI ошибка `No Lua runtime installed`

Поставь свежую версию. Модуль больше не использует Lua-controller для пункта меню LuCI:

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
```

Установщик удалит старый файл:

```text
/usr/lib/lua/luci/controller/owrt_full_backup.lua
```

И заменит его на LuCI JS-view + rpcd ACL.

## Если ошибка `No space left on device`

Причина почти всегда одна: архив создается в `/tmp`, а там RAM закончилась.

Что сделать:

```sh
mkdir -p /mnt/usb
owrt-full-backup create -o /mnt/usb
```

В веб-панели укажи папку `/mnt/usb`. Для raw MTD dump это обязательно.

## Если при загрузке архива браузер пишет `ERR_CONNECTION_RESET`

Обнови модуль. Загрузка архива теперь идет потоково: файл пишется сразу на диск, а не целиком в память.

Если ошибка осталась, проверь свободное место в папке для архивов и ставь папку на USB/диск, например `/mnt/usb`.

## Удаление

Удалить модуль, но оставить конфиг и ключ:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/uninstall.sh | sh
```

Удалить модуль, конфиг и веб-ключ:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/uninstall.sh | PURGE=1 sh
```

Архивы бэкапов при удалении не стираются.
