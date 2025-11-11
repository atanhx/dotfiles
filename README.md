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
- **Fonts & Other Packages**: See `pkgs.txt` file

More screenshots are under `/assets/` directory.

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
