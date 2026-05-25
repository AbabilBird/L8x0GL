#!/bin/sh
. /usr/share/l8x0gl/lib.sh

mbim_device() {
	local dev
	dev="$(uci_get mbim device auto)"
	if [ "$dev" = "auto" ] || [ -z "$dev" ]; then
		dev="$(state_get mbim_device 2>/dev/null)" || dev=""
		[ -n "$dev" ] || { /usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || true; dev="$(state_get mbim_device 2>/dev/null)" || dev=""; }
	fi
	[ -n "$dev" ] && printf '%s\n' "$dev"
}

mbim_proxy_arg() {
	local use_proxy
	use_proxy="$(uci_get mbim use_proxy 1)"
	[ "$use_proxy" = "1" ] && printf '%s\n' '--device-open-proxy'
}

mbimcli_safe() {
	local dev proxy
	dev="$(mbim_device)" || return 1
	[ -e "$dev" ] || return 1
	proxy="$(mbim_proxy_arg)"
	mbimcli -d "$dev" $proxy "$@"
}

packet_service_status() {
	mbimcli_safe --query-packet-service-state
}

registration_status() {
	mbimcli_safe --query-registration-state
}
