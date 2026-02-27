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
        loginRequired = true;
      };
    };
  };

  services.resonite-server = {
    enable = false;
    environmentFiles = [ config.sops.templates."resonite/.env".path ];
    settingsFile = config.sops.templates."resonite/config.json".path;
  };
}
