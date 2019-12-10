#!/bin/bash

emrClientDepsPath="s3://salander/edge-node/emr-client"
echo "EMR client dependencies path: "$emrClientDepsPath

cd /mnt
mkdir t
cd t

# hadoop配置文件
mkdir -p ./etc/hadoop/conf
cp -a /etc/hadoop/conf/yarn-site.xml ./etc/hadoop/conf/
cp -a /etc/hadoop/conf/core-site.xml ./etc/hadoop/conf/

#打包了hive的配置文件
mkdir -p ./etc/hive/conf
cp -a /etc/hive/conf/* ./etc/hive/conf/

#lib文件
mkdir -p ./usr/lib
cp -a /usr/lib/hbase ./usr/lib
cp -a /usr/lib/hadoop ./usr/lib
cp -a /usr/lib/hadoop-lzo ./usr/lib
cp -a /usr/lib/hadoop-hdfs ./usr/lib
cp -a /usr/lib/hive  ./usr/lib


#share文件
mkdir -p ./usr/share
cp -a /usr/share/aws ./usr/share

rm -rf ./usr/share/aws/emr/instance-controller
rm -rf ./usr/share/aws/emr/hadoop-state-pusher


#把所有的配置文件都pack好 打包成一个tgz存到S3上
tar cvfz ../awsemrdeps.tgz .
cd ..
aws s3 cp awsemrdeps.tgz $emrClientDepsPath/