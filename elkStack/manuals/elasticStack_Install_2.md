sudo apt update

sudo apt install apt-transport-https

sudo apt install openjdk-11-jdk

java -version (verify)

sudo nano /etc/environment
    paste following into file:
    'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"'
    (replace existing)
    
source /etc/environment

verify: echo $JAVA_HOME

wget -qO \
- https://artifacts.elastic.co/GPG-KEY-elasticsearch \
| sudo gpg --dearmor \
-o /usr/share/keyrings/elasticsearch-keyring.gpg 

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
| sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update

sudo apt-get install elasticsearch

sudo systemctl start elasticsearch

sudo systemctl enable elasticsearch

Check status: sudo systemctl status elasticsearch

# Configuring
sudo nano /etc/elasticsearch/elasticsearch.yml

*Uncomment network.host and replace your system ip with 'network.host:0.0.0.0'*

add 'discovery.seed_hosts: []' in the discovery section

change 'xpack.security.enabled: true' to false

sudo systemctl restart elasticsearch

You can now access elasticsearch through browser with http://IP:9200

# Logstash
sudo apt-get install logstash

sudo systemctl start logstash

sudo systemctl enable logstash

sudo systemctl status logstash

sudo nano /etc/logstash/logstash.yml

# Kibana
sudo apt-get install kibana

sudo systemctl start kibana

sudo systemctl enable kibana

sudo systemctl status kibana

## config kibana
sudo nano /etc/kibana/kibana.yml

uncomment the following lines: 
    - server.port:5601
    - server.host:"localhost"
    - elasticsearch.hosts: ["http://localhost:9200"]

sudo systemctl restart kibana

now you can test kibana at http://ip:5601

# installing and configuring filebeat
sudo apt-get install filebeat

sudo nano /etc/filebeat/filebeat.yml

comment out 'output.elasticsearch:' section

uncomment output.logstash: and hosts: beneath it

change localhost in output.logstash to 0.0.0.0

## enable filebeat
sudo filebeat modules enable system

### load index
sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["0.0.0.0:9200"]'

sudo systemctl start filebeat

sudo systemctl enable filebeat

To verify: curl -XGET http://192.168.131.169:9200/_cat/indices?v

# Accessing kibana dashboard
http://192.168.133.12:5601

If you cant access, check status of all 4 services. 
some of them are resource hogs...



# Other stuff
## JVM max heapsize
https://www.elastic.co/guide/en/elasticsearch/reference/8.6/advanced-configuration.html#set-jvm-heap-size


