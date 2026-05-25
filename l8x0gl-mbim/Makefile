include $(TOPDIR)/rules.mk

include ../version.mk

PKG_NAME:=l8x0gl-mbim
PKG_VERSION:=$(L8X0GL_VERSION)
PKG_RELEASE:=$(L8X0GL_RELEASE)
PKG_LICENSE:=GPL-3.0-or-later
PKG_MAINTAINER:=AbabilBird

include $(INCLUDE_DIR)/package.mk

define Package/l8x0gl-mbim
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Fibocom L850-GL/L860-GL MBIM manager
  PKGARCH:=all
  DEPENDS:=+kmod-usb-wdm +kmod-usb-acm +kmod-usb-net-cdc-mbim +umbim +libmbim +libmbim-utils +jsonfilter +lpac-mbim
endef

define Package/l8x0gl-mbim/description
  Lightweight OpenWrt MBIM manager for Fibocom L850-GL/L860-GL.
  It handles USB re-enumeration, MBIM device discovery, netifd setup,
  mbim-proxy coexistence, eSIM/lpac coordination, and staged recovery.
endef

define Package/l8x0gl-mbim/conffiles
/etc/config/l8x0gl
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/l8x0gl-mbim/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,l8x0gl-mbim))
