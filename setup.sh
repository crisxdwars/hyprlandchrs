#!/bin/env bash

mkdir -p ~/.config
cp -r wofi ~/.config
cp -r dunst ~/.config
cp -r hypr ~/.config
cp -r waybar ~/.config
cp -r kitty ~/.config

echo "Setup Complete!"
