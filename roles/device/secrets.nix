{
  inputs,
  config,
  lib,
  ...
}:
let
  hostSecretsFile = ../../systems + "/${config.networking.hostName}/secrets.yaml";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = lib.mkIf (builtins.pathExists hostSecretsFile) hostSecretsFile;
}
