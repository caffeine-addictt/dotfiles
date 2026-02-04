function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    alias pamcan pacman
    if test -f ~/.profile
        bass source ~/.profile
    end

    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'

    eval "$(fzf --fish)"
    eval "$(zoxide init --cmd cd fish)"

    function __ctrl_c_like_enter
        if test (commandline | string length) -eq 0
            commandline -f execute
        else
            commandline -f cancel-commandline
        end
    end
    bind \cC __ctrl_c_like_enter
end
