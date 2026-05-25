include $(TOPDIR)/rules.mk

include ../version.mk

LUCI_TITLE:=LuCI support for Fibocom L8x0GL MBIM manager
LUCI_DEPENDS:=+l8x0gl-mbim +luci-base
LUCI_PKGARCH:=all
PKG_VERSION:=$(L8X0GL_VERSION)
PKG_RELEASE:=$(L8X0GL_RELEASE)
PKG_LICENSE:=GPL-3.0-or-later
PKG_MAINTAINER:=AbabilBird

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
