#!/bin/sh

packages=(python2-beautifulsoup3 python2-creepy-git python2-ipy python2-netfilterqueue-git python2-pefile python2-pypcap python2-pyqt4-qtwebkit python2-ua-parser python2-user-agents python2-yapsy python-tld python-ua-parser python-user-agents python-yapsy python-yaswfp perl-switch perl-www-mechanize i3lock-color android-apktool autopsy betterlockscreen burpsuite crowbar crunch dirb dirbuster firefox-noscript firefox-vim-vixen giskismet libcli maltego-community mitmf-git netdiscover netsniff-ng polenum polybar-git radare2 rockyou sleuthkit-java social-engineer-toolkit theharvester-git tor-browser unicornscan urlcrazy wapiti websploit wfuzz zaproxy joomscan)

read -p "Building a the local repository for arch may take a while, as you are building ${#packages[@]} from source. Are you sure you want to continue? [yN]" answer
case $answer in
	[yY]* ) sudo pacman -Rns $installing
		break;;
	[nN]* ) exit;;
	* )     exit;;
esac

sudo pacman -Syyu

installing=()

currdir=$(pwd)

echo "Server = file:///$currdir/local_repo/\$arch" >> Archery_Hunter/pacman.conf
echo "Server = file:///$currdir/local_repo/\$arch" >> Archery_Olympic/pacman.conf

mkdir -p local_repo/x86_64

for pkg in ${packages[@]}
do
	sudo pacman -S $pkg --noconfirm
	if [[ $? == 0 ]]
	then
		installing+=( $pkg )
	fi
done

cd pkg_build

for pkg in ${packages[@]}
do
	yaourt -G $pkg
	cd $pkg
	while [1]
	do
		makepkg
		if [[ $? != 0 ]]
		then
			echo "Fix this error to continue"
			read -p "When you have fixed it press any key" answer
			case $answer in
				*) break;;
			esac
		else
			break
		fi
	done
	cd ..
done

sudo cp */*.pkg.* ../local_repo/x86_64
rm -rf *
cd ../local_repo/x86_64
sudo repo-add custom_repo.db.tar.gz *.pkg.*

read -p "Remove the tools installed to create the local repository? [yN]" answer
case $answer in
	[yY]* ) sudo pacman -Rns $installing
		break;;
	[nN]* ) exit;;
	* )     exit;;
esac
