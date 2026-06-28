<div align="center">

# OpenWrt Full Backup

**LuCI web-панель и SSH-утилита для полного бэкапа OpenWrt без сборки `.ipk`.**

[![OpenWrt](https://img.shields.io/badge/OpenWrt-22.x%20%7C%2023.x%20%7C%2024.x%20%7C%2025.x-00A3E0?style=for-the-badge)](https://openwrt.org/)
[![LuCI](https://img.shields.io/badge/LuCI-web%20panel-16A34A?style=for-the-badge)](https://openwrt.org/docs/guide-user/luci/start)
[![No Lua runtime](https://img.shields.io/badge/LuCI-no%20Lua%20runtime-111827?style=for-the-badge)](#если-в-luci-ошибка-no-lua-runtime-installed)
[![Install](https://img.shields.io/badge/install-one%20command-2563EB?style=for-the-badge)](#быстрая-установка)

[Telegram](https://t.me/kzolotarev95) · [GitHub автора](https://github.com/kzolotarev95)

</div>

## Зачем нужен модуль

`luci-app-owrt-full-backup` делает удобную панель в OpenWrt для создания, скачивания, загрузки и восстановления архивов бэкапа. Подходит для обычного сохранения настроек, переноса конфигурации после перепрошивки и подготовки полного архива роутера перед экспериментами.

> [!IMPORTANT]
> После установки скрипт покажет приватную ссылку с `key=...`. Не отдавай ее посторонним: по этой ссылке можно создавать и восстанавливать бэкапы.

## Быстрая установка

Зайди на роутер по SSH и выполни:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh | sh
```

После установки открой:

```text
LuCI -> Службы -> OpenWrt Full Backup
```

Также установщик покажет прямую ссылку:

```text
http://192.168.1.1/cgi-bin/owrt-full-backup?key=SECRET
```

## Что умеет

| Возможность | Что делает |
| --- | --- |
| Веб-панель LuCI | Пункт `Службы -> OpenWrt Full Backup` и отдельная защищенная CGI-панель |
| Бэкап настроек | Создает стандартный `sysupgrade` backup конфигурации OpenWrt |
| Список пакетов | Сохраняет список установленных пакетов `opkg` |
| Overlay snapshot | Может добавить `/overlay/upper` |
| ROM snapshot | Может добавить снимок `/rom` |
| Firmware image | Может положить в архив готовый `sysupgrade.bin` |
| Raw MTD dump | Может сохранить `/dev/mtd*`, если архив пишется на USB/диск |
| Архивы в веб-панели | Скачать, загрузить, посмотреть и удалить архив |
| Восстановление | Отдельные галочки для настроек, пакетов, overlay и firmware |
| Виджеты роутера | Показывает разделы памяти, свободное место и температуру |

## Как выглядит сценарий работы

1. Открываешь `Службы -> OpenWrt Full Backup`.
2. Выбираешь папку для архива, лучше USB или диск: `/mnt/usb`.
3. Нажимаешь `Создать бэкап`.
4. На странице виден журнал выполнения и таймер.
5. После завершения архив появляется в списке.
6. Архив можно скачать, удалить, загрузить обратно или восстановить.

## Безопасное место для архива

`/tmp` в OpenWrt обычно находится в RAM. Для маленького бэкапа настроек этого может хватить, но для больших архивов лучше сразу использовать USB/диск.

Рекомендуемый путь:

```text
/mnt/usb
```

> [!WARNING]
> Raw MTD dump может быть очень большим и привязан к конкретной модели роутера. Модуль не дает сохранять raw MTD в `/tmp`, чтобы не забить RAM и не получить `No space left on device`.

## CLI-команды

Создать бэкап на USB:

```sh
owrt-full-backup create -o /mnt/usb
```

Добавить firmware image:

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

## Что ставится на роутер

| Путь | Назначение |
| --- | --- |
| `/usr/sbin/owrt-full-backup` | Основная CLI-команда |
| `/usr/sbin/owrt-full-backup-upload` | Потоковая загрузка `.tar.gz` из браузера без Lua |
| `/www/cgi-bin/owrt-full-backup` | Основная веб-панель |
| `/www/luci-static/resources/view/owrt_full_backup.js` | LuCI-страница-редирект без Lua runtime |
| `/usr/share/luci/menu.d/luci-app-owrt-full-backup.json` | Пункт меню LuCI |
| `/usr/share/rpcd/acl.d/luci-app-owrt-full-backup.json` | ACL-доступ LuCI к приватному ключу |
| `/etc/config/fullbackup` | Настройки по умолчанию |
| `/etc/owrt-full-backup/web.key` | Приватный ключ веб-панели |

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

## Обновление

Принудительно поставить свежую версию с GitHub:

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
```

Скрипт обновляет файлы, удаляет старый Lua-controller, чистит кэш LuCI и перезапускает `rpcd/uhttpd`.

## Удаление

Удалить модуль, но оставить конфиг и веб-ключ:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/uninstall.sh | sh
```

Удалить модуль, конфиг и веб-ключ:

```sh
wget -O - https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/uninstall.sh | PURGE=1 sh
```

Архивы бэкапов при удалении не стираются.

## Диагностика

<details>
<summary>Пункт не появился в LuCI</summary>

Обнови модуль и перезапусти кэш LuCI:

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache /tmp/luci-indexcache.* /tmp/luci-modulecache.*
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
```

Потом обнови страницу LuCI или выйди и зайди снова.

</details>

<details>
<summary>В LuCI ошибка `No Lua runtime installed`</summary>

Поставь свежую версию. Модуль больше не использует Lua-controller для пункта меню LuCI.

```sh
wget -O - "https://raw.githubusercontent.com/kzolotarev95/luci-app-owrt-full-backup/main/install.sh?v=$(date +%s)" | sh
```

Проверка:

```sh
test ! -e /usr/lib/lua/luci/controller/owrt_full_backup.lua && echo "Lua controller удален"
```

</details>

<details>
<summary>Ошибка `No space left on device`</summary>

Архив создается в `/tmp`, а там закончилась RAM. Используй USB/диск:

```sh
mkdir -p /mnt/usb
owrt-full-backup create -o /mnt/usb
```

В веб-панели тоже укажи `/mnt/usb`.

</details>

<details>
<summary>Браузер пишет `ERR_CONNECTION_RESET` при загрузке архива</summary>

Обнови модуль. Загрузка архива идет потоково и не держит весь `.tar.gz` в памяти.

Если ошибка осталась, проверь свободное место в папке архива и используй USB/диск:

```text
/mnt/usb
```

</details>

## Автор

Проект: `luci-app-owrt-full-backup`

Автор: [byzks95 / kzolotarev95](https://github.com/kzolotarev95)

Связь: [Telegram](https://t.me/kzolotarev95)
