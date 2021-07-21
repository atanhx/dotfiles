#!/bin/sh
echo "$(tput setaf 1)Welcome!$(tput setaf 7)" && sleep 5
echo
echo
echo
echo "$(tput setaf 3)Updating the system first!...Please Wait!$(tput setaf 7)" && sleep 3
echo
sudo pacman --noconfirm -Syu
echo
echo "$(tput setaf 3)Installing xorg$(tput setaf 7)" && sleep 3
echo
sudo pacman -S --noconfirm --needed rofi feh xorg xorg-xinit xorg-xinput
echo
echo "$(tput setaf 3)Installing fonts$(tput setaf 7)" && sleep 3
echo
mkdir -p  ~/.local/share/fonts
cp -r ./.local/share/fonts/* ~/.local/share/fonts
fc-cache -vf
echo
echo "$(tput setaf 2)Copied fonts successfully!$(tput setaf 7)" && sleep 5
clear
echo "$(tput setaf 3)Installing AUR(yay) helper now!$(tput setaf 7)" && sleep 3
echo
mkdir ~/.helper
git clone https://aur.archlinux.org/yay.git ~/.helper/yay
(cd ~/.helper/yay/ && makepkg -si)
echo
echo "$(tput setaf 2)Helper Installed!!$(tput setaf 7)" && sleep 5
clear
echo "$(tput setaf 3)Installing the important packages now.$(tput setaf 7)"
echo
yay -S --noconfirm --needed bspwm alacritty sxhkd polybar network-manager-applet arandr lxappearance polkit-gnome acpi sysstat feh rofi pavucontrol scrot picom-ibhagwan-git dunst materia-gtk-theme papirus-icon-theme xorg-xinput xorg-xbacklight pulseaudio blueman bluez-utils xorg-xrandr netctl htop neofetch firefox tldr wmctrl
echo
echo "$(tput setaf 2)Done!$(tput setaf 1)" && sleep 5
clear
echo "$(tput setaf 3)Copying config files now!$(tput setaf 7)" && sleep 3
mkdir -p ~/.config/
mkdir -p ~/bin
cp -r ./.config/* ~/.config/
cp -r ./bin/* ~/bin
echo "$(tput setaf 2)Copying completed!$(tput setaf 7)" && sleep 5
echo
echo "$(tput setaf 4)Adding ~/.bin to your PATH now$(tput setaf 7)"
echo -e '\nexport PATH="${PATH}:$HOME/bin/"' >> ~/.bashrc
sleep 5
echo
echo
echo
echo "$(tput setaf 2)Woohoo!! INSTALLATION COMPLETED SUCCESSFULLY!!!$(tput setaf 7)"

