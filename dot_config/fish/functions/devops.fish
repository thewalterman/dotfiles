function devops --description 'Open devops tmux layout for the current dir (if KUBECONFIG is set), else attach to the last session'
    if set -q TMUX
        echo "Already inside tmux (session: "(tmux display-message -p '#S')")"
        return 1
    end

    if set -q KUBECONFIG
        set -l name (basename $PWD)
        bash ~/.config/tmux/devops.sh "$name" "$PWD"
    else
        if tmux list-sessions >/dev/null 2>&1
            exec tmux attach
        else
            bash ~/.config/tmux/devops.sh
        end
    end
end
