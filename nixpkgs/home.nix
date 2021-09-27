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
      unstable.anytype
    ];

    programs.git = {
      enable = true;
      userName = "<handle>";
      userEmail = "<handle>.1011@gmail.com";
    };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}
