include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-full-backup
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKGARCH:=all
PKG_LICENSE:=MIT
PKG_MAINTAINER:=K. Zolotarev

include $(INCLUDE_DIR)/package.mk

define Package/openwrt-full-backup
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Full backup and restore helper for OpenWrt
endef

define Package/openwrt-full-backup/description
Creates a portable backup archive with sysupgrade config backup, installed
package list, OpenWrt metadata, optional overlay snapshot, optional ROM rootfs
snapshot, optional firmware image copy, and optional raw MTD dumps. Includes
guarded restore helpers for OpenWrt 22.x through 25.x.
endef

define Build/Compile
endef

define Package/openwrt-full-backup/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/usr/sbin/owrt-full-backup $(1)/usr/sbin/owrt-full-backup
	$(LN) owrt-full-backup $(1)/usr/sbin/owrt-backup
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/fullbackup $(1)/etc/config/fullbackup
endef

$(eval $(call BuildPackage,openwrt-full-backup))
