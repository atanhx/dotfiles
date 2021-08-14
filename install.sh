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
read -p "$(tput setaf 3) 4. Install Optional Packages? (y/n) $(tput setaf 7) :: " optResp
read -p "$(tput setaf 3) 5. Install Video Codecs Packages? (y/n) $(tput setaf 7) :: " vidcodecResp
read -p "$(tput setaf 3) 6. Install AppImage installer? (y/n) $(tput setaf 7) :: " appimageResp
read -p "$(tput setaf 3) 7. Install AnyType? (y/n) $(tput setaf 7) :: " anytypeResp
read -p "$(tput setaf 3) 8. Install Overdrive Downloader? (y/n) $(tput setaf 7) :: " overdriveResp
# clear

echo "$(tput setaf 3) [*] Updating the system first!...Please Wait!$(tput setaf 7)"
sudo pacman -Syu --noconfirm
# clear

install_xorg() {
    if [[ $xorgResp -eq "y" || $xorgResp -eq "" ]]; then
        sudo pacman -S --noconfirm --needed xorg xorg-xinit xorg-xinput xorg-xbacklight xorg-xrandr man
        # clear
    else
        break
    fi
}
install_xorg

install_font() {
    if [[ $fontResp -eq "y" || $fontResp -eq "" ]]; then
        mkdir -p  ~/.local/share/fonts
        cp -r ./.local/share/fonts/* ~/.local/share/fonts
        fc-cache -vf
        # clear
    else
        break
    fi
}
install_font


install_yay() {
    if [[ $yayResp = "y" || $yayResp = "" ]]; then
        mkdir ~/.helper
        git clone https://aur.archlinux.org/yay.git ~/.helper/yay
        (cd ~/.helper/yay/ && makepkg -si)
        # clear
    else
        break
    fi
}
install_yay

install_optionalPackages() {
    if [[ $optResp = "y" || $optResp = "" ]]; then
        yay -S --noconfirm --needed scrcpy visual-studio-code-bin network-manager-applet arandr lxappearance polkit-gnome acpi sysstat pavucontrol scrot materia-gtk-theme papirus-icon-theme pulseaudio bluez-utils netctl htop pfetch firefox-nightly chromium tldr obs-studio telegram-desktop-bin 
        systemctl enable bluetooth
        systemctl start bluetooth
        # clear
    else
        break
    fi
}
install_optionalPackages

install_vidcodecPackages() {
    if [[ $vidcodecResp = "y" || $vidcodecResp = "" ]]; then
        sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore
        sudo pacman -S --noconfirm --needed vlc
        # clear
    else
        break
    fi
}
install_vidcodecPackages

install_appimagelauncher() {
    if [[ $appimageResp = "y" || $appimageResp = "" ]]; then
        cd ~/Downloads
        wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-lite-2.2.0-travis995-0f91801-x86_64.AppImage 
        chmod +x ~/Downloads/appimagelauncher-lite-2.2.0-travis995-0f91801-x86_64.AppImage
        ./appimagelauncher-lite-2.2.0-travis995-0f91801-x86_64.AppImage install 
        printf 'export PATH=$HOME/Applications:$PATH\n' >> ~/.bashrc
        source ~/.bashrc
    else
        break
    fi
}
install_appimagelauncher

install_anytype() {
    if [[ $anytypeResp = "y" || $anytypeResp = "" ]];then
        read -p "$(tput setaf 3) Enter Latest Anytype version (default 0.18.59) $(tput setaf 7) :: " input_anytypeVer
        if [[ $input_anytypeVer = "" ]];then
            cd ~/Applications
            wget https://at9412003.fra1.digitaloceanspaces.com/Anytype-0.18.59.AppImage
            # clear
        else
            cd ~/Applications
            wget https://at9412003.fra1.digitaloceanspaces.com/Anytype-$input_anytypeVer.AppImage
            # clear
        fi
    else
        break
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
        printf 'export PATH=$HOME/.local/bin:$PATH\n' >> ~/.bashrc
        source ~/.bashrc
    else
        break
    fi
}
install_overdriveDownloader

sleep 5
# clear
echo "$(tput setaf 2) [**] INSTALLATION COMPLETED SUCCESSFULLY!!! $(tput setaf 7)"
  

