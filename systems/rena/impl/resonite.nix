{ config, ... }:
{
  sops = {
    secrets = {
      "resonite/steam/username" = { };
      "resonite/steam/password" = { };
      "resonite/steam/branch-password" = { };
      "resonite/username" = { };
      "resonite/password" = { };
    };

    templates = {
      "resonite/.env".content = ''
        STEAM_USER=${config.sops.placeholder."resonite/steam/username"}
        STEAM_PASS=${config.sops.placeholder."resonite/steam/password"}
        BETA_CODE=${config.sops.placeholder."resonite/steam/branch-password"}
      '';
      "resonite/config.json".content = builtins.toJSON {
        universeId = null;
        tickRate = 60.0;
        maxConcurrentAssetTransfers = 8;

        loginCredential = config.sops.placeholder."resonite/username";
        loginPassword = config.sops.placeholder."resonite/password";
        loginRequired = false;

        startWorlds = [
          {
            isEnabled = true;
            sessionName = "<color=#FAA>N</color><color=#FCA>a</color><color=#FDA>l</color><color=#FEA>i</color><color=#FFB>'</color><color=#EFB>s</color><color=#CFC> </color><color=#BFE>N</color><color=#9FF>e</color><color=#9DF>s</color><color=#ACF>t</color>";
            customSessionId = "U-1hrtnrzGoJk:NalisNest";
            accessLevel = "ContactsPlus";
            maxUsers = 16;
            loadWorldURL = "resrec:///G-1hRRTntwYc4/R-b2bb4e04-93f7-4ef2-b511-ae8e0ce9cb61";
            forcedRestartInterval = 86400;
            forcePort = 12100;
            autoRecover = true;
            autoSleep = false;
            autosaveInterval = -1;
          }
        ];
      };
    };
  };

  services.resonite-server = {
    enable = true;
    environment = {
      ENABLE_MODS = "true";
      ENABLE_AUTO_MOD_UPDATE = "true";
      MOD_HeadlessTweaks = "true";
      MOD_StresslessHeadless = "true";
      MOD_HeadlessUserCulling = "true";
    };
    environmentFiles = [ config.sops.templates."resonite/.env".path ];
    settingsFile = config.sops.templates."resonite/config.json".path;
  };

  networking.firewall.allowedUDPPorts = [ 12100 ];
}
