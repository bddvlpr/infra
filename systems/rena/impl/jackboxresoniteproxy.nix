{ inputs, ... }:
{
  imports = [ inputs.jackboxresoniteproxy.nixosModules.default ];

  services.jackboxresoniteproxy = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts."jackbox.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3002";
      proxyWebsockets = true;
    };
    locations."= /".return = "302 https://avali.network/";
  };
}
