#!/bin/sh
. /usr/share/l8x0gl/lib.sh
. /usr/share/l8x0gl/recover.sh

iface_has_ip() {
	local iface
	iface="$(uci_get global interface l8x0gl)"
	ip -4 addr show dev "$iface" 2>/dev/null | grep -q 'inet '
}

monitor_once() {
	/usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || { say "monitor: modem not ready"; return 1; }
	iface_has_ip && return 0
	say "monitor: interface has no IPv4 address, triggering soft recovery"
	recover_soft
}

monitor_loop() {
	local interval
	interval="$(uci_get global monitor_interval 15)"
	while true; do
		monitor_once || true
		sleep "$interval"
	done
}

case "$1" in
	once) monitor_once ;;
	*) monitor_loop ;;
esac
