{ lib, ... }:
{
  flake.nixosModules =
    let
      allModules = import ./top-level.nix;
    in
    lib.listToAttrs (
      map (module: {
        name = lib.removeSuffix ".nix" (baseNameOf module);
        value = import module;
      }) allModules
    );
}
