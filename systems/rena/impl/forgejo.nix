{
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git.avali.network";
        ROOT_URL = "https://git.avali.network/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
      };

      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

  services.nginx.virtualHosts."git.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
    };
    extraConfig = ''
      client_max_body_size 512M;
    '';
  };
}
