#!/bin/sh
. /usr/share/l8x0gl/lib.sh

/usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || true
printf 'enabled=%s\n' "$(uci_get global enabled 1)"
printf 'interface=%s\n' "$(uci_get global interface l8x0gl)"
printf 'mode=%s\n' "$(state_get mode 2>/dev/null)"
printf 'mbim_device=%s\n' "$(state_get mbim_device 2>/dev/null)"
printf 'data_interface=%s\n' "$(state_get data_interface 2>/dev/null)"
printf 'at_port=%s\n' "$(state_get at_port 2>/dev/null)"
printf 'mbim_proxy_pid=%s\n' "$(pidof mbim-proxy 2>/dev/null)"
