sudo apt update && apt upgrade -y
sudo apt install openjdk-8-jdk -y
cd /home/terraform
mkdir cassandra
cd cassandra
sudo curl -OL https://archive.apache.org/dist/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz
sudo tar -xvzf  apache-cassandra-3.11.4-bin.tar.gz
sudo mv apache-cassandra-3.11.4 /usr/local/cassandra
sudo mv /home/terraform/cassandra.yml /usr/local/cassandra/conf/cassandra.yaml
sudo mv /home/terraform/cassandra-rackdc.properties /usr/local/cassandra/conf/cassandra-rackdc.properties
sudo mv /home/terraform/cassandra.service /etc/systemd/system/cassandra.service