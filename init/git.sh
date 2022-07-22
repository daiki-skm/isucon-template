#!/usr/bin/bash

# sudo su -

cd .ssh &&
ssh-keygen -t rsa &&
cat ~/.ssh/id_rsa.pub &&
cd / &&
git init &&
git config --global --add safe.directory / &&
git branch main &&
git checkout main &&
git add ./home/isucon/xxx/xxx/go/main.go &&
git add ./home/isucon/xxx/xxx/mysql/db/0_Schema.sql &&
git commit -m 'init' &&
git remote add origin git@github.com:xxx/xxx.git &&
git config --global user.name "wataruhigasi" &&
git config --global user.email ayumu_h130424@outlook.jp &&
cd /home/isucon ||
echo "git failed";

# git push -u origin main
