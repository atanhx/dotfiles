{
    imports = [
        ./common.nix
        ./envSysPackages.nix
        ./hardware-configuration.nix
        #./home.nix
    ];

    ### Using the systemd-boot EFI boot loader here.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    networking.hostName = "nixos";

    ### Networking 
    networking.useDHCP = false;
    networking.interfaces.enp0s31f6.useDHCP = true;
    networking.interfaces.wlp1s0.useDHCP = true;

    #### X11 and Gnome Desktop Enviroment
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.xserver.libinput.enable = true;
    services.openssh.enable = true;
    
}
