#!/bin/bash

set -e

app=$(argocd app list | tail -n +2 | awk '{print $1}' | fzf)

argocd app sync --prune "$app"
