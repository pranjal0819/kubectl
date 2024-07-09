FROM ubuntu:latest

ARG HELM_VERSION="v3.15.2"
ARG KUBECTL_VERSION="v1.30.2"
ARG TARGETPLATFORM

ENV HOME=/home/kubectl PATH=$PATH:/home/kubectl NAMESPACE=core SERVER=cat

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl unzip vim fish

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
    aws/install && chmod +x kubectl && chmod +x /usr/local/bin/helm && \
    rm -rf aws awscliv2.zip kubectl.sha256 linux-amd64 linux-arm64

# Switch to application user.
USER kubectl

COPY --chown=kubectl:kubectl . $HOME

RUN /bin/fish

RUN chmod +x script.sh && script.sh && rm -rf script.sh

CMD /bin/fish
