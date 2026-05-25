#!/bin/sh
. /usr/share/l8x0gl/lib.sh

is_l8x0gl_vidpid() {
	case "$1:$2" in
		2cb7:0007|8087:095a) return 0 ;;
	esac
	return 1
}

find_mbim_device() {
	local dev base uevent vid pid
	for dev in /dev/cdc-wdm*; do
		[ -e "$dev" ] || continue
		base="$(basename "$dev")"
		uevent="$(find /sys/bus/usb/devices -path "*/usbmisc/$base/uevent" 2>/dev/null | head -n 1)"
		[ -n "$uevent" ] || { printf '%s\n' "$dev"; return 0; }
		vid="$(sed -n 's/^PRODUCT=\([0-9a-fA-F]*\)\/.*/\1/p' "$uevent" | head -n 1)"
		pid="$(sed -n 's/^PRODUCT=[0-9a-fA-F]*\/\([0-9a-fA-F]*\)\/.*/\1/p' "$uevent" | head -n 1)"
		[ -n "$vid" ] && [ -n "$pid" ] && is_l8x0gl_vidpid "$vid" "$pid" && { printf '%s\n' "$dev"; return 0; }
	done
	return 1
}

find_data_interface() {
	local iface
	for iface in /sys/class/net/wwan* /sys/class/net/usb*; do
		[ -e "$iface" ] || continue
		printf '%s\n' "$(basename "$iface")"
		return 0
	done
	return 1
}

find_at_port() {
	local tty
	for tty in /dev/ttyACM0 /dev/ttyACM2 /dev/ttyUSB2 /dev/ttyUSB3; do
		[ -e "$tty" ] && { printf '%s\n' "$tty"; return 0; }
	done
	return 1
}

detect_main() {
	local mbim data at mode
	mbim="$(find_mbim_device 2>/dev/null)" || mbim=""
	data="$(find_data_interface 2>/dev/null)" || data=""
	at="$(find_at_port 2>/dev/null)" || at=""
	[ -n "$mbim" ] && mode="mbim" || mode="unknown"
	state_reset
	state_set mode "$mode"
	state_set mbim_device "$mbim"
	state_set data_interface "$data"
	state_set at_port "$at"
	state_commit
	printf 'mode=%s\nmbim_device=%s\ndata_interface=%s\nat_port=%s\n' "$mode" "$mbim" "$data" "$at"
	[ -n "$mbim" ]
}

detect_main "$@"
