#!/bin/sh

# Git login using cached git credential data
git config --global credentail.helper cache

# Remove all services
rm -rf express-api socket-server

# Start cloning each services from git
git clone https://github.com/kyhsa93/node-base-image.git base-image
if [ $? -eq 1 ];then
  rm -rf base-image
  exit
fi

git clone https://github.com/kyhsa93/express-api-starter.git express-api
if [ $? -eq 1 ];then
  rm -rf express-api
  exit
fi

git clone https://github.com/kyhsa93/socket-server-starter.git socket-server
if [ $? -eq 1 ];then
  rm -rf socket-server
  exit
fi

# Run npm install to install babel for transpiling each services's code
npm install
if [ $? -eq 1 ];then
  rm -rf node_modules
  exit
fi

cp -r node_modules express-api/node_modules

cp -r node_modules socket-server/node_modules

cd express-api && sh ./transpile.sh && cd ..

cd socket-server && sh ./transpile.sh && cd ..

# Start build docker image
docker build --tag kyhsa93/node-base-image base-image/

docker build --tag kyhsa93/gateway gateway/

docker build --tag kyhsa93/express-api-starter express-api/

docker build --tag kyhsa93/socket-server-starter socket-server/

# Start push to docker hub repository
docker push kyhsa93/node-base-image

docker push kyhsa93/gateway

docker push kyhsa93/express-api-starter

docker push kyhsa93/socket-server-starter
