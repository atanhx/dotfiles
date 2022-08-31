{ pkgs, ... }: {

    programs = {
        gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
        };
        # ssh.startAgent = true;
    };
    security.pam.services.login.enableGnomeKeyring = true;
    services = {
        dbus.packages = with pkgs; [ gcr ];
        gnome.gnome-keyring.enable = true;
    };
}