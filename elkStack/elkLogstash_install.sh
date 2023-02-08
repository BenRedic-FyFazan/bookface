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
