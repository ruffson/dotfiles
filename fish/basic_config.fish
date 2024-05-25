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
abbr -a ls lsd
abbr -a l lsd -l
abbr -a ll lsd -l
abbr -a ip ip -c
abbr -a grep rg
# <<< ALIASES <<<

# >>> Exports >>>
set -gx VISUAL "nvim"
set -gx EDITOR "nvim"
set -gx FZF_DEFAULT_COMMAND "fd --type f"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
# fish_add_path "$HOME/Applications/mambaforge/bin"
# <<< Exports <<<
zoxide init fish | source
