# L8x0GL

OpenWrt/ImmortalWrt package feed for Fibocom L850-GL/L860-GL in USB MBIM mode.

This repo is intentionally smaller than QModem. It takes the useful ideas for
L850-GL only: patient USB hotplug handling, MBIM auto-detect, netifd setup,
mbim-proxy coexistence, staged reconnect/recovery, and patched lpac support for
removable eSIM over MBIM.

## Packages

- `l8x0gl-mbim`: backend manager for Fibocom L850-GL/L860-GL MBIM.
- `lpac-mbim`: patched lpac 2.3.0 package with MBIM removable eSIM fixes. It installs `/usr/bin/lpac-mbim` and a compatibility symlink `/usr/bin/lpac`.
- `luci-app-l8x0gl`: modern LuCI JavaScript GUI for status, config, eSIM and logs.

## Design goals

- Target OpenWrt 24.10 and newer snapshots/25.x.
- MBIM-only internet path.
- Do not assume `/dev/cdc-wdm0`, `/dev/wwan0`, or a fixed AT port.
- Start `mbim-proxy` early so lpac and MBIM tools do not fight over the same
  `/dev/cdc-wdmX` control device.
- Keep non-disruptive eSIM operations such as chip info, profile list, download,
  and delete profile usable while internet is online.
- For enable/switch profile, reconnect/check the MBIM interface only if needed.

## Build example

Add this repository as a feed or copy the package directories into your OpenWrt
package tree, then run:

```sh
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make package/l8x0gl-mbim/compile V=s
make package/lpac-mbim/compile V=s
make package/luci-app-l8x0gl/compile V=s
```

## Runtime commands

```sh
/etc/init.d/l8x0gl-mbim-proxy enable
/etc/init.d/l8x0gl enable
/etc/init.d/l8x0gl start
l8x0glctl status
l8x0glctl detect
l8x0glctl setup-network
l8x0glctl reconnect
l8x0glctl esim chip info
l8x0glctl esim profile list
lpac-mbim chip info
lpac profile list
```

## Notes

This is the first backend skeleton. LuCI is intentionally not included yet so the
modem manager and lpac coexistence can be reviewed and tested first.
