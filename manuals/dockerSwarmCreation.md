#Swarm creation:
1. 'sudo docker swarm init --advertise-addr [MANAGER-IP]'
    - On the node you want as manager
    
2. copy the "docker swarm join" command that appears on manager, run it on all swarm workers.

3. (you can run 'sudo docker info' to view current state of swarm)
    - or 'docker node ls' to view information about nodes in swarm
    
4. Network for the swarm, example: 'sudo docker network create --attachable --driver overlay [NETWORK NAME]' (i used bookface-network)
    
5. Now you can deploy a service from the manager: 'sudo docker service create --replicas 1 --name helloworld alpine ping docker.com'
    - 'sudo docker service ls' to view currently running services
    
7. Make service to host docker images:
    sudo docker service create --name registry --publish 5000:5000 registry:2
    - creates the registry service
    
    sudo curl localhost:5000/v2/_catalog 
    - If you want to test it on any node on the cluster
    
8. Build docker image: 'sudo docker build -t "bookface:v1" .'

9. Tagging and pushing image to registry service: 
    - 'sudo docker tag bookface:v1 localhost:5000/bookface:v1'
    - 'sudo docker push localhost:5000/bookface:v1'
    
10. Creating the service: 
    'sudo docker service create \
    --mode replicated \
    --replicas 0 \
    --name apache-Service \
    --update-delay 10s \
    --network apache-network \
    --endpoint-mode dnsrr \
    localhost:5000/bookface:v1'
    
    Notice we don't actually run any replicas of the service yet.
    
11. HAPROXY PART:
    Copy haproxy.cfg into /etc/haproxy on all nodes

12.create a single instance of HAProxy:
    'sudo docker service create \
    --mode replicated \
    --replicas 1 \
    --name haproxy-service \
    --network apache-network \
    --publish published=80,target=80,protocol=tcp,mode=ingress \
    --publish published=443,target=443,protocol=tcp,mode=ingress \
    --mount type=bind,src=/etc/haproxy/,dst=/etc/haproxy/,ro=true \
    --dns=127.0.0.11 \
    haproxytech/haproxy-debian:2.0'
    
    sudo docker service create \
  --mode replicated \
  --replicas 1 \
  --name haproxy-service \
  --network apache-network \
  --publish published=80,target=80,protocol=tcp,mode=ingress \
  --publish published=443,target=443,protocol=tcp,mode=ingress \
  --mount type=bind,src=/etc/haproxy/,dst=/etc/haproxy/,ro=true \
  --dns=127.0.0.11 \
  haproxytech/haproxy-debian:2.0
    
    can check service with 'sudo docker service logs --tail 20 haproxy-service'
    
    and can check stats here: 'http://[IP-TO-NODE'X']/my-stats'
    
13. Scale the service upwards: 'sudo docker service scale apache-Service=1' (or 6)
    
14. 'sudo docker service rm [SERVICE NAME]' to remove service

15. Rolling update of service:
    'sudo docker service update --image [image]:[version] [service]'
    for us:
    'sudo docker service update --image localhost:5000/bookface:[version] apache-Service'
