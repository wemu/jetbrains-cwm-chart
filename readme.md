# Important Update

***
Starting on April 6, 2021, JetBrains will begin selling [Code With Me Enterprise](https://www.jetbrains.com/code-with-me/).
***

The download of the lobby and relay server is no longer possible. So this chart will be archived sooner or later. Probably sooner, like: tomorrow. Still: it was a nice experiment :)


# Kubernetes Helm Chart for the Jetbrains Code With Me Plugin

This repository contains some scripts to build docker images
for the Code With Me plugin to be able to host a lobby server
within your company's kubernetes server.

Current status: **Experimental Mode**.

Cause:
* redis not yet using volume claims to store session data


## Instructions

create a namespace in kubernetes (1.18+), in this example: "jetbrains-cwm-test"

```shell script
$ kubectl create ns jetbrains-cwm-test
```

```shell script
$ cd jetbrains-cwm-chart
```

create a values-stage.yaml file and adjust the defaults from values.yaml (stage intended to be "test" or "preprod" or "prod" etc)
then check if the values are as expected:

```shell script
$ helm template . -f values-stage.yaml
```

then use [helm](https://helm.sh) to deploy this chart to kubernetes

```shell script
$ helm install cwm-release . -f values-stage.yaml -n jetbrains-cwm-test
```

## Helm Notes

```shell
# List all releases in this namespace
helm list -n jetbrains-cwm-test

# Upgrade Release / Deployment
$ helm upgrade cwm-release . -f values-test.yaml -n jetbrains-cwm-test
```


## Checking what's going on using the [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

```shell script
# install kubedash
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# retrieve login token
$ kubectl -n kube-system describe secret default

# start proxy to access kubedash (stays running, new terminal)
$ kubectl proxy
```

Go to [Kubedash on Localhost](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/).


## Site-Seeing:

* [Getting Started with Code With Me](https://www.jetbrains.com/help/cwm/code-with-me.html)
* The scripts here are based on instructions in the [Administration Guide](https://www.jetbrains.com/help/cwm/code-with-me-administration-guide.html)
* [FAQ](https://www.jetbrains.com/help/idea/faq-about-code-with-me.html)
