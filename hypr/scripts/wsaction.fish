#!/usr/bin/env fish

# Map old dispatcher names to new Lua dispatch syntax
# hyprctl dispatch in 0.55+ expects Lua syntax
function dispatch_lua
    switch $argv[1]
        case 'workspace'
            echo -n "hl.dsp.focus({ workspace = $argv[2] })"
        case 'movetoworkspace'
            echo -n "hl.dsp.window.move({ workspace = $argv[2] })"
        case '*'
            echo "Unknown dispatcher: $argv[1]" >&2
            exit 1
    end
end

if test "$argv[1]" = '-g'
    set group
    set -e argv[1]
end

if test (count $argv) -ne 2
    echo 'Wrong number of arguments. Usage: ./wsaction.fish [-g] <dispatcher> <workspace>'
    exit 1
end

set -l active_ws (hyprctl activeworkspace -j | jq -r '.id')

if set -q group
    # Move to group
    set -l target_ws (math "($argv[2] - 1) * 10 + $active_ws % 10")
    hyprctl dispatch "$(dispatch_lua $argv[1] $target_ws)"
else
    # Move to ws in group
    set -l target_ws (math "floor(($active_ws - 1) / 10) * 10 + $argv[2]")
    hyprctl dispatch "$(dispatch_lua $argv[1] $target_ws)"
end
