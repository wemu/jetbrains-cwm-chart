# Kubernetes Helm Chart for the Jetbrains Code With Me Plugin

This repository contains some scripts to build docker images
for the Code With Me plugin to be able to host a lobby server
within your company's kubernetes server.

Current status: **Experimental Mode**.

Cause:
* redis not yet using volume claims to store session data


## Instructions

1. create a namespace in kubernetes (1.18+)
1. create a stage-test-values.yaml file and adjust the defaults from values.yaml
1. use [helm](https://helm.sh) to deploy this chart to kubernetes


## Site-Seeing:

* [Getting Started with Code With Me](https://www.jetbrains.com/help/cwm/code-with-me.html)
* The scripts here are based on instructions in the [Administration Guide](https://www.jetbrains.com/help/cwm/code-with-me-administration-guide.html)
* [FAQ](https://www.jetbrains.com/help/idea/faq-about-code-with-me.html)
