#!/bin/bash
sudo systemctl start nginx

#sudo docker pull gnaig/startcamp-workshop-frontend
#sudo docker run -d -p 8080:80 gnaig/startcamp-workshop-frontend
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