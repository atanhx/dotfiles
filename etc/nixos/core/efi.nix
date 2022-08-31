{ lib, ... }: {
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
            #systemd-boot.enable = true;
            #systemd-boot.configurationLimit = 15;
        };
        grub = {
	    enable = true;
            efiSupport = true;
            device = "nodev";
        };
    };
}
