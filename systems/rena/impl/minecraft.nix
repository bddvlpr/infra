{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  modpack = pkgs.fetchPackwizModpack {
    src = inputs.modpack;
    packHash = "sha256-oWBPTLe5XrmNfQKaas78qaR0RxzK05dya2ZKgnCOeWg=";
  };

  inherit (modpack.manifest.versions) minecraft fabric;

  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${minecraft}";
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs = {
    overlays = [ inputs.nix-minecraft.overlay ];
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "minecraft-server" ];
  };

  sops.secrets."minecraft/env" = {
    owner = config.services.minecraft-servers.user;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    environmentFile = config.sops.secrets."minecraft/env".path;

    servers.awawivr = {
      enable = true;
      openFirewall = true;
      enableReload = false;
      package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabric; };
      jvmOpts = "-Xms2G -Xmx16G";

      symlinks = {
        mods = "${modpack}/mods";
      };

      files = {
        "config/Discord-Integration.toml" = "${modpack}/config/Discord-Integration.toml";
        "config/bluemap" = "${modpack}/config/bluemap";
      };

      serverProperties = {
        accepts-transfers = false;
        allow-flight = true;
        broadcast-console-to-ops = true;
        broadcast-rcon-to-ops = true;
        difficulty = 3;
        force-gamemode = true;
        gamemode = 0;
        level-type = "minecraft:large_biomes";
        max-players = 16;
        motd = "awawi vr";
        spawn-protection = 0;
        simulation-distance = 16;
        view-distance = 16;
      };

      operators = {
        bddvlpr = "d10d86d1-33ec-405f-b165-d2483dd0d39a";
      };
    };
  };

  services.nginx.virtualHosts."minecraft.avali.network" = {
    enableACME = true;
    forceSSL = true;

    root = inputs.modpack;

    extraConfig = ''
      autoindex on;
      autoindex_localtime on;
    '';

    locations = {
      "/map".return = "301 /map/";
      "/map/" = {
        proxyPass = "http://127.0.0.1:8100/";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 24454 ];
}
