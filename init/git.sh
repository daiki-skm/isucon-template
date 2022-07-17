#!/usr/bin/bash

# sudo su -

cd .ssh &&
ssh-keygen -t rsa &&
cat ~/.ssh/id_rsa.pub &&
cd /home/isucon &&
git init &&
cd ./private_isu/webapp &&
git config --global --add safe.directory /home/isucon &&
git add golang &&
git commit -m 'golang' &&
git branch -M main &&
git remote add origin git@github.com:xxx/xxx.git &&
git config --global user.name "xxx" &&
git config --global user.email xxx@example.com &&
cd /home/isucon;

# git push -u origin main
