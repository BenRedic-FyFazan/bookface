# installing metricbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.6.1-amd64.deb 

sudo dpkg -i metricbeat-8.6.1-amd64.deb

sudo nano /etc/metricbeat/metricbeat.yml
change to following:
output.elasticsearch:
  hosts: ["https://myEShost:9200"]
  username: "metricbeat_internal"
  password: "YOUR_PASSWORD" 
  ssl:
    enabled: true
    ca_trusted_fingerprint: "FINGERPRINT"
    
