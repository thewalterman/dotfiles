function fkube
    if test -z "$argv[1]"
        echo "Use: fkube <file>"
        return 1
    end

    set -l dir $HOME/.kube/kubeconfig

    if not test -d $dir
        echo "Directory $dir not found"
        return 1
    end

    set -l files (ls $dir)

    if test (count $files) -eq 0
        echo "No kubeconfig found in $dir"
        return 1
    end

    set -l file $dir/$argv[1]

    if not test -f $file
        echo "File '$argv[1]' not found in $dir"
        return 1
    end

    k9s --kubeconfig=$file
end

# Autocomplete
function __fish_complete_fkube
    set -l dir $HOME/.kube/kubeconfig
    set -l files (ls $dir)
    for file in $files
        echo $file
    end
end

complete -f -c fkube -a "(__fish_complete_fkube)"
