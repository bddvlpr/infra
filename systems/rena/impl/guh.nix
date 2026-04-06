{ inputs, config, ... }:
{
  imports = [ inputs.guh.nixosModules.default ];

  sops.secrets."guh/env" = { };

  services.guh = {
    enable = true;
    environmentFiles = [ config.sops.secrets."guh/env".path ];
  };

  services.nginx.virtualHosts."lock.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:3000";
  };
}
