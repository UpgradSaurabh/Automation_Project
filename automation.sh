#!/bin/bash

# Update package index
sudo apt-get update

# Install Apache2
sudo apt-get install apache2 -y

# Enable Apache2 services
sudo systemctl enable apache2.service
sudo systemctl start apache2.service

# set the name of the tar archive to include your name and a timestamp
name="Saurabh"
timestamp=$(date '+%d%m%Y-%H%M%S')
tar_name="${name}-httpd-logs-${timestamp}.tar"

# create a tar archive of only the .log files in the /var/log/apache2/ directory
cd /var/log/apache2/
tar -cvf /tmp/${tar_name} --exclude='*.zip' --exclude='*.tar' access.log
tar -cvf /tmp/${tar_name} --exclude='*.zip' --exclude='*.tar' error.log

# copy the tar archive to an AWS S3 bucket using the AWS CLI
aws s3 cp /tmp/${tar_name} s3://upgrad-saurabh123/${tar_name}
