#!/bin/sh

# alp
sudo apt update &&
sudo apt install unzip &&
# wget https://github.com/tkuchiki/alp/releases/download/v1.0.10/alp_linux_arm64.zip &&
wget https://github.com/tkuchiki/alp/releases/download/v1.0.10/alp_linux_amd64.zip &&
# unzip alp_linux_arm64.zip &&
unzip alp_linux_amd64.zip &&
sudo install ./alp /usr/local/bin &&
# rm ./alp_linux_arm64.zip &&
rm ./alp_linux_amd64.zip &&
rm ./alp ||
echo "alp install failed";

# apache bench
sudo apt install apache2-utils ||
echo "apache2-utils install failed";

# mysql
sudo apt install mysql-server mysql-client ||
echo "mysql install failed";

# dstat
sudo apt install dstat ||
echo "dstat install failed";

# k6
# wget https://github.com/grafana/k6/releases/download/v0.39.0/k6-v0.39.0-linux-arm64.tar.gz &&
wget https://github.com/grafana/k6/releases/download/v0.39.0/k6-v0.39.0-linux-amd64.tar.gz &&
# tar -xf k6-v0.39.0-linux-arm64.tar.gz &&
tar -xf k6-v0.39.0-linux-amd64.tar.gz &&
# sudo install ./k6-v0.39.0-linux-arm64/k6 /usr/local/bin/ &&
sudo install ./k6-v0.39.0-linux-amd64/k6 /usr/local/bin/ &&
# rm ./k6-v0.39.0-linux-arm64.tar.gz &&
rm ./k6-v0.39.0-linux-amd64.tar.gz &&
# rm -r ./k6-v0.39.0-linux-arm64 ||
rm -r ./k6-v0.39.0-linux-amd64 ||
echo "k6 install failed";

# pt-query-digest
sudo apt install percona-toolkit ||
echo "percona-toolkit install failed";

# query-digester
git clone https://github.com/kazeburo/query-digester.git &&
sudo install ./query-digester/query-digester /usr/local/bin/ &&
rm -r ./query-digester ||
echo "query-digester install failed";
