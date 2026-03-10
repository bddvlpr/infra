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
    };
  };

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
