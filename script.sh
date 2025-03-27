#!/bin/bash
sudo apt update -y

# Install Nginx
sudo apt install -y nginx

sudo systemctl enable nginx