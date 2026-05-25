#!/bin/sh
. /usr/share/l8x0gl/lib.sh
. /usr/share/l8x0gl/netifd.sh

ensure_proxy() {
	/etc/init.d/l8x0gl-mbim-proxy enabled >/dev/null 2>&1 && /etc/init.d/l8x0gl-mbim-proxy start >/dev/null 2>&1 || true
}

lpac_run() {
	local bin op
	bin="$(uci_get esim lpac_bin /usr/bin/lpac-mbim)"
	op="$1"
	shift
	[ -x "$bin" ] || { say "lpac binary wrapper not found: $bin"; return 1; }
	/usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || true
	ensure_proxy
	LPAC_APDU_MBIM_DEVICE="$(state_get mbim_device 2>/dev/null)" \
	LPAC_APDU_MBIM_USE_PROXY=1 \
	LPAC_APDU_MBIM_SKIP_SLOT_MAPPING=1 \
	"$bin" "$op" "$@"
}

lpac_switch() {
	local rc
	lpac_run "$@"
	rc=$?
	say "eSIM switch/enable operation finished, checking MBIM interface"
	sleep 5
	ifup_l8x0gl || true
	return "$rc"
}
