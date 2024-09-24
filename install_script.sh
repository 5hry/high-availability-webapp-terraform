#!/bin/bash
# Update the system and install Nginx
sudo yum update 
sudo yum install -y docker
sudo systemctl enable docker
sudo service docker start


# Fetch the Availability Zone and Hostname, and display them in the index.html
# EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
# echo "<h3 align='center'> Hello World from Availability zone : $EC2_AVAIL_ZONE ; Hostname $(hostname -f) </h3>" | sudo tee /usr/share/nginx/html/index.html
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 905418377779.dkr.ecr.ap-southeast-1.amazonaws.com
REPOSITORY_URI=905418377779.dkr.ecr.ap-southeast-1.amazonaws.com/ws1-bluegreen-repo
IMAGE_TAG="latest"
docker pull $REPOSITORY_URI:$IMAGE_TAG

docker images
# sudo yum install stress -y


# Variables for container
CONTAINER_NAME="app-container"
PORT_MAPPING="80:80" # Replace with your desired port mapping

# Check if the container is already running, if so, stop and remove it
if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Run the container from the pulled image
docker run -d --name $CONTAINER_NAME -p $PORT_MAPPING $REPOSITORY_URI:$IMAGE_TAG

# Check if the container started successfully
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Container is running: $CONTAINER_NAME"
else
    echo "Failed to run container: $CONTAINER_NAME"
    exit 1
fi