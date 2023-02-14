#!/bin/bash -X

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/$
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin

# Pulls package-registry
sudo docker pull docker.elastic.co/package-registry/distribution:7.17.9

# Save docker image locally
#sudo docker save -o package-registry-7.17.9.tar docker.elastic.co/package-registry/distribution:7.17.9

# Load image
#sudo docker load -i package-registry-7.17.9.tar

# Run 
sudo docker run -it -d -p 8080:8080 docker.elastic.co/package-registry/distribution:7.17.9

## OPTIONAL
# Monitor health of package registry with requests to root path
#docker run -it -p 8080:8080 \
#    --health-cmd "curl -f -L http://127.0.0.1:8080/health" \
#    docker.elastic.co/package-registry/distribution:7.17.9

## MORE INFO HERE: https://www.elastic.co/guide/en/fleet/7.17/air-gapped.html
# Connect kibana to to your hosted registry:
# 'xpack.fleet.registryUrl: "http://package-registry.corp.net:8080"'

