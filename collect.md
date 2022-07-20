## TIPS
- アクセスログをJSON形式で出力(nginx)
- 負荷試験の試行ごとにアクセスログ・スロークエリログをローテート
        - apache benchで負荷試験
        - k6でのシナリオを持った負荷試験
        - alpでアクセスログ解析
        - mysqldumpslowでスロークエリログ解析
- top/dstatで確認
- rubyからgoに切り替え
        - goは自動で複数のCPUを利用する
- worker processはCPUコア数の数倍程度
        - ex) worker_process = 2 * cpu

## INSTALL
```
#!/bin/sh

# git repo
git clone https://github.com/daiki328/isucon-template.git ||
echo "git clone failed";

# alp
apt update &&
apt install unzip &&
wget https://github.com/tkuchiki/alp/releases/download/v1.0.10/alp_linux_arm64.zip &&
unzip alp_linux_arm64.zip &&
sudo install ./alp /usr/local/bin ||
echo "alp install failed";

# apache bench
apt install apache2-utils ||
echo "apache2-utils install failed";

# mysql
apt install mysql-server mysql-client ||
echo "mysql install failed";

# dstat
apt install dstat ||
echo "dstat install failed";

# k6
wget https://github.com/grafana/k6/releases/download/v0.39.0/k6-v0.39.0-linux-arm64.tar.gz &&
tar -xf k6-v0.39.0-linux-arm64.tar.gz &&
sudo install ./k6-v0.39.0-linux-arm64/k6 /usr/local/bin/ ||
echo "k6 install failed";

# pt-query-digest
apt install percona-toolkit ||
echo "percona-toolkit install failed";

# query-digester
git clone https://github.com/kazeburo/query-digester.git &&
sudo install ./query-digester/query-digester /usr/local/bin/ ||
echo "query-digester install failed";
```

## COMMAND
```
## nginx
# in /etc/nginx/nginx.conf
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

nginx -t
# by root user
sudo rm /var/log/nginx/access.log && sudo systemctl reload nginx

## alp
cat /var/log/nginx/access.log | alp json
# or
alp json --file /var/log/nginx/access.log

## apach bench
ab -c 1 -t 10 http://localhost/

## dstat
dstat --cpu

## k6
wget http://--.---.---.--/image/xxx.jpg && mv xxx.jpg testimage.jpg

k6 run --vus 1 --duration 30s xxx.js

## from ruby to go
sudo systemctl stop isu-ruby &&
sudo systemctl disable isu-ruby &&
sudo systemctl start isu-go &&
sudo systemctl enable isu-go ||
echo "from ruby to go failed";
# systemctl restart isu-go
# systemctl status isu-go

## mysql

```

<!-- in /home/isucon/private_isu/webapp/ruby/unicorn_config.rb -->
worker_process = 2 * cpu
```
systemctl status isu-ruby &&
systemctl restart isu-ruby &&
systemctl status isu-ruby ||
echo "ruby restart failed";
```

## refs
- [private-isu](https://github.com/catatsuy/private-isu)
- [isucon-cheatsheet](https://github.com/budougumi0617/isucon-cheatsheet/blob/d642a10057342866d73af615a72b086720022cb8/script/tool_setup.sh)
- [isucontinuous git](https://github.com/ShotaKitazawa/isucontinuous)
- [isucontinuous speakerdeck](https://speakerdeck.com/shotakitazawa/isucon-deshi-eruturuwozuo-tuta)
- [ISUCON7予選でやったインフラのお仕事](https://qiita.com/ihsiek/items/11106ce7a13e09b61547)
- [ISUCON9予選1日目で最高スコアを出しました](https://to-hutohu.com/2019/09/09/isucon9-qual/#%E8%BE%9E%E9%80%80%E3%81%97%E3%81%9F%E7%90%86%E7%94%B1)

- [AWS EC2でISUCONの練習環境を用意するまでに色々とはまったこと](https://zenn.dev/libra/articles/669ae27f9d0b20)
- [linux command sequencial](https://qiita.com/egawa_kun/items/714394609eef6be8e0bf)
- [Nginx pidとは何か](https://qiita.com/keitean/items/cfb27f496aa42a07c2e7)
- [k6 http requests](https://k6.io/docs/using-k6/http-requests/)

- [isucon11予選](https://hackmd.io/@isucon-kuolc38th/rJjeC3jlF)
- [traP isucon 講習会](https://hackmd.io/@oribe/BkGXfhKj5)

## mysql
<!-- in /etc/mysql/mysql.conf.d/mysqld.cnf -->
```
slow_query_log = 1 # slow query logを有効にする
slow_query_log_file = /var/log/mysql/slow.log # slow query logを出力するファイルを指定する
long_query_time = 0 # 指定した秒数以上かかったクエリログを出力する
```
- systemctl restart mysql
- mysqldumpslow /var/log/mysql/mysql-slow.log
- sudo mysql -u root
<!-- or -->
- mysql -u root -p
- SHOW DATABASES;
- use isuconp;
- SHOW TABLES;
- SHOW CREATE TABLE comments;
<!-- index <= 5% -->
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 9995 ORDER BY `created_at` DESC LIMIT 3;
- SELECT * FROM `comments` WHERE `post_id` = 9995 ORDER BY `created_at` DESC LIMIT 3;
- ALTER TABLE comments ADD INDEX post_id_idx(post_id);
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 9995 ORDER BY `created_at` DESC LIMIT 3;
- SELECT * FROM `comments` WHERE `post_id` = 9995 ORDER BY `created_at` DESC LIMIT 3;
- rm /var/log/mysql/mysql-slow.log
- mysqladmin flush-logs

## mysql
- sudo mysql -u root
<!-- or -->
- mysql -u root -p
- SHOW FULL PROCESSLIST;
- SET GLOBAL slow_query_log = 1;
- SET GLOBAL slow_query_log_file = '/var/log/mysql/mysql-slow.log';
- SET GLOBAL long_query_time = 0;

- pt-query-digest --version
- pt-query-digest /var/log/mysql/mysql-slow.log | tee digest_$(date +%Y%m%d%H%M).txt

- sudo query-digester -duration 50 & k6 run integrated.js

- SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- ALTER TABLE comments ADD INDEX post_id_idx(post_id);
- SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;

- SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- ALTER TABLE comments DROP INDEX post_id_idx, ADD INDEX post_id_idx(post_id, created_at);
- SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;

- SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- ALTER TABLE comments DROP INDEX post_id_idx, ADD INDEX post_id_idx(post_id, created_at DESC);
- SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;
- EXPLAIN SELECT * FROM `comments` WHERE `post_id` = 100 ORDER BY `created_at` DESC LIMIT 3;

- SELECT COUNT(*) FROM `comments` WHERE `user_id` = 123;
- EXPLAIN SELECT COUNT(*) FROM `comments` WHERE `user_id` = 123;
- ALTER TABLE comments ADD INDEX idx_user_id(user_id);
- SELECT COUNT(*) FROM `comments` WHERE `user_id` = 123;
- EXPLAIN SELECT COUNT(*) FROM `comments` WHERE `user_id` = 123;

- ALTER TABLE comments ADD FULLTEXT INDEX comments_fulltext_idx(comment) WITH PARSER ngram;
- SELECT * FROM `comments` WHERE MATCH (comment) AGAINST ('データベース' IN BOOLEAN MODE);

- EXPLAIN SELECT * FROM `users` WHERE `id` = 635;
