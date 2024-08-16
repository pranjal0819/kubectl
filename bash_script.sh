#!/bin/sh

# Append prompt customization to .bashrc
echo 'export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;31m\]$SERVER\[\033[00m\]~\[\033[01;32m\]$NAMESPACE\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"' >> ~/.bashrc

# Append aliases to .bashrc
echo '
alias kubectl="kubectl --namespace=$NAMESPACE"
alias khelp="cat < ~/.kube_help"
alias kall="kubectl get all -A"
alias kpod="kubectl get pod"
alias kjob="kubectl get job"
alias klogs="kubectl logs -f"
alias kexec="kubectl exec -it"
alias kdelpod="kubectl delete pod"
alias kdeljob="kubectl delete job"
alias kcount="kubectl get pods -A --field-selector=status.phase=Running --no-headers | wc -l"
' >> ~/.bashrc

# Append functions for deleting pods and jobs to .bashrc
echo '
delete_pods() { kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep "$1" | xargs kubectl delete --namespace=$NAMESPACE pod; }
alias kdelpods="delete_pods"

delete_jobs() { kubectl get jobs --no-headers -o custom-columns=":metadata.name" | grep "$1" | xargs kubectl delete --namespace=$NAMESPACE job; }
alias kdeljobs="delete_jobs"
' >> ~/.bashrc

cat ~/.bashrc

# Append prompt customization to config.fish
echo '
function fish_prompt
    set_color yellow
    echo -n (whoami)
    set_color normal
    echo -n "@"
    set_color red
    echo -n $SERVER
    set_color normal
    echo -n "~"
    set_color green
    echo -n $NAMESPACE
    set_color normal
    echo -n ":"
    set_color blue
    echo -n (prompt_pwd)
    set_color normal
    echo -n "\$ "
end
' >> ~/.config/fish/config.fish

# Append aliases to config.fish
echo '
alias kubectl "kubectl --namespace=$NAMESPACE"
alias helm "helm --namespace=$NAMESPACE"
alias khelp "cat < ~/.kube_help"
alias kall "kubectl get all -A"
alias kpod "kubectl get pod"
alias kjob "kubectl get job"
alias klogs "kubectl logs -f"
alias kexec "kubectl exec -it"
alias kdelpod "kubectl delete pod"
alias kdeljob "kubectl delete job"
alias kcount "kubectl get pods -A --field-selector=status.phase=Running --no-headers | wc -l"
' >> ~/.config/fish/config.fish

# Append functions for deleting pods and jobs to config.fish
echo '
function delete_pods
    kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep "$argv[1]" | xargs kubectl delete --namespace=$NAMESPACE pod
end
alias kdelpods "delete_pods"

function delete_jobs
    kubectl get jobs --no-headers -o custom-columns=":metadata.name" | grep "$argv[1]" | xargs kubectl delete --namespace=$NAMESPACE job
end
alias kdeljobs "delete_jobs"
' >> ~/.config/fish/config.fish

cat ~/.config/fish/config.fish
