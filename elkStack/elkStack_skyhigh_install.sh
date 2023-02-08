#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y \
git \ 
ca-certificates \ 
curl \ 
gnupg \ 
lsb-release \
net-tools \

## INSTALLATION
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

# Logstash
sudo apt-get install logstash
sudo systemctl enable logstash

# Kibana
sudo apt-get install kibana
sudo systemctl enable kibana

# Firebeat
sudo apt-get install filebeat
sudo systemctl enable firebeat

## DID DEPLOY CHECK WORK?! IT WORKS

## CONFIGURATION

# Pulling git repo and navigating to home
cd /home/ubuntu/
sudo git clone https://github.com/BenRedic-FyFazan/bookface.git

# elkStack config
cd ./bookface/elkStack/
sudo rm /etc/elasticsearch/elasticsearch.yml
sudo cp code/elasticSearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
# jvm_max size
sudo cp code/elasticSearch/jvm_heap_size.options /etc/elasticsearch/jvm.options.d/jvm_heap_size.options

# Logstash config
## None atm

# Kibana config
cd /home/ubuntu/bookface/elkStack/
sudo rm /etc/kibana/kibana.yml
sudo cp code/kibana/kibana.yml /etc/kibana/kibana.yml

# Filebeat config
cd /home/ubuntu/bookface/elkStack/
sudo rm /etc/filebeat/filebeat.yml
sudo cp code/filebeat/filebeat.yml /etc/filebeat/filebeat.yml
sudo filebeat modules enable system

## loading filebeat index
sudo filebeat setup --index-managementsudo filebeat setup \
 --index-management -E output.logstash.enabled=false \
-E 'output.elasticsearch.hosts=["0.0.0.0:9200"]'

sudo systemctl enable filebeat
## Disabling for easier install
# sudo systemctl start elasticsearch
# sudo systemctl start logstash
# sudo systemctl start kibana
# sudo systemctl start filebeat






