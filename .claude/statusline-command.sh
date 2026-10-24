#!/usr/bin/env bash
# Status line: model name + context usage progress bar
# Parses the JSON input with sed/grep so it works without jq installed.
input=$(cat)
model=$(printf '%s' "$input" | grep -o '"display_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:[[:space:]]*"\([^"]*\)"/\1/')
pct=$(printf '%s' "$input" | grep -o '"used_percentage"[[:space:]]*:[[:space:]]*[0-9.]*' | head -1 | sed 's/.*:[[:space:]]*//')
model=${model:-Unknown}
pct=$(printf '%.0f' "${pct:-0}")
[ "$pct" -gt 100 ] && pct=100
width=10
filled=$((pct * width / 100))
empty=$((width - filled))
bar=""
for ((i = 0; i < filled; i++)); do bar+="█"; done
for ((i = 0; i < empty; i++)); do bar+="░"; done
if [ "$pct" -ge 80 ]; then color="31"; elif [ "$pct" -ge 50 ]; then color="33"; else color="32"; fi
printf '\033[36m%s\033[0m | Context: \033[%sm%s\033[0m %s%%' "$model" "$color" "$bar" "$pct"
