#!/bin/bash

s3Repo=s3://salander/edge-node
s3UploadPath=s3://salander/edge-node
#presignedUrl=$3


# Configure RStudio Server user
cd /home/ec2-user
mkdir download

# Upgrade Java
yum install -y java-1.8.0
yum remove -y java-1.7.0-openjdk

# Download apps
aws s3 cp s3://salander/edge-node/apps/ download/ --recursive

# Install Hadoop
tar xfz download/hadoop-2.8.4.tar.gz
ln -s /home/ec2-user/hadoop-2.8.4 /usr/lib/hadoop
rm -rf /usr/lib/hadoop/share/doc*

#install hive
wget http://us.mirrors.quenda.co/apache/hive/hive-2.3.5/apache-hive-2.3.5-bin.tar.gz
tar -zxvf apache-hive-2.3.5-bin.tar.gz 
ln -s /home/ec2-user/hive-2.3.5  /usr/lib/hive


#
# add AWS EMR Client deps from root
#
cd /

fileDeps=awsemrdeps.tgz
emrDepsFilePath=s3://salander/edge-node/emr-client/awsemrdeps.tgz

#下载EMR配置文件
aws s3 cp s3://salander/edge-node/emr-client/awsemrdeps.tgz awsemrdeps.tgz
tar xfz awsemrdeps.tgz
rm -f awsemrdeps.tgz

# Client will create directories under /mnt for buffering
chmod 777 /mnt

# Change ownership back to ruser
chown -R ec2-user:ec2-user /home/ec2-user

# Configure environment variables for user & R
echo "export HADOOP_HOME=/usr/lib/hadoop" >> /home/ec2-user/.bashrc
echo "export HADOOP_CONF_DIR=/usr/lib/hadoop/etc/hadoop" >> /home/ec2-user/.bashrc
echo "export JAVA_HOME=/etc/alternatives/jre" >> /home/ec2-user/.bashrc
echo "export HIVE_HOME=/user/lib/hive" >>/home/ec2-user/.bashrc
echo "export PATH=$HIVE_HOME/bin:$PATH" >> /home/ec2-user/.bashrc

echo "HADOOP_HOME=/usr/lib/hadoop" >> /home/ec2-user/.Renviron
echo "HADOOP_CONF_DIR=/usr/lib/hadoop/etc/hadoop" >> /home/ec2-user/.Renviron
echo "JAVA_HOME=/etc/alternatives/jre" >> /home/ec2-user/.Renviron
echo "export HIVE_HOME=/user/lib/hive" >> /home/ec2-user/.Renviron
echo "export PATH=$HIVE_HOME/bin:$PATH" >>  /home/ec2-user/.Renviron

