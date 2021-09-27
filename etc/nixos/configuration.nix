{
    imports = [
        ./defaults.nix
        ./packages.nix
        ./core/hardware.nix
        ./core/docker.nix
        ./core/efi.nix
        ./core/nix.nix
        ./core/sudo.nix
        ./core/trusted.nix
        ./networking/openssh.nix
        ./networking/network-setup.nix
    ];
}
