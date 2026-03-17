{ config, ... }:
{
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8080;

    settings = {
      server_url = "https://tailscale.avali.network";
      dns = {
        base_domain = "nodes.avali.network";
        nameservers.global = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };

  services.nginx.virtualHosts."tailscale.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass =
        let
          inherit (config.services.headscale) port;
        in
        "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };
}
