## AWS EC2でISUCONの練習環境を用意するまでに色々とはまったこと
- https://zenn.dev/libra/articles/669ae27f9d0b20

## ISUCON7予選でやったインフラのお仕事
- https://qiita.com/ihsiek/items/11106ce7a13e09b61547

## Nginx pidとは何か
- https://qiita.com/keitean/items/cfb27f496aa42a07c2e7

## ISUCON9予選1日目で最高スコアを出しました
- https://to-hutohu.com/2019/09/09/isucon9-qual/#%E8%BE%9E%E9%80%80%E3%81%97%E3%81%9F%E7%90%86%E7%94%B1

## nginx
<!-- in /etc/nginx/nginx.conf -->
```
log_format json escape=json '{"time":"$time_iso8601",'
        '"host":"$remote_addr",'
        '"port":$remote_port,'
        '"method":"$request_method",'
        '"uri":"$request_uri",'
        '"status":$status,'
        '"body_bytes":$body_bytes_sent,'
        '"referer":"$http_referer",'
        '"ua":"$http_user_agent",'
        '"request_time":"$request_time",'
        '"response_time":"$upstream_response_time"}';

access_log /var/log/nginx/access.log json;
```
- nginx -t
<!-- by root user -->
- sudo rm /var/log/nginx/access.log && sudo systemctl reload nginx

## alp
- wget https://github.com/tkuchiki/alp/releases/download/v1.0.10/alp_linux_arm64.zip
- apt install unzip
- unzip alp_linux_arm64.zip
- sudo install ./alp /usr/local/bin

- cat /var/log/nginx/access.log | alp json
<!-- or -->
- alp json --file /var/log/nginx/access.log

### ref
- https://github.com/tkuchiki/alp/releases
- https://nishinatoshiharu.com/install-alp-to-nginx/

## apach bench
- apt update
- apt install apache2-utils
- ab -c 1 -t 10 http://localhost/

## mysql
- apt install mysql-server mysql-client
<!-- in /etc/mysql/mysql.conf.d/mysqld.cnf -->
- delete comment out & long_query_time = 0
- systemctl restart mysql
- mysqldumpslow /var/log/mysql/mysql-slow.log
- sudo mysql -u root
- SHOW DATABASES;
- use xxx;
- SHOW TABLES;
- SHOW CREATE TABLE comments;
<!-- index <= 5% -->
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 9995 ORDER BY `created_at` DESC LIMIT 3;
- ALTER TABLE comments ADD INDEX post_id_idx(post_id);
- SELECT * FROM `comments` WHERE `post_id` = 9995 ORDER BY `created_at` DESC LIMIT 3;
- rm /var/log/mysql/mysql-slow.log
- mysqladmin flush-logs

## dstat
- apt install dstat
- dstat --cpu

<!-- in private_isu/webapp/ruby/unicorn_config.rb -->
worker_process = 2 * cpu
- systemctl status isu-ruby
- systemctl restart isu-ruby

## k6
- wget https://github.com/grafana/k6/releases/download/v0.39.0/k6-v0.39.0-linux-arm64.tar.gz
- tar -xf k6-v0.39.0-linux-arm64.tar.gz
- sudo install ./k6-v0.39.0-linux-arm64/k6 /usr/local/bin/

- wget http://--.---.---.--/image/10091.jpg
- mv 10091.jpg testimage.jpg

- k6 run --vus 1 --duration 30s xxx.js
- k6 run integrated.js

- alp json --sort sum -r -m "/posts/[0-9]+,/@\w+" -o count,method,uri,min,avg,max,sum < /var/log/nginx/access.log
