{ config, ... }:
{
  services.backup.jobs.postgres.paths = [ config.services.postgresql.dataDir ];
}
