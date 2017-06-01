#!/bin/bash
sudo yum update -y
sudo yum install -y git gcc ruby-devel rubygems rake
sudo gem install io-console serverspec
echo "1\n2" | serverspec-init
cd /home/ec2-user/
git clone https://github.com/ShehryarAbbasi/kafkaExample.git
cd kafkaExample
rake spec
cd /home/ec2-user/
echo "done" > sys.log

cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
cd ~
kafkaVer="kafka_2.11-0.10.2.0"
if [ ! -d /opt/$kafkaVer ]
then
    wget "http://apache.claz.org/kafka/0.10.2.0/$kafkaVer.tgz"
    tar -xvf $kafkaVer.tgz
    sudo mv $kafkaVer /opt
    cd /opt/$kafkaVer
    publicIP=$(curl -s "http://169.254.169.254/latest/meta-data/public-ipv4/")
    echo "public ip from meta-data: $publicIP"
    sudo sed -i "s|#advertised.listeners=PLAINTEXT:.*:9092|advertised.listeners=PLAINTEXT:\/\/$publicIP:9092|" config/server.properties
fi
(sudo bin/zookeeper-server-start.sh -daemon config/zookeeper.properties)
(sudo bin/kafka-server-start.sh config/server.properties)
cd /opt/$kafkaVer
(sudo bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testTopic)


