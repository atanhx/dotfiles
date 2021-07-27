#!/bin/sh


####################################################################
# THIS SCRIPT IS NOT FOR INSTALLING WM
# IT'S JUST TO SAVE SOME TIME TYPING BASIC COMMANDS ON FRESH INSTALL
####################################################################


echo "$(tput setaf 1) [*] Welcome! $(tput setaf 7)"
echo "$(tput setaf 3) [*] Updating the system first!...Please Wait!$(tput setaf 7)"
sudo pacman -Syu --noconfirm 
echo "$(tput setaf 3) [*] Installing xorg $(tput setaf 7)"
sudo pacman -S --noconfirm --needed xorg xorg-xinit xorg-xinput xorg-xbacklight xorg-xrandr man
echo "$(tput setaf 3) [*] Installing fonts$(tput setaf 7)"
mkdir -p  ~/.local/share/fonts
cp -r ./.local/share/fonts/* ~/.local/share/fonts
fc-cache -vf
echo "$(tput setaf 2) [**] Copied fonts successfully! $(tput setaf 7)"
clear
echo "$(tput setaf 3) [*] Installing AUR(yay) helper now! $(tput setaf 7)"
mkdir ~/.helper
git clone https://aur.archlinux.org/yay.git ~/.helper/yay
(cd ~/.helper/yay/ && makepkg -si)
echo "$(tput setaf 2) [*] Helper Installed!!$(tput setaf 7)"
clear
echo "$(tput setaf 3) [*] Installing the important packages now. $(tput setaf 7)"
yay -S --noconfirm --needed scrcpy visual-studio-code-bin network-manager-applet arandr lxappearance polkit-gnome acpi sysstat pavucontrol scrot materia-gtk-theme papirus-icon-theme pulseaudio blueman bluez-utils netctl htop pfetch firefox-nightly tldr obs-studio telegram-desktop-bin 
systemctl enable bluetooth
systemctl start bluetooth
echo "$(tput setaf 2) [**] Done! $(tput setaf 1)"
clear
echo "$(tput setaf 3) [*] Installing Codecs and Videoplayer now! $(tput setaf 7)"
sudo pacman -S --noconfirm --needed a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins
sudo pacman -S --noconfirm --needed vlc 
echo "$(tput setaf 2) [**] Done! $(tput setaf 7)"
echo "$(tput setaf 4) [*] Adding ~/.bin to your PATH now $(tput setaf 7)"
echo -e '\nexport PATH="${PATH}:$HOME/bin/"' >> ~/.bashrc
sleep 5
echo "$(tput setaf 2) [**] Woohoo!! INSTALLATION COMPLETED SUCCESSFULLY!!! $(tput setaf 7)"

