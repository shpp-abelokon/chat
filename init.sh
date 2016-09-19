#!/bin/bash

dist_name=$1
dist_version=$2
clear


function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}


function install_node {
  echo -e '\E[37;40m'"\033[1m==>Install Nodejs\033[0m"
  tput sgr0
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  sudo apt-get update
  sudo apt-get install -y nodejs
  sudo apt-get install -y build-essential
  echo -e '\E[37;40m'"\033[1m==>Nodejs has been installed ✔\033[0m"
  tput sgr0
}

isNode=$(program_is_installed node)
isUnzip=$(program_is_installed unzip)
isGit=$(program_is_installed git)
isNginx=$(program_is_installed nginx)

if [ $isNode == 0 ]; then
  echo "$(install_node)"
else
  echo -e '\E[37;40m'"\033[1m==>Nodejs ✔\033[0m"
  tput sgr0
fi


if [ $dist_name == 'ubuntu']; then
  echo -e '\E[37;40m'"\033[1m==>You OS $dist_name\033[0m"
fi

if [ ! -x  /opt/chat ]; then
    sudo mkdir /opt/chat && cd /opt
    if [ $isGit == 0 ]; then
      echo -e '\E[37;40m'"\033[1m==>Install Git\033[0m"
      tput sgr0
      sudo apt-get install -y git
    fi
    echo -e '\E[37;40m'"\033[1m==>Clone repository github\033[0m"
    tput sgr0
    sudo git clone https://github.com/shpp-abelokon/chat.git
    echo -e '\E[37;40m'"\033[1m==>Install npm modules\033[0m"
    tput sgr0
    cd /opt/chat && sudo npm i
    echo -e '\E[37;40m'"\033[1m==>Install npm modules from front-end\033[0m"
    tput sgr0
    cd /opt/chat/public && sudo npm i
    echo -e '\E[37;40m'"\033[1m==>Install -g bower\033[0m"
    tput sgr0
    sudo npm install -g bower
    echo -e '\E[37;40m'"\033[1m==>Install bower modules\033[0m"
    tput sgr0
    sudo bower install --allow-root
    echo -e '\E[37;40m'"\033[1m==>Install -g gulp\033[0m"
    tput sgr0
    sudo npm install --global gulp-cli
    if [ $isNginx == 0 ]; then
      echo -e '\E[37;40m'"\033[1m==>Install nginx\033[0m"
      tput sgr0
      sudo apt-get update
      sudo apt-get install -y nginx
    fi
    sudo cp /opt/chat/chat.io /etc/nginx/sites-available/chat.io
    sudo service nginx restart
    
    cd /etc/nginx/sites-available/ && cp /etc/nginx/sites-available/default /opt/chat/chat.io





    if [ $isUnzip == 0 ]; then
    echo -e '\E[37;40m'"\033[1m==>Install unzip\033[0m"
    tput sgr0
    sudo apt-get install -y unzip
    fi
    unzip ./master.zip -d /opt/
    cp /opt/chat-master/* /opt/mychat/
    sudo rm /opt/master.zip
    sudo rm -rf /opt/chat-master
    echo -e '\E[37;40m'"\033[1m==>Install npm modules\033[0m"
    tput sgr0
    cd /opt/mychat && npm i
    echo -e '\E[37;40m'"\033[1m==>Run mychat\033[0m"
    tput sgr0
    sudo npm start
    echo -e '\E[37;40m'"\033[1m==>Install nginx \033[0m"
fi