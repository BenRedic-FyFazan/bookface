# Registry service
## Creating a registry service
sudo docker service create --name registry --publish 5000:5000 registry:2
    - creating the registry service
    
sudo curl localhost:5000/v2/_catalog 
    - If you want to test it on any node on the cluster
    
## Tagging and pushing image to registry service
sudo docker tag [imagename] localhost:5000/[imagename]:[version]
    - tags the image
    
sudo docker push localhost:5000/[imagename]:[version]
    - pushes image to registry service
    
## Create service:
sudo docker service create --name [SERVICE NAME] localhost:5000/[imagename]:[version]

# Creating services
sudo docker service create [OPTIONS] [image name]:[version]
    - options:
        - --publish published= [VM PORT], target= [CONTAINER PORT]
        - --name [SERVICE NAME]
        - --replicas [AMOUNT]
    
example: sudo docker service create --name bookface --publish published=49000,target=80 --replicas 3 localhost:5000/bookface:v1

# Building images
sudo docker build -t "[image name]:[version]" .
