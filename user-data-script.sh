#!/bin/bash

## GENERAL SETUP ##
## update yum, install and start AWS cloudwatch agent, install AWS SSM agent
sudo yum update -y
sudo yum install -y awslogs https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm


## APP SPECIFIC SETUP ##
## install and run Zookeeper + Kafka in the background, create a generic Kafka Topic
cd /tmp
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
(sudo bin/kafka-server-start.sh -daemon config/server.properties)
cd /opt/$kafkaVer
(sudo bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testTopic)


## RUN TESTS ##
## pull down repo to run serverspec tests
cd /home/ec2-user/
sudo yum install -y git gcc ruby-devel rubygems rake
sudo gem install io-console serverspec
git clone https://github.com/ShehryarAbbasi/kafkaExample.git && cd kafkaExample/tests/
rake spec
sudo sed -i "s/^/$(date +%b-%d-%H:%M:%S) /" spec/Reports/test_report.json

## CONFIGURE CLOUDWATCH TO PICKUP OUR TEST REPORT JSON FILE
sudo tee /etc/awslogs/config/serverspec_results.conf > /dev/null <<EOF
[/tests/serverspec]
datetime_format = %b-%d-%H:%M:%S
file = /home/ec2-user/kafkaExample/tests/spec/Reports/test_report.json
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /tests/serverspec
EOF
sudo service awslogs start && sudo chkconfig awslogs on
