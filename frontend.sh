#!/bin/bash

source ./common.sh
check_root

dnf module disable nginx -y  &>>$LOG_FILE
VALIDATE $? "Disabling Default Nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginix"

systemctl enable nginx  &>>$LOG_FILE
systemctl start nginx 
VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping frontend"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Removing default nginx conf"

cp $SCRIPT_DIR/nginx.conf  /etc/nginx/nginx.conf 
VALIDATE $? "copying nginx.cong"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"

print_time