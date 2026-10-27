#!/bin/sh
# Navigate only the tags assigned to the focused monitor.
# Usage: workspace-step.sh view|tag -1|1
action=${1:-view}
step=${2:-1}

state=$(mmsg get all-monitors) || exit 1
monitor=$(printf '%s' "$state" | jq -r '.monitors[] | select(.active) | .name')
current=$(printf '%s' "$state" | jq -r '.monitors[] | select(.active) | .active_tags[0] // empty')

case "$monitor" in
    DP-1) tags="1 3 5 7 9" ;;
    DP-2) tags="2 4 6 8" ;;
    *) exit 1 ;;
esac

set -- $tags
count=$#
index=1
i=1
for tag do
    if [ "$tag" = "$current" ]; then
        index=$i
        break
    fi
    i=$((i + 1))
done

index=$((index + step))
[ "$index" -lt 1 ] && index=$count
[ "$index" -gt "$count" ] && index=1
eval "target=\${$index}"

case "$action" in
    view) mmsg dispatch "viewcrossmon,$target,$monitor" ;;
    tag)  mmsg dispatch "tagcrossmon,$target,$monitor" ;;
    *) exit 2 ;;
esac
