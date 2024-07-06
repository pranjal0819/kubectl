FROM ubuntu:latest

ARG HELM_VERSION="v3.15.2"
ARG KUBECTL_VERSION="v1.30.2"
ARG TARGETPLATFORM

ENV HOME=/home/kubectl PATH=$PATH:/home/kubectl NAMESPACE=core SERVER=cat

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl unzip vim

# Create group "kubectl" and user "kubectl".
RUN groupadd --system kubectl
RUN useradd --system --create-home --home-dir /home/kubectl --shell /bin/bash --gid kubectl kubectl

WORKDIR $HOME

# Download dependencies.
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/arm64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/arm64/kubectl.sha256" && \
    curl -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" && \
    curl -L "https://get.helm.sh/helm-$HELM_VERSION-linux-arm64.tar.gz" | tar -xz && mv linux-arm64/helm /usr/local/bin/helm; \
    else \
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256" && \
    curl -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    curl -L "https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz" | tar -xz && mv linux-amd64/helm /usr/local/bin/helm; \
    fi

# Install dependencies.
RUN echo "$(cat kubectl.sha256) kubectl" | sha256sum --check && unzip -q awscliv2.zip && \
    ./aws/install && chmod +x ./kubectl && chmod +x /usr/local/bin/helm && \
    rm -rf aws awscliv2.zip kubectl.sha256 linux-amd64 linux-arm64

# Switch to application user.
USER kubectl

COPY --chown=kubectl:kubectl . $HOME

RUN echo 'export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;31m\]$SERVER\[\033[00m\]~\[\033[01;32m\]$NAMESPACE\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"' >> ~/.bashrc && \
    echo 'alias kubectl="kubectl --namespace=$NAMESPACE"' >> ~/.bashrc && \
    echo 'alias khelp="cat < ~/kube_help"' >> ~/.bashrc && \
    echo 'alias kpop="kubectl get pod"' >> ~/.bashrc && \
    echo 'alias kjob="kubectl get job"' >> ~/.bashrc && \
    echo 'alias kall="kubectl get pod -A"' >> ~/.bashrc && \
    echo 'alias klogs="kubectl logs -f"' >> ~/.bashrc && \
    echo 'alias kexec="kubectl exec -it"' >> ~/.bashrc && \
    echo 'alias kdelpod="kubectl delete pod"' >> ~/.bashrc && \
    echo 'alias kdeljob="kubectl delete job"' >> ~/.bashrc && \
    echo 'alias kcount="kubectl get pods -A --field-selector=status.phase=Running --no-headers | wc -l"' >> ~/.bashrc && \
    echo 'alias kdelpods="delete_pods() { kubectl get pods --no-headers=true | awk '\''/'\''\$1'\''/{print \$1}'\'' | xargs kubectl delete --namespace=$NAMESPACE pod; }; delete_pods"' >> ~/.bashrc && \
    echo 'alias kdeljobs="delete_jobs() { kubectl get jobs --no-headers=true | awk '\''/'\''\$1'\''/{print \$1}'\'' | xargs kubectl delete --namespace=$NAMESPACE job; }; delete_jobs"' >> ~/.bashrc

CMD /bin/bash
