#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y \
git \ 
ca-certificates \ 
curl \ 
gnupg \ 
lsb-release \
net-tools \

# Pulling git repo and navigating to home
cd /home/ubuntu/
sudo git clone https://github.com/BenRedic-FyFazan/bookface.git

# Installing https transport and java runtime environment
sudo apt update
sudo apt install apt-transport-https
sudo apt install openjdk-11-jdk

# Setting java runtime environment
echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee -a /etc/environment
source /etc/environment

# getting elasticSearch key
wget -qO \
- https://artifacts.elastic.co/GPG-KEY-elasticsearch \
| sudo gpg --dearmor \
-o /usr/share/keyrings/elasticsearch-keyring.gpg 

# Setting the key
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
| sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Installing elasticSearch
sudo apt-get update && sudo apt-get install elasticsearch
sudo systemctl enable elasticsearch

## Disabling for easier install
# sudo systemctl start elasticsearch

## DID DEPLOY CHECK WORK?! IT WORKS

# configuring elkStack
cd ./bookface/elkStack/
sudo rm /etc/elasticsearch/elasticsearch.yml
sudo cp code/elasticSearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
# jvm_max size
sudo cp code/elasticSearch/jvm_heap_size.options /etc/elasticsearch/jvm.options.d/jvm_heap_size.options
## Disabling for easier install
# sudo systemctl restart elasticsearch

# Installing the rest
./elkLogstash_install.sh
