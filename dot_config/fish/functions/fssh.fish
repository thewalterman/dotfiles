function fssh
    if test -z "$argv[1]"
        echo "Use: fssh <host>"
        return 1
    end

    set -l hosts (awk '/^Host / {print $2}' $HOME/.ssh/config)

    if not contains $argv[1] $hosts
        echo "Host not found in $HOME/.ssh/config"
        return 1
    end
    set host $argv[1]
    if pass show "ssh/$host" >/dev/null 2>&1
        set password (pass show "ssh/$host")
        sshpass -p "$password" ssh $host
    else
        ssh $host
    end
end

# Abilitare l'autocompletamento
function __fish_complete_fssh
    set -l hosts (awk '/^Host / {print $2}' $HOME/.ssh/config)
    for host in $hosts
        echo $host
    end
end

complete -f -c fssh -a "(__fish_complete_fssh)"
