#!/bin/bash


pacman -Q | awk '{ print $1 }' | xargs -I {} pacman -Qi {} > /tmp/arch-packages

awk -f deps-to-clean.awk /tmp/arch-packages
