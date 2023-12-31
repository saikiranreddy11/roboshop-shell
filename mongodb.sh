#!/bin/bash
id=$(id -u)
R="\e[31m"
N="\e[0m"
Y="\e[33m"
date=$(date +%F-%H-%M-%S)
script_name=$0
#logfiles=/tmp/shell-script-logs/$script_name-$date.log 
if [ $id -ne 0 ]
then
    echo -e "$R ERROR: $N you do not have the sudo access, please install with root access"
    exit 1
fi

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R  $2  is FAiled $N"
        exit 1
    else 
        echo -e "$Y $2 is success"
    fi
}

test -d /tmp/shell-script-logs
if [ $? -ne 0 ]
then
    mkdir /tmp/shell-script-logs 
    validate $? "setup an shell-script-log directory"
fi
logfiles=/tmp/shell-script-logs/$script_name-$date.log

cp  mongo.repo /etc/yum.repos.d/mongo.repo 

validate $? "configuring the mongo"

yum install mongodb-org -y >>$logfiles

validate $?  "Installing MongoDb"

systemctl enable mongod >>$logfiles

validate $? "Enabling MongoDb"

systemctl start mongod >>$logfiles

validate $? "Starting Mongodb"

sed -i "s/127.0.0.1/0.0.0.0/"  /etc/mongod.conf

validate $? "Changing the DNS"

systemctl restart mongod >>logfiles

validate $? "Restarting MongoDB"