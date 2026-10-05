#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "?"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '(.context_window.current_usage // {}) | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0))')
size=$(echo "$input" | jq -r '(.context_window.context_window_size // 0)')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
sess=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

fmt() { awk -v n="$1" 'BEGIN{ if(n>=1000000) printf "%.1fM", n/1000000; else if(n>=1000) printf "%.0fk", n/1000; else printf "%d", n }'; }

out=$(printf '\033[36m%s' "$model")
[ -n "$effort" ] && out="$out [$effort]"
out="$out\033[0m"
out="$out  $(printf '\033[33mcontext %s/%s (%.0f%%)\033[0m' "$(fmt "$used")" "$(fmt "$size")" "$pct")"
[ -n "$sess" ] && out="$out  $(printf '\033[35msession %.0f%%\033[0m' "$sess")"
printf '%b\n' "$out"
