#!/bin/bash

source ./common.sh
app_name=redis
check_root

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling Default Redis version"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enabling Redis:7"

dnf install redis -y  &>>$LOG_FILE
VALIDATE $? "installing redis"

sed -i  -e 's/127.0.0.1/0.0.0.0/g'  -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf  &>>$LOG_FILE
VALIDATE $? "Edited redis.conf to accept remote connections"

systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE
VALIDATE $? "starting redis"

print_time 



