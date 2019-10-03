#!/bin/bash

# This script helps to find out JDK packages installed in the environment
# Might be useful when java version property is not defined in rpm/deb package installed

UNAME=$(uname | tr "[:upper:]" "[:lower:]")

if [ "$UNAME" == "linux" ]; then
  if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
    export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
  else
    export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
  fi
fi

[ "$DISTRO" == "" ] && export DISTRO=$UNAME
unset UNAME

declare OS_TYPE

if [[ $(echo $DISTRO | grep -e "centos" -e "redhat") ]]; then
  OS_TYPE="rhel"
  declare -a PACKAGES=($(rpm -qa | grep -e "jdk" -e "zulu" -e "zing"))
fi
if [[ $(echo :$DISTRO | grep -e "ubuntu" -e "debian") ]]; then
  OS_TYPE="deb"
  declare -a PACKAGES=($(dpkg -l | grep -e "jdk" -e "zulu" -e "zing"))
fi

for PACKAGE_NAME in ${PACKAGES[@]}; do
  if [[ $OS_TYPE -eq "rhel" ]]; then
    EXEC_JAVA=$(rpm -ql $PACKAGE_NAME | grep "bin/java" | head -n1)
  else
    EXEC_JAVA=$(dpkg-query -L $PACKAGE_NAME | grep "bin/java" | head -n1)
  fi
  if [[ $EXEC_JAVA ]]; then
    echo "Package name: $PACKAGE_NAME"
    echo $($EXEC_JAVA -version 2>&1 >/dev/null)
    echo "==================================="
  else
    continue
  fi

done

