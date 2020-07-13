#!/bin/bash
sudo usermod -aG docker vagrant
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
cd /home/vagrant/
sudo apt install default-jdk npm zip --yes
git clone https://github.com/apache/openwhisk-devtools.git
cd openwhisk-devtools/docker-compose
sed -i '1 i\SHELL:=/bin/bash' Makefile
sed -i 's/trycounttimeout=30/trycounttimeout=120/g' Makefile
sed -i 's/latest/nightly/g' docker-compose.yml
sed -i 's/echo Installing apimgmt actions/echo Installing apimgmt actions\nsleep 10' openwhisk-src/ansible/roles/routemgmt/files/installRouteMgmt.sh
mkdir -p /root/tmp && mkdir -p /root/tmp/openwhisk/
ln -s /home/vagrant/openwhisk-devtools/docker-compose/docker-whisk-controller.env /root/tmp/openwhisk/local.env
echo "invoke docker-compose pull two times to guarantee success:"
docker-compose pull
docker-compose pull
rm /root/tmp/openwhisk/local.env
#sudo make setup
sudo make docker-pull
echo "All images should be pulled now. Starting build and launch process:"
counter=1
sudo make quick-start
while [ $? -ne 0 ]; do
	counter=$((counter+1)) && echo "try no. #$counter" && sudo make destroy && sudo make quick-start
done
echo "total number of attempts: #$counter"
