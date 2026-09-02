fish_add_path $HOME/.local/bin

alias b 'cd -'
alias c clear
alias cat 'bat -pp'
alias cm chezmoi
alias d docker
alias k kubectl
alias kk 'k9s -A'
alias lg lazygit
alias lc lazydocker
alias ls 'eza --icons -1'
alias la 'eza --icons -TL2'
alias ll 'eza -hal --icons --header'
alias l nvim
alias q exit

abbr -a -- inst 'sudo apt install -y'
abbr -a -- rem 'sudo apt remove -y'
abbr -a -- rmd 'rm -rf'

abbr -a --set-cursor='%' -- gc 'git add -A && git commit -m "%"'
abbr -a --set-cursor='%' -- gp 'git add -A && git commit -m "%" && git push'

abbr -a --set-cursor='%' -- cmg 'cm git -- add -A && cm git -- commit -m "%" && cm git -- push'

abbr -a -- dl 'docker logs -f'
abbr -a -- db 'docker build -t'
abbr -a -- dr 'docker run --rm -it'
abbr -a -- de 'docker exec -it'
abbr -a -- dcu 'docker compose up -d'
abbr -a -- dcd 'docker compose down'

abbr -a -- kg 'kubectl get -n'
abbr -a -- kd 'kubectl describe -n'
abbr -a -- kl 'kubectl logs -n'
abbr -a -- ka 'kubectl apply -f'
abbr -a --set-cursor='%' -- kap 'begin echo "%" | kubectl apply -f -'
abbr -a --set-cursor='%' -- ke 'kubectl exec -it -n % -- sh'
abbr -a --set-cursor='%' -- kr 'kubectl run -it --rm --restart=Never --image=% -- sh'

abbr -a -- hget 'helm get values -n'
abbr -a --set-cursor='%' -- hval 'helm show values % > /tmp/hval.yaml && nvim /tmp/hval.yaml'
abbr -a --set-cursor='%' -- htem 'helm template release % > /tmp/hval.yaml && nvim /tmp/hval.yaml'
abbr -a -- hup 'helm upgrade -i --create-namespace -n'

abbr -a -- fa 'flux get all -n'
abbr -a -- fr 'flux reconcile kustomization'
abbr -a -- fr 'flux logs --level=error -n'

abbr -a --position anywhere -- xc '| xclip -selection clipboard'
abbr -a --position anywhere -- h --help
abbr -a --position anywhere -- v --version

mise activate fish | source
starship init fish | source
zoxide init fish | source
fzf --fish | source
