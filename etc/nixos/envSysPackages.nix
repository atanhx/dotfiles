{ config, lib, pkgs, ... }:

with lib;

{
    config = {
    programs.mtr.enable = true;
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      vim
      nano
      wget
      gnupg
      man-pages
      whois
      firefox
      pkgs.nmap
      pkgs.tmux
      pkgs.curlFull
      pkgs.gnome.gnome-tweaks
      pkgs.docker
      pkgs.docker-compose
      pkgs.brave
      pkgs.obs-studio
      pkgs.vscode
      pkgs.materia-theme
      pkgs.papirus-icon-theme
        ];
    };
}