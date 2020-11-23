#!/bin/bash
yum install httpd -y
systemctl enable httpd.service
systemctl start httpd.service
echo "Azure bootstrap" > /var/www/html/index.html
yum update -y