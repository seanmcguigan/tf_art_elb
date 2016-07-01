#!/bin/bash

# Install Oracle Java

echo "Installing Java 8 (64bit)"

yum remove java-1.7.0-openjdk-1.7.0.101-2.6.6.1.67.amzn1.x86_64 -y

cd /opt/

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-linux-x64.tar.gz"
tar xzf jdk-8u40-linux-x64.tar.gz

cd /opt/jdk1.8.0_40/

alternatives --install /usr/bin/java java /opt/jdk1.8.0_40/bin/java 2
alternatives --config java <<< '1'

alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_40/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_40/bin/javac 2
alternatives --set jar /opt/jdk1.8.0_40/bin/jar
alternatives --set javac /opt/jdk1.8.0_40/bin/javac

export JAVA_HOME=/opt/jdk1.8.0_40

# Install es
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF

yum install elasticsearch -y

chkconfig --add elasticsearch

/usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf

echo 'network.host: _eth0_' >> /etc/elasticsearch/elasticsearch.yml
#echo 'discovery.zen.ping.multicast.enabled: false' >> /etc/elasticsearch/elasticsearch.yml
#echo 'discovery.zen.minimum_master_nodes: 2' >> /etc/elasticsearch/elasticsearch.yml
#echo 'discovery.zen.ping.unicast.hosts: [“es00.art.com″, ”es01.art.com″, ”es02.art.com″]' >> /etc/elasticsearch/elasticsearch.yml
#echo 'bootstrap.mlockall: true' >> /etc/elasticsearch/elasticsearch.yml

service elasticsearch start

