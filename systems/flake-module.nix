{ self, inputs, ... }:
let
  makeHost =
    class:
    { name, ... }:
    {
      imports = [
        ./${name}/default.nix
        ./${name}/hardware.nix
        ./${name}/disko.nix
      ];

      deployment = {
        targetHost = "${name}.nodes.avali.network";
        targetUser = null;
      };

      networking.hostName = name;
    };
in
{
  flake = {
    colmenaHive = inputs.colmena.lib.makeHive {
      meta = {
        nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        specialArgs = { inherit self inputs; };
      };

      rena = makeHost "nixos";
    };

    nixosConfigurations = self.colmenaHive.nodes;
  };
}
