#!/bin/bash
sudo yum update -y
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo yum install java-1.8.0-openjdk.x86_64
sudo echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /etc/profile
sudo echo "export JRE_HOME=/usr/lib/jvm/jre" >> /etc/profile
source /etc/profile
cd ~
wget http://www-us.apache.org/dist/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
tar -xvf kafka_2.11-0.9.0.1.tgz
sudo mv kafka_2.11-0.9.0.1 /opt
cd /opt/kafka_2.11-0.9.0.1
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties
cd /opt/kafka_2.11-0.9.0.1
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic shehryarsTopic
