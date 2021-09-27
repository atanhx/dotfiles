{lib, ...}:
{
    networking = {
        hostName = "nixOS";
        useDHCP = false;
        interfaces.enp0s31f6.useDHCP = true;
        interfaces.wlp1s0.useDHCP = true;
    };
}