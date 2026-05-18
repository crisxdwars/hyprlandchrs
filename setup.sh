#!/bin/env bash

echo "Installing Dependencies..."

sudo pacman -S waybar swaybg gpu-screen-recorder wl-clipboard slurp grim ttf-fira-code ttf-fira-code noto-fonts-cjk zip unzip pavucontrol --noconfirm

mkdir -p ~/.config
cp -r wofi ~/.config
cp -r dunst ~/.config
cp -r hypr ~/.config
cp -r waybar ~/.config
cp -r kitty ~/.config

echo "Setup Complete!"
