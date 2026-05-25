# SPDX-License-Identifier: AGPL-3.0-only

include $(TOPDIR)/rules.mk

include ../version.mk

PKG_NAME:=lpac-mbim
PKG_VERSION:=2.3.0
PKG_RELEASE:=$(L8X0GL_RELEASE)

PKG_SOURCE:=lpac-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/estkme-group/lpac/tar.gz/refs/tags/v$(PKG_VERSION)?
PKG_HASH:=661dffbd1e9e5732dab4a0bb0a9837d4906c8c66bd748bda262fe3e8d3e420f6
PKG_BUILD_DIR:=$(BUILD_DIR)/lpac-$(PKG_VERSION)

PKG_MAINTAINER:=AbabilBird
PKG_LICENSE:=AGPL-3.0-only LGPL-2.1-only
PKG_LICENSE_FILES:=LICENSES/AGPL-3.0-only.txt LICENSES/LGPL-2.1-only.txt

CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/lpac-mbim
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Patched lpac for MBIM removable eSIM on L8x0GL
  DEPENDS:=+libcurl +jq +libmbim +LPAC_MBIM_ENABLE_PCSC:libpcsclite +LPAC_MBIM_ENABLE_PCSC:pcscd
  URL:=https://github.com/estkme-group/lpac
endef

define Package/lpac-mbim/description
  lpac eUICC/eSIM manager built with MBIM backend and patches for
  Fibocom L850-GL/L860-GL removable eSIM operation via MBIM Low-Level
  UICC Access. The wrapper defaults to mbim-proxy to avoid conflicts
  with an active MBIM internet connection.
endef

define Package/lpac-mbim/config
  source "$(SOURCE)/Config.in"
endef

define Package/lpac-mbim/conffiles
/etc/config/lpac
endef

TARGET_CFLAGS += $(FPIC)

CMAKE_OPTIONS += \
  -DLPAC_WITH_APDU_PCSC=$(if $(CONFIG_LPAC_MBIM_ENABLE_PCSC),ON,OFF) \
  -DLPAC_WITH_APDU_AT=$(if $(CONFIG_LPAC_MBIM_ENABLE_AT),ON,OFF) \
  -DLPAC_WITH_APDU_UQMI=$(if $(CONFIG_LPAC_MBIM_ENABLE_UQMI),ON,OFF) \
  -DLPAC_WITH_APDU_MBIM=$(if $(CONFIG_LPAC_MBIM_ENABLE_MBIM),ON,OFF) \
  -DLPAC_WITH_APDU_QMI_QRTR=OFF

define Package/lpac-mbim/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/lpac-mbim $(1)/usr/bin/lpac-mbim
	$(LN) lpac-mbim $(1)/usr/bin/lpac

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/lpac $(1)/etc/config/lpac

	$(INSTALL_DIR) $(1)/usr/lib/lpac-mbim
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/lpac $(1)/usr/lib/lpac-mbim/lpac
endef

$(eval $(call BuildPackage,lpac-mbim))
