#!/usr/bin/bash

useradd -m ec2_hond &&
cd /home/ec2_hond &&
# umask 000 &&
sudo -u ec2_hond -s mkdir .ssh &&
sudo -u ec2_hond -s touch .ssh/authorized_keys &&
sudo -u ec2_hond -s curl https://github.com/hond0413.keys >> .ssh/authorized_keys &&
sudo -u ec2_hond -s chmod 700 /home/ec2_hond/.ssh/ &&
sudo -u ec2_hond -s chmod 600 /home/ec2_hond/.ssh/authorized_keys ||
echo  "ec2_hond failed";

useradd -m ec2_daiki_skm &&
cd /home/ec2_daiki_skm &&
sudo -u ec2_daiki_skm mkdir .ssh &&
sudo -u ec2_daiki_skm -s touch .ssh/authorized_keys &&
sudo -u ec2_daiki_skm curl https://github.com/daiki328.keys >> .ssh/authorized_keys &&
sudo -u ec2_daiki_skm chmod 700 /home/ec2_daiki_skm/.ssh/ &&
sudo -u ec2_daiki_skm chmod 600 /home/ec2_daiki_skm/.ssh/authorized_keys ||
echo  "ec2_daiki_skm failed";

useradd -m ec2_walk &&
cd /home/ec2_walk &&
sudo -u ec2_walk mkdir .ssh &&
sudo -u ec2_walk -s touch .ssh/authorized_keys &&
sudo -u ec2_walk curl https://github.com/wataruhigasi.keys >> .ssh/authorized_keys &&
sudo -u ec2_walk chmod 700 /home/ec2_walk/.ssh/ &&
sudo -u ec2_walk chmod 600 /home/ec2_walk/.ssh/authorized_keys ||
echo  "ec2_walk failed";
