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
#Path=/tmp/$tar_name
Type=httpd-logs
File=tar
Path="/tmp/$name-httpd-logs-$timestamp.tar"
Size=$(du -h $Path | awk '{print $1}')
#Size=$(stat -c%s "$Path")
#Size=$(stat -c%s "$Path")

# create a tar archive of only the .log files in the /var/log/apache2/ directory
cd /var/log/apache2/
tar -cvf /tmp/${tar_name} --exclude='*.zip' --exclude='*.tar' *.log

# copy the tar archive to an AWS S3 bucket using the AWS CLI
aws s3 cp /tmp/${tar_name} s3://upgrad-saurabh123/${tar_name}

echo -e "${Type}\t${timestamp}\t${File}\t${Size}" >> /var/www/html/inventory.html

echo "* * * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
