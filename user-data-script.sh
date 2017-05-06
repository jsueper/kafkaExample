#!/bin/bash
sudo yum update -y
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
cd ~
kafkaVer="kafka_2.11-0.10.2.0"
if [ ! -d /opt/$kafkaVer ]
then
    wget "http://apache.claz.org/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz"
    tar -xvf $kafkaVer.tgz
    sudo mv $kafkaVer /opt
    cd /opt/$kafkaVer
    sudo sed -i 's/#port=9092/port=9092/' config/server.properties
    sudo sed -i 's/#host.name=localhost/host.name=localhost/' config/server.properties
fi
(sudo bin/zookeeper-server-start.sh -daemon config/zookeeper.properties)
(sudo bin/kafka-server-start.sh config/server.properties)
cd /opt/$kafkaVer
(sudo bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic shehryarsTopic)
