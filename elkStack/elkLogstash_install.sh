#!/bin/bash

# Logstash
sudo apt-get install logstash
sudo systemctl enable logstash
## Disabling for easier install
#sudo systemctl start logstash

# Kibana
sudo apt-get install kibana
sudo systemctl enable kibana
## Disabling for easier install
#sudo systemctl start kibana

# Kibana config
sudo rm /etc/kibana/kibana.yml
sudo cp code/kibana/kibana.yml /etc/kibana/kibana.yml

# Firebeat
sudo apt-get install filebeat
sudo rm /etc/filebeat/filebeat.yml
sudo cp code/filebeat/filebeat.yml /etc/filebeat/filebeat.yml
sudo filebeat modules enable system

## loading index
sudo filebeat setup --index-managementsudo filebeat setup \
 --index-management -E output.logstash.enabled=false \
-E 'output.elasticsearch.hosts=["0.0.0.0:9200"]'

sudo systemctl enable filebeat
## Disabling for easier install
# sudo systemctl start filebeat
