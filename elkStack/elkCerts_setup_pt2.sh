#!/bin/bash -x
## Gets ip address
ip4=$(/sbin/ip -o -4 addr list ens3 | awk '{print $4}' | cut -d/ -f1)

cd /usr/share/elasticsearch

printf 'n\ny\n/usr/share/elasticsearch/elastic-stack-ca.p12\nadmin1\n5y\nn\nnode-1\n\ny\n%s\n\ny\nn\nadmin1\nadmin1\n\n' $ip4 \
 | sudo ./bin/elasticsearch-certutil http

sudo unzip elasticsearch-ssl-http.zip 
sudo mv ./elasticsearch/http.p12 /etc/elasticsearch/http.p12
printf 'y\nadmin1\n' | sudo ./bin/elasticsearch-keystore add xpack.security.http.ssl.keystore.secure_password

sudo mv ./kibana/elasticsearch-ca.pem /etc/kibana/elasticsearch-ca.pem
echo "elasticsearch.ssl.certificateAuthorities: /etc/kibana/elasticsearch-ca.pem" \
| sudo tee -a /etc/kibana/kibana.yml

sudo echo "elasticsearch.hosts: https://${ip4}:9200" \
| sudo tee -a /etc/kibana/kibana.yml
