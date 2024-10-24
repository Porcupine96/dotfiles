#!/bin/bash

set -e

context=$(argocd context | tail -n +2 | awk '{print $2}' | fzf)

argocd context "$context"
