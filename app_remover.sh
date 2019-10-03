#!/bin/bash

# This script is intended to be useful while applications removing in Linux and Mac environment.
# Example usage:  sudo ./app_remover.sh <app_name>

APP=$1
IFS=$'\n'
RM=$(which rm)
declare -a PATHS=($(find / -name "*$APP*" -type f -o -name "*$APP*" -type d 2>&1 | grep -v "find:"))
# shellcheck disable=SC2068
for PATH in in ${PATHS[@]}; do
  while read -p "Deleting: $PATH. Are you sure ? (y/n): " answer; do
    if [[ $answer =~ ^[Yy]$ ]] || [[ $answer =~ ^[Nn]$ ]]; then
      break
    else continue
    fi
  done
  if [[ $answer =~ ^[Yy]$ ]]; then
    $RM -rf $PATH
  else
    continue
  fi
done
