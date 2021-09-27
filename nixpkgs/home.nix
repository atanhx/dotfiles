{ config, pkgs, ... }:
let
  unstable = import <unstable> { config.allowUnfree = true; };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "uday";
  home.homeDirectory = "/home/uday";

  home.packages = [
      pkgs.unzip
      pkgs.vlc
      pkgs.handlr
      pkgs.htop
      pkgs.neofetch
      pkgs.flatpak
      pkgs.discord
      unstable.anytype
    ];

    programs.git = {
      enable = true;
      userName = "<handle>";
      userEmail = "<handle>.1011@gmail.com";
    };

  home.stateVersion = "21.05";
}
