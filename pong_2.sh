#!/bin/sh
echo -ne '\033c\033]0;pong_2\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/pong_2.x86_64" "$@"
