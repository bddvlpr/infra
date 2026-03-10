{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixos-mailserver.nixosModules.mailserver ];

  sops.secrets."mailserver/users/nali/password" = { };

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.avali.network";
    domains = [
      "avali.network"
      "birds.avali.network"
    ];

    x509.useACMEHost = config.mailserver.fqdn;

    loginAccounts = {
      "nali@birds.avali.network" = {
        hashedPasswordFile = config.sops.secrets."mailserver/users/nali/password".path;
        aliases = [
          "postmaster@avali.network"
          "abuse@avali.network"
          "postmaster@birds.avali.network"
        ];
      };
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
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };
}
