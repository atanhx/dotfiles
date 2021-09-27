{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  unstable = import <unstable> { config.allowUnfree = true; };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.my_username = {
    programs.home-manager.enable = true;
    programs.bat.enable = true;

    home.username = "uday";
    home.homeDirectory = "/home/uday";
    
    home.packages = [
      pkgs.unzip
      pkgs.vlc
      pkgs.handlr
      pkgs.htop
      pkgs.neofetch
      pkgs.gitFull
      pkgs.flatpak
      unstable.anytype
    ];

    programs.git = {
      enable = true;
      userName = "<handle>";
      userEmail = "<handle>.1011@gmail.com";
    };

  
    home.stateVersion = "21.05";
  };
}
