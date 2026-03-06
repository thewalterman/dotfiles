function fvim
    set file (fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}")
    if test -n "$file"
        nvim "$file"
    end
end
