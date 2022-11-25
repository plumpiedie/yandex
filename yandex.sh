#!/bin/bash
HOSTS="
HOST1
HOST2
"

for H in $HOSTS
do
  result=$(ping -c 2 -W  1 -q  $H | grep transmitted)
  pattern="2 received";

  if [[ $result =~ $pattern ]]; then
    echo "$H is up"
    sshpass -p ADMIN_PASS ssh -o "StrictHostKeyChecking no" -y admin@$H 'sudo -S apt-get update;sudo -S apt-get -y install eepm;sudo -S epm --force play yandex-browser;for d in $(find /home/domain/* -maxdepth 0); do echo -e "[Desktop Entry]\nVersion=1.0\nname=Yandex Browser\nGenericName=Web Browser\nGenericName[ru]=Веб-браузер\nComment=Access the Internet\nComment[ru]=Доступ в Интернет\nExec=/usr/bin/yandex-browser-beta %U\nStartupNotify=true\nTerminal=false\nIcon=yandex-browser-beta\nType=Application\nCategories=Network;WebBrowser;" > yandex-browser.desktop; sudo -S cp yandex-browser.desktop $d/Рабочий\ стол/; done;sudo -S  mkdir /etc/skel/Рабочий\ стол;sudo -S cp yandex-browser.desktop /etc/skel/Рабочий\ стол'
  else
    echo "$H is down"
    echo $H >> down.txt
  fi
done

