#!/bin/sh

L8X0GL_TAG="l8x0gl"
L8X0GL_STATE_DIR="/var/run/l8x0gl"
L8X0GL_STATE_FILE="$L8X0GL_STATE_DIR/state"
L8X0GL_LOCK="/var/lock/l8x0gl.lock"

log() {
	logger -t "$L8X0GL_TAG" "$*"
}

say() {
	echo "$*"
	log "$*"
}

uci_get() {
	local section="$1"
	local option="$2"
	local default="$3"
	local value
	value="$(uci -q get "l8x0gl.$section.$option" 2>/dev/null)" || value=""
	[ -n "$value" ] && printf '%s\n' "$value" || printf '%s\n' "$default"
}

ensure_state_dir() {
	[ -d "$L8X0GL_STATE_DIR" ] || mkdir -p "$L8X0GL_STATE_DIR"
}

state_set() {
	ensure_state_dir
	printf '%s=%s\n' "$1" "$2" >> "$L8X0GL_STATE_FILE.tmp"
}

state_reset() {
	ensure_state_dir
	: > "$L8X0GL_STATE_FILE.tmp"
}

state_commit() {
	ensure_state_dir
	mv "$L8X0GL_STATE_FILE.tmp" "$L8X0GL_STATE_FILE"
}

state_get() {
	local key="$1"
	[ -f "$L8X0GL_STATE_FILE" ] || return 1
	grep "^${key}=" "$L8X0GL_STATE_FILE" | tail -n 1 | cut -d= -f2-
}

with_lock() {
	local lockdir="${1:-$L8X0GL_LOCK}"
	shift
	local i=0
	while ! mkdir "$lockdir" 2>/dev/null; do
		i=$((i + 1))
		[ "$i" -gt 30 ] && return 1
		sleep 1
	done
	trap 'rmdir "$lockdir" 2>/dev/null' EXIT INT TERM
	"$@"
	local rc=$?
	rmdir "$lockdir" 2>/dev/null || true
	trap - EXIT INT TERM
	return "$rc"
}

has_cmd() {
	command -v "$1" >/dev/null 2>&1
}

run_timeout() {
	local seconds="$1"
	shift
	if has_cmd timeout; then
		timeout "$seconds" "$@"
	else
		"$@"
	fi
}
