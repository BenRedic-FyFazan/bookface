# MAYBE THIS?!
https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

# Prerequisites:
Docker installed and configured
Docker compose installed
git installed

## Installing
´´docker pull docker.elastic.co/elasticsearch/elasticsearch:8.6.1´´

## single-node cluster

create network:
´´sudo docker network create elastic´´

start elasticsearch:
´´sudo docker run --name es01 --net elastic -p 9200:9200 -it docker.elastic.co/elasticsearch/elasticsearch:8.6.1´´

MAKE NOTE OF PASSWORD AND ENROLLMENT TOKEN
