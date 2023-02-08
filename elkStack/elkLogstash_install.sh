#!/bin/bash

# Logstash
sudo apt-get install logstash
sudo systemctl enable logstash
sudo systemctl start logstash

# Kibana
sudo apt-get install kibana
sudo systemctl enable kibana
sudo systemctl start kibana

# Kibana config

