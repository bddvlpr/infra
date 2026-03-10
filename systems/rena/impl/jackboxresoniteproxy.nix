{ inputs, ... }:
{
  imports = [ inputs.jackboxresoniteproxy.nixosModules.default ];

  services.jackboxresoniteproxy = {
    enable = true;
    openFirewall = true;
  };
}
