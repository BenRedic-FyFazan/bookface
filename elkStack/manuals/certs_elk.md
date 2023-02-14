# Sjekk at versjon stemmer for hver guide
# Part 1
source1: https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup.html

source2: https://discuss.elastic.co/t/unable-to-run-elasticsearch-after-setting-up-ssl-certificate/312774

sudo su
cd /usr/share/elasticsearch
./bin/elasticsearch-certutil ca
Enter (to accept the default name elastic-stack-ca.p12)
 - Password was entered

./bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12
Enter (to accept the default name elastic-certificates.p12)
 - The SAME password was entered

chown root:elasticsearch elastic-certificates.p12
chmod 660 elastic-certificates.p12
mv elastic-certificates.p12 /etc/elasticsearch

./bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password
 - SAME password was entered

./bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password
 - SAME password was entered

./bin/elasticsearch-keystore add xpack.security.http.ssl.keystore.secure_password
 - SAME password was entered

./bin/elasticsearch-keystore add xpack.security.http.ssl.truststore.secure_password
 - SAME password was entered

# Part 2
source: https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup-https.html

# Part 3?
https://discuss.elastic.co/t/import-ca-cert-as-privatekeyentry-to-http-keystore-solve-unable-to-create-enrollment-token-error/313780/3

# Encrypting communictaions
https://www.elastic.co/guide/en/elasticsearch/reference/7.5/configuring-tls.html

# Keytool

Keytool install:
    https://www.misterpki.com/install-keytool/

sudo keytool -importkeystore -destkeystore /etc/elasticsearch/http.p12 -srckeystore /usr/share/elasticsearch/elastic-stack-ca.p12 -srcstoretype PKCS12

# LOGIN WITH ELASTIC USER
password in log

# Getting ip variable in a script:
ip4=$(/sbin/ip -o -4 addr list ens3 | awk '{print $4}' | cut -d/ -f1)
ip6=$(/sbin/ip -o -6 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
echo "Your ipv4 address is: ${ip4}";
echo "Your ipv6 address is: ${ip6}";

Alternatively:

#!/bin/bash
lanIp="$(ip -4 -o -br addr|awk '$0 ~ /^[we]\w+\s+UP\s+/ {str = gsub("/[1-9][0-9]*", "", $0); print $3}')";
wanIp="$(curl https://ipinfo.io/ip 2>/dev/null)";
 
echo "Your private ip is: ${lanIp}";
echo "Your public ip is: ${wanIp}";


# For the scripting:
1. Cleanup the elasticsearch.yml and kibana.yml 
2. Centralize the files to git repo
3. Write Script for part 1 and test it
4. Write script for part 2 and test it
5. integrate to main script

Part 1:
https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup.html
    Input:
    - Password for CA: blank
    - Password for certificate: minimum 6 symbols: use admin1 for testing
    
    
    
    
part 2:
https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup-https.html
    Input in order (run through first to confirm):
    - n
    - y
    - "path to ca"
    - "password to ca": admin1
    - 5y
    - n
    [some stuff here]
    - node-1
    [some stuff here]
    - "ip address": gotten via script, see above
    - "password to private key": use same as above: admin1
    
    
CERTIFICATE GUIDE:
https://github.com/bvader/howtos/blob/master/basic-security-elasticsearch/README.md
