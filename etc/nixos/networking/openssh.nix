{ lib, ... }: {
    programs.mosh.enable = true;
  
    services.openssh = {
            enable = true;
            startWhenNeeded = true;
            passwordAuthentication = false;
            challengeResponseAuthentication = false;
        };
}