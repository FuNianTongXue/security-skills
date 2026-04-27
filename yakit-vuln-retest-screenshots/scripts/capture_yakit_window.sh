#!/bin/zsh
set -euo pipefail

OUT_PATH="${1:?output png path required}"

WINDOW_INFO="$(osascript -e 'tell application "System Events" to tell process "Yakit" to get {position, size} of front window')"
X="$(printf '%s' "$WINDOW_INFO" | awk -F, '{gsub(/ /,"",$1); print $1}')"
Y="$(printf '%s' "$WINDOW_INFO" | awk -F, '{gsub(/ /,"",$2); print $2}')"
W="$(printf '%s' "$WINDOW_INFO" | awk -F, '{gsub(/ /,"",$3); print $3}')"
H="$(printf '%s' "$WINDOW_INFO" | awk -F, '{gsub(/ /,"",$4); print $4}')"

screencapture -x -R${X},${Y},${W},${H} "$OUT_PATH"
