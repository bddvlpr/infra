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

        allowedUrlHosts = [
          "wss://featherpile.awawi.nexus"
          "https://lock.avali.network"
        ];

        startWorlds = [
          {
            isEnabled = true;
            sessionName = "<color=#FAA>N</color><color=#FCA>a</color><color=#FDA>l</color><color=#FEA>i</color><color=#FFB>'</color><color=#EFB>s</color><color=#CFC> </color><color=#BFE>N</color><color=#9FF>e</color><color=#9DF>s</color><color=#ACF>t</color>";
            customSessionId = "U-1hrtnrzGoJk:NalisNest";
            accessLevel = "ContactsPlus";
            defaultUserRoles = {
              Nali = "Admin";
              Talii = "Admin";
              Mint_Shock = "Builder";
            };
            maxUsers = 16;
            loadWorldURL = "resrec:///G-1hRRTntwYc4/R-b2bb4e04-93f7-4ef2-b511-ae8e0ce9cb61";
            idleRestartInterval = 86400;
            forcePort = 12100;
            autoRecover = true;
            autoSleep = false;
            autosaveInterval = -1;
          }
          {
            isEnabled = true;
            sessionName = "<color=orange>Birds' Treehouse</color>";
            customSessionId = "U-1hrtnrzGoJk:BirdsTreehouse";
            accessLevel = "Anyone";
            defaultUserRoles = {
              Nali = "Admin";
              Talii = "Admin";
              Mint_Shock = "Builder";
            };
            maxUsers = 24;
            loadWorldURL = "resrec:///G-1hRRTntwYc4/R-019cebfd-92ea-7645-a37c-8f19887855d5";
            idleRestartInterval = 86400;
            forcePort = 12099;
            autoRecover = true;
            autoSleep = false;
            autosaveInterval = 15 * 60;
          }
        ];
      };
    };
  };

  services.resonite-server = {
    enable = true;
    ports = [
      "12100:12100/udp"
      "12099:12099/udp"
    ];
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

  networking.firewall.allowedUDPPorts = [
    12099
    12100
  ];
}
