#!/bin/sh
. /usr/share/l8x0gl/lib.sh

at_port_auto() {
	local p
	p="$(state_get at_port 2>/dev/null)" || p=""
	[ -n "$p" ] && [ -e "$p" ] && { printf '%s\n' "$p"; return 0; }
	/usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || true
	state_get at_port 2>/dev/null
}

send_at() {
	local port="$1"
	local cmd="$2"
	[ -e "$port" ] || return 1
	printf '%s\r\n' "$cmd" > "$port"
	# Minimal placeholder: OpenWrt images should use atinout/microcom/ubus-at if added later.
	return 0
}

get_usb_mode() {
	local port
	port="$(at_port_auto)" || return 1
	say "AT mode query requested on $port; interactive AT reader not enabled in first backend skeleton"
	return 0
}

set_mbim_mode() {
	local port
	port="$(at_port_auto)" || { say "no AT port found"; return 1; }
	say "setting Fibocom Intel USB mode to MBIM on $port"
	send_at "$port" 'AT+GTUSBMODE=7' || return 1
	sleep 1
	send_at "$port" 'AT+CFUN=15' || true
}
