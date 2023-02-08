# Installing ElasticSearch
Dependencies: ca-ls certificates
 - src url: https://www.elastic.co/guide/en/elasticsearch/reference/8.6/deb.html
 
## DL + install public signing key:
´´wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg ´´

## Install elasticStack from APT
Might need to install https transport package first:
´´sudo apt-get install apt-transport-https´´

Then save repo definition:
´´echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list´´

Finally we install:
´´sudo apt-get update && sudo apt-get install elasticsearch´´

MAKE NOTE OF THE PASSWORD OUTPUT FROM THE INSTALL!
- gN6ofc2dPSh6H*DaAllh


## Starting ElasticSearch with security enabled
To change the password of the superuser, run the following:

First we make it start automatically when the system boots:
´´sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service´´

If we need to start/stop the service we can use the following:
´´sudo systemctl start elasticsearch.service
sudo systemctl stop elasticsearch.service´´

Check that ElasticSearch is running:
´´curl --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic https://localhost:9200´´

## Configuring Elasticsearch
Default configuration directory: /etc/elasticsearch
Ownership of this directory and all contained files are set to root:elasticsearch

# Install Kibana
Source url: https://www.elastic.co/guide/en/kibana/8.6/deb.html

## installing and running
install command:
´´sudo apt-get update && sudo apt-get install kibana´´

Make it start automatically when the system boots:
´´sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service´´

## Starting and enrolling kibana to Elastic cluster
We need to generate an enrollment token for kibana:
´´/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana´´

i got:
eyJ2ZXIiOiI4LjYuMSIsImFkciI6WyIxOTIuMTY4LjEyOS4xNTA6OTIwMCJdLCJmZ3IiOiJhMmYzOGI5NjYzNzFlYWUzNTRkOWQzYTNkOTAxMzE1NTY2N2ViNTQ3Y2MxZTEzYjMwMmQ0MmFjMTIxYTgyMGYyIiwia2V5IjoiMnhTR0xZWUIzUVRpZ2h4c1RteEI6ZzAzSFQ0bFNTRWlERWdleTRZZXotUSJ9

We can then check if it is started with: ´´sudo journalctl -u kibana.service´

## Configuring Kibana
Kibana loads configuration from the /etc/kibana/kibana.yml by default. The format is explained here: https://www.elastic.co/guide/en/kibana/8.6/settings.html


# Installing Logstash
## Dependencies:
´´sudo apt install openjdk-17-jdk openjdk-17-jre´

source: https://www.elastic.co/guide/en/logstash/8.6/installing-logstash.html
## Install
´´sudo apt-get update && sudo apt-get install logstash´´

## Running Logstash as a service
Source: https://www.elastic.co/guide/en/logstash/8.6/running-logstash.html

Same as before, we put it in the daemon:´´sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable logstash.service´´

We can also start it with: ´´sudo systemctl start logstash.service´´, make sure to stop it afterwards if you try.

And here too we can check the journal if something feels off:
´´sudo journalctl -u logstash.service´´

## Directory layout
source: https://www.elastic.co/guide/en/logstash/8.6/dir-layout.html

## testing 
source: https://www.elastic.co/guide/en/logstash/current/first-event.html

´´cd /usr/share/logstash
sudo bin/logstash -e 'input { stdin { } } output { stdout {} }' --path.settings=/etc/logstash´

now write 'hello world' 

## Using filebeat to send files to logstash
source: https://www.elastic.co/guide/en/logstash/8.6/advanced-pipeline.html#configuring-filebeat

curl this file: ´´curl https://download.elastic.co/demos/logstash/gettingstarted/logstash-tutorial.log.gz --output logstash-tutorial.log.gz´´

now unzip it: ´´gunzip logstash-tutorial.log.gz´´

But first we need to install filebeat...

# Installing filebeat
source: https://www.elastic.co/guide/en/beats/filebeat/8.6/filebeat-installation-configuration.html

## Installing
´´curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.6.1-amd64.deb
sudo dpkg -i filebeat-8.6.1-amd64.deb´´

## testing

Now we need to do some config:
´´cd /etc/filebeat
nano filebeat.yml´´

now replace all the contents with the following

´´filebeat.inputs:
- type: log
  paths:
    - /path/to/file/logstash-tutorial.log 
output.logstash:
  hosts: ["localhost:5044"]´´
  
### Running filebeat
ignore port 5044 warnings as beats isn't running yet
´´sudo ./filebeat -e -c filebeat.yml -d "publish"´´

MAKE THIS PART BETTER


## Configuring Logstash for filebeat input
src:https://www.elastic.co/guide/en/logstash/8.6/advanced-pipeline.html#configuring-filebeat

verify configuration (from the /usr/share/logstash directory):
´´sudo /usr/share/logstash/bin/logstash -f first-pipeline.conf --config.test_and_exit --path.settings=/etc/logstash´´

if it passed verification run this:
´´sudo /usr/share/logstash/bin/logstash -f first-pipeline.conf --config.reload.automatic --path.settings=/etc/logstash´´
