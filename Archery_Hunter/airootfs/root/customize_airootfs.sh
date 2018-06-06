#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

chmod +x /etc/skel/.scripts/polybar_launch

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root

cp -aT /etc/skel/ /root/
#chmod 700 /root

#useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/zsh live
#chown -R live:users /home/live

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service NetworkManager.service
systemctl set-default multi-user.target

#ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit
#sed 's|path_array+=(.*)|path_array+=("/opt/exploit-database")|g' /opt/exploit-database/.searchsploit_rc > ~/.searchsploit_rc

ln -sf /opt/cupp-master/cupp3.py /usr/bin/cupp3
ln -sf /opt/cupp-master/cupp.py /usr/bin/cupp

ln -sf /opt/exploit-database/searchsploit /usr/bin/searchsploit

ln -sf /opt/fluxion/fluxion.sh /usr/bin/fluxion

ln -sf /opt/miranda/miranda.py /usr/bin/miranda

ln -sf /opt/u3-pwn/u3-pwn.py /usr/bin/u3-pwn

ln -sf /opt/CeWL/cewl.rb /usr/bin/cewl

ln -sf /opt/twofi/twofi.rb /usr/bin/twofi

ln -sf /opt/chkrootkit/chkrootkit /usr/bin/chkrootkit

chmod +x /etc/NetworkManager/dispatcher.d/99-wlan

## Recon-ng setup
cd /usr/bin/recon-ng
pip2 install -r REQUIREMENTS

gem install spider
gem install mini_exiftool
gem install mime

## intrace installation

git clone https://github.com/robertswiecki/intrace.git /usr/src/intrace
cd /usr/src/intrace
make
ln -s /usr/src/intrace/intrace /usr/bin/intrace
cd

## creepy installation
git clone https://github.com/ilektrojohn/creepy.git /opt/creepy
sed -i 's/python/env python2/g' /opt/creepy/creepy/CreepyMain.py
chmod -R 777 /opt/creepy/creepy/*
ln -s /opt/creepy/creepy/CreepyMain.py /usr/bin/creepy

# SMBmap installation
git clone https://github.com/ShawnDEvans/smbmap.git /opt/smbmap
chmod +x /opt/smbmap/smbmap.py
ln -s /opt/smbmap/smbmap.py /usr/bin/smbmap

# install dmitry
git clone https://github.com/jaygreig86/dmitry.git /usr/src/dmitry
cd /usr/src/dmitry
chmod +x configure
./configure
make
make install
cd
ln -sf /opt/dmitry/dmitry /usr/bin/dmitry

#install golismero
cd /opt
git clone https://github.com/golismero/golismero.git
cd golismero
pip install -r requirements.txt
pip install -r requirements_unix.txt
ln -s /opt/golismero/golismero.py /usr/bin/golismero

# Install msfpc
curl -k -L "https://raw.githubusercontent.com/g0tmi1k/mpc/master/msfpc.sh" > /usr/bin/msfpc
chmod +x /usr/bin/msfpc

# Install cymothoa
git clone https://github.com/jorik041/cymothoa.git /opt/cymothoa
ln -s /opt/cymothoa/cymothoa /usr/bin/cymothoa

# Install powersploit
git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/powersploit

# Install exe2hex
git clone https://github.com/g0tmi1k/exe2hex.git /opt/exe2hex
chmod +x /opt/exe2hex/exe2hex.py
ln -s /opt/exe2hex/exe2hex.py /usr/bin/exe2hex

# Install mimikatz
git clone https://github.com/gentilkiwi/mimikatz.git /opt/mimikatz

# Install nishang
git clone https://github.com/samratashok/nishang.git /opt/nishang

# Install weevely
git clone https://github.com/epinna/weevely3.git /opt/weevely3
chmod +x /opt/weevely3/weevely.py
ln -s /opt/weevely3/weevely.py /usr/bin/weevely

# Install dnsspoof
git clone https://github.com/DanMcInerney/dnsspoof.git /opt/dnsspoof
sed -i '1s/^/#!\/usr\/bin\/env python2\n/' /opt/dnsspoof/dnsspoof.py
chmod +x /opt/dnsspoof/dnsspoof.py
ln -s /opt/dnsspoof/dnsspoof.py /usr/bin/dnsspoof

# Install movfuscator
git clone https://github.com/xoreaxeaxeax/movfuscator /opt/movfuscator
cd /opt/movfuscator
./build.sh
sudo ./install.sh

# Setup Openvas
#systemctl restart redis
#openvas-manage-certs -a
#greenbone-nvt-sync
#greenbone-scapdata-sync
#greenbone-certdata-sync
#systemctl start openvas-scanner
#openvasmd --rebuild --progress


pacman -Syyu

cd

