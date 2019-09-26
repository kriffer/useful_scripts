#!/bin/bash

read -p "Enter source path (default-current dir)  : " source
read -p "Enter destination path (default-current dir)  : " dest
read -p "Enter ssh port  : " port

if [ -z $source ]; then
  source="$(pwd)/"
fi

if [ -z $dest  ]; then
  dest="$(pwd)/"
fi
if [ -z $port ]; then
  port=22
fi
echo "Copying: $source"
sleep 3
rsync -zavP -e "ssh -p $port" $source $dest
