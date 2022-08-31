{ pkgs, ... }: {

    nix = {
        allowedUsers = [ "@wheel" ];
        daemonIONiceLevel = 5;
        package = pkgs.nixUnstable;
        trustedUsers = [ "root" "@wheel" ];
    };
}