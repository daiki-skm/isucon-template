#!/usr/bin/bash

userdel ec2_walk &&
userdel ec2_daiki_skm &&
userdel ec2_hond &&
rm -rf /home/ec2_* &&
rm env.sh;
