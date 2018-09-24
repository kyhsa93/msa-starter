#!/bin/sh

git config --global credential.helper cache

rm -rf express-api

git clone https://github.com/kyhsa93/express-api-starter.git express-api

npm install

cp -r node_modules express-api/node_modules

cd express-api && sh ./transpile.sh && cd ..

docker-compose up -d --build
if [ $? -eq 1 ];then
  sudo docker-compose up -d --build
fi

docker images
if [ $? -eq 1 ];then
  sudo docker images
fi

docker ps -a
if [ $? -eq 1 ];then
  sudo docker ps -a
fi
