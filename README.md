# Kubectl and Helm packaged by Pranjal Kushwaha

## What is Kubectl?

> Kubectl is the Kubernetes command-line interface. It allows for managing the Kubernetes cluster by providing a wide
> set of commands that allows communication with the Kubernetes API in a friendly way.

## What is helm?

> Helm is a package manager for Kubernetes that helps you define, install, and manage Kubernetes applications using
> charts. It simplifies the deployment, upgrading, and configuration of applications on Kubernetes clusters.

---

## Summary

```bash
alias kubectl-gamma='function _kubectl_gamma() { docker run -it --rm --env NAMESPACE="${1:-core}" --env SERVER=gamma --env-file $HOME/.keys/aws_credential_gamma --volume $HOME/.keys/kube_config_gamma:/home/kubectl/.kube/config pranjal0819/kubectl; }; _kubectl_gamma'
alias kubectl-prod=' function _kubectl_prod()  { docker run -it --rm --env NAMESPACE="${1:-core}" --env SERVER=prod  --env-file $HOME/.keys/aws_credential_prod  --volume $HOME/.keys/kube_config_prod:/home/kubectl/.kube/config  pranjal0819/kubectl; }; _kubectl_prod'
```

### You can add alias into `bashrc` or `zshrc` file, like this:

```bash
echo 'alias kubectl-gamma='\''function _kubectl_gamma() { docker run -it --rm --env NAMESPACE="${1:-core}" --env SERVER=gamma --env-file $HOME/.keys/aws_credential_gamma --volume $HOME/.keys/kube_config_gamma:/home/kubectl/.kube/config pranjal0819/kubectl; }; _kubectl_gamma'\''' >> ~/.zshrc
echo 'alias kubectl-prod='\'' function _kubectl_prod()  { docker run -it --rm --env NAMESPACE="${1:-core}" --env SERVER=prod  --env-file $HOME/.keys/aws_credential_prod  --volume $HOME/.keys/kube_config_prod:/home/kubectl/.kube/config  pranjal0819/kubectl; }; _kubectl_prod'\'''  >> ~/.zshrc
```

You can run these command into the container

1. `kpod` to get list of pod, and
2. `klogs pod_name` to get log of pod
3. `khelp` to get a list of shortcut commands

---

## Get this image

The recommended way to get the Kubectl Docker Image is to pull the prebuilt image from
the [Docker Hub Registry](https://hub.docker.com/repository/docker/pranjal0819/kubectl).

```bash
docker pull pranjal0819/kubectl
```

To use a specific version, you can pull a versioned tag. You can view
the [list of available versions](https://hub.docker.com/repository/docker/pranjal0819/kubectl/tags) in the Docker Hub
Registry.

```bash
docker pull pranjal0819/kubectl:[TAG]
```

### If you wish, you can also build the image yourself.

```bash
docker build --no-cache --tag pranjal0819/kubectl .
```

### For multiplatform use buildx

```bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx rm builder
docker buildx create --name builder --driver docker-container --use
docker buildx inspect --bootstrap
docker buildx build --no-cache --platform linux/amd64,linux/arm64 --tag pranjal0819/kubectl . --load
```

---

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example, to execute `kubectl version` you can follow
the example below:

```bash
docker run --rm --env NAMESPACE=core --env SERVER=gamma --env-file $HOME/.keys/aws_credential --volume $HOME/.keys/kube_config:/home/kubectl/.kube/config pranjal0819/kubectl kubectl
```

To access inside the docker shell you can use `docker run -it`, you can follow the example below:

```bash
docker run -it --rm --env NAMESPACE=core --env SERVER=gamma --env-file $HOME/.keys/aws_credential --volume $HOME/.keys/kube_config:/home/kubectl/.kube/config pranjal0819/kubectl
```

Consult the [Kubectl Reference Documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
to find the completed list of commands available.

---

## Issues

If you encountered a problem running this container, you can reach out
to [Pranjal Kushwaha](mailto:pranjal0819@gmail.com).
For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

## License

Copyright &copy; 2024-25 Pranjal Kushwaha
