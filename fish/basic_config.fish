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
abbr -a sb bass source /home/raph/dev/bright/iroc/src/brightai/ros2_ws/install/setup.sh
alias bat="batcat"
alias fd="fdfind"

# <<< ALIASES <<<

# >>> Exports >>>
set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND "fd --type f"
set -gx MANPAGER "sh -c 'col -bx | batcat -l man -p'"
set -gx MANROFFOPT -c
set -g hydro_multiline true
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
set -gx INFLUX_TOKEN "o9Wmge1ri34RfPVSw5W_S7drPsAcLE7uah7ysXR0XEjVu5RW4uEqmBLZtBqmMQaPz1YW1yGkYkgvIwImuY3mTA=="

# TODO: Make this conditional or put in a fn
# bass source /usr/lib64/ros2-humble/setup.bash

zoxide init fish | source
