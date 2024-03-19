# dotfiles

<img src="./assets/example.png" alt="img" align="right" width="400px">

Details about the setup:

- **OS**: Endeavour OS
- **WM**: [Hyprland](https://github.com/hyprwm/Hyprland)
- **Shell**: [bash](https://wiki.archlinux.org/title/bash)
- **Browser**: Firefox
- **Bar**: [waybar](https://github.com/Alexays/Waybar)
- **Shell Theme**: [Starship](https://starship.rs)
- **Terminal**: [Alacritty](https://github.com/alacritty/alacritty)
- **Editor**: [VS Code](https://code.visualstudio.com/) (Everforest Theme from marketplace)
- **Launcher**: [Wofi](https://hg.sr.ht/~scoopta/wofi)
- **Notification**: [Dunst](https://github.com/dunst-project/dunst)
- **Logout Screen**: [Wlogout](https://github.com/ArtsyMacaw/wlogout)
- **Fonts & Other Packages**: See `pkgs.txt` file

More screenshots are under `/assets/` directory.

## Installation:

The installion is divided into two parts

1. **Arch** (which installs and links the whole config with packages and theme)
2. **NixOS** (doesn't install anything - **not recommended**)

### Arch Configuration:

Clone the repo to ~/dev/ (if you want to change the location then make sure to update the paths in `install.sh`)

```bash
mkdir -p ~/dev/

cd ~/dev/

git clone https://github.com/<handle>/dotfiles.git
```

Before installing, have a look at the `pkgs.txt` file
Now, lets install the packages

```bash
## Packages in pkgs.txt are for arch based distros only. Install them according to your own system.
yay -S $(cat ~/dev/dotfiles/pkgs.txt | cut -d' ' -f1)
```

Now, use the install script to link the folders inside `dotfiles` to your `.config` directory.

```bash
# Note that this is an optional step. If you don't want to use it then you can manually copy paste the files like normal.
chmod +x ~/dev/dotfiles/install.sh

~/dev/dotfiles/install.sh
```

After running this, it will create a _soft link_ from the `dotfiles` to `~/.config/*` folder. Again, this was optional.

Tada! now you've installed the theme.

You can switch your session and see if it works!

> **NOTE**
>
> You may need to adjust the screen resolution and waybar widgets postion manually as they are _**most**_ likely to change on your device.

### NixOS Configuration (totally independent, not for WM):

Installing Git (most likely is installed on newer version)

```bash
nix-env -iA pkgs.git
```

Backup the hardware config and install the repo to `/etc/nixos`

```bash
# !!! Backup the /etc/nixos/hardware-configuration.nix
sudo cp -r /etc/nixos/hardware-configuration.nix ~/Downloads/

# Remove the base configs
sudo rm -r /etc/nixos

# You might need to create ~/dev folder
git clone https://github.com/<handle>/dotfiles.git ~/dev/

sudo ln -s ~/dev/dotfiles/etc/nixos /etc/nixos
```

And now configure you nix configs from your dotfiles.

Add Home Manager and Unstable Channels

```bash
nix-channel --add https://nixos.org/channels/nixos-unstable unstable

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

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

ln -s ~/dev/dotfiles/nixpkgs ~/.config/nixpkgs

home-manager switch
```
