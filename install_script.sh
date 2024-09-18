#!/bin/bash
# Update the system and install Nginx
sudo yum update 
sudo yum install -y nginx

# Enable and start Nginx
sudo systemctl enable nginx.service
sudo systemctl start nginx.service

# Fetch the Availability Zone and Hostname, and display them in the index.html
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
echo "<h3 align='center'> Hello World from Availability zone : $EC2_AVAIL_ZONE ; Hostname $(hostname -f) </h3>" | sudo tee /usr/share/nginx/html/index.html

# Install stress tool for testing CPU, memory, I/O, etc.
sudo yum install stress -y
