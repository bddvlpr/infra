{ config, ... }:
{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git.avali.network";
        ROOT_URL = "https://git.avali.network/";
        PROTOCOL = "http+unix";
      };

      service = {
        DISABLE_REGISTRATION = true;
      };

      ui = {
        DEFAULT_THEME = "avali-network";
        THEMES = "avali-network";
      };
    };
  };

  systemd.tmpfiles.rules =
    let
      inherit (config.services.forgejo) customDir;
    in
    [
      "d ${customDir}/public - forgejo forgejo - -"
      "d ${customDir}/public/assets - forgejo forgejo - -"
      "d ${customDir}/public/assets/css - forgejo forgejo - -"
      "L+ ${customDir}/public/assets/css/theme-avali-network.css - - - - ${config.assets.forgejo-theme}"
      "d ${customDir}/public/assets/img - forgejo forgejo - -"
      "L+ ${customDir}/public/assets/img/logo.svg - - - - ${config.assets.illuminate-logo-svg}"
      "L+ ${customDir}/public/assets/img/logo.png - - - - ${config.assets.illuminate-logo-512}"
      "L+ ${customDir}/public/assets/img/favicon.svg - - - - ${config.assets.illuminate-logo-svg}"
      "L+ ${customDir}/public/assets/img/favicon.png - - - - ${config.assets.illuminate-logo-128}"
    ];

  services.anubis.instances.forgejo.settings = {
    TARGET = "unix://${config.services.forgejo.settings.server.HTTP_ADDR}";
  };

  services.nginx.virtualHosts."git.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://unix:${config.services.anubis.instances.forgejo.settings.BIND}";
    };
    extraConfig = ''
      client_max_body_size 512M;
    '';
  };
}
