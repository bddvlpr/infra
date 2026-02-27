{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./firewall.nix
    ./secrets.nix
    ./sudo.nix
    ./users.nix
  ]
  ++ import ../../modules/top-level.nix;
}
