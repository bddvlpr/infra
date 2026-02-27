{
  imports = [
    ../../roles/headless
    ../../modules/services/resonite-server.nix
  ];

  boot.swraid.mdadmConf = ''
    MAILADDR luna@bddvlpr.com
  '';

  # sops.secrets = {
  #   "resonite/steam/username" = { };
  #   "resonite/steam/password" = { };
  #   "resonite/steam/branch-password" = { };
  #   "resonite/username" = { };
  #   "resonite/password" = { };
  # };

  # services.resonite-server = {
  #   enable = true;
  # };

  system.stateVersion = "25.11";
}
