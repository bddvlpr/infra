{ inputs, lib, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./firewall.nix
    ./network.nix
    ./secrets.nix
    ./sudo.nix
    ./users.nix
  ]
  ++ import ../../modules/top-level.nix;

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      settings = {
        warn-dirty = false;
        trusted-users = [ "@wheel" ];

        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://cache.garnix.io"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

}
