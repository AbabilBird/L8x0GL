#!/bin/sh
. /usr/share/l8x0gl/lib.sh

setup_network() {
	local iface apn user pass auth iptype dev
	iface="$(uci_get global interface l8x0gl)"
	apn="$(uci_get global apn internet)"
	user="$(uci_get global username '')"
	pass="$(uci_get global password '')"
	auth="$(uci_get global auth none)"
	iptype="$(uci_get global iptype ipv4v6)"
	dev="$(state_get mbim_device 2>/dev/null)" || dev=""
	[ -n "$dev" ] || { /usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || true; dev="$(state_get mbim_device 2>/dev/null)" || dev=""; }
	[ -n "$dev" ] || { say "cannot setup network: MBIM device not found"; return 1; }

	uci -q batch <<EOT
set network.$iface=interface
set network.$iface.proto='mbim'
set network.$iface.device='$dev'
set network.$iface.apn='$apn'
set network.$iface.auth='$auth'
set network.$iface.pdptype='$iptype'
EOT
	[ -n "$user" ] && uci set network.$iface.username="$user" || uci -q delete network.$iface.username
	[ -n "$pass" ] && uci set network.$iface.password="$pass" || uci -q delete network.$iface.password
	uci commit network
	say "network.$iface configured for MBIM device $dev"
}

ifup_l8x0gl() {
	local iface
	iface="$(uci_get global interface l8x0gl)"
	ifup "$iface"
}

ifdown_l8x0gl() {
	local iface
	iface="$(uci_get global interface l8x0gl)"
	ifdown "$iface"
}

