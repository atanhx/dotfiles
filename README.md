# NixOS Configuration

Installing Git
```bash
nix-env -iA pkgs.git
```

Backup the hardware config and install the repo to `/etc/nixos`
```bash
# !!! Backup the /etc/nixos/hardware-configuration.nix

sudo rm -r /etc/nixos

sudo git clone https://github.com/<handle>/dotfiles.git ~/

sudo ln -s ~/dotfiles/etc/nixos /etc/nixos
```

Add Home Manager and Unstable Channels
```bash
nix-channel --add https://nixos.org/channels/nixos-unstable unstable

nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager

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

home-manger switch
```

Installing Fonts (Optional)
```bash
sudo cp -r /home/$(whoami)/dotfiles/.local/share/fonts /home/$(whoami)/.local/share/
```
