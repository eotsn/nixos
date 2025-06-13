#!/bin/bash

nix-shell --packages stow --command "stow --dotfiles --target=$HOME ."
