#!/usr/bin/env bash

set -e

usage() {
	cat <<'USAGE'
usage: argos [-r|--refresh] [-h|--help]

Pick an ArgoCD app with fzf and sync it (with --prune).

The app list is cached per ArgoCD context; by default the cache is used
when present, so the picker opens instantly.

  -r, --refresh   ignore the cache and fetch the app list from ArgoCD
USAGE
}

refresh=0
while [ $# -gt 0 ]; do
	case "$1" in
	-r | --refresh)
		refresh=1
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "argos: unknown argument: $1" >&2
		usage >&2
		exit 1
		;;
	esac
done

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/argos"
context=$(argocd context 2>/dev/null | awk '$1 == "*" { print $2 }')
cache_file="$cache_dir/apps-$(printf '%s' "${context:-default}" | tr -c '[:alnum:]._-' '_')"

fetch_apps() {
	mkdir -p "$cache_dir"
	argocd app list | tail -n +2 | awk '{print $1}' >"$cache_file.tmp"
	mv "$cache_file.tmp" "$cache_file"
}

if [ "$refresh" -eq 1 ] || [ ! -s "$cache_file" ]; then
	fetch_apps
fi

app=$(fzf --prompt="app> " <"$cache_file")

argocd app sync --prune "$app"
