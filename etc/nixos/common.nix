{ config, lib, pkgs, ... }:

with lib;

{
  config = {

    system.stateVersion = "21.05";
    nix.gc.automatic = true;
    nix.gc.options = "--delete-older-than 30d";
    nix.optimise.automatic = true;

    ## Auto Upgrade
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = true;
    system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;

    ## Locale and Timezone
    i18n.defaultLocale = "en_US.UTF-8";
    services.timesyncd.enable = true;
    time.timeZone = "Asia/Kolkata";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
    services.xserver.layout = "us";
    services.xserver.xkbOptions = "eurosign:e";

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";
    virtualisation.docker.autoPrune.enable = true;
    services.dockerRegistry.enableGarbageCollect = config.services.dockerRegistry.enable;


    users.users.uday = {
      uid = 1000;
      description = "atanhx";
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      group = "users";
      initialPassword = "uday";
      shell = "/run/current-system/sw/bin/bash";
      home = "/home/uday";
    };
    
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  };
}