{ config, ... }:

{
    virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
    };
    
    virtualisation.oci-containers.backend = "docker";
    services.dockerRegistry.enableGarbageCollect = config.services.dockerRegistry.enable;
}