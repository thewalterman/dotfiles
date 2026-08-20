function devops --description 'Attach to (or create) a zellij devops session named after the current directory, or plain-attach to a given session name'
    if set -q ZELLIJ
        echo "Already inside zellij (session: $ZELLIJ_SESSION_NAME)"
        return 1
    end

    if set -q argv[1]
        zellij attach --force-run-commands $argv[1]
    else
        bash ~/.config/zellij/devops.sh (basename $PWD) $PWD
    end
end
