# Dotfiles

> **Warning**
> Install the packages according to your own distribution.

Clone the repo
```bash
git clone https://github.com/<handle>/dotfiles.git ~/
```

Use the install script provided in the directory
```bash
## Packages are arch based only. Install them according to your own system.
yay -S $(cat ~/dotfiles/pkgs.txt | cut -d' ' -f1)

chmod +x ~/dotfiles/install.sh

~/dotfiles/install.sh
```


## NixOS Configuration (Independent of above step)

Installing Git
```bash
nix-env -iA pkgs.git
```

Backup the hardware config and install the repo to `/etc/nixos`
```bash
# !!! Backup the /etc/nixos/hardware-configuration.nix

sudo rm -r /etc/nixos

git clone https://github.com/<handle>/dotfiles.git ~/

sudo ln -s ~/dotfiles/etc/nixos /etc/nixos
```

Add Home Manager and Unstable Channels
```bash
nix-channel --add https://nixos.org/channels/nixos-unstable unstable

nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager

nix-channel --update
```

Install from the new config.

```bash
sudo nixos-rebuild switch

reboot
```

Install Home-Manger
```bash
nix-shell '<home-manager>' -A install

rm -rf ~/.config/nixpkgs

ln -s ~/dotfiles/nixpkgs ~/.config/nixpkgs

home-manager switch
```

Installing Fonts (Optional)
```bash
cp -r ~/dotfiles/.local/share/fonts ~/.local/share/
```

