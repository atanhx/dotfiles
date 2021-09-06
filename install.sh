#!/bin/sh


####################################################################
# THIS SCRIPT IS NOT FOR INSTALLING WM
# IT'S JUST TO SAVE SOME TIME TYPING BASIC COMMANDS ON FRESH INSTALL
####################################################################

clear
echo "$(tput setaf 1) [*] Welcome! $(tput setaf 7)"
echo "$(tput setaf 2) Let's start with what you want to install ('Ctrl+C' to stop the script) $(tput setaf 7)"
read -p "$(tput setaf 3) 1. Install Xorg? (y/n) $(tput setaf 7) :: " xorgResp
read -p "$(tput setaf 3) 2. Install Yay? (y/n) $(tput setaf 7) :: " yayResp
read -p "$(tput setaf 3) 3. Install Fonts? (y/n) $(tput setaf 7) :: " fontResp
pkg_readInput() {
printf "$(tput setaf 3) 4. Install your default Packages from AUR and Pacman?\n----------------------------
- Yes, Install both of them --> $(tput setaf 2)y$(tput setaf 7)\n
$(tput setaf 3)- No, I don't want to install this --> $(tput setaf 2)n$(tput setaf 7)\n
$(tput setaf 3)- See AUR PKG list --> $(tput setaf 2)a$(tput setaf 7)\n
$(tput setaf 3)- See Pacman PKG list --> $(tput setaf 2)p$(tput setaf 7)\n\n
$(tput setaf 3)Type one of them [y,a,p,n]$(tput setaf 7)"
read -p " :: " optResp
}
pkg_readInput
read -p "$(tput setaf 3) 5. Install AnyType? (y/n) $(tput setaf 7) :: " anytypeResp
read -p "$(tput setaf 3) 6. Install Overdrive Downloader? (y/n) $(tput setaf 7) :: " overdriveResp
read -p "$(tput setaf 3) 7. Install Docker? (y/n) $(tput setaf 7) :: " dockerResp
read -p "$(tput setaf 3) 8. Install WM settings and files? (y/n) $(tput setaf 7) :: " wmResp

clear
echo "$(tput setaf 3) [*] Checking for system update...$(tput setaf 7)"
sudo pacman -Syu --noconfirm

install_xorg() {
    if [[ $xorgResp -eq "y" || $xorgResp -eq "" ]]; then
        sudo pacman -Sy --noconfirm --needed xorg xorg-xinit xorg-xinput xorg-xbacklight xorg-xrandr man
    elif [[ $xorgResp -eq "n" ]]; then
        break
    else
        continue
    fi
}
install_xorg

install_font() {
    if [[ $fontResp -eq "y" || $fontResp -eq "" ]]; then
        mkdir -p  ~/.local/share/fonts
        cp -r ./.local/share/fonts/* ~/.local/share/fonts
        fc-cache -vf
    elif [[ $fontResp -eq "n" ]]; then
        break
    else
        continue
    fi
}
install_font


install_yay() {
    if [[ $yayResp = "y" || $yayResp = "" ]]; then
        mkdir ~/.helper
        git clone https://aur.archlinux.org/yay.git ~/.helper/yay
        (cd ~/.helper/yay/ && makepkg -si)
    elif [[ $yayResp -eq "n" ]]; then
        break
    else
        continue
    fi
}
install_yay

install_optionalPackages() {
	install_List() {
		if [[ $pacResp = "y" && $aurResp = "y" ]]; then
            sudo pacman -S $(grep -v "^\s*#" pacman-pkg-list.txt) --noconfirm --needed
			yay -S $(grep -v "^\s*#" aur-pkg-list.txt) --noconfirm --needed
		elif [[ $pacResp = "n" && $aurResp = "y" ]]; then
			yay -S $(grep -v "^\s*#" aur-pkg-list.txt) --noconfirm --needed
		elif [[ $pacResp = "y" && $aurResp = "n" ]]; then
			sudo pacman -S $(grep -v "^\s*#" pacman-pkg-list.txt) --noconfirm --needed
		elif [[ $pacResp = "n" && $aurResp = "n" ]]; then
			read -p "You don't want to install these? correct? (y/n)" conformationResp
				if [[ $conformationResp = "y" ]]; then
					break
				elif [[ $conformationResp = "n" ]]; then
					install_optionalPackages
				else
					break
				fi

		else
			break
		fi
	}
	if [[ $optResp = "a" ]]; then
		nano ./aur-pkg-list.txt
		clear
		read -p "Install these optional packages? (y/n) :: " aurResp
		if [[ $aurResp = "y" ]]; then
			clear
			pkg_readInput
			install_optionalPackages
		elif [[ $aurResp = "n" ]]; then
			clear
			pkg_readInput
			install_optionalPackages
		else
			echo "Something bad happened :("
		fi
        
	elif [[ $optResp = "p" ]]; then
		nano ./pacman-pkg-list.txt
		clear
		read -p "Install these optional packages? (y/n) :: " pacResp
		if [[ $pacResp = "y" ]]; then
			clear
			pkg_readInput
			install_optionalPackages
		elif [[ $pacResp = "n" ]]; then
			clear
			pkg_readInput
			install_optionalPackages
		else
			echo "Something bad happened :("
		fi
	elif [[ $optResp = "y" || $optResp = "" ]]; then
		install_List
	elif [[ $optResp = "n" ]]; then
		printf "\n"
		continue
	else
		break		
	fi
	
}
install_optionalPackages

install_anytype() {
    if [[ $anytypeResp = "y" || $anytypeResp = "" ]];then
        read -p "$(tput setaf 3)- Enter Latest Anytype version (default 0.18.59) $(tput setaf 7) :: " input_anytypeVer
        if [[ $input_anytypeVer = "" ]];then
            mkdir -p ~/Apps/Icons
            mkdir -p ~/Apps/Files
            cd ~/Apps/Files
            wget https://at9412003.fra1.digitaloceanspaces.com/Anytype-0.18.59.AppImage
            chmod +x ~/Apps/Files/Anytype*
            ./Anytype* --appimage-extract
            cp ~/Apps/Files/squa*/usr/share/icons/hicolor/0x0/apps/anytype2.png ~/Apps/Icons/
            rm -rf ~/Apps/Files/squa*
            touch ~/Apps/launch_Anytype
            chmod +x ~/Apps/launch_Anytype
            printf "exec ~/Apps/Files/Anytype* &" >> ~/Apps/launch_Anytype
            echo -e "\nexport PATH='$PATH:~/Apps/'" >> ~/.bashrc
            touch ~/.local/share/applications/Anytype.desktop
            echo -e "[Desktop Entry]\nVersion=1.0\nName=Anytype\nExec=/home/uday/Apps/launch_Anytype &\nPath=/home/uday/Apps/\nIcon=/home/uday/Apps/Icons/anytype2.png\nTerminal=false\nType=Application" >> ~/.local/share/applications/Anytype.desktop

        else
            mkdir -p ~/Apps/Icons
            mkdir -p ~/Apps/Files
            cd ~/Apps/Files
            wget https://at9412003.fra1.digitaloceanspaces.com/Anytype-$input_anytypeVer.AppImage
            chmod +x ~/Apps/Files/Anytype-*
            ./Anytype-* --appimage-extract
            cp ~/Apps/Files/squa*/usr/share/icons/hicolor/0x0/apps/anytype2.png ~/Apps/Icons/
            rm -rf ~/Apps/Files/squa*
            touch ~/Apps/launch_Anytype
            chmod +x ~/Apps/launch_Anytype
            printf "exec ~/Apps/Files/Anytype* &" >> ~/Apps/launch_Anytype
            echo -e "\nexport PATH='$PATH:~/Apps/'" >> ~/.bashrc
            touch ~/.local/share/applications/Anytype.desktop
            echo -e "[Desktop Entry]\nVersion=1.0\nName=Anytype\nExec=/home/uday/Apps/launch_Anytype &\nPath=/home/uday/Apps/\nIcon=/home/uday/Apps/Icons/anytype2.png\nTerminal=false\nType=Application" >> ~/.local/share/applications/Anytype.desktop

        fi
    elif [[ $anytypeResp -eq "n" ]]; then
        break
    else
        continue
    fi
}
install_anytype

install_overdriveDownloader() {
    if [[ $overdriveResp = "y" || $overdriveResp = "" ]]; then
        sudo pacman -S curl util-linux libxml2 openssl coreutils tidy
        mkdir -p ~/.local/bin
        curl https://chbrown.github.io/overdrive/overdrive.sh -o ~/.local/bin/overdrive
        chmod +x ~/.local/bin/overdrive
        sleep 2
        printf 'export PATH=~/.local/bin:$PATH\n' >> ~/.bashrc
        source ~/.bashrc
    elif [[ $overdriveResp -eq "n" ]]; then
        break
    else
        continue
    fi
}
install_overdriveDownloader

install_docker() {
    if [[ $dockerResp = "y" || $dockerResp = "" ]]; then
        sudo pacman -S docker
        systemctl start docker.service
        systemctl enable docker.service || groupadd docker || gpasswd -a $(whoami) docker
    elif [[ $dockerResp -eq "n" ]]; then
        break
    else
        continue
    fi  
}
install_docker

install_windowManagerfiles() {
    if [[ $wmResp = "y" || $wmResp = "" ]]; then
        WM_PKGS=(
            'awesome'   
            'xfce4-power-manager'
            'rofi'
            'picom-ibhagwan-git'
            'xclip'
            'lxappearance'
            'feh'
            'alacritty'
            'dunst'
            )
        for PKG in "${WM_PKGS[@]}"; do
            sudo pacman -S "$PKG" --noconfirm --needed
        done
    elif [[ $xorgResp -eq "n" ]]; then
        break
    else
        continue
    fi
}
sleep 5
# clear
echo "$(tput setaf 2) [**] INSTALLATION COMPLETED SUCCESSFULLY!!! $(tput setaf 7)"
  

