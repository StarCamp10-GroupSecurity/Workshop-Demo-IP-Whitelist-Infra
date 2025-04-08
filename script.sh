#!/bin/bash
sudo apt update -y

# Install Nginx
sudo apt install -y nginx

# install docker 
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ubuntu

sudo docker pull heyyytamvo/starcamp:latest
sudo docker run -d -p 8080:80 heyyytamvo/starcamp:latest

# Fix Nginx
sudo rm /etc/nginx/sites-enabled/default
sudo tee /etc/nginx/sites-enabled/default > /dev/null << 'EOF'
server {
        listen 80;
        server_name _;
 
        location / {
                proxy_pass http://localhost:8080; 
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_redirect off;
        }
}
EOF
sudo systemctl reload nginx