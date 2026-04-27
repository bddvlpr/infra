{ config, ... }:
{
  services.immich = {
    enable = true;

    host = "127.0.0.1";

    settings = {
      server.externalDomain = "https://pictures.avali.network";
    };
  };

  services.anubis.instances.immich.settings = {
    TARGET = "http://127.0.0.1:${toString config.services.immich.port}";
  };

  services.nginx.virtualHosts."pictures.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "= /.within.website/x/cmd/anubis/static/img/pensive.webp".alias = config.assets.anubis-pensive;
      "= /.within.website/x/cmd/anubis/static/img/happy.webp".alias = config.assets.anubis-happy;
      "= /.within.website/x/cmd/anubis/static/img/reject.webp".alias = config.assets.anubis-reject;

      "/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.immich.settings.BIND}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 10000M;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };
    };
  };

  services.backup.jobs.immich.paths = [ config.services.immich.mediaLocation ];
}
