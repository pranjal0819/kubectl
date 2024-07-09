FROM ubuntu:latest

ARG USER="user"
ARG PASSWORD="ubuntu"
ARG HELM_VERSION="v3.15.2"
ARG KUBECTL_VERSION="v1.30.2"
ARG TARGETPLATFORM

ENV HOME=/home/$USER PATH=$PATH:/home/$USER NAMESPACE=core SERVER=cat

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl unzip vim fish sudo

# Create group "$USER"
# Create a new user "$USER" with a home directory and set the shell to /bin/bash
# Set the password for the "$USER" user
# Add the "$USER" user to the sudo group
RUN groupadd --system $USER && \
    useradd --system --create-home --home-dir /home/$USER --shell /bin/bash --gid $USER $USER && \
    echo "$USER:$PASSWORD" | chpasswd && \
    usermod --append --groups sudo $USER

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
    aws/install && chmod +x kubectl && mv kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/helm && \
    rm -rf aws awscliv2.zip kubectl.sha256 linux-amd64 linux-arm64

# Switch to application user.
USER $USER

COPY --chown=$USER:$USER . $HOME

RUN /bin/fish

RUN chmod +x bash_script.sh && bash_script.sh && rm -rf bash_script.sh

CMD /bin/fish
