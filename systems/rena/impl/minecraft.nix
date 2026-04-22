{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs = {
    overlays = [ inputs.nix-minecraft.overlay ];
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "minecraft-server"
        "neoforge"
      ];
  };

  sops.secrets."minecraft/env" = {
    owner = config.services.minecraft-servers.user;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    environmentFile = config.sops.secrets."minecraft/env".path;

    servers.awawivr =
      let
        modpack = pkgs.fetchPackwizModpack {
          src = inputs.modpack;
          packHash = "sha256-7G/Vserdc4V7PY/1WE2/9wrNneGPy6exhkmk1FARD/g=";
        };

        inherit (modpack.manifest.versions) minecraft fabric;

        serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${minecraft}";
      in
      {
        enable = false;
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
          difficulty = 2;
          force-gamemode = true;
          gamemode = 0;
          max-players = 16;
          motd = "awawi vr";
          spawn-protection = 0;
        };

        operators = {
          bddvlpr = "d10d86d1-33ec-405f-b165-d2483dd0d39a";
        };
      };

    servers.awawi =
      let
        modpack = pkgs.fetchPackwizModpack {
          src = inputs.modpack-rewrite;
          packHash = "sha256-rqRQsYfTNiFrqGQV0ZCLV3KfF33QhnUOPwQ9JYFCINo=";
        };

        inherit (modpack.manifest.versions) minecraft;

        serverVersion = lib.replaceStrings [ "." ] [ "_" ] "neoforge-${minecraft}";
      in
      {
        enable = true;
        openFirewall = true;
        enableReload = false;
        package = pkgs.neoforgeServers.${serverVersion};
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
          difficulty = 2;
          force-gamemode = true;
          gamemode = 0;
          max-players = 16;
          motd = "awawi";
          spawn-protection = 0;
        };

        operators = {
          bddvlpr = "d10d86d1-33ec-405f-b165-d2483dd0d39a";
        };
      };
  };

  services.nginx.virtualHosts."minecraft.avali.network" = {
    enableACME = true;
    forceSSL = true;

    root = inputs.modpack-rewrite;

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

  services.backup.jobs.minecraft.paths = [ config.services.minecraft-servers.dataDir ];

  networking.firewall.allowedUDPPorts = [ 24454 ];
}
