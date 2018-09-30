#!/bin/sh

# Read first argument
env=$1

# If first argument is omitted, start development environment
if [ -z $env ];then
  echo "\033[31m"Argument is omitted. Start development environment."\033[0m"
  env="develop"
  rm -r docker-compose.yml .env
  cp docker-compose.develop.yml docker-compose.yml
  cp .env.develop .env
fi

# If first argument is matched 'production', start production environment
if [ "$env" = "production" ];then
  echo "\033[31m"Start production environment."\033[0m"
  env="master"
  rm -r docker-compose.yml .env
  cp docker-compose.production.yml docker-compose.yml
  cp .env.production .env
fi

# Git login using cached git credential data
git config --global credential.helper cache

# Remove all service
rm -rf express-api socket-server

# Start cloning each services from git, branch name is read first argument in cli.
git clone -b $env https://github.com/kyhsa93/express-api-starter.git express-api
if [ $? -eq 1 ];then
  rm -rf express-api
  exit
fi

git clone -b $env https://github.com/kyhsa93/socket-server-starter.git socket-server
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

# Start transpiling each services
cd express-api && sh ./transpile.sh && cd ..

cd socket-server && sh ./transpile.sh && cd ..

# Start dockerize
docker-compose up -d --build
if [ $? -eq 1 ];then
  sudo docker-compose up -d --build
  if [ $? -eq -1 ];then
    echo "\033[31m"docker-compose command is failed. Process is stoped."\033[0m"
    exit
  fi
fi

# Show docker image list
docker images
if [ $? -eq 1 ];then
  sudo docker images
fi

# Show docker container list
docker ps -a
if [ $? -eq 1 ];then
  sudo docker ps -a
fi
