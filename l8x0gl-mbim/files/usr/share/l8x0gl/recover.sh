#!/bin/sh
. /usr/share/l8x0gl/lib.sh
. /usr/share/l8x0gl/netifd.sh

recover_soft() {
	say "soft recovery: ifdown/ifup L8x0GL interface"
	ifdown_l8x0gl || true
	sleep 2
	ifup_l8x0gl || true
}

recover_mbim() {
	say "mbim recovery: reconnecting netifd interface"
	recover_soft
}

recover_hard() {
	local allow
	allow="$(uci_get global allow_hard_reset 0)"
	[ "$allow" = "1" ] || { say "hard reset skipped by config"; return 1; }
	say "hard reset is allowed but not implemented in first safe backend"
	return 1
}
