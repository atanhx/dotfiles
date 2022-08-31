{ config, pkgs, ... }:

{
    config = {

    programs.mtr.enable = true;
    
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      vim
      git
      nano
      wget
      gnupg
      man-pages
      whois
      firefox
      systemd
      libinput
      pkgs.direnv
      pkgs.nmap
      pkgs.tmux
      pkgs.curlFull
      pkgs.gnome.gnome-tweaks
      pkgs.docker
      pkgs.docker-compose
      pkgs.obs-studio
      pkgs.vscode
      pkgs.materia-theme
      pkgs.papirus-icon-theme
      ];
    };
}
