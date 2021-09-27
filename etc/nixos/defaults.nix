{ config, lib, pkgs, ... }:

with lib;

{
  config = {

    system.stateVersion = "21.05";
    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 30d";
    nix.optimise.automatic = true;

    ## AUTO UPGRADE
    # system.autoUpgrade.enable = true;
    # system.autoUpgrade.allowReboot = true;
    # system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;

    ############
    ## LOCALE, TIME AND LAYOUT
    ############
    i18n.defaultLocale = "en_US.UTF-8";
    services.timesyncd.enable = true;
    time.timeZone = "Asia/Kolkata";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
    services.xserver.layout = "us";
    services.xserver.xkbOptions = "eurosign:e";

    users.users.uday = {
      uid = 1000;
      description = "atanhx";
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "networkmanager" "flatpak" "kvm" "audio"];
      group = "users";
      initialPassword = "uday";
      shell = "/run/current-system/sw/bin/bash";
      home = "/home/uday";
    };
    ############
    ## SOUND 
    ############
    sound.enable = true;
    hardware.pulseaudio.enable = true;


    ##############
    ## TOUCHPAD
    ##############
    services.xserver.libinput = {
        enable = true;
        touchpad.tapping = true;
        touchpad.naturalScrolling = true;
    };


    ########################
    ## DESKTOP ENVIROMENT 
    ########################
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}