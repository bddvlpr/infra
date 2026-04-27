{
  imports = [
    ../../roles/headless
    ../../roles/webserver
    ./impl/forgejo.nix
    ./impl/forgejo-runner.nix
    ./impl/guh.nix
    ./impl/headscale.nix
    ./impl/immich.nix
    ./impl/jackboxresoniteproxy.nix
    ./impl/mailserver.nix
    ./impl/minecraft.nix
    ./impl/postgresql.nix
    ./impl/resonite.nix
    ./impl/storage.nix
  ];

  boot.swraid.mdadmConf = ''
    MAILADDR luna@bddvlpr.com
  '';

  # Temporarily redirect any traffic to the forgejo instance.
  services.nginx.virtualHosts."avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/".return = "302 https://git.avali.network/";
  };

  system.stateVersion = "25.11";
}
