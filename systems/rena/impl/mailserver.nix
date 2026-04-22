{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixos-mailserver.nixosModules.mailserver ];

  sops.secrets = {
    "mailserver/noreply/password" = { };
    "mailserver/users/nali/password" = { };
  };

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.avali.network";
    domains = [
      "avali.network"
      "birds.avali.network"
    ];

    enableManageSieve = true;
    lmtpSaveToDetailMailbox = "no";

    x509.useACMEHost = config.mailserver.fqdn;

    accounts = {
      "noreply@avali.network" = {
        hashedPasswordFile = config.sops.secrets."mailserver/noreply/password".path;
        sendOnly = true;
      };
      "nali@birds.avali.network" = {
        hashedPasswordFile = config.sops.secrets."mailserver/users/nali/password".path;
        quota = "1G";
      };
    };

    aliases = {
      "abuse@avali.network" = [ "nali@birds.avali.network" ];
      "contact@avali.network" = [ "nali@birds.avali.network" ];
      "postmaster@avali.network" = [ "nali@birds.avali.network" ];
      "postmaster@birds.avali.network" = [ "nali@birds.avali.network" ];
    };
  };

  services.nginx.virtualHosts."mail.avali.network".enableACME = true;

  services.roundcube = {
    enable = true;
    hostName = "webmail.avali.network";
    dicts = with pkgs.aspellDicts; [
      en
      de
      fr
      nl
    ];
    plugins = [ "managesieve" ];
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.backup.jobs.mailserver.paths = [ config.mailserver.storage.path ];
}
