{ lib, config, ... }:
let
  cfg = config.services.backup;
in
{
  options.services.backup = {
    enable = lib.mkEnableOption "automatic backups" // {
      default = true;
    };

    jobs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            paths = lib.mkOption {
              type = with lib.types; coercedTo str lib.singleton (listOf str);
              description = ''
                Path(s) to back up.
              '';
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."backup/ssh-key" = {
      mode = "0600";
    };

    services.borgbackup.jobs = lib.mapAttrs (
      name: job:
      let
        inherit (config.services.borgbackup.jobs.${name}) archiveBaseName;
      in
      {
        inherit (job) paths;

        encryption.mode = "none";
        environment.BORG_RSH = "ssh -i ${config.sops.secrets."backup/ssh-key".path}";
        repo = "ssh://u581008@u581008.your-storagebox.de:23/home/backups/${archiveBaseName}";
        compression = "auto,zstd";
        startAt = "daily";
      }
    ) cfg.jobs;
  };
}
