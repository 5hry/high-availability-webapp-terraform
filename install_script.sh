#!/bin/bash
sudo yum update 
sudo yum install -y docker
sudo systemctl enable docker
sudo service docker start

aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 905418377779.dkr.ecr.ap-southeast-1.amazonaws.com
REPOSITORY_URI=905418377779.dkr.ecr.ap-southeast-1.amazonaws.com/ws1-bluegreen-repo
IMAGE_TAG="latest"
docker pull $REPOSITORY_URI:$IMAGE_TAG

CONTAINER_NAME="app-container"
PORT_MAPPING="80:80"

if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

docker run -d --name $CONTAINER_NAME -p $PORT_MAPPING $REPOSITORY_URI:$IMAGE_TAG

if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Container is running: $CONTAINER_NAME"
else
    echo "Failed to run container: $CONTAINER_NAME"
    exit 1
fi