# >>> Start TMUX on login >>>
if status is-interactive
    and not set -q TMUX
    and not pstree -s %self | grep -q code
    exec tmux
end
# <<< Start TMUX on login <<<

# >>> ALIASES >>>
abbr -a g git
abbr -a vim nvim
abbr -a grep rg
abbr -a cat bat
abbr -a ls lsd
abbr -a l lsd -l
abbr -a ll lsd -l
abbr -a ip ip -c
abbr -a sage micromamba run -n sage sage
abbr -a sr bass source /usr/lib64/ros2-humble/setup.bash
# <<< ALIASES <<<

# >>> Exports >>>
set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND "fd --type f"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
# fish_add_path "$HOME/Applications/mambaforge/bin"
# <<< Exports <<<

function prime-run
    set -x ___NV_PRIME_RENDER_OFFLOAD 1
    set -x __GLX_VENDOR_LIBRARY_NAME nvidia
    command $argv
end
funcsave prime-run >/dev/null

set -gx DBX_CONTAINER_MANAGER docker

# TODO: Make this conditional or put in a fn
bass source /usr/lib64/ros2-humble/setup.bash

zoxide init fish | source
