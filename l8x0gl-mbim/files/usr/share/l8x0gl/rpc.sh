#!/bin/sh
. /usr/share/l8x0gl/lib.sh

json_escape() {
	printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g'
}

json_kv() {
	printf '"%s":"%s"' "$1" "$(json_escape "$2")"
}

status_json() {
	/usr/share/l8x0gl/detect.sh >/dev/null 2>&1 || true
	local iface ipv4 route proxy_pid lpac_ok
	iface="$(uci_get global interface l8x0gl)"
	ipv4="$(ip -4 addr show dev "$iface" 2>/dev/null | sed -n 's/.*inet \([^ ]*\).*/\1/p' | head -n 1)"
	route="$(ip route show default 2>/dev/null | head -n 1)"
	proxy_pid="$(pidof mbim-proxy 2>/dev/null)"
	[ -x /usr/bin/lpac-mbim ] && lpac_ok=1 || lpac_ok=0
	printf '{'
	json_kv enabled "$(uci_get global enabled 1)"; printf ','
	json_kv interface "$iface"; printf ','
	json_kv mode "$(state_get mode 2>/dev/null)"; printf ','
	json_kv mbim_device "$(state_get mbim_device 2>/dev/null)"; printf ','
	json_kv data_interface "$(state_get data_interface 2>/dev/null)"; printf ','
	json_kv at_port "$(state_get at_port 2>/dev/null)"; printf ','
	json_kv ipv4 "$ipv4"; printf ','
	json_kv default_route "$route"; printf ','
	json_kv mbim_proxy_pid "$proxy_pid"; printf ','
	json_kv lpac_mibm_available "$lpac_ok"
	printf '}\n'
}

config_json() {
	printf '{'
	json_kv enabled "$(uci_get global enabled 1)"; printf ','
	json_kv interface "$(uci_get global interface l8x0gl)"; printf ','
	json_kv apn "$(uci_get global apn internet)"; printf ','
	json_kv username "$(uci_get global username '')"; printf ','
	json_kv auth "$(uci_get global auth none)"; printf ','
	json_kv iptype "$(uci_get global iptype ipv4v6)"; printf ','
	json_kv auto_connect "$(uci_get global auto_connect 1)"; printf ','
	json_kv monitor_interval "$(uci_get global monitor_interval 15)"; printf ','
	json_kv boot_debounce "$(uci_get global boot_debounce 12)"; printf ','
	json_kv allow_hard_reset "$(uci_get global allow_hard_reset 0)"; printf ','
	json_kv use_proxy "$(uci_get mbim use_proxy 1)"; printf ','
	json_kv esim_enabled "$(uci_get esim enabled 1)"; printf ','
	json_kv reconnect_on_switch "$(uci_get esim reconnect_on_switch auto)"
	printf '}\n'
}

set_config() {
	local key value
	while [ "$#" -gt 1 ]; do
		key="$1"; value="$2"; shift 2
		case "$key" in
			enabled|interface|apn|username|password|auth|iptype|auto_connect|monitor_interval|boot_debounce|allow_hard_reset)
				uci set "l8x0gl.global.$key=$value"
				;;
			use_proxy)
				uci set "l8x0gl.mbim.use_proxy=$value"
				;;
			esim_enabled)
				uci set "l8x0gl.esim.enabled=$value"
				;;
			reconnect_on_switch)
				uci set "l8x0gl.esim.reconnect_on_switch=$value"
				;;
			esac
	done
	uci commit l8x0gl
	printf '{"ok":true}\n'
}

logs_json() {
	local lines
	lines="$(logread 2>/dev/null | grep -E 'l8x0gl|mbim-proxy|lpac' | tail -n 80 | sed 's/\\/\\\\/g; s/"/\\"/g')"
	printf '{"log":"'
	printf '%s' "$lines" | awk '{printf "%s\\n", $0}'
	printf '"}\n'
}

run_action() {
	case "$1" in
		detect) /usr/sbin/l8x0glctl detect >/tmp/l8x0gl.rpc.out 2>&1 ;;
		setup-network) /usr/sbin/l8x0glctl setup-network >/tmp/l8x0gl.rpc.out 2>&1 ;;
		connect) /usr/sbin/l8x0glctl connect >/tmp/l8x0gl.rpc.out 2>&1 ;;
		disconnect) /usr/sbin/l8x0glctl disconnect >/tmp/l8x0gl.rpc.out 2>&1 ;;
		reconnect) /usr/sbin/l8x0glctl reconnect >/tmp/l8x0gl.rpc.out 2>&1 ;;
		monitor-once) /usr/sbin/l8x0glctl monitor-once >/tmp/l8x0gl.rpc.out 2>&1 ;;
		*) printf '{"ok":false,"error":"invalid action"}\n'; return 1 ;;
	esac
	local rc="$?" out
	out="$(cat /tmp/l8x0gl.rpc.out 2>/dev/null)"
	printf '{"ok":%s,"output":"%s"}\n' "$([ "$rc" = 0 ] && echo true || echo false)" "$(json_escape "$out")"
}

esim_action() {
	local action="$1"; shift || true
	case "$action" in
		chip-info) /usr/sbin/l8x0glctl esim chip info "$@" ;;
		profile-list) /usr/sbin/l8x0glctl esim profile list "$@" ;;
		download) /usr/sbin/l8x0glctl esim profile download "$@" ;;
		delete) /usr/sbin/l8x0glctl esim profile delete "$@" ;;
		enable|switch) /usr/sbin/l8x0glctl esim-switch profile enable "$@" ;;
		disable) /usr/sbin/l8x0glctl esim-switch profile disable "$@" ;;
		*) printf 'invalid esim action\n'; return 1 ;;
	esac
}
