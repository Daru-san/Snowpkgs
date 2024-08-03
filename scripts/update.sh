#!/usr/bin/env bash

nix-update -F bridge-editor --commit --format
nix-update -F poketex --commit --format
nix-update -F kronkhite --format --commit --version branch
nix-update -F valent --format --commit --version branch
nix-update -F waydroid-script --format --commit --version branch
nix-update -F trashy --format --commit --version branch
