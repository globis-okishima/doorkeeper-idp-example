# README

## 1. リポジトリのclone

```
cd /path/to/somewhere_work_dir
git clone https://github.com/globis-okishima/doorkeeper-idp-example.git
```

## 2. DBコンテナの用意

他に依存するミドルウェアとしてDBなどがあるが、別個コンテナ作る(docker-compose で一元的に管理したりは今回はしない)

```
docker container run --name mysql-local -it -e MYSQL_ROOT_PASSWORD='password' -p 33306:3306 mysql:5.7.30
```

上記に接続できるように `database.yml` を編集する

## 3. アプリケーションコンテナの起動

```
docker build -t doorkeeper-idp-example . -f Dockerfile
docker container run --name doorkeeper-idp-example -it -p 33000:3000 -v $PWD:/webapp doorkeeper-idp-example
```

```
docker container exec doorkeeper-idp-example rake db:create db:migrate
```

## 4. アカウントの用意

* [http://localhost:33000/users/sign_up](http://localhost:33000/users/sign_up) へアクセスする
* 適当にアカウント作る
* 上記ユーザーのレコードの `admin` カラムの値を1にする

上記ユーザーでログインしたら下記でOAuthクライアントの管理ができるようになる

[http://localhost:33000/oauth/applications](http://localhost:33000/oauth/applications)
