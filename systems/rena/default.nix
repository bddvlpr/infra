{
  imports = [
    ../../roles/headless
    ../../roles/webserver
    ./impl/forgejo.nix
    ./impl/forgejo-runner.nix
    ./impl/headscale.nix
    ./impl/jackboxresoniteproxy.nix
    ./impl/mailserver.nix
    ./impl/resonite.nix
    ./impl/storage.nix
  ];

  boot.swraid.mdadmConf = ''
    MAILADDR luna@bddvlpr.com
  '';

  system.stateVersion = "25.11";
}
