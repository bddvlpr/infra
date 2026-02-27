{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.resonite-server;

  settingsFormat = pkgs.formats.json { };
  generatedSettingsFile = settingsFormat.generate "config.json" cfg.settings;
in
{
  options.services.resonite-server = {
    enable = lib.mkEnableOption "Resonite headless server";

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = { };
      description = ''
        The configuration to run on startup.
        Read <https://wiki.resonite.com/Headless_server_software/Configuration_file> for details.
      '';
    };

    settingsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        The configuration to run on startup. This overrides `settings`.
        Read <https://wiki.resonite.com/Headless_server_software/Configuration_file> for details.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        STEAM_BRANCH = "headless";
        TZ = "Etc/UTC";
      };
      description = ''
        Environment variables passed to the Resonite container.
        Check <https://github.com/voxelbonecloud/resonite-headless-docker> for more information.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [
        "/run/secrets/resonite-credentials"
      ];
      description = "Environment files for the Resonite container.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.resonite-server.environment = {
      STEAM_BRANCH = "headless";
      CONFIG_FILE = "config.json";
      TZ = "Etc/UTC";
    };

    virtualisation.oci-containers = {
      backend = lib.mkDefault "podman";

      containers.resonite-server = {
        image = "ghcr.io/voxelbonecloud/resonite-headless-docker:main";
        pull = "newer";

        inherit (cfg) environment environmentFiles;

        user = "0";

        volumes =
          let
            configFile = if cfg.settingsFile != null then cfg.settingsFile else generatedSettingsFile;
          in
          [
            "${configFile}:/Config/config.json:ro"
            "resonite-server-logs:/Logs"
            "resonite-server-mods:/RML"
          ];
      };
    };
  };
}
