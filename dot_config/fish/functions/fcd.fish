function fcd
    set dir (fdfind . "$HOME" -t d | fzf --preview "eza --icons --color always -hal {}")
    if test -n "$dir"
        cd "$dir"
    end
end
